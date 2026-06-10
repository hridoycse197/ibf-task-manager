import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ibf_task_manager/controllers/task_controller.dart';

void showAddTaskDialog(BuildContext context) {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final controller = Get.find<TaskController>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add New Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter task title',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleSubmit(
                context,
                controller,
                titleController,
                descriptionController,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => _handleSubmit(
            context,
            controller,
            titleController,
            descriptionController,
          ),
          child: const Text('Add Task'),
        ),
      ],
    ),
  );
}

void _handleSubmit(
  BuildContext context,
  TaskController controller,
  TextEditingController titleController,
  TextEditingController descriptionController,
) {
  final title = titleController.text.trim();
  final description = descriptionController.text.trim();

  if (title.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a title'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  Navigator.of(context).pop();
  controller.addTask(title, description);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Task added successfully'),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
