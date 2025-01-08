import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/task.dart';
import 'db.dart';

class TaskListNotifier extends AutoDisposeAsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    List<Task> list = await fetch();
    return list;
  }

  Future<List<Task>> fetch() async {
    final dbHelper = DBhelper.instance;
    var list = await dbHelper.queryTask();
    return list;
  }

  Future<void> toggle(Task task) async {
    final dbHelper = DBhelper.instance;
    state = await AsyncValue.guard(() async {
      await dbHelper.updateTask(task);
      return fetch();
    });
  }

  Future<void> add(Task task) async {
    final dbHelper = DBhelper.instance;
    state = await AsyncValue.guard(() async {
      await dbHelper.insertTask(task);
      return fetch();
    });
  }
}

final taskListProvider =
    AsyncNotifierProvider.autoDispose<TaskListNotifier, List<Task>>(
        TaskListNotifier.new);
