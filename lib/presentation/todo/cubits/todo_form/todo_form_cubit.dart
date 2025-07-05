import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:test_todo/core/utils/validations/required_field.dart';
import 'package:test_todo/domain/entities/todo.dart';

part 'todo_form_state.dart';

class TodoFormCubit extends Cubit<TodoFormState> {
  TodoFormCubit() : super(const TodoFormState());

  void init(Todo? todo) {
    if (todo == null) return;

    emit(
      state.copyWith(
        title: RequiredField.dirty(value: todo.title),
        description: RequiredField.dirty(value: todo.description),
        fechaLimite: todo.fechaLimite,
      ),
    );
  }

  void submit() {
    emit(
      state.copyWith(
        title: RequiredField.dirty(value: state.title.value),
        description: RequiredField.dirty(value: state.description.value),
        isValid: Formz.validate([state.title, state.description]),
      ),
    );
  }

  void titleChanged(String value) {
    final title = RequiredField.dirty(value: value);

    emit(state.copyWith(title: title, isValid: Formz.validate([title])));
  }

  void descriptionChanged(String value) {
    final description = RequiredField.dirty(value: value);

    emit(
      state.copyWith(
        description: description,
        isValid: Formz.validate([description]),
      ),
    );
  }

  void fechaLimiteChanged(DateTime? fechaLimite) {
    emit(state.copyWith(fechaLimite: fechaLimite));
  }

  void clearFechaLimite() {
    emit(state.copyWith(clearFechaLimite: true));
  }

  void isCompletedChanged(bool value) {
    emit(state.copyWith(isCompleted: value));
  }
}
