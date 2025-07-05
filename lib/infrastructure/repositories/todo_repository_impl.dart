import 'package:fpdart/fpdart.dart';
import 'package:test_todo/core/error/failures.dart';
import 'package:test_todo/domain/entities/todo.dart';
import 'package:test_todo/domain/repositories/todo_repository.dart';
import 'package:test_todo/infrastructure/datasources/todo_datasource.dart';
import 'package:test_todo/infrastructure/models/todo_request.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDatasource _todoDatasource;

  TodoRepositoryImpl(this._todoDatasource);

  @override
  Future<Either<Failures, List<Todo>>> getTodos() async {
    try {
      final result = await _todoDatasource.getTodos();
      return Right(result);
    } on Failures catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failures, bool>> createTodo(TodoRequest todoRequest) async {
    try {
      final result = await _todoDatasource.createTodo(todoRequest);
      return Right(result);
    } on Failures catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failures, bool>> updateTodo(int id, TodoRequest todoRequest) async {
    try {
      final result = await _todoDatasource.updateTodo(id, todoRequest);
      return Right(result);
    } on Failures catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failures, bool>> deleteTodo(int id) async {
    try {
      final result = await _todoDatasource.deleteTodo(id);
      return Right(result);
    } on Failures catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failures, bool>> toggleTodoStatus(String id) async {
    try {
      final result = await _todoDatasource.toggleTodoStatus(id);
      return Right(result);
    } on Failures catch (failure) {
      return Left(failure);
    }
  }

} 