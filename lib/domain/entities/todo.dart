class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime? fechaLimite;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.fechaLimite,
    required this.isCompleted,
  });
}
