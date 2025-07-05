import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'todo_filter_state.dart';

class TodoFilterCubit extends Cubit<TodoFilterState> {
  TodoFilterCubit() : super(const TodoFilterState());

  void queryChanged(String query) {
    emit(state.copyWith(query: query));
  }

  void setCompletedFilter(bool isCompleted) {
    emit(state.copyWith(
      isCompleted: isCompleted,
      hasCompletedFilter: true,
    ));
  }

  void clearCompletedFilter() {
    emit(state.copyWith(
      hasCompletedFilter: false,
      isCompleted: false,
    ));
  }

  void setDateFilter(DateTime? date) {
    emit(state.copyWith(filterDate: date));
  }

  void clearDateFilter() {
    emit(state.copyWith(clearFilterDate: true));
  }

  void clearAllFilters() {
    emit(const TodoFilterState());
  }

  void showAllTodos() {
    emit(state.copyWith(
      isCompleted: false,
      hasCompletedFilter: false,
      clearFilterDate: true,
    ));
  }

  void showCompletedTodos() {
    emit(state.copyWith(
      isCompleted: true,
      hasCompletedFilter: true,
    ));
  }

  void showPendingTodos() {
    emit(state.copyWith(
      isCompleted: false,
      hasCompletedFilter: true,
    ));
  }
}
