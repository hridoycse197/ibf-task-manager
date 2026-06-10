import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ibf_task_manager/data/models/task_model.dart';
import '../../core/network/dio_client.dart';

/// Remote data source for fetching tasks from JSONPlaceholder API
class TaskApi {
  final DioClient _dioClient;

  TaskApi(this._dioClient);

  /// Fetch tasks from JSONPlaceholder API
  /// Returns a list of tasks
  Future<List<TaskModel>> fetchTasks() async {
    try {
      // Simulate network delay
      final response = await _dioClient.dio.get(
        '/todos',
        queryParameters: {
          '_limit': 5, // Limit to 10 tasks for this demo
        },
      );

      final List<dynamic> data = response.data as List<dynamic>;

      return data.map((json) {
        final task = TaskModel.fromJson(json as Map<String, dynamic>);
        // Since JSONPlaceholder doesn't have descriptions, add one
        task.description = null;
        return task;
      }).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio exceptions and convert to user-friendly messages
  String _handleDioError(DioException error) {
    String message = 'An error occurred';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please check your internet.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        message = 'Server error ($statusCode)';
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        break;
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          message = 'No internet connection';
        } else {
          message = 'Unexpected error: ${error.error}';
        }
        break;
      default:
        message = 'Unexpected error occurred';
    }

    return message;
  }
}
