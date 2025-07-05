import 'package:test_todo/domain/entities/todo.dart';

class TodoResponse {
  final int id;
  final String title;
  final String description;
  final DateTime? fechaLimite;
  final bool isCompleted;

  TodoResponse({
    required this.id,
    required this.title,
    required this.description,
    this.fechaLimite,
    required this.isCompleted,
  });

  factory TodoResponse.fromMap(Map<String, dynamic> map) {
    return TodoResponse(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      fechaLimite: map['fechaLimite'] != null
          ? DateTime.parse(map['fechaLimite'])
          : null,
      isCompleted: map['isCompleted'] == 1,
    );
  }

  Todo toEntity() {
    return Todo(
      id: id,
      title: title,
      description: description,
      fechaLimite: fechaLimite,
      isCompleted: isCompleted,
    );
  }
}
