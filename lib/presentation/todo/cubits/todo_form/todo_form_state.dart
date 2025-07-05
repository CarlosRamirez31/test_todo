part of 'todo_form_cubit.dart';

class TodoFormState extends Equatable {
  final RequiredField title;
  final RequiredField description;
  final DateTime? fechaLimite;
  final bool isCompleted;
  final bool isValid;

  const TodoFormState({
    this.title = const RequiredField.pure(),
    this.description = const RequiredField.pure(),
    this.isCompleted = false,
    this.fechaLimite,
    this.isValid = false,
  });

  copyWith({
    RequiredField? title,
    RequiredField? description,
    DateTime? fechaLimite,
    bool? isCompleted,
    bool? isValid,
    bool clearFechaLimite = false,
  }) => TodoFormState(
    title: title ?? this.title,
    description: description ?? this.description,
    fechaLimite: clearFechaLimite ? null : fechaLimite ?? this.fechaLimite,
    isCompleted: isCompleted ?? this.isCompleted,
    isValid: isValid ?? this.isValid,
  );

  @override
  List<Object?> get props => [title, description, fechaLimite, isCompleted, isValid];
}
