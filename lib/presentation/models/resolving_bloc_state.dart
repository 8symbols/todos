import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/blocs_resolvers/base_blocs_resolver.dart';

typedef OnBlocUpdate<T extends Cubit> = void Function(T bloc);

/// Состояние блока.
///
/// Используется в [BaseBlocsResolver].
class ResolvingBlocState<T extends Cubit> {
  /// Блок.
  final T bloc;

  /// Вызывается при обновления состояния блока.
  final OnBlocUpdate<T> _onUpdate;

  /// Устарело ли состояние блока.
  bool _isOutdated = false;

  /// Следует ли обновлять состояние блока сразу после получения
  /// информации о том, что оно устарело.
  bool _isInstantResolving = true;

  ResolvingBlocState(
    this.bloc, {
    @required OnBlocUpdate<T> onUpdate,
  }) : _onUpdate = onUpdate;

  /// Устанавливает [_isInstantResolving].
  ///
  /// Если устанавливается [true], состояние обновляется в случае
  /// устаревания.
  set isInstantResolving(bool isInstantResolving) {
    _isInstantResolving = isInstantResolving;
    if (_isInstantResolving && _isOutdated) {
      updateState();
    }
  }

  /// Обновляет состояние блока.
  ///
  /// Возвращает [true], если блок был обновлен.
  /// Возвращает [false], если не установлен [_isInstantResolving].
  bool updateState() {
    if (_isInstantResolving) {
      _onUpdate(bloc);
    }
    _isOutdated = !_isInstantResolving;
    return _isInstantResolving;
  }
}
