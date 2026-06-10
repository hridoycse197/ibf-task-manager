import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ibf_task_manager/controllers/task_controller.dart';
import 'package:ibf_task_manager/domain/entities/task.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit task',
            onPressed: () {
              final task = controller.selectedTask.value;
              if (task != null) {
                _showEditDialog(context, task, controller);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete task',
            onPressed: () {
              final task = controller.selectedTask.value;
              if (task != null) {
                _showDeleteDialog(context, task, controller);
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        final task = controller.selectedTask.value;

        if (task == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            // Status card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 32.r,
                      color: task.isCompleted ? Colors.green : Colors.orange,
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      task.isCompleted ? 'Completed' : 'Active',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: task.isCompleted ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Title section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Description section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        if (task.description.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.copy, size: 18.r),
                            tooltip: 'Copy description',
                            onPressed: () =>
                                _copyDescription(context, task.description),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      task.description.isNotEmpty
                          ? task.description
                          : 'No description',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Metadata section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _DetailRow(
                      label: 'Created',
                      value: _formatDate(task.createdAt),
                    ),
                    SizedBox(height: 8.h),
                    _DetailRow(
                      label: 'Last Updated',
                      value: _formatDate(task.updatedAt),
                    ),
                    SizedBox(height: 8.h),
                    _DetailRow(label: 'Task ID', value: '#${task.id}'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Toggle status button
            FilledButton.icon(
              onPressed: () => _showToggleDialog(context, task, controller),
              icon: Icon(
                task.isCompleted
                    ? Icons.radio_button_unchecked
                    : Icons.check_circle,
              ),
              label: Text(
                task.isCompleted ? 'Mark as Active' : 'Mark as Completed',
              ),
              style: FilledButton.styleFrom(
                minimumSize: Size.fromHeight(48.h),
                backgroundColor: task.isCompleted
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
          ],
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _copyDescription(BuildContext context, String description) async {
    await Clipboard.setData(ClipboardData(text: description));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Description copied to clipboard'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showEditDialog(
    BuildContext context,
    TaskEntity task,
    TaskController controller,
  ) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Title cannot be empty'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              final updatedTask = task.copyWith(
                title: titleController.text.trim(),
                description: descriptionController.text.trim(),
                updatedAt: DateTime.now(),
              );

              Navigator.of(context).pop();
              controller.editTask(updatedTask);

              // Show success message
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task updated successfully'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showToggleDialog(
    BuildContext context,
    TaskEntity task,
    TaskController controller,
  ) {
    final isCompleting = !task.isCompleted;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCompleting ? 'Mark as Completed?' : 'Mark as Active?'),
        content: Text(
          isCompleting
              ? 'Are you sure you want to mark "${task.title}" as completed?'
              : 'Are you sure you want to mark "${task.title}" as active?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.toggleTask(task);
              // Pop the details screen after toggling
              Navigator.of(context).pop();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    TaskEntity task,
    TaskController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.deleteTask(task.id);
              // Pop the details screen after deleting
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
