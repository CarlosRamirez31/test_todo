import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_todo/domain/entities/todo.dart';
import 'package:test_todo/domain/repositories/todo_repository.dart';

part 'get_todo_state.dart';

class GetTodoCubit extends Cubit<GetTodoState> {
  final TodoRepository _todoRepository;

  GetTodoCubit(this._todoRepository) : super(GetTodoInitial());

  Future<void> getTodos() async {
    emit(GetTodoLoading());

    final result = await _todoRepository.getTodos();

    if (isClosed) return;

    result.fold(
      (failure) => emit(GetTodoFailure(message: failure.message)),
      (todos) => emit(GetTodoLoaded(todos: todos)),
    );
  }
}
