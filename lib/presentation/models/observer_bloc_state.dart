import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/blocs_resolvers/base_blocs_resolver.dart';

typedef OnBlocUpdate<T extends Cubit> = void Function(T bloc);

/// Состояние прослушивающего блока.
///
/// Используется в [BaseBlocsResolver].
class ObserverBlocState<T extends Cubit> {
  /// Блок.
  final T bloc;

  /// Вызывается при обновления состояния блока.
  final OnBlocUpdate<T> _onUpdate;

  /// Устарело ли состояние блока.
  bool _isOutdated = false;

  /// Следует ли обновлять состояние блока сразу после получения
  /// информации о том, что оно устарело.
  bool _isInstantUpdate = true;

  ObserverBlocState(
    this.bloc, {
    @required OnBlocUpdate<T> onUpdate,
  }) : _onUpdate = onUpdate;

  /// Устанавливает [_isInstantUpdate].
  ///
  /// Если устанавливается [true], состояние обновляется в случае
  /// устаревания.
  set isInstantUpdate(bool isInstantUpdate) {
    _isInstantUpdate = isInstantUpdate;
    if (_isInstantUpdate && _isOutdated) {
      updateState();
    }
  }

  /// Обновляет состояние блока.
  ///
  /// Возвращает [true], если блок был обновлен.
  /// Возвращает [false], если не установлен [_isInstantUpdate].
  bool updateState() {
    if (_isInstantUpdate) {
      _onUpdate(bloc);
    }
    _isOutdated = !_isInstantUpdate;
    return _isInstantUpdate;
  }
}
