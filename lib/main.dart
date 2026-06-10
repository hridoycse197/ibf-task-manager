import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibf_task_manager/routes/pages.dart';
import 'package:ibf_task_manager/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      getPages: AppPages.routes,
    );
  }
}
