import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/task_model.dart';

/// Service for managing Isar database instance
class IsarService {
  static IsarService? _instance;
  static IsarService get instance => _instance ??= IsarService._();

  IsarService._();

  Isar? _isar;

  /// Get the Isar instance
  Isar get isar {
    if (_isar == null) {
      throw Exception('Isar not initialized. Call open() first.');
    }
    return _isar!;
  }

  /// Open Isar database with all collections
  Future<void> open() async {
    if (_isar != null && _isar!.isOpen) {
      return;
    }

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [TaskModelSchema],
      directory: dir.path,
      inspector: true, // Enable inspector for debugging
    );
  }

  /// Close the database
  Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
    }
  }

  /// Clear all data (useful for testing/development)
  Future<void> clear() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
