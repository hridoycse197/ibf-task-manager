
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart' as domain;
import '../datasource/task_api.dart';
import '../datasource/task_local.dart';
import '../mappers/task_mapper.dart';


class TaskRepositoryImpl implements domain.TaskRepository {
  final TaskApi _api;
  final TaskLocal _local;

  TaskRepositoryImpl({
    required TaskApi api,
    required TaskLocal local,
  })  : _api = api,
        _local = local;

  @override
  Future<List<TaskEntity>> getTasks() async {
    final models = await _local.getTasks();
    return TaskMapper.toEntityList(models);
  }

  @override
  Future<List<TaskEntity>> getTasksByStatus(bool isCompleted) async {
    final models = await _local.getTasksByStatus(isCompleted);
    return TaskMapper.toEntityList(models);
  }

  @override
  Future<int> addTask(TaskEntity task) async {
    final model = TaskMapper.toModel(task);
    return await _local.saveTask(model);
  }

  /// Add a task with title and description (convenience method)
  Future<int> addTaskDetails(String title, String description) async {
    final task = TaskEntity(
      id: 0, // Will be assigned by database
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return await addTask(task);
  }

  @override
  Future<bool> updateTask(TaskEntity task) async {
    final model = TaskMapper.toModel(task);
    return await _local.updateTask(model);
  }

  @override
  Future<TaskEntity> toggleTask(TaskEntity task) async {
    final toggledTask = task.copyWith(
      isCompleted: !task.isCompleted,
      updatedAt: DateTime.now(),
    );

    await updateTask(toggledTask);
    return toggledTask;
  }

  @override
  Future<bool> deleteTask(int id) async {
    return await _local.deleteTask(id);
  }

  @override
  Future<bool> seedDataIfNeeded() async {
    final isEmpty = await _local.isEmpty();

    if (!isEmpty) {
      return false;
    }

    try {
      final remoteModels = await _api.fetchTasks();

      // Take only first 5 tasks for initial seed
      await _local.saveTasks(remoteModels.take(5).toList());

      return true;
    } catch (e) {
      // If API fails, we'll start with empty local storage
      // User can still add tasks manually
      return false;
    }
  }

  @override
  Future<void> clearAll() async {
    await _local.deleteAll();
  }

  @override
  Future<List<TaskEntity>> refreshFromApi() async {
    try {
      final remoteModels = await _api.fetchTasks();
      await _local.clearAndSeed(remoteModels);
      return TaskMapper.toEntityList(remoteModels);
    } catch (e) {
      rethrow;
    }
  }
}
