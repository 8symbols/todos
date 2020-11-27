import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/models/observer_bloc_state.dart';
import 'package:meta/meta.dart';

/// Синхронизирует изменения между блоками.
///
/// При изменении состояния какого-либо из прослушиваемых блоков вызывает
/// функции обновления состояний прослушивающих блоков.
abstract class BaseBlocsResolver {
  /// Прослушивающие блоки.
  final List<ObserverBlocState> _observers = [];

  /// Прослушиваемые блоки.
  ///
  /// Ключ - блок, значение - подписка на поток его состояний.
  final Map<dynamic, StreamSubscription<dynamic>> _observables = {};

  /// Регистрирует в прослушиваемых и в прослушивающих блоках блок [bloc],
  /// для обновления которого будет вызываться [onUpdate].
  ///
  /// Если блок уже зарегистрирован в каком-либо списке, пропускает его.
  ///
  /// При состояниях [ignoreStates] уведомление об изменении не происходит.
  /// При обновлении блок обязан возвращать только эти состояния.
  void register<T extends Cubit>(
    T bloc,
    List<Type> ignoreStates, {
    @required OnBlocUpdate<T> onUpdate,
  }) {
    registerObserver(bloc, onUpdate: onUpdate);
    registerObservable(bloc, ignoreStates);
  }

  /// Удаляет из прослушиваемых и из прослушивающих блоках блок [bloc].
  ///
  /// Если блок не зарегистрирован в каком-либо списке, пропускает его.
  void unregister<T extends Cubit>(T bloc) {
    unregisterObserver(bloc);
    unregisterObservable(bloc);
  }

  /// Регистрирует в прослушивающих блоках блок [bloc], для обновления
  /// которого будет вызываться [onUpdate].
  ///
  /// Если блок уже зарегистрирован, ничего не делает.
  void registerObserver<T extends Cubit>(
    T bloc, {
    @required OnBlocUpdate<T> onUpdate,
  }) {
    if (!containsObserver(bloc)) {
      _observers.add(ObserverBlocState(bloc, onUpdate: onUpdate));
    }
  }

  /// Удаляет блок [bloc] из зарегистрированных прослушивающих блоков.
  ///
  /// Если он не был зарегистрирован, ничего не делает.
  void unregisterObserver<T extends Cubit>(T bloc) {
    _observers
        .removeWhere((observerState) => identical(observerState.bloc, bloc));
  }

  /// Регистрирует в прослушиваемых блоках блок [bloc].
  ///
  /// Если блок уже зарегистрирован, ничего не делает.
  ///
  /// При состояниях [ignoreStates] уведомление об изменении не происходит.
  /// Если блок также является прослушиваемым, при обновлении он обязан
  /// возвращать только эти состояния.
  void registerObservable<T extends Cubit>(T bloc, List<Type> ignoreStates) {
    if (!containsObservable(bloc)) {
      _observables[bloc] = bloc.listen((state) {
        if (!ignoreStates.contains(state.runtimeType)) {
          _updateObservers(bloc);
        }
      });
    }
  }

  /// Удаляет блок [bloc] из зарегистрированных прослушиваемых блоков.
  ///
  /// Если он не был зарегистрирован, ничего не делает.
  void unregisterObservable<T extends Cubit>(T bloc) {
    if (containsObservable(bloc)) {
      _observables[bloc].cancel();
      _observables.remove(bloc);
    }
  }

  /// Проверяет, зарегистрирован ли блок [bloc] в прослушиваемых блоках.
  ///
  /// Возвращает [true], если зарегистрирован.
  bool containsObservable<T extends Cubit>(T bloc) =>
      _observables.containsKey(bloc);

  /// Проверяет, зарегистрирован ли блок [bloc] в прослушивающих блоках.
  ///
  /// Возвращает [true], если зарегистрирован.
  bool containsObserver<T extends Cubit>(T bloc) =>
      _observers.any((observerState) => identical(observerState.bloc, bloc));

  /// Приостанавливает обновление состояния блока при изменении состояний
  /// других блоков.
  void pauseObserver<T extends Cubit>(T bloc) {
    _changeBlocInstantUpdate(bloc, false);
  }

  /// Возобновляет обновление состояния блока при изменении состояний
  /// других блоков.
  ///
  /// Если между вызовами [pauseObserver] и [continueObserver]
  /// состояние прослушиваемых блоков изменялось, обновит состояние.
  void continueObserver<T extends Cubit>(T bloc) {
    _changeBlocInstantUpdate(bloc, true);
  }

  /// Устанавливает, нужно ли обновлять блок [bloc] при изменении других
  /// зарегистрированных блоков.
  void _changeBlocInstantUpdate<T extends Cubit>(
    T bloc,
    bool isInstantUpdate,
  ) {
    _observers.forEach((observerState) {
      if (identical(observerState.bloc, bloc)) {
        observerState.isInstantUpdate = isInstantUpdate;
      }
    });
  }

  /// Обновляет прослушивающие блоки.
  void _updateObservers<T extends Cubit>(T senderObservable) {
    _observers.forEach((observerState) {
      if (!identical(senderObservable, observerState.bloc)) {
        observerState.updateState();
      }
    });
  }
}
