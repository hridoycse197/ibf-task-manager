import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/pages.dart';
import 'widgets/add_task_dialog.dart';

/// Simple static task model for display
class _StaticTask {
  final String title;
  final String description;
  final bool isCompleted;

  const _StaticTask({
    required this.title,
    required this.description,
    required this.isCompleted,
  });
}

/// Static sample tasks for display
final _staticTasks = [
  const _StaticTask(
    title: 'Review project proposal',
    description: 'Read through the Q3 project proposal and provide feedback',
    isCompleted: false,
  ),
  const _StaticTask(
    title: 'Team standup meeting',
    description: 'Daily sync with the development team',
    isCompleted: true,
  ),
  const _StaticTask(
    title: 'Update documentation',
    description: 'Add API documentation for new endpoints',
    isCompleted: false,
  ),
  const _StaticTask(
    title: 'Code review - PR #142',
    description: 'Review and approve the authentication module changes',
    isCompleted: false,
  ),
  const _StaticTask(
    title: 'Deploy staging build',
    description: 'Deploy latest changes to staging environment',
    isCompleted: true,
  ),
];

/// Main home screen displaying the task list with static data
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Static stats
    const totalTasks = 5;
    const activeTasks = 3;
    const completedTasks = 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          // Filter menu (static, no functionality)
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter tasks',
            onSelected: (_) {}, // No-op
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Tasks'),
              ),
              const PopupMenuItem(
                value: 'active',
                child: Text('Active'),
              ),
              const PopupMenuItem(
                value: 'completed',
                child: Text('Completed'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Static stats header
          _buildStatsHeader(context, totalTasks, activeTasks, completedTasks),

          const Divider(height: 1),

          // Static task list
          Expanded(child: _buildTaskList(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add task',
        onPressed: () {
          // Show the add task dialog
          showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsHeader(BuildContext context, int total, int active, int done) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Total',
            value: total.toString(),
            icon: Icons.task,
          ),
          _StatItem(
            label: 'Active',
            value: active.toString(),
            icon: Icons.radio_button_unchecked,
          ),
          _StatItem(
            label: 'Done',
            value: done.toString(),
            icon: Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    // Static task list
    return ListView.builder(
      itemCount: _staticTasks.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final task = _staticTasks[index];
        return _TaskTile(task: task);
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Individual task tile widget
class _TaskTile extends StatelessWidget {
  final _StaticTask task;

  const _TaskTile({
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () {
          // Navigate to task details screen
          Get.toNamed(Routes.taskDetails);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              // Static checkbox icon
              IconButton(
                icon: Icon(
                  task.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: task.isCompleted ? Colors.green : Colors.grey,
                ),
                tooltip: task.isCompleted
                    ? 'Completed'
                    : 'Active',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Toggle - Static demo mode')),
                  );
                },
              ),

              // Task content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6)
                            : null,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (task.description.isNotEmpty)
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: task.isCompleted
                              ? Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6)
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),

              // Delete button
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Delete - Static demo mode')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 