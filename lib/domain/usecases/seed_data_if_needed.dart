import '../repositories/task_repository.dart';

/// Use case for seeding data from API if local storage is empty
class SeedDataIfNeededUseCase {
  final TaskRepository _repository;

  SeedDataIfNeededUseCase(this._repository);

  /// Execute the use case
  /// Returns true if data was seeded, false if local data already exists
  Future<bool> call() {
    return _repository.seedDataIfNeeded();
  }
}
