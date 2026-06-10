import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case for toggling task completion status
class ToggleTaskUseCase {
  final TaskRepository _repository;

  ToggleTaskUseCase(this._repository);

  /// Execute the use case
  /// Returns the updated task with toggled status
  Future<TaskEntity> call(TaskEntity task) async {
    // Business rule: Task must exist
    if (task.id <= 0) {
      throw ArgumentError('Invalid task ID');
    }

    return _repository.toggleTask(task);
  }
}
