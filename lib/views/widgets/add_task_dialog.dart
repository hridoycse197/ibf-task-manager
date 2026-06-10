import 'package:flutter/material.dart';

/// Shows a static add task dialog (demo mode)
void showAddTaskDialog(BuildContext context) {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

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
            const SizedBox(height: 16),
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

  // Show demo message instead of actually adding task
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Task added: $title (demo mode)'),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );

  // Debug print to show what would have been added
  debugPrint('Demo: Added task - Title: "$title", Description: "$description"');
}
