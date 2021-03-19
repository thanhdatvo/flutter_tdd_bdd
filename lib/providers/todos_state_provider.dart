import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tdd_bdd/models/todo_model.dart';
import 'package:flutter_tdd_bdd/providers/todos_repository_provider.dart';

class TodosStateNotifier extends StateNotifier<List<TodoModel>> {
  final Reader read;
  TodosStateNotifier(this.read) : super([]);

  Future<void> insert(TodoModel todo) async {
    await read(todosRepositoryProvider).add(todo);
    state.add(todo);
    state = [...state];
  }

  Future<void> update(TodoModel todo) async {
    await read(todosRepositoryProvider).update(todo);
    final index = state.indexWhere((e) => e.id == todo.id);
    state..[index] = todo;
  }

  Future<void> deleteById(String id) async {
    await read(todosRepositoryProvider).deleteById(id);
    state..removeWhere((e) => e.id == id);
  }

  Future<void> queryBy(bool isCompleted) async {
    state = await read(todosRepositoryProvider).queryBy(isCompleted);
  }
}

final todosStateProvider =
    StateNotifierProvider((ref) => TodosStateNotifier(ref.read));
