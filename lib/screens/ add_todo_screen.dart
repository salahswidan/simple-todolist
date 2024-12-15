import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../models/todo_model.dart';

class AddTodoScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Task Title',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final title = controller.text;
                if (title.isNotEmpty) {
                  final todo = Todo(title: title);
                  context.read<TodoProvider>().addTodo(todo);
                  Navigator.pop(context);
                }
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
