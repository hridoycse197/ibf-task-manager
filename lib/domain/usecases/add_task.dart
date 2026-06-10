import 'package:dartz/dartz.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';
import '../../core/error/failures.dart';

/// Use case for adding a new task
class AddTaskUseCase {
  final TaskRepository _repository;

  AddTaskUseCase(this._repository);

  /// Execute the use case
  /// Returns Either a Failure or the ID of the created task
  Future<Either<Failure, int>> call(TaskEntity task) async {
    // Business rule: Title cannot be empty
    if (task.title.trim().isEmpty) {
      return Left(ValidationFailure.requiredField('Title'));
    }

    // Business rule: Description is optional but title is required
    if (task.title.length > 200) {
      return Left(ValidationFailure.invalidFormat('Title is too long (max 200 characters)'));
    }

    return await _repository.addTask(task);
  }
}
