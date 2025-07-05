import 'package:fpdart/fpdart.dart';
import 'package:test_todo/core/error/failures.dart';
import 'package:test_todo/domain/entities/todo.dart';
import 'package:test_todo/infrastructure/models/todo_request.dart';

abstract class TodoRepository {
  Future<Either<Failures, List<Todo>>> getTodos();
  Future<Either<Failures, bool>> createTodo(TodoRequest todoRequest);
  Future<Either<Failures, bool>> updateTodo(String id, TodoRequest todoRequest);
  Future<Either<Failures, bool>> deleteTodo(String id);
  Future<Either<Failures, bool>> toggleTodoStatus(String id);
} 