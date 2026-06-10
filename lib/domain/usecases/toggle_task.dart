import 'package:dartz/dartz.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';
import '../../core/error/failures.dart';

/// Use case for toggling task completion status
class ToggleTaskUseCase {
  final TaskRepository _repository;

  ToggleTaskUseCase(this._repository);

  /// Execute the use case
  /// Returns Either a Failure or the updated task with toggled status
  Future<Either<Failure, TaskEntity>> call(TaskEntity task) async {
    // Business rule: Task must have a valid ID
    if (task.id <= 0) {
      return Left(ValidationFailure.invalidInput('Invalid task ID'));
    }

    return await _repository.toggleTask(task);
  }
}
