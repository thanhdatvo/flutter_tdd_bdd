
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tdd_bdd/repository/todos_state_repository.dart';

final todosRepositoryProvider = Provider<ITodoRepository>((ref)=>TodoRepository());