import 'package:isar/isar.dart';
import '../../core/storage/isar_service.dart';
import '../models/task_model.dart';

/// Local data source for managing tasks in Isar database
class TaskLocal {
  late final Isar _isar;

  TaskLocal() {
    _isar = IsarService.instance.isar;
  }

  /// Get all tasks from local storage
  Future<List<TaskModel>> getTasks() async {
    return await _isar.taskModels.where().findAll();
  }

  /// Get tasks by completion status
  Future<List<TaskModel>> getTasksByStatus(bool isCompleted) async {
    return await _isar.taskModels
        .filter()
        .isCompletedEqualTo(isCompleted)
        .findAll();
  }

  /// Save a single task
  Future<int> saveTask(TaskModel task) async {
    return await _isar.writeTxn(() async {
      return await _isar.taskModels.put(task);
    });
  }

  /// Save multiple tasks
  Future<void> saveTasks(List<TaskModel> tasks) async {
    await _isar.writeTxn(() async {
      await _isar.taskModels.putAll(tasks);
    });
  }

  /// Update an existing task
  Future<bool> updateTask(TaskModel task) async {
    task.updatedAt = DateTime.now();
    final id = await _isar.writeTxn(() async {
      return await _isar.taskModels.put(task);
    });
    return id > 0;
  }

  /// Delete a task by ID
  Future<bool> deleteTask(int id) async {
    return await _isar.writeTxn(() async {
      return await _isar.taskModels.delete(id);
    });
  }

  /// Delete all tasks
  Future<void> deleteAll() async {
    await _isar.writeTxn(() async {
      await _isar.taskModels.clear();
    });
  }

  /// Clear all data and seed with initial tasks
  Future<void> clearAndSeed(List<TaskModel> tasks) async {
    await _isar.writeTxn(() async {
      await _isar.taskModels.clear();
      await _isar.taskModels.putAll(tasks);
    });
  }

  /// Check if local storage is empty
  Future<bool> isEmpty() async {
    final count = await _isar.taskModels.count();
    return count == 0;
  }
}
