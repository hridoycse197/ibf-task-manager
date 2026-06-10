import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case for getting tasks filtered by completion status
class GetTasksByStatusUseCase {
  final TaskRepository _repository;

  GetTasksByStatusUseCase(this._repository);

  /// Execute the use case
  Future<List<TaskEntity>> call(bool isCompleted) {
    return _repository.getTasksByStatus(isCompleted);
  }
}
