import '../../domain/entities/task.dart';
import '../models/task_model.dart';

/// Mapper for converting between TaskModel (data) and TaskEntity (domain)
class TaskMapper {
  /// Convert TaskModel to TaskEntity
  static TaskEntity toEntity(TaskModel model) {
    return TaskEntity(
      id: model.id,
      title: model.title,
      description: model.description ?? '',
      isCompleted: model.isCompleted,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Convert TaskEntity to TaskModel
  static TaskModel toModel(TaskEntity entity) {
    final model = TaskModel(
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
    )
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;

    // Only set ID if it's a positive number (existing task)
    // For new tasks (id == 0), let Isar auto-assign the ID
    if (entity.id > 0) {
      model.id = entity.id;
    }

    return model;
  }

  /// Convert list of TaskModel to list of TaskEntity
  static List<TaskEntity> toEntityList(List<TaskModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }

  /// Convert list of TaskEntity to list of TaskModel
  static List<TaskModel> toModelList(List<TaskEntity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }
}
