part of 'todos_list_bloc.dart';

@immutable
abstract class TodosListState {}

class TodosListLoading extends TodosListState {}

class TodosListUsing extends TodosListState {
  final bool shouldShowFAB;

  final List<Todo> todos;

  TodosListUsing(this.todos, {this.shouldShowFAB = true});

  TodosListUsing copyWith({List<Todo> todos, bool shouldShowFAB}) {
    return TodosListUsing(
      todos ?? this.todos,
      shouldShowFAB: shouldShowFAB ?? this.shouldShowFAB,
    );
  }
}
