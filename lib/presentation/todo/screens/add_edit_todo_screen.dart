import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:test_todo/common/button/custom_filled_button.dart';
import 'package:test_todo/common/text_form/custom_text_form_field.dart';
import 'package:test_todo/core/utils/string_format.dart';
import 'package:test_todo/domain/entities/todo.dart';
import 'package:test_todo/domain/repositories/todo_repository.dart';
import 'package:test_todo/infrastructure/models/todo_request.dart';
import 'package:test_todo/presentation/todo/cubits/todo_form/todo_form_cubit.dart';

class AddEditTodoScreen extends StatelessWidget {
  final Todo? todo;

  const AddEditTodoScreen({super.key, this.todo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<TodoFormCubit>(),
      child: AddEditTodoView(todo: todo),
    );
  }
}

class AddEditTodoView extends StatefulWidget {
  final Todo? todo;
  const AddEditTodoView({super.key, this.todo});

  @override
  State<AddEditTodoView> createState() => _AddEditTodoViewState();
}

class _AddEditTodoViewState extends State<AddEditTodoView> {
  @override
  void initState() {
    super.initState();
    context.read<TodoFormCubit>().init(widget.todo);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = widget.todo != null;
    final todoFormCubit = context.watch<TodoFormCubit>();
    final title = todoFormCubit.state.title;
    final description = todoFormCubit.state.description;
    final fechaLimite = todoFormCubit.state.fechaLimite;

    return SafeArea(
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    Text(
                      isEditing ? 'Editar Tarea' : 'Nueva Tarea',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.go('/todo'),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                CustomTextFormField(
                  hintText: 'Título',
                  onChanged: todoFormCubit.titleChanged,
                  errorText: title.errorMessage,
                  initialValue: title.value,
                ),

                const SizedBox(height: 20),

                CustomTextFormField(
                  hintText: 'Descripción',
                  onChanged: todoFormCubit.descriptionChanged,
                  enableAutoExpand: true,
                  defaultLines: 5,
                  errorText: description.errorMessage,
                  initialValue: description.value,
                ),

                const SizedBox(height: 20),

                BlocBuilder<TodoFormCubit, TodoFormState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.fechaLimite != null)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 20,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Tarea programada para el ${StringFormat.formatScheduledDate(state.fechaLimite!)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<TodoFormCubit>()
                                        .clearFechaLimite();
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    size: 18,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        state.fechaLimite ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2030),
                                  );
                                  if (date != null) {
                                    if (!context.mounted) return;

                                    context
                                        .read<TodoFormCubit>()
                                        .fechaLimiteChanged(date);
                                  }
                                },
                                icon: Icon(Icons.calendar_today),
                                label: Text(
                                  state.fechaLimite != null
                                      ? 'Cambiar fecha'
                                      : 'Asignar fecha límite',
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: CustomFilledButton(
                    text: isEditing ? 'Actualizar' : 'Guardar',
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: colorScheme.primary,
                    onPressed: () async {
                      todoFormCubit.submit();

                      if (!todoFormCubit.state.isValid) return;

                      final todoRequest = TodoRequest(
                        title: title.value,
                        description: description.value,
                        fechaLimite: fechaLimite,
                        isCompleted: widget.todo?.isCompleted ?? false,
                      );

                      if (isEditing) {
                        final result = await GetIt.I<TodoRepository>()
                            .updateTodo(widget.todo!.id, todoRequest);

                        result.fold(
                          (failure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(failure.message)),
                            );
                          },
                          (success) {
                            context.go('/todo');
                          },
                        );
                      } else {
                        final result = await GetIt.I<TodoRepository>()
                            .createTodo(todoRequest);

                        result.fold(
                          (failure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(failure.message)),
                            );
                          },
                          (success) {
                            context.go('/todo');
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
