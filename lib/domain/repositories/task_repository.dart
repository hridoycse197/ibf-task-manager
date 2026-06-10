import 'package:dartz/dartz.dart';
import '../entities/task.dart';
import '../../core/error/failures.dart';

/// Abstract task repository interface
/// Defines the contract for task data operations
/// Implementation is provided by the data layer
abstract class TaskRepository {
  /// Get all tasks from storage
  Future<Either<Failure, List<TaskEntity>>> getTasks();

  /// Get tasks filtered by completion status
  Future<Either<Failure, List<TaskEntity>>> getTasksByStatus(bool isCompleted);

  /// Add a new task
  Future<Either<Failure, int>> addTask(TaskEntity task);

  /// Update an existing task
  Future<Either<Failure, bool>> updateTask(TaskEntity task);

  /// Delete a task by ID
  Future<Either<Failure, bool>> deleteTask(int id);

  /// Toggle task completion status
  Future<Either<Failure, TaskEntity>> toggleTask(TaskEntity task);

  /// Seed data from API if local storage is empty
  /// Returns true if data was seeded, false if local data already exists
  Future<Either<Failure, bool>> seedDataIfNeeded();

  /// Clear all local data
  Future<Either<Failure, void>> clearAll();

  /// Refresh tasks from API
  Future<Either<Failure, List<TaskEntity>>> refreshFromApi();
}
