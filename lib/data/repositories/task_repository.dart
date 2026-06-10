import '../datasource/task_api.dart';
import '../datasource/task_local.dart';
import '../models/task_model.dart';

/// Repository for task data operations
/// Combines remote and local data sources
class TaskRepository {
  final TaskApi _api;
  final TaskLocal _local;

  TaskRepository({
    required TaskApi api,
    required TaskLocal local,
  })  : _api = api,
        _local = local;

  /// Get all tasks from local storage
  Future<List<TaskModel>> getTasks() async {
    return await _local.getTasks();
  }

  /// Get tasks filtered by completion status
  Future<List<TaskModel>> getTasksByStatus(bool isCompleted) async {
    return await _local.getTasksByStatus(isCompleted);
  }

  /// Add a new task
  Future<int> addTask(TaskModel task) async {
    return await _local.saveTask(task);
  }

  /// Add a task with title and description
  Future<int> addTaskDetails(String title, String description) async {
    final task = TaskModel(
      title: title,
      description: description,
    );
    return await _local.saveTask(task);
  }

  /// Update an existing task
  Future<bool> updateTask(TaskModel task) async {
    return await _local.updateTask(task);
  }

  /// Toggle task completion status
  Future<void> toggleTask(TaskModel task) async {
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }

  /// Delete a task
  Future<bool> deleteTask(int id) async {
    return await _local.deleteTask(id);
  }

  /// Seed data from API if local storage is empty
  /// Returns true if data was seeded, false if local data already exists
  Future<bool> seedDataIfNeeded() async {
    final isEmpty = await _local.isEmpty();

    if (!isEmpty) {
      return false;
    }

    try {
      final remoteTasks = await _api.fetchTasks();

      // Take only first 5 tasks for initial seed
      await _local.saveTasks(remoteTasks.take(5).toList());

      return true;
    } catch (e) {
      // If API fails, we'll start with empty local storage
      // User can still add tasks manually
      return false;
    }
  }

  /// Clear all local data
  Future<void> clearAll() async {
    await _local.deleteAll();
  }

  /// Refresh tasks from API (optional feature)
  Future<List<TaskModel>> refreshFromApi() async {
    try {
      final remoteTasks = await _api.fetchTasks();
      await _local.clearAndSeed(remoteTasks);
      return remoteTasks;
    } catch (e) {
      rethrow;
    }
  }
}
