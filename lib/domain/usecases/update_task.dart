import 'package:dartz/dartz.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';
import '../../core/error/failures.dart';

/// Use case for updating an existing task
class UpdateTaskUseCase {
  final TaskRepository _repository;

  UpdateTaskUseCase(this._repository);

  /// Execute the use case
  /// Returns Either a Failure or true if update was successful
  Future<Either<Failure, bool>> call(TaskEntity task) async {
    // Business rule: Title cannot be empty
    if (task.title.trim().isEmpty) {
      return Left(ValidationFailure.requiredField('Title'));
    }

    // Business rule: Title length validation
    if (task.title.length > 200) {
      return Left(ValidationFailure.invalidFormat('Title is too long (max 200 characters)'));
    }

    return await _repository.updateTask(task);
  }
}
