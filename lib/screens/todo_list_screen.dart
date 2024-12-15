import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import ' add_todo_screen.dart';
import '../providers/todo_provider.dart';
import 'update_todo_screen.dart';

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          final todos = provider.todoBox.values.toList();
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(todo.title),
                trailing: IconButton(
                  icon: Icon(CupertinoIcons.delete),
                  onPressed: () => provider.deleteTodo(index),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateTodoScreen(index: index),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTodoScreen()),
          );
        },
        child: Icon(CupertinoIcons.add),
      ),
    );
  }
}
