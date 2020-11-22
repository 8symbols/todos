import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:todos/presentation/constants/assets_paths.dart';

/// Изображение гор с анимациями.
class MountainsAnimation extends StatefulWidget {
  @override
  _MountainsAnimationState createState() => _MountainsAnimationState();
}

class _MountainsAnimationState extends State<MountainsAnimation> {
  /// Изображается сейчас день или ночь.
  bool _isDayTime;

  /// Изображение.
  Artboard _riveArtboard;

  /// Controller анимации облаков.
  RiveAnimationController _cloudsController;

  /// Controller анимации дня.
  RiveAnimationController _dayController;

  /// Controller анимации ночи.
  RiveAnimationController _nightController;

  /// Controller анимации перехода дня в ночь.
  RiveAnimationController _dayToNightController;

  /// Controller анимации перехода ночи в день.
  RiveAnimationController _nightToDayController;

  /// Анимируется ли сейчас смена времени суток.
  bool get _isDayTimeChanging =>
      _dayToNightController.isActive || _nightToDayController.isActive;

  _MountainsAnimationState() {
    final hourNow = DateTime.now().hour;
    _isDayTime = 6 <= hourNow && hourNow < 18;
  }

  @override
  void initState() {
    super.initState();
    rootBundle.load(AssetsPaths.mountainsAnimation).then(
      (data) async {
        final file = RiveFile();
        if (file.import(data)) {
          _initializeControllers();
          setState(() {
            _riveArtboard = file.mainArtboard
              ..addController(_cloudsController)
              ..addController(_isDayTime ? _dayController : _nightController);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 113.0,
      height: 113.0,
      child: _riveArtboard == null
          ? null
          : GestureDetector(
              onTap: _changeDayTime,
              child: Rive(artboard: _riveArtboard),
            ),
    );
  }

  void _initializeControllers() {
    _cloudsController = SimpleAnimation('clouds');
    _dayController = SimpleAnimation('day');
    _nightController = SimpleAnimation('night');

    _dayToNightController = SimpleAnimation('day_to_night')
      ..isActiveChanged.addListener(
        () => _replaceOnFinish(_dayToNightController, _nightController),
      );

    _nightToDayController = SimpleAnimation('night_to_day')
      ..isActiveChanged.addListener(
        () => _replaceOnFinish(_nightToDayController, _dayController),
      );
  }

  void _replaceOnFinish(
    RiveAnimationController startAnimation,
    RiveAnimationController finishAnimation,
  ) {
    if (!startAnimation.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _riveArtboard
          ..removeController(startAnimation)
          ..addController(finishAnimation);
      });
    }
  }

  void _changeDayTime() {
    if (_isDayTimeChanging) {
      return;
    }

    _riveArtboard
      ..removeController(_isDayTime ? _dayController : _nightController)
      ..addController(
        _isDayTime ? _dayToNightController : _nightToDayController,
      );

    _isDayTime = !_isDayTime;
  }
}
