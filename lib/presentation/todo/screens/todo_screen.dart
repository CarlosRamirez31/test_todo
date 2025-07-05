import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:test_todo/common/button/custom_filled_button.dart';
import 'package:test_todo/core/cubit/theme/theme_cubit.dart';
import 'package:test_todo/core/utils/string_format.dart';
import 'package:test_todo/domain/repositories/todo_repository.dart';
import 'package:test_todo/presentation/todo/cubits/get_todo/get_todo_cubit.dart';
import 'package:test_todo/presentation/todo/cubits/todo_filter/todo_filter_cubit.dart';
import 'package:test_todo/common/text_form/custom_text_form_field.dart';
import 'package:test_todo/domain/entities/todo.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => GetIt.I<GetTodoCubit>()..getTodos(),
      child: Builder(
        builder: (contextCubit) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<TodoFilterCubit, TodoFilterState>(
                        builder: (context, filterState) {
                          return GestureDetector(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate:
                                    filterState.filterDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (date != null) {
                                if (!context.mounted) return;

                                context.read<TodoFilterCubit>().setDateFilter(
                                  date,
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Today',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  filterState.filterDate != null
                                      ? StringFormat.formatDateHeader(
                                        filterState.filterDate!,
                                      )
                                      : StringFormat.formatDateHeader(
                                        DateTime.now(),
                                      ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        filterState.filterDate != null
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                            : null,
                                  ),
                                ),
                                if (filterState.filterDate != null) ...[
                                  SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<TodoFilterCubit>()
                                          .clearDateFilter();
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      size: 16,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                      BlocBuilder<ThemeCubit, bool>(
                        builder: (context, isDarkMode) {
                          return IconButton(
                            icon: Icon(
                              isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            ),
                            onPressed:
                                () => context.read<ThemeCubit>().toggleTheme(),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  FilterSection(),

                  SizedBox(height: 20),

                  BlocBuilder<GetTodoCubit, GetTodoState>(
                    builder: (context, state) {
                      if (state is GetTodoLoading) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (state is GetTodoFailure) {
                        return Center(child: Text(state.message));
                      }

                      if (state is GetTodoLoaded) {
                        final todos = state.todos;

                        if (todos.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No hay tareas',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              final todo = todos[index];

                              return TodoItem(
                                todo: todo,
                                onEdit: () async {
                                  context.go('/add_edit_todo', extra: todo);
                                },
                                onDelete: () async {
                                  await _showDeleteConfirmation(
                                    context,
                                    onDelete: () async {
                                      final result =
                                          await GetIt.I<TodoRepository>()
                                              .deleteTodo(todo.id);
                                      result.fold(
                                        (failure) {
                                          context.pop();

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(failure.message),
                                            ),
                                          );
                                        },
                                        (success) {
                                          context
                                              .read<GetTodoCubit>()
                                              .getTodos();

                                          context.pop();
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }

                      return SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            floatingActionButton: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                context.pushReplacement('/add_edit_todo');
              },
              child: Icon(Icons.add, color: colorScheme.onTertiary, size: 25),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context, {
    required void Function() onDelete,
  }) async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirmar eliminación',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          content: Text(
            '¿Estás seguro de que quieres eliminar esta tarea?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(onPressed: () => context.pop(), child: Text('Cancelar')),
            TextButton(onPressed: onDelete, child: Text('Eliminar')),
          ],
        );
      },
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todo;
  final Future<void> Function() onEdit;
  final Future<void> Function() onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final todo = widget.todo;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Dismissible(
        key: ValueKey('${widget.todo.id}'),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          switch (direction) {
            case DismissDirection.startToEnd:
              await widget.onEdit();
              break;
            case DismissDirection.endToStart:
              await widget.onDelete();
              break;
            default:
              break;
          }

          setState(() {});
          return false;
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.edit, color: colorScheme.onPrimary),
              SizedBox(width: 8),
              Text(
                'Editar',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: colorScheme.error,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Eliminar',
                style: TextStyle(
                  color: colorScheme.onError,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.delete, color: colorScheme.onError),
            ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              if (todo.fechaLimite != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Tarea programada para el ${StringFormat.formatScheduledDate(todo.fechaLimite!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) async {
                    if (value != null) {
                      final result = await GetIt.I<TodoRepository>()
                          .toggleTodoStatus(todo.id.toString());
                      result.fold(
                        (failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(failure.message)),
                          );
                        },
                        (success) {
                          context.read<GetTodoCubit>().getTodos();
                        },
                      );
                    }
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: 16,
                        decoration:
                            todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                        decorationColor: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      todo.description,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            todo.isCompleted
                                ? Colors.grey.shade600.withOpacity(0.5)
                                : Colors.grey.shade600,
                        decoration:
                            todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                        decorationColor: Colors.grey.shade500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterSection extends StatelessWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<TodoFilterCubit, TodoFilterState>(
      builder: (context, state) {
        final filterState = context.watch<TodoFilterCubit>().state;

        return Column(
          children: [
            // Barra de búsqueda
            CustomTextFormField(
              hintText: 'Buscar tareas...',
              initialValue: filterState.query,
              onChanged: (query) {
                context.read<TodoFilterCubit>().queryChanged(query);
              },
            ),

            SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CustomFilledButton(
                  text: 'Todas',
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor:
                      !filterState.hasCompletedFilter
                          ? colorScheme.primary
                          : colorScheme.surface,
                  foregroundColor:
                      !filterState.hasCompletedFilter
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                  onPressed:
                      () => context.read<TodoFilterCubit>().showAllTodos(),
                ),
                CustomFilledButton(
                  text: 'Pendientes',
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor:
                      filterState.hasCompletedFilter && !filterState.isCompleted
                          ? colorScheme.primary
                          : colorScheme.surface,
                  foregroundColor:
                      filterState.hasCompletedFilter && !filterState.isCompleted
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                  onPressed:
                      () => context.read<TodoFilterCubit>().showPendingTodos(),
                ),
                CustomFilledButton(
                  text: 'Completados',
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor:
                      filterState.hasCompletedFilter && filterState.isCompleted
                          ? colorScheme.primary
                          : colorScheme.surface,
                  foregroundColor:
                      filterState.hasCompletedFilter && filterState.isCompleted
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                  onPressed:
                      () =>
                          context.read<TodoFilterCubit>().showCompletedTodos(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
