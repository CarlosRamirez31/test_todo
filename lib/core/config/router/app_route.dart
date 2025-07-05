import 'package:go_router/go_router.dart';
import 'package:test_todo/domain/entities/todo.dart';
import 'package:test_todo/presentation/todo/screens/add_edit_todo_screen.dart';
import 'package:test_todo/presentation/todo/screens/todo_screen.dart';

class AppRoute {
  static final GoRouter router = GoRouter(
    initialLocation: '/todo',
    routes: [
      GoRoute(
        path: '/todo',
        name: 'todo',
        builder: (context, state) => const TodoScreen(),
      ),
      GoRoute(
        path: '/add_edit_todo',
        name: 'add-todo',
        builder: (context, state) {
          final todo = state.extra as Todo?;

          return AddEditTodoScreen(todo: todo);
        },
      ),
    ],
  );
}
