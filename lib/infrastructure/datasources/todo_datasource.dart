import 'package:sqflite/sqflite.dart';
import 'package:test_todo/core/error/failures.dart';
import 'package:test_todo/core/helpers/database_helper.dart';
import 'package:test_todo/domain/entities/todo.dart';
import 'package:test_todo/infrastructure/models/todo_request.dart';
import 'package:test_todo/infrastructure/models/todo_response.dart';

abstract class TodoDatasource {
  Future<List<Todo>> getTodos();
  Future<bool> createTodo(TodoRequest todoRequest);
  Future<bool> updateTodo(int id, TodoRequest todoRequest);
  Future<bool> deleteTodo(int id);
  Future<bool> toggleTodoStatus(String id);
}

class TodoDatasourceImpl implements TodoDatasource {
  final DatabaseHelper _databaseHelper;

  TodoDatasourceImpl(this._databaseHelper);

  Future<Database> get _database async => await _databaseHelper.database;

  @override
  Future<List<Todo>> getTodos() async {
    try {
      final db = await _database;
      final maps = await db.query('todos', orderBy: 'id DESC');

      return maps.map((map) => TodoResponse.fromMap(map).toEntity()).toList();
    } on DatabaseException catch (e) {
      throw DatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> createTodo(TodoRequest todoRequest) async {
    try {
      final db = await _database;
      await db.insert('todos', todoRequest.toJson());
      return true;
    } on DatabaseException catch (e) {
      throw DatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> updateTodo(int id, TodoRequest todoRequest) async {
    try {
      final db = await _database;

      await db.update(
        'todos',
        todoRequest.toJson(),
        where: 'id = ?',
        whereArgs: [id],
      );

      return true;
    } on DatabaseException catch (e) {
      throw DatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> deleteTodo(int id) async {
    try {
      final db = await _database;
      await db.delete('todos', where: 'id = ?', whereArgs: [id]);
      return true;
    } on DatabaseException catch (e) {
      throw DatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> toggleTodoStatus(String id) async {
    try {
      final db = await _database;

      await db.rawUpdate(
        '''
        UPDATE todos 
        SET isCompleted = CASE 
          WHEN isCompleted = 1 THEN 0 
          ELSE 1 
        END 
        WHERE id = ?
      ''',
        [int.parse(id)],
      );

      return true;
    } on DatabaseException catch (e) {
      throw DatabaseFailure(message: e.toString());
    }
  }
}
