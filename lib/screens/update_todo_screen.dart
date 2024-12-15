import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../models/todo_model.dart';

class UpdateTodoScreen extends StatelessWidget {
  final int index;
  final TextEditingController controller = TextEditingController();

  UpdateTodoScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    final todo = context.read<TodoProvider>().todoBox.getAt(index);
    controller.text = todo?.title ?? '';

    return Scaffold(
      appBar: AppBar(title: Text('Update Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = controller.text;
                if (title.isNotEmpty) {
                  final updatedTodo = Todo(
                    title: title,
                    isDone: todo?.isDone ?? false,
                  );
                  context.read<TodoProvider>().updateTodo(index, updatedTodo);
                  Navigator.pop(context);
                }
              },
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
