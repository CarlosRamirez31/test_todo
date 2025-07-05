part of 'todo_filter_cubit.dart';

class TodoFilterState extends Equatable {
  final String query;
  final bool isCompleted;
  final bool hasCompletedFilter;
  final DateTime? filterDate;

  const TodoFilterState({
    this.query = '',
    this.isCompleted = false,
    this.hasCompletedFilter = false,
    this.filterDate,
  });

  copyWith({
    String? query,
    bool? isCompleted,
    bool? hasCompletedFilter,
    DateTime? filterDate,
    bool clearFilterDate = false,
  }) {
    return TodoFilterState(
      query: query ?? this.query,
      isCompleted: isCompleted ?? this.isCompleted,
      hasCompletedFilter: hasCompletedFilter ?? this.hasCompletedFilter,
      filterDate: clearFilterDate ? null : filterDate ?? this.filterDate,
    );
  }

  @override
  List<Object?> get props => [query, isCompleted, hasCompletedFilter, filterDate];
}
