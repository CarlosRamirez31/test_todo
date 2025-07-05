import 'package:go_router/go_router.dart';
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
    ],
  );
}
