import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/task_controller.dart';
import '../domain/entities/task.dart';
import 'widgets/add_task_dialog.dart';

/// Main home screen displaying the task list
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh tasks',
            onPressed: () => controller.loadTasks(isFromReload: true),
          ),

          // Filter menu
          PopupMenuButton<TaskFilter>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter tasks',
            onSelected: (filter) => controller.setFilter(filter),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TaskFilter.all,
                child: Text('All Tasks'),
              ),
              const PopupMenuItem(
                value: TaskFilter.active,
                child: Text('Active'),
              ),
              const PopupMenuItem(
                value: TaskFilter.completed,
                child: Text('Completed'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats header
          Obx(() => _buildStatsHeader(context, controller)),

          Divider(height: 1.h),

          // Task list
          Expanded(child: Obx(() => _buildTaskList(context, controller))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add task',
        onPressed: () => showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsHeader(BuildContext context, TaskController controller) {
    if (controller.isLoading.value) {
      return _buildStatsLoadingSkeleton();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Total',
            value: controller.totalTasks.toString(),
            icon: Icons.task,
          ),
          _StatItem(
            label: 'Active',
            value: controller.activeTasks.toString(),
            icon: Icons.radio_button_unchecked,
          ),
          _StatItem(
            label: 'Done',
            value: controller.completedTasks.toString(),
            icon: Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, TaskController controller) {
    // Loading state
    if (controller.isLoading.value) {
      return _buildLoadingSkeleton();
    }

    // Error state
    if (controller.error.value.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.r, color: Colors.red),
            SizedBox(height: 16.h),
            Text(controller.error.value, textAlign: TextAlign.center),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => controller.loadTasks(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Empty state
    final tasks = controller.filteredTasks;
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              controller.currentFilter.value == TaskFilter.completed
                  ? Icons.check_circle_outline
                  : Icons.task_alt,
              size: 64.r,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              _getEmptyMessage(controller.currentFilter.value),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    // Task list
    return ListView.builder(
      itemCount: tasks.length,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _TaskTile(
          task: task,
          onDelete: () => controller.deleteTask(task.id),
          onToggle: () => controller.toggleTask(task),
          onTap: () => controller.navigateToTaskDetails(task),
        );
      },
    );
  }

  /// Build loading skeleton for stats header
  Widget _buildStatsLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.all(16.w),
        color: Colors.grey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(3, (index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 10.r),
                SizedBox(height: 4.h),
                SizedBox(
                  width: 24.w,
                  height: 20.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: 40.w,
                  height: 12.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  String _getEmptyMessage(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return 'No tasks yet. Tap + to add one!';
      case TaskFilter.active:
        return 'No active tasks';
      case TaskFilter.completed:
        return 'No completed tasks yet';
    }
  }

  /// Build loading skeleton with shimmer effect
  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      itemCount: 6,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            child: ListTile(
              leading: const CircleAvatar(),
              title: Container(
                height: 16,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              subtitle: Container(
                height: 12,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              trailing: Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        );
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
          size: 20.r,
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
  final TaskEntity task;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const _TaskTile({
    required this.task,
    required this.onDelete,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.w),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: InkWell(
          // Navigate to details on tap (excluding checkbox and delete button)
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: Row(
              children: [
                // Checkbox with confirmation dialog
                IconButton(
                  icon: Icon(
                    task.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: task.isCompleted ? Colors.green : Colors.grey,
                  ),
                  tooltip: task.isCompleted
                      ? 'Mark as active'
                      : 'Mark as completed',
                  onPressed: () => _showToggleDialog(context),
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
                            fontSize: 12.sp,
                          ),
                        ),
                    ],
                  ),
                ),

                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete',
                  onPressed: () => _showDeleteDialog(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showToggleDialog(BuildContext context) {
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
              onToggle();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: Text(
          'Are you sure you want to delete "${task.title}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
