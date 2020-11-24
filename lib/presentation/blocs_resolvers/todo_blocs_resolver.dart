import 'package:todos/presentation/models/resolving_bloc_state.dart';
import 'package:todos/presentation/screens/branches/blocs/branches_bloc/branches_bloc.dart';
import 'package:todos/presentation/screens/todo/blocs/todo_bloc/todo_bloc.dart';
import 'package:todos/presentation/screens/todo/blocs/todo_steps_bloc/todo_steps_bloc.dart';
import 'package:todos/presentation/screens/todos_list/blocs/todo_list_bloc/todo_list_bloc.dart';
import 'package:todos/presentation/screens/todos_list/blocs/branch_cubit/branch_cubit.dart';

/// Синхронизирует изменения в блоках, связанных с задачами.
class TodoBlocsResolver {
  final _branchesBlocState = ResolvingBlocState<BranchesBloc>(
    onUpdate: (bloc) => bloc.add(const BranchesOutdatedEvent()),
  );

  final _todoListBlocState = ResolvingBlocState<TodoListBloc>(
    onUpdate: (bloc) => bloc.add(const TodoListOutdatedEvent()),
  );

  /// Состояние блока списка веток.
  ResolvingBlocState<BranchesBloc> get branchesBlocState => _branchesBlocState;

  /// Состояние блока списка задач.
  ResolvingBlocState<TodoListBloc> get todoListBlocState => _todoListBlocState;

  /// Синхронизирует изменения блока списка задач с остальными блоками.
  void resolveTodoListStateChange(TodoListState state) {
    const meaningfulToBranchesBlocStates = <Type>[
      TodoListTodoAddedState,
      TodoListTodoEditedState,
      TodoListTodoDeletedState,
      TodoListTodosDeletedState,
    ];

    if (meaningfulToBranchesBlocStates.contains(state.runtimeType)) {
      _branchesBlocState.updateBloc();
    }
  }

  /// Синхронизирует изменения блока ветки с остальными блоками.
  void resolveBranchStateChange(BranchState state) {
    const meaningfulToBranchesBlocStates = <Type>[
      BranchEditedState,
    ];

    if (meaningfulToBranchesBlocStates.contains(state.runtimeType)) {
      _branchesBlocState.updateBloc();
    }
  }

  /// Синхронизирует изменения блока задачи с остальными блоками.
  void resolveTodoStateChange(TodoState state) {
    const meaningfulToBranchesBlocStates = <Type>[
      TodoEditedState,
      TodoDeletedState,
    ];
    const meaningfulToTodoListBlocStates = <Type>[
      TodoEditedState,
      TodoDeletedState,
    ];

    if (meaningfulToBranchesBlocStates.contains(state.runtimeType)) {
      _branchesBlocState.updateBloc();
    }
    if (meaningfulToTodoListBlocStates.contains(state.runtimeType)) {
      _todoListBlocState.updateBloc();
    }
  }

  /// Синхронизирует изменения блока шагов задачи с остальными блоками.
  void resolveTodoStepsStateChange(TodoStepsState state) {
    const meaningfulToTodoListBlocStates = <Type>[
      StepAddedState,
      StepDeletedState,
      StepEditedState,
    ];

    if (meaningfulToTodoListBlocStates.contains(state.runtimeType)) {
      _todoListBlocState.updateBloc();
    }
  }
}
