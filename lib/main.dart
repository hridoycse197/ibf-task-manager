import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibf_task_manager/bindings/task_binding.dart';
import 'package:ibf_task_manager/core/storage/isar_service.dart';
import 'package:ibf_task_manager/routes/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Isar
  await IsarService.instance.open();
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      initialBinding: TaskBinding(),
      getPages: AppPages.routes,
    );
  }
}
