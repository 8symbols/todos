import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:todos/presentation/constants/assets_paths.dart';

class MountainsAnimation extends StatefulWidget {
  @override
  _MountainsAnimationState createState() => _MountainsAnimationState();
}

class _MountainsAnimationState extends State<MountainsAnimation> {
  bool _isDayNow;

  Artboard _riveArtboard;

  RiveAnimationController _cloudsController;
  RiveAnimationController _dayController;
  RiveAnimationController _nightController;

  bool get _isDayTimeChanging =>
      _dayController.isActive || _nightController.isActive;

  _MountainsAnimationState() {
    final hourNow = DateTime.now().hour;
    _isDayNow = 6 <= hourNow && hourNow < 18;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    rootBundle.load(AssetsPaths.mountainsAnimation).then(
      (data) async {
        final file = RiveFile();
        if (file.import(data)) {
          _cloudsController = SimpleAnimation('clouds');
          _dayController = SimpleAnimation('day');
          _nightController = SimpleAnimation('night');
          setState(() {
            _riveArtboard = file.mainArtboard..addController(_cloudsController);
            setInitialDayTime();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _cloudsController?.dispose();
    _dayController?.dispose();
    _nightController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 113.0,
      height: 113.0,
      child: _riveArtboard == null
          ? null
          : GestureDetector(
              onTap: changeDayTime,
              child: Rive(artboard: _riveArtboard),
            ),
    );
  }

  void setInitialDayTime() {
    final initialAnimation = _isDayNow ? _dayController : _nightController;
    _riveArtboard.addController(initialAnimation);
  }

  void changeDayTime() {
    if (_isDayTimeChanging) {
      return;
    }

    _isDayNow = !_isDayNow;

    if (_isDayNow) {
      _riveArtboard
        ..removeController(_nightController)
        ..addController(_dayController);
    } else {
      _riveArtboard
        ..removeController(_dayController)
        ..addController(_nightController);
    }
  }
}
