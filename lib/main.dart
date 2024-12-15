import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/todo_model.dart';
import 'providers/todo_provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-Do List',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.blueGrey[900],
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        home: TodoListScreen(),
      ),
    );
  }
}

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'To-Do List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[900]!, Colors.blue[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Consumer<TodoProvider>(
          builder: (context, provider, child) {
            final todos = provider.todoBox.values.toList();
            return todos.isEmpty
                ? Center(
                    child: Text(
                      'No tasks available!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Card(
                        color:
                            todo.isDone ? Colors.blue[200] : Colors.blue[100],
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: todo.isDone
                                  ? Colors.blue[900]
                                  : Colors.blue[700],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(CupertinoIcons.delete,
                                color: Colors.red[700]),
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
                        ),
                      );
                    },
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTodoScreen()),
          );
        },
        label: Text('Add Task'),
        icon: Icon(CupertinoIcons.add),
        backgroundColor: Colors.blue[800],
      ),
    );
  }
}

class AddTodoScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Add Task'),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[900]!, Colors.blue[700]!],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: Colors.white),
                // filled: true,
                fillColor: Colors.blue[100],
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[800]!),
                ),
              ),
            ),
            SizedBox(height: 20),
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

class UpdateTodoScreen extends StatelessWidget {
  final int index;
  final TextEditingController controller = TextEditingController();

  UpdateTodoScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    final todo = context.read<TodoProvider>().todoBox.getAt(index);
    controller.text = todo!.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Task'),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[900]!, Colors.blue[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: Colors.white),
                //: true,
                fillColor: Colors.blue[100],
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[800]!),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = controller.text;
                if (title.isNotEmpty) {
                  final updatedTodo = Todo(
                    title: title,
                    isDone: todo.isDone,
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
