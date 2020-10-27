import 'package:flutter/material.dart';

class TodosListScreen extends StatelessWidget {
  static const routeName = '/todos_list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _TodosList(),
      ),
    );
  }
}

class MockTodo {
  bool wasCompleted;
  String title;
}

final mockTodos = [
  for (var i = 0; i < 12; ++i)
    MockTodo()
      ..wasCompleted = i % 2 == 0
      ..title = i.toString(),
];

class _TodosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: mockTodos.map((e) => _Todo(e)).toList(),
      ),
    );
  }
}

class _Todo extends StatelessWidget {
  final MockTodo mockTodo;

  _Todo(this.mockTodo);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Checkbox(value: mockTodo.wasCompleted, onChanged: (v) {}),
            Expanded(child: Text(mockTodo.title)),
            IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
