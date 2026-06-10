import 'package:dartz/dartz.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';
import '../../core/error/failures.dart';

/// Use case for getting all tasks
class GetTasksUseCase {
  final TaskRepository _repository;

  GetTasksUseCase(this._repository);

  /// Execute the use case
  /// Returns Either a Failure or a list of tasks
  Future<Either<Failure, List<TaskEntity>>> call() {
    return _repository.getTasks();
  }
}
