import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasource/task_api.dart';
import '../../data/datasource/task_local.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/seed_data_if_needed.dart';
import '../../domain/usecases/toggle_task.dart';
import '../../domain/usecases/update_task.dart';
import '../controllers/task_controller.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    // ==================== INFRASTRUCTURE LAYER ====================

    // HTTP Client
    final dioClient = DioClient();
    Get.put(dioClient, permanent: true);

    // ==================== DATA LAYER ====================

    // Data Sources
    final taskApi = TaskApi(dioClient);
    final taskLocal = TaskLocal();

    // Repository Implementation (implements domain interface)
    final taskRepositoryImpl = TaskRepositoryImpl(
      api: taskApi,
      local: taskLocal,
    );

    // Provide repository as domain interface (Dependency Inversion)
    Get.put<TaskRepository>(taskRepositoryImpl, permanent: true);

    // ==================== DOMAIN LAYER ====================

    // Use Cases (Business Logic)
    final getTasksUseCase = GetTasksUseCase(taskRepositoryImpl);
    final addTaskUseCase = AddTaskUseCase(taskRepositoryImpl);
    final deleteTaskUseCase = DeleteTaskUseCase(taskRepositoryImpl);
    final toggleTaskUseCase = ToggleTaskUseCase(taskRepositoryImpl);
    final updateTaskUseCase = UpdateTaskUseCase(taskRepositoryImpl);
    final seedDataUseCase = SeedDataIfNeededUseCase(taskRepositoryImpl);

    Get.put(getTasksUseCase, permanent: true);
    Get.put(addTaskUseCase, permanent: true);
    Get.put(deleteTaskUseCase, permanent: true);
    Get.put(toggleTaskUseCase, permanent: true);
    Get.put(updateTaskUseCase, permanent: true);
    Get.put(seedDataUseCase, permanent: true);

    // ==================== PRESENTATION LAYER ====================

    // Controller (depends on use cases, not repository directly)
    final taskController = TaskController(
      getTasksUseCase: getTasksUseCase,
      addTaskUseCase: addTaskUseCase,
      deleteTaskUseCase: deleteTaskUseCase,
      toggleTaskUseCase: toggleTaskUseCase,
      updateTaskUseCase: updateTaskUseCase,
      seedDataUseCase: seedDataUseCase,
    );

    Get.put(taskController, permanent: true);
  }
}
