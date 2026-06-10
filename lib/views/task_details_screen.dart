import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          padding: const EdgeInsets.all(16),
          children: [
            // Status card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 32,
                      color: task.isCompleted ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 16),
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

            const SizedBox(height: 16),

            // Title section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
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

            const SizedBox(height: 16),

            // Description section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                            icon: const Icon(Icons.copy, size: 18),
                            tooltip: 'Copy description',
                            onPressed: () =>
                                _copyDescription(context, task.description),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
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

            const SizedBox(height: 16),

            // Metadata section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      label: 'Created',
                      value: _formatDate(task.createdAt),
                    ),
                    const SizedBox(height: 8),
                    _DetailRow(
                      label: 'Last Updated',
                      value: _formatDate(task.updatedAt),
                    ),
                    const SizedBox(height: 8),
                    _DetailRow(label: 'Task ID', value: '#${task.id}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

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
                minimumSize: const Size.fromHeight(48),
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
            const SizedBox(height: 16),
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
