part of 'todos_list_bloc.dart';

@immutable
abstract class TodosListState {}

class TodosListLoading extends TodosListState {}

class TodosListUsing extends TodosListState {
  final List<Todo> todos;

  TodosListUsing(this.todos);
}
