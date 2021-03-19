import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tdd_bdd/models/todo_model.dart';
import 'package:flutter_tdd_bdd/providers/todos_repository_provider.dart';
import 'package:flutter_tdd_bdd/providers/todos_state_provider.dart';
import 'package:flutter_tdd_bdd/repository/todos_state_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTodosRepository implements ITodoRepository {
  @override
  Future<void> add(TodoModel todo) async {
    return;
  }

  @override
  Future<bool> deleteById(String id) async {
    return true;
  }

  @override
  Future<List<TodoModel>> queryBy(bool isCompleted) async {
    return [];
  }

  @override
  Future<bool> update(TodoModel todo) async {
    return true;
  }
}

void main() {
  test('insert one todo', () async {
    final container = ProviderContainer(overrides: [
      todosRepositoryProvider.overrideWithValue(FakeTodosRepository())
    ]);
    await container
        .read(todosStateProvider)
        .insert(TodoModel("1", "title", true));
    final data = container.read(todosStateProvider.state);
    expect(data, [
      isA<TodoModel>()
          .having((s) => s.id, "#1 id", "1")
          .having((s) => s.title, "#1 title", "title")
          .having((s) => s.isCompleted, "#1 isCompleted", true)
    ]);
  });
}
