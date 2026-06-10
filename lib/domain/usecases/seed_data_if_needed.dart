import 'package:dartz/dartz.dart';
import '../repositories/task_repository.dart';
import '../../core/error/failures.dart';

/// Use case for seeding data from API if local storage is empty
class SeedDataIfNeededUseCase {
  final TaskRepository _repository;

  SeedDataIfNeededUseCase(this._repository);

  /// Execute the use case
  /// Returns Either a Failure or true if data was seeded, false if local data already exists
  Future<Either<Failure, bool>> call() {
    return _repository.seedDataIfNeeded();
  }
}
