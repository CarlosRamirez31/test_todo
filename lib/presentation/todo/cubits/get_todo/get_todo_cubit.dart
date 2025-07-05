import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_todo/domain/entities/todo.dart';
import 'package:test_todo/domain/repositories/todo_repository.dart';
import 'package:test_todo/presentation/todo/cubits/todo_filter/todo_filter_cubit.dart';

part 'get_todo_state.dart';

class GetTodoCubit extends Cubit<GetTodoState> {
  final TodoRepository _todoRepository;
  final TodoFilterCubit _todoFilterCubit;
  late final StreamSubscription _filterSubscription;
  final List<Todo> originalTodos = [];

  GetTodoCubit(this._todoRepository, this._todoFilterCubit)
    : super(GetTodoInitial()) {
    _filterSubscription = _todoFilterCubit.stream.listen(_onFilterChange);
  }

  void _onFilterChange(TodoFilterState filterState) {
    if (originalTodos.isEmpty) return;

    List<Todo> filteredTodos = originalTodos;

    // Aplicar filtro por query (título o descripción)
    if (filterState.query.isNotEmpty) {
      filteredTodos =
          filteredTodos.where((todo) {
            final titleMatch = todo.title.toLowerCase().contains(
              filterState.query.toLowerCase(),
            );
            final descriptionMatch = todo.description.toLowerCase().contains(
              filterState.query.toLowerCase(),
            );
            return titleMatch || descriptionMatch;
          }).toList();
    }

    // Aplicar filtro por estado completado
    if (filterState.hasCompletedFilter) {
      filteredTodos =
          filteredTodos
              .where((todo) => todo.isCompleted == filterState.isCompleted)
              .toList();
    }

    // Aplicar filtro por fecha
    if (filterState.filterDate != null) {
      filteredTodos = filteredTodos.where((todo) {
        if (todo.fechaLimite == null) return false;
        
        final todoDate = DateTime(
          todo.fechaLimite!.year,
          todo.fechaLimite!.month,
          todo.fechaLimite!.day,
        );
        
        final filterDate = DateTime(
          filterState.filterDate!.year,
          filterState.filterDate!.month,
          filterState.filterDate!.day,
        );
        
        return todoDate.isAtSameMomentAs(filterDate);
      }).toList();
    }

    emit(GetTodoLoaded(todos: filteredTodos));
  }

  Future<void> getTodos() async {
    emit(GetTodoLoading());

    final result = await _todoRepository.getTodos();

    if (isClosed) return;

    result.fold((failure) => emit(GetTodoFailure(message: failure.message)), (
      todos,
    ) {
      originalTodos.clear();

      originalTodos.addAll(todos);

      final currentFilter = _todoFilterCubit.state;
      _applyFilters(currentFilter);
    });
  }

  void _applyFilters(TodoFilterState filterState) {
    List<Todo> filteredTodos = originalTodos;

    // Aplicar filtro por query
    if (filterState.query.isNotEmpty) {
      filteredTodos =
          filteredTodos.where((todo) {
            final titleMatch = todo.title.toLowerCase().contains(
              filterState.query.toLowerCase(),
            );
            final descriptionMatch = todo.description.toLowerCase().contains(
              filterState.query.toLowerCase(),
            );
            return titleMatch || descriptionMatch;
          }).toList();
    }

    // Aplicar filtro por estado completado
    if (filterState.hasCompletedFilter) {
      filteredTodos =
          filteredTodos
              .where((todo) => todo.isCompleted == filterState.isCompleted)
              .toList();
    }

    // Aplicar filtro por fecha
    if (filterState.filterDate != null) {
      filteredTodos = filteredTodos.where((todo) {
        if (todo.fechaLimite == null) return false;
        
        final todoDate = DateTime(
          todo.fechaLimite!.year,
          todo.fechaLimite!.month,
          todo.fechaLimite!.day,
        );
        
        final filterDate = DateTime(
          filterState.filterDate!.year,
          filterState.filterDate!.month,
          filterState.filterDate!.day,
        );
        
        return todoDate.isAtSameMomentAs(filterDate);
      }).toList();
    }

    emit(GetTodoLoaded(todos: filteredTodos));
  }

  @override
  Future<void> close() {
    _filterSubscription.cancel();
    return super.close();
  }
}
