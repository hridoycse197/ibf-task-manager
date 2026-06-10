import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case for getting all tasks
class GetTasksUseCase {
  final TaskRepository _repository;

  GetTasksUseCase(this._repository);

  /// Execute the use case
  Future<List<TaskEntity>> call() {
    return _repository.getTasks();
  }
}
