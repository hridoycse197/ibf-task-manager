import 'package:isar/isar.dart';

part 'task_model.g.dart';

/// Represents a task in the local database
@collection
class TaskModel {
  /// Auto-incremented unique identifier
  Id id = Isar.autoIncrement;

  /// Task title
  late String title;

  /// Optional task description
  String? description;

  /// Completion status
  bool isCompleted;

  /// Timestamp when task was created
  late DateTime createdAt;

  /// Timestamp when task was last updated
  late DateTime updatedAt;

  TaskModel({
    required this.title,
    this.description = '',
    this.isCompleted = false,
  }) {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  /// Create TaskModel from JSONPlaceholder API response
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'] as String? ?? 'Untitled',
      description: json['description'] as String? ?? '',
      isCompleted: json['completed'] as bool? ?? false,
    );
  }

  /// Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': isCompleted,
    };
  }

  /// Create a copy with updated fields
  TaskModel copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? updatedAt,
  }) {
    return TaskModel(
        title: title ?? this.title,
        description: description ?? this.description,
        isCompleted: isCompleted ?? this.isCompleted,
      )
      ..id = id
      ..createdAt = createdAt
      ..updatedAt = updatedAt ?? DateTime.now();
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, isCompleted: $isCompleted)';
  }
}
