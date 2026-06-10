import '../entities/task.dart';

/// Abstract task repository interface
/// Defines the contract for task data operations
/// Implementation is provided by the data layer
abstract class TaskRepository {
  /// Get all tasks from storage
  Future<List<TaskEntity>> getTasks();

  /// Get tasks filtered by completion status
  Future<List<TaskEntity>> getTasksByStatus(bool isCompleted);

  /// Add a new task
  Future<int> addTask(TaskEntity task);

  /// Update an existing task
  Future<bool> updateTask(TaskEntity task);

  /// Delete a task by ID
  Future<bool> deleteTask(int id);

  /// Toggle task completion status
  Future<TaskEntity> toggleTask(TaskEntity task);

  /// Seed data from API if local storage is empty
  /// Returns true if data was seeded, false if local data already exists
  Future<bool> seedDataIfNeeded();

  /// Clear all local data
  Future<void> clearAll();

  /// Refresh tasks from API
  Future<List<TaskEntity>> refreshFromApi();
}
