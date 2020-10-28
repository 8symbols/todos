part of 'todos_list_bloc.dart';

@immutable
abstract class TodosListState {}

class TodosListLoadingState extends TodosListState {}

class TodosListUsingState extends TodosListState {
  final bool shouldShowFAB;

  final List<Todo> todos;

  TodosListUsingState(this.todos, {this.shouldShowFAB = true});

  TodosListUsingState copyWith({List<Todo> todos, bool shouldShowFAB}) {
    return TodosListUsingState(
      todos ?? this.todos,
      shouldShowFAB: shouldShowFAB ?? this.shouldShowFAB,
    );
  }
}
