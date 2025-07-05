part of 'get_todo_cubit.dart';

sealed class GetTodoState extends Equatable {
  const GetTodoState();

  @override
  List<Object> get props => [];
}

final class GetTodoInitial extends GetTodoState {}

final class GetTodoLoading extends GetTodoState {}

final class GetTodoLoaded extends GetTodoState {
  final List<Todo> todos;

  const GetTodoLoaded({required this.todos});

  @override
  List<Object> get props => [todos];
}

final class GetTodoFailure extends GetTodoState {
  final String message;

  const GetTodoFailure({required this.message});

  @override
  List<Object> get props => [message];
}
