import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasource/task_api.dart';
import '../datasource/task_local.dart';
import '../mappers/task_mapper.dart';

/// Implementation of TaskRepository
/// Handles data operations and converts exceptions to failures
class TaskRepositoryImpl implements TaskRepository {
  final TaskApi _api;
  final TaskLocal _local;

  TaskRepositoryImpl({required TaskApi api, required TaskLocal local})
    : _api = api,
      _local = local;

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      final models = await _local.getTasks();
      final entities = TaskMapper.toEntityList(models);
      return Right(entities);
    } on CacheException catch (e) {
      AppLogger.error('Failed to get tasks from cache', error: e);
      return Left(CacheFailure.readError());
    } catch (e) {
      AppLogger.error('Unexpected error getting tasks', error: e);
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksByStatus(
    bool isCompleted,
  ) async {
    try {
      final models = await _local.getTasksByStatus(isCompleted);
      final entities = TaskMapper.toEntityList(models);
      return Right(entities);
    } on CacheException catch (e) {
      AppLogger.error('Failed to get tasks by status from cache', error: e);
      return Left(CacheFailure.readError());
    } catch (e) {
      AppLogger.error('Unexpected error getting tasks by status', error: e);
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> addTask(TaskEntity task) async {
    try {
      final model = TaskMapper.toModel(task);
      final id = await _local.saveTask(model);
      return Right(id);
    } on CacheException catch (e) {
      AppLogger.error('Failed to save task to cache', error: e);
      return Left(CacheFailure.writeError());
    } catch (e) {
      AppLogger.error('Unexpected error adding task', error: e);
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateTask(TaskEntity task) async {
    try {
      final model = TaskMapper.toModel(task);
      final success = await _local.updateTask(model);
      return Right(success);
    } on CacheException catch (e) {
      AppLogger.error('Failed to update task in cache', error: e);
      return Left(CacheFailure.writeError());
    } catch (e) {
      AppLogger.error('Unexpected error updating task', error: e);
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> toggleTask(TaskEntity task) async {
    try {
      final toggledTask = task.copyWith(
        isCompleted: !task.isCompleted,
        updatedAt: DateTime.now(),
      );

      final updateResult = await updateTask(toggledTask);

      return updateResult.fold(
        (failure) => Left(failure),
        (success) => Right(toggledTask),
      );
    } catch (e) {
      AppLogger.error('Unexpected error toggling task', error: e);
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(int id) async {
    try {
      final success = await _local.deleteTask(id);
      return Right(success);
    } on CacheException catch (e) {
      AppLogger.error('Failed to delete task from cache', error: e);
      return Left(CacheFailure.deleteError());
    } catch (e) {
      AppLogger.error('Unexpected error deleting task', error: e);
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> seedDataIfNeeded() async {
    try {
      final isEmpty = await _local.isEmpty();

      if (!isEmpty) {
        return Right(false);
      }

      // Fetch remote tasks
      final remoteModels = await _api.fetchTasks();

      // Take only first 5 tasks for initial seed
      await _local.saveTasks(remoteModels.take(5).toList());

      return Right(true);
    } on ServerException catch (e) {
      AppLogger.error('Server error while seeding data', error: e);
      return Left(ServerFailure.unknown(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error while seeding data', error: e);
      return Left(ServerFailure.networkError());
    } on CacheException catch (e) {
      AppLogger.error('Cache error while seeding data', error: e);
      return Left(CacheFailure.writeError());
    } catch (e) {
      AppLogger.error('Unexpected error while seeding data', error: e);
      // If API fails, we'll start with empty local storage
      // User can still add tasks manually
      return Right(false);
    }
  }

  @override
  Future<Either<Failure, void>> clearAll() async {
    try {
      await _local.deleteAll();
      return Right(null);
    } on CacheException catch (e) {
      AppLogger.error('Failed to clear cache', error: e);
      return Left(CacheFailure.deleteError());
    } catch (e) {
      AppLogger.error('Unexpected error clearing cache', error: e);
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> refreshFromApi() async {
    try {
      final remoteModels = await _api.fetchTasks();
      await _local.clearAndSeed(remoteModels);
      final entities = TaskMapper.toEntityList(remoteModels);
      return Right(entities);
    } on ServerException catch (e) {
      AppLogger.error('Server error while refreshing from API', error: e);
      return Left(ServerFailure.unknown(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error while refreshing from API', error: e);
      return Left(ServerFailure.networkError());
    } on CacheException catch (e) {
      AppLogger.error('Cache error while refreshing from API', error: e);
      return Left(CacheFailure.writeError());
    } catch (e) {
      AppLogger.error('Unexpected error while refreshing from API', error: e);
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  /// Add a task with title and description (convenience method)
  /// Not part of the interface but useful for the application
  Future<Either<Failure, int>> addTaskDetails(
    String title,
    String description,
  ) async {
    try {
      // Validate input
      if (title.trim().isEmpty) {
        return Left(ValidationFailure.requiredField('Title'));
      }

      final task = TaskEntity(
        id: 0, // Will be assigned by database
        title: title,
        description: description,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return await addTask(task);
    } catch (e) {
      AppLogger.error('Unexpected error adding task details', error: e);
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }
}
