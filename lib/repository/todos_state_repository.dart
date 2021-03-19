import 'package:flutter_tdd_bdd/models/todo_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String TODOS_TABLE = "todos";

abstract class ITodoRepository {
  Future<void> add(TodoModel todo);
  Future<bool> deleteById(String id);
  Future<bool> update(TodoModel todo);
  Future<List<TodoModel>> queryBy(bool isCompleted);
}

class TodoRepository implements ITodoRepository {
  static final TodoRepository _instance = TodoRepository._();
  TodoRepository._();
  factory TodoRepository() => _instance;
  Database _database;
  init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $TODOS_TABLE(id TEXT PRIMARY KEY, title TEXT, isCompleted INTEGER)",
        );
      },
      version: 1,
    );
  }

  @override
  Future<void> add(TodoModel todo) async {
    await _database.insert(
      TODOS_TABLE,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<bool> deleteById(String id) async {
    final result = await _database.delete(
      TODOS_TABLE,
      where: "id = ?",
      whereArgs: [id],
    );
    return result == 1;
  }

  @override
  Future<List<TodoModel>> queryBy(bool isCompleted) async {
    List<Map<String, Object>> results;
    if (isCompleted == null) {
      results = await _database.query(TODOS_TABLE);
    } else {
      results = await _database.query(
        TODOS_TABLE,
        where: "isCompleted = ?",
        whereArgs: [isCompleted],
      );
    }
    return results.map<TodoModel>((e) => TodoModel.fromMap(e)).toList();
  }

  @override
  Future<bool> update(TodoModel todo) async {
    final results = await _database.update(
      TODOS_TABLE,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return results == 1;
  }
}
