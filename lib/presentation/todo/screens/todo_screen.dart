import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_todo/core/cubit/theme/theme_cubit.dart';

class TodoItem {
  final String title;
  bool isCompleted;

  TodoItem({required this.title, required this.isCompleted});
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<TodoItem> _todoItems = [
    TodoItem(title: 'Hacer la tarea de la universidad', isCompleted: false),
    TodoItem(title: 'Comprar comida para la fiesta', isCompleted: false),
    TodoItem(title: 'Desayunar', isCompleted: false),
    TodoItem(title: 'Dormir', isCompleted: false),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                      '26 Dic',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                BlocBuilder<ThemeCubit, bool>(
                  builder: (context, isDarkMode) {
                    return IconButton(
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      ),
                      onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: _todoItems.length,
                itemBuilder: (context, index) {
                  final todo = _todoItems[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (value) {},
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        Expanded(
                          child: Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 16,
                              decorationColor: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
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
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: colorScheme.onTertiary,
          size: 25,
        ),
      ),
    );
  }
}
