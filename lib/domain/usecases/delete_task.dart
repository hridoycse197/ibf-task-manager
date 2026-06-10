import 'package:dartz/dartz.dart';
import '../repositories/task_repository.dart';
import '../../core/error/failures.dart';

/// Use case for deleting a task
class DeleteTaskUseCase {
  final TaskRepository _repository;

  DeleteTaskUseCase(this._repository);

  /// Execute the use case
  /// Returns Either a Failure or true if deletion was successful
  Future<Either<Failure, bool>> call(int id) async {
    // Business rule: ID must be positive
    if (id <= 0) {
      return Left(ValidationFailure.invalidInput('Invalid task ID'));
    }

    return await _repository.deleteTask(id);
  }
}
