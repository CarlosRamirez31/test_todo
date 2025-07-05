class TodoRequest {
  final String title;
  final String description;
  final DateTime? fechaLimite;
  final bool isCompleted;

  TodoRequest({
    required this.title,
    required this.description,
    this.fechaLimite,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'fechaLimite': fechaLimite?.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
