import 'package:dartz/dartz.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';
import '../../core/error/failures.dart';

/// Use case for getting tasks filtered by completion status
class GetTasksByStatusUseCase {
  final TaskRepository _repository;

  GetTasksByStatusUseCase(this._repository);

  /// Execute the use case
  /// Returns Either a Failure or a list of filtered tasks
  Future<Either<Failure, List<TaskEntity>>> call(bool isCompleted) {
    return _repository.getTasksByStatus(isCompleted);
  }
}
