import 'package:flutter/material.dart';
import 'package:todos/data/services/notifications_service.dart';
import 'package:todos/domain/models/branch_theme.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/presentation/blocs/deletion_cubit/deletion_cubit.dart';
import 'package:todos/presentation/screens/todo/blocs/todo_bloc/todo_bloc.dart';
import 'package:todos/presentation/screens/todo/blocs/todo_images_bloc/todo_images_bloc.dart';
import 'package:todos/presentation/screens/todo/blocs/todo_steps_bloc/todo_steps_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/screens/todo/widgets/todo_images_card.dart';
import 'package:todos/presentation/screens/todo/widgets/todo_sliver_appbar.dart';
import 'package:todos/presentation/screens/todo/widgets/todo_steps_card.dart';
import 'package:todos/presentation/screens/todo/widgets/todo_time_setting_card.dart';
import 'package:todos/presentation/widgets/deletion_mode_will_pop_scope.dart';

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

  DeletionModeCubit _deletionModeCubit;

  @override
  void initState() {
    super.initState();
    final todosRepository = context.read<ITodosRepository>();
    _stepsBloc = TodoStepsBloc(todosRepository, widget._todo)
      ..add(StepsLoadingRequestedEvent());
    _imagesBloc = TodoImagesBloc(todosRepository, widget._todo)
      ..add(ImagesLoadingRequestedEvent());
    _todoBloc = TodoBloc(todosRepository, NotificationsService(), widget._todo);
    _deletionModeCubit = DeletionModeCubit();
  }

  @override
  void dispose() {
    _stepsBloc.close();
    _todoBloc.close();
    _imagesBloc.close();
    _deletionModeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const appBarMaxExtent = 200.0;

    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoStepsBloc>.value(value: _stepsBloc),
        BlocProvider<TodoImagesBloc>.value(value: _imagesBloc),
        BlocProvider<TodoBloc>.value(value: _todoBloc),
        BlocProvider<DeletionModeCubit>.value(value: _deletionModeCubit),
      ],
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: widget._branchTheme.primaryColor,
          accentColor: widget._branchTheme.primaryColor,
          scaffoldBackgroundColor: widget._branchTheme.secondaryColor,
        ),
        child: BlocConsumer<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state is TodoDeletedState) {
              Navigator.of(context).pop();
            }
          },
          buildWhen: (previous, current) => current is! TodoDeletedState,
          builder: (context, state) => DeletionModeWillPopScope(
            child: Scaffold(
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: TodoSliverAppBar(
                      appBarMaxExtent,
                      MediaQuery.of(context).padding.top,
                      widget._branchTheme,
                      state.todo,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 4.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TodoStepsCard(state.todo),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TodoTimeSettingsCard(state.todo),
                      ),
                      const SizedBox(height: 20.0),
                      TodoImagesCard(widget._branchTheme),
                      const SizedBox(height: 20.0),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
