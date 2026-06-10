import 'package:get/get.dart';
import '../domain/entities/task.dart';
import '../domain/usecases/add_task.dart';
import '../domain/usecases/delete_task.dart';
import '../domain/usecases/get_tasks.dart';
import '../domain/usecases/seed_data_if_needed.dart';
import '../domain/usecases/toggle_task.dart';
import '../core/error/failures.dart';

/// Task filter options
enum TaskFilter { all, active, completed }

/// Task Controller - Presentation layer for Clean Architecture
/// Depends on USE CASES, not repository directly (Single Responsibility Principle)
/// Handles Either<Failure, Success> pattern from use cases
class TaskController extends GetxController {
  // Use Cases (Business Logic)
  final GetTasksUseCase _getTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final ToggleTaskUseCase _toggleTaskUseCase;
  final SeedDataIfNeededUseCase _seedDataUseCase;

  TaskController({
    required GetTasksUseCase getTasksUseCase,
    required AddTaskUseCase addTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required ToggleTaskUseCase toggleTaskUseCase,
    required SeedDataIfNeededUseCase seedDataUseCase,
  })  : _getTasksUseCase = getTasksUseCase,
        _addTaskUseCase = addTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        _toggleTaskUseCase = toggleTaskUseCase,
        _seedDataUseCase = seedDataUseCase;

  // Observable state
  final tasks = <TaskEntity>[].obs;
  final filteredTasks = <TaskEntity>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  // Selected task for details view
  final Rx<TaskEntity?> selectedTask = Rx<TaskEntity?>(null);

  // Filter state
  final Rx<TaskFilter> currentFilter = TaskFilter.all.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeTasks();
  }

  /// Initialize tasks - only load from local storage (no API call)
  Future<void> _initializeTasks() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Use use case instead of repository
      final result = await _getTasksUseCase();

      result.fold(
        (failure) => error.value = _getErrorMessage(failure),
        (data) {
          tasks.assignAll(data);
          _applyFilter();
        },
      );
    } catch (e) {
      error.value = 'Unexpected error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Load tasks from local storage
  /// If local storage is empty, will also seed from API
  Future<void> loadTasks({
    bool manageLoading = true,
    bool isFromReload = false,
  }) async {
    if (manageLoading) {
      isLoading.value = true;
      error.value = '';
    }

    try {
      final result = await _getTasksUseCase();

      result.fold(
        (failure) => error.value = _getErrorMessage(failure),
        (data) {
          tasks.assignAll(data);
          _applyFilter();

          // If local storage is empty, seed from API
          if (data.isEmpty && isFromReload) {
            seedDataIfNeeded(manageLoading: false);
          }
        },
      );
    } catch (e) {
      error.value = 'Unexpected error: $e';
    } finally {
      if (manageLoading) {
        isLoading.value = false;
      }
    }
  }

  /// Seed data from API if local storage is empty
  Future<void> seedDataIfNeeded({bool manageLoading = true}) async {
    if (manageLoading) {
      isLoading.value = true;
      error.value = '';
    }

    try {
      final result = await _seedDataUseCase();

      result.fold(
        (failure) => error.value = _getErrorMessage(failure),
        (wasSeeded) {
          if (wasSeeded) {
            // Load tasks after seeding (loading already managed)
            loadTasks(manageLoading: false);
          }
        },
      );
    } catch (e) {
      error.value = 'Unexpected error: $e';
    } finally {
      if (manageLoading) {
        isLoading.value = false;
      }
    }
  }

  /// Add a new task
  Future<void> addTask(String title, String description) async {
    if (title.trim().isEmpty) {
      error.value = 'Title cannot be empty';
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      // Create task entity
      final task = TaskEntity(
        id: 0, // Will be assigned by database
        title: title,
        description: description,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await _addTaskUseCase(task);

      result.fold(
        (failure) => error.value = _getErrorMessage(failure),
        (id) {
          // Task added successfully, reload the list
          loadTasks();
        },
      );
    } catch (e) {
      error.value = 'Unexpected error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a task
  Future<void> deleteTask(int id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _deleteTaskUseCase(id);

      result.fold(
        (failure) => error.value = _getErrorMessage(failure),
        (success) {
          if (success) {
            loadTasks();
          } else {
            error.value = 'Failed to delete task';
          }
        },
      );
    } catch (e) {
      error.value = 'Unexpected error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle task completion status
  Future<void> toggleTask(TaskEntity task) async {
    try {
      final result = await _toggleTaskUseCase(task);

      result.fold(
        (failure) {
          error.value = _getErrorMessage(failure);
          // Reload to ensure consistent state
          loadTasks();
        },
        (updatedTask) {
          // Update the task in the list
          final updatedTasks = tasks.map((t) {
            if (t.id == task.id) {
              return updatedTask;
            }
            return t;
          }).toList();

          tasks.assignAll(updatedTasks);
          _applyFilter();
        },
      );
    } catch (e) {
      error.value = 'Unexpected error: $e';
      await loadTasks();
    }
  }

  /// Update filter
  void setFilter(TaskFilter filter) {
    currentFilter.value = filter;
    _applyFilter();
  }

  /// Apply current filter to tasks
  void _applyFilter() {
    List<TaskEntity> filtered;
    switch (currentFilter.value) {
      case TaskFilter.all:
        filtered = tasks.toList();
        break;
      case TaskFilter.active:
        filtered = tasks.where((t) => !t.isCompleted).toList();
        break;
      case TaskFilter.completed:
        filtered = tasks.where((t) => t.isCompleted).toList();
        break;
    }
    filteredTasks.assignAll(filtered);
  }

  /// Get task counts
  int get totalTasks => tasks.length;
  int get activeTasks => tasks.where((t) => !t.isCompleted).length;
  int get completedTasks => tasks.where((t) => t.isCompleted).length;

  /// Navigate to task details screen with selected task
  void navigateToTaskDetails(TaskEntity task) {
    selectedTask.value = task;
    Get.toNamed('/task-details');
  }

  /// Clear selected task (call when navigating back from details)
  void clearSelectedTask() {
    selectedTask.value = null;
  }

  /// Convert Failure to user-friendly error message
  String _getErrorMessage(Failure failure) {
    switch (failure) {
      case ServerFailure _:
        switch (failure.code) {
          case 'NETWORK_ERROR':
            return 'Network connection failed. Please check your internet.';
          case 'TIMEOUT':
            return 'Request timeout. Please try again.';
          case 'UNAUTHORIZED':
            return 'Unauthorized access.';
          case 'NOT_FOUND':
            return 'Resource not found.';
          case 'SERVER_ERROR':
            return 'Server error. Please try again later.';
          default:
            return failure.message;
        }

      case CacheFailure _:
        switch (failure.code) {
          case 'READ_ERROR':
            return 'Failed to read from local storage.';
          case 'WRITE_ERROR':
            return 'Failed to save data.';
          case 'DELETE_ERROR':
            return 'Failed to delete data.';
          case 'DATABASE_ERROR':
            return 'Database error occurred.';
          default:
            return failure.message;
        }

      case ValidationFailure _:
        return failure.message;

      case UnknownFailure _:
        return 'An unexpected error occurred. Please try again.';

      default:
        return failure.message;
    }
  }
}
