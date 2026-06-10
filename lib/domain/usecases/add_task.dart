import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case for adding a new task
class AddTaskUseCase {
  final TaskRepository _repository;

  AddTaskUseCase(this._repository);

  /// Execute the use case
  /// Returns the ID of the created task
  Future<int> call(TaskEntity task) {
    // Business rule: Title cannot be empty
    if (task.title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }

    return _repository.addTask(task);
  }
}
