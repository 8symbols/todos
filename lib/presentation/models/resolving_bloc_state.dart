import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/blocs_resolvers/todo_blocs_resolver.dart';

typedef OnBlocUpdate<ResolvingBloc> = void Function(ResolvingBloc bloc);

/// Состояние блока.
///
/// Используется в [TodoBlocsResolver].
class ResolvingBlocState<ResolvingBloc extends Cubit> {
  /// Блок.
  ///
  /// Может быть равным [null].
  ResolvingBloc _bloc;

  /// Устарело ли состояние блока.
  bool _isOutdated;

  /// Следует ли обновлять состояние блока сразу после получения
  /// информации о том, что оно устарело.
  bool _isInstantResolving;

  /// Вызывается при обновления состояния блока.
  ///
  /// Не вызывается, если [_bloc] равен [null].
  final OnBlocUpdate<ResolvingBloc> _onUpdate;

  ResolvingBlocState({
    ResolvingBloc bloc,
    @required OnBlocUpdate<ResolvingBloc> onUpdate,
  })  : _bloc = bloc,
        _onUpdate = onUpdate,
        _isOutdated = false,
        _isInstantResolving = true;

  /// Устанавливает [_bloc] и сбрасывает [_isOutdated].
  set bloc(ResolvingBloc bloc) {
    _bloc = bloc;
    _isOutdated = false;
  }

  /// Устанавливает [_isOutdated].
  set isOutdated(bool isOutdated) => _isOutdated = isOutdated;

  /// Устанавливает [_isInstantResolving].
  ///
  /// Если устанавливается [true], состояние обновляется в случае
  /// устаревания.
  set isInstantResolving(bool isInstantResolving) {
    _isInstantResolving = isInstantResolving;
    if (_isInstantResolving && _isOutdated) {
      updateBloc();
    }
  }

  /// Обновляет состояние блока.
  ///
  /// Возвращает [true], если блок был обновлен.
  /// Возвращает [false], если не установлен [_isInstantResolving].
  bool updateBloc() {
    if (_isInstantResolving && _bloc != null) {
      _onUpdate(_bloc);
    }
    _isOutdated = !_isInstantResolving;
    return _isInstantResolving;
  }
}
