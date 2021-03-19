import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tdd_bdd/models/todo_model.dart';
import 'package:flutter_tdd_bdd/providers/todos_state_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<FormFieldState<String>> _formFieldKey;
  @override
  void initState() {
    super.initState();
    _formFieldKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextFormField(
                key: _formFieldKey,
              ),
              ElevatedButton(
                child: Text("add"),
                onPressed: () async {
                  final title = _formFieldKey.currentState.value;
                  if (title != null && title.length > 0) {
                    await context
                        .read(todosStateProvider)
                        .insert(TodoModel("31", title, false));
                    _formFieldKey.currentState.reset();
                  }
                },
              )
            ],
          ),
          Expanded(
            child: Consumer(
              builder: (context, watch, child) {
                final todos = watch(todosStateProvider.state);
                return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoWidget(key: Key(todo.id), todo: todo);
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final TodoModel todo;
  const TodoWidget({Key key, this.todo}) : super(key: key);
  _completeTodo(BuildContext context) {
    context
        .read(todosStateProvider)
        .update(TodoModel(todo.id, todo.title, true));
  }

  _deleteTodo(BuildContext context) {
    context.read(todosStateProvider).deleteById(todo.id);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(todo.title)),
        IconButton(
            icon: Icon(Icons.check), onPressed: () => _completeTodo(context)),
        IconButton(
            icon: Icon(Icons.delete), onPressed: () => _deleteTodo(context))
      ],
    );
  }
}
