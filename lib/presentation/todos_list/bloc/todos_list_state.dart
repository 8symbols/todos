part of 'todos_list_bloc.dart';

@immutable
abstract class TodosListState {}

class TodosListLoadingState extends TodosListState {}

class TodosListUsingState extends TodosListState {
  final List<Todo> todos;

  TodosListUsingState(this.todos);
}
