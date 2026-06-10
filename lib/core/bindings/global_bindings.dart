import 'package:get/get.dart';
import '../constants/api_constants.dart';
import '../network/dio_client.dart';
import '../storage/isar_service.dart';
import '../../data/datasource/task_api.dart';
import '../../data/datasource/task_local.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/get_tasks_by_status.dart';
import '../../domain/usecases/seed_data_if_needed.dart';
import '../../domain/usecases/toggle_task.dart';

/// Global bindings for dependency injection
/// This class sets up all the dependencies for the application using GetX
class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    // Core services
    _registerCoreServices();

    // Network and Storage
    _registerNetworkAndStorage();

    // Data sources
    _registerDataSources();

    // Repositories
    _registerRepositories();

    // Use cases
    _registerUseCases();
  }

  void _registerCoreServices() {
    // API Constants (singleton)
    if (!Get.isRegistered<ApiConstants>()) {
      Get.lazyPut<ApiConstants>(() => ApiConstants(), fenix: true);
    }
  }

  void _registerNetworkAndStorage() {
    // Dio Client (singleton)
    if (!Get.isRegistered<DioClient>()) {
      Get.lazyPut<DioClient>(
        () => DioClient(),
        fenix: true,
      );
    }

    // Isar Service (singleton) - Already initialized via singleton pattern
    // IsarService uses instance getter, so we don't need to register it
  }

  void _registerDataSources() {
    // Task API Data Source (singleton)
    if (!Get.isRegistered<TaskApi>()) {
      Get.lazyPut<TaskApi>(
        () => TaskApi(Get.find<DioClient>()),
        fenix: true,
      );
    }

    // Task Local Data Source (singleton)
    if (!Get.isRegistered<TaskLocal>()) {
      Get.lazyPut<TaskLocal>(
        () => TaskLocal(),
        fenix: true,
      );
    }
  }

  void _registerRepositories() {
    // Task Repository Implementation (singleton)
    if (!Get.isRegistered<TaskRepositoryImpl>()) {
      Get.lazyPut<TaskRepositoryImpl>(
        () => TaskRepositoryImpl(
          api: Get.find<TaskApi>(),
          local: Get.find<TaskLocal>(),
        ),
        fenix: true,
      );
    }

    // Task Repository Interface (singleton)
    if (!Get.isRegistered<TaskRepository>()) {
      Get.lazyPut<TaskRepository>(
        () => Get.find<TaskRepositoryImpl>(),
        fenix: true,
      );
    }
  }

  void _registerUseCases() {
    // Get Tasks Use Case
    if (!Get.isRegistered<GetTasksUseCase>()) {
      Get.lazyPut<GetTasksUseCase>(
        () => GetTasksUseCase(Get.find<TaskRepository>()),
        fenix: true,
      );
    }

    // Get Tasks By Status Use Case
    if (!Get.isRegistered<GetTasksByStatusUseCase>()) {
      Get.lazyPut<GetTasksByStatusUseCase>(
        () => GetTasksByStatusUseCase(Get.find<TaskRepository>()),
        fenix: true,
      );
    }

    // Add Task Use Case
    if (!Get.isRegistered<AddTaskUseCase>()) {
      Get.lazyPut<AddTaskUseCase>(
        () => AddTaskUseCase(Get.find<TaskRepository>()),
        fenix: true,
      );
    }

    // Toggle Task Use Case
    if (!Get.isRegistered<ToggleTaskUseCase>()) {
      Get.lazyPut<ToggleTaskUseCase>(
        () => ToggleTaskUseCase(Get.find<TaskRepository>()),
        fenix: true,
      );
    }

    // Delete Task Use Case
    if (!Get.isRegistered<DeleteTaskUseCase>()) {
      Get.lazyPut<DeleteTaskUseCase>(
        () => DeleteTaskUseCase(Get.find<TaskRepository>()),
        fenix: true,
      );
    }

    // Seed Data If Needed Use Case
    if (!Get.isRegistered<SeedDataIfNeededUseCase>()) {
      Get.lazyPut<SeedDataIfNeededUseCase>(
        () => SeedDataIfNeededUseCase(Get.find<TaskRepository>()),
        fenix: true,
      );
    }
  }
}

/// Extension method for easy access to dependencies
extension GlobalBindingsExtension on GetInterface {
  /// Get API Constants
  ApiConstants get apiConstants => find<ApiConstants>();

  /// Get Dio Client
  DioClient get dioClient => find<DioClient>();

  /// Get Isar Service (via singleton)
  static IsarService get isarService => IsarService.instance;

  /// Get Task API
  TaskApi get taskApi => find<TaskApi>();

  /// Get Task Local
  TaskLocal get taskLocal => find<TaskLocal>();

  /// Get Task Repository
  TaskRepository get taskRepository => find<TaskRepository>();

  /// Get Get Tasks Use Case
  GetTasksUseCase get getTasksUseCase => find<GetTasksUseCase>();

  /// Get Get Tasks By Status Use Case
  GetTasksByStatusUseCase get getTasksByStatusUseCase => find<GetTasksByStatusUseCase>();

  /// Get Add Task Use Case
  AddTaskUseCase get addTaskUseCase => find<AddTaskUseCase>();

  /// Get Toggle Task Use Case
  ToggleTaskUseCase get toggleTaskUseCase => find<ToggleTaskUseCase>();

  /// Get Delete Task Use Case
  DeleteTaskUseCase get deleteTaskUseCase => find<DeleteTaskUseCase>();

  /// Get Seed Data If Needed Use Case
  SeedDataIfNeededUseCase get seedDataIfNeededUseCase => find<SeedDataIfNeededUseCase>();
}
