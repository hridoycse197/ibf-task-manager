import '../repositories/task_repository.dart';

/// Use case for deleting a task
class DeleteTaskUseCase {
  final TaskRepository _repository;

  DeleteTaskUseCase(this._repository);

  /// Execute the use case
  /// Returns true if deletion was successful
  Future<bool> call(int id) {
    // Business rule: ID must be positive
    if (id <= 0) {
      throw ArgumentError('Invalid task ID');
    }

    return _repository.deleteTask(id);
  }
}
