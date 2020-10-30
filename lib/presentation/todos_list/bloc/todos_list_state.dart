part of 'todos_list_bloc.dart';

@immutable
abstract class TodosListState {
  final List<Todo> todos;

  TodosListState(this.todos);
}

class TodosListLoadingState extends TodosListState {
  TodosListLoadingState() : super(null);
}

class TodosListUsingState extends TodosListState {
  TodosListUsingState(List<Todo> todos) : super(todos);
}
