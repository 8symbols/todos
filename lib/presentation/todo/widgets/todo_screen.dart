import 'package:flutter/material.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:todos/data/services/notifications_service.dart';
import 'package:todos/domain/models/branch_theme.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/presentation/todo/todo_bloc/todo_bloc.dart';
import 'package:todos/presentation/todo/todo_images_bloc/todo_images_bloc.dart';
import 'package:todos/presentation/todo/todo_steps_bloc/todo_steps_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/todo/widgets/todo_images_card.dart';
import 'package:todos/presentation/todo/widgets/todo_sliver_appbar.dart';
import 'package:todos/presentation/todo/widgets/todo_steps_card.dart';
import 'package:todos/presentation/todo/widgets/todo_time_setting_card.dart';

/// Экран задачи.
class TodoScreen extends StatefulWidget {
  static const routeName = '/todo';

  /// Тема ветки.
  final BranchTheme _branchTheme;

  /// Задача.
  final Todo _todo;

  TodoScreen(this._branchTheme, this._todo);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TodoStepsBloc _stepsBloc;

  TodoImagesBloc _imagesBloc;

  TodoBloc _todoBloc;

  @override
  void initState() {
    super.initState();
    final todosRepository = context.repository<ITodosRepository>();
    _stepsBloc = TodoStepsBloc(todosRepository, widget._todo)
      ..add(StepsLoadingRequestedEvent());
    _imagesBloc = TodoImagesBloc(todosRepository, widget._todo)
      ..add(ImagesLoadingRequestedEvent());
    _todoBloc = TodoBloc(todosRepository, NotificationsService(), widget._todo);
  }

  @override
  void dispose() {
    _stepsBloc.close();
    _todoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const appBarExpandedHeight = 200.0;

    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoStepsBloc>.value(value: _stepsBloc),
        BlocProvider<TodoImagesBloc>.value(value: _imagesBloc),
        BlocProvider<TodoBloc>.value(value: _todoBloc),
      ],
      child: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoDeletedState) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) => Scaffold(
          backgroundColor: widget._branchTheme.secondaryColor,
          body: SliverFab(
            floatingWidget: FloatingActionButton(
              onPressed: () =>
                  _changeTodoWasCompleted(context, !state.todo.wasCompleted),
              child: Icon(
                state.todo.wasCompleted ? Icons.close : Icons.check,
                color: Colors.white,
              ),
            ),
            floatingPosition: const FloatingPosition(left: 16),
            expandedHeight: appBarExpandedHeight,
            slivers: <Widget>[
              TodoSliverAppBar(
                  appBarExpandedHeight, widget._branchTheme, state.todo),
              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 32.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TodoStepsCard(widget._todo),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TodoTimeSettingsCard(state.todo),
                  ),
                  const SizedBox(height: 20.0),
                  TodoImagesCard(),
                  const SizedBox(height: 20.0),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeTodoWasCompleted(BuildContext context, bool wasCompleted) {
    final todo = context.bloc<TodoBloc>().state.todo;
    context
        .bloc<TodoBloc>()
        .add(TodoEditedEvent(todo.copyWith(wasCompleted: wasCompleted)));
  }
}
