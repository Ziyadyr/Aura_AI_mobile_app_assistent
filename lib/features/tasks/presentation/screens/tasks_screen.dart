import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/task_model.dart';
import '../../../../shared/providers/mock_data_provider.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Today', 'Upcoming', 'High Priority', 'Completed'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TaskModel> _getFilteredTasks(List<TaskModel> tasks) {
    switch (_selectedFilter) {
      case 'Today':
        return tasks.where((t) => 
          t.dueDate != null &&
          t.dueDate!.year == DateTime.now().year &&
          t.dueDate!.month == DateTime.now().month &&
          t.dueDate!.day == DateTime.now().day
        ).toList();
      case 'Upcoming':
        return tasks.where((t) => 
          t.dueDate != null && t.dueDate!.isAfter(DateTime.now())
        ).toList();
      case 'High Priority':
        return tasks.where((t) => t.priority == 'high' || t.priority == 'critical').toList();
      case 'Completed':
        return tasks.where((t) => t.status == 'completed').toList();
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = ref.watch(tasksProvider);
    final filteredTasks = _getFilteredTasks(allTasks);
    final pendingCount = allTasks.where((t) => t.status != 'completed').length;
    final completedCount = allTasks.where((t) => t.status == 'completed').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Tasks',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddTaskBottomSheet(context),
            icon: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.add,
                color: AppColors.onPrimary,
                size: 18.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          labelStyle: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: 'Pending ($pendingCount)'),
            Tab(text: 'Completed ($completedCount)'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;
                return FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  selectedColor: AppColors.primaryContainer,
                  checkmarkColor: AppColors.primary,
                  labelStyle: AppTypography.labelMedium.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  backgroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.outline,
                    ),
                  ),
                );
              },
            ),
          ),

          // Tasks List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Pending Tab
                _buildTaskList(
                  filteredTasks.where((t) => t.status != 'completed').toList(),
                  isCompleted: false,
                ),
                // Completed Tab
                _buildTaskList(
                  filteredTasks.where((t) => t.status == 'completed').toList(),
                  isCompleted: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<TaskModel> tasks, {required bool isCompleted}) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.task_alt_rounded : Icons.inbox_outlined,
              size: 64.sp,
              color: AppColors.onSurfaceVariant.withOpacity(0.3),
            ),
            SizedBox(height: 16.h),
            Text(
              isCompleted ? 'No completed tasks yet' : 'No pending tasks',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            if (!isCompleted) ...[
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: () => _showAddTaskBottomSheet(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Task'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskItem(tasks[index]);
      },
    );
  }

  Widget _buildTaskItem(TaskModel task) {
    final priorityColors = {
      'low': AppColors.priorityLow,
      'medium': AppColors.priorityMedium,
      'high': AppColors.priorityHigh,
      'critical': AppColors.priorityCritical,
    };

    final categoryColors = {
      'Work': AppColors.primary,
      'Personal': AppColors.secondary,
      'Health': const Color(0xFFFF8A5C),
      'Finance': const Color(0xFF9B59B6),
      'Study': AppColors.tertiary,
    };

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              final tasks = ref.read(tasksProvider);
              final updatedTasks = tasks.map((t) {
                if (t.id == task.id) {
                  return t.copyWith(
                    status: t.status == 'completed' ? 'pending' : 'completed',
                    completedAt: t.status == 'completed' ? null : DateTime.now(),
                  );
                }
                return t;
              }).toList();
              ref.read(tasksProvider.notifier).state = updatedTasks;
            },
            backgroundColor: task.status == 'completed' ? AppColors.warning : AppColors.success,
            foregroundColor: AppColors.onPrimary,
            icon: task.status == 'completed' ? Icons.refresh : Icons.check,
            label: task.status == 'completed' ? 'Undo' : 'Complete',
            borderRadius: BorderRadius.horizontal(right: Radius.circular(16.r)),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            GestureDetector(
              onTap: () {
                final tasks = ref.read(tasksProvider);
                final updatedTasks = tasks.map((t) {
                  if (t.id == task.id) {
                    return t.copyWith(
                      status: t.status == 'completed' ? 'pending' : 'completed',
                      completedAt: t.status == 'completed' ? null : DateTime.now(),
                    );
                  }
                  return t;
                }).toList();
                ref.read(tasksProvider.notifier).state = updatedTasks;
              },
              child: Container(
                width: 28.w,
                height: 28.w,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: task.status == 'completed' ? AppColors.success : AppColors.outline,
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  color: task.status == 'completed' ? AppColors.success : Colors.transparent,
                ),
                child: task.status == 'completed'
                    ? Icon(Icons.check, size: 16.sp, color: AppColors.onPrimary)
                    : null,
              ),
            ),
            SizedBox(width: 14.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: task.status == 'completed' ? TextDecoration.lineThrough : null,
                      color: task.status == 'completed' ? AppColors.onSurfaceVariant : AppColors.onBackground,
                    ),
                  ),
                  if (task.description != null && task.description!.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Text(
                      task.description!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      // Priority
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: (priorityColors[task.priority] ?? AppColors.priorityLow).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          task.priority.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: priorityColors[task.priority] ?? AppColors.priorityLow,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Category
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: (categoryColors[task.category] ?? AppColors.primary).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          task.category,
                          style: AppTypography.labelSmall.copyWith(
                            color: categoryColors[task.category] ?? AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Due Date
                      if (task.dueDate != null)
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 14.sp,
                              color: AppColors.onSurfaceVariant,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              DateFormat('MMM d').format(task.dueDate!),
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String priority = 'medium';
    String category = 'Work';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          ),
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 24.w,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.outline,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'New Task',
                  style: AppTypography.h5.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 24.h),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Task title',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Description (optional)',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                SizedBox(height: 16.h),
                Text('Priority', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: 8.h),
                Row(
                  children: ['low', 'medium', 'high', 'critical'].map((p) {
                    final isSelected = p == priority;
                    final colors = {
                      'low': AppColors.priorityLow,
                      'medium': AppColors.priorityMedium,
                      'high': AppColors.priorityHigh,
                      'critical': AppColors.priorityCritical,
                    };
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ChoiceChip(
                          label: Text(p.toUpperCase()),
                          selected: isSelected,
                          onSelected: (_) => setModalState(() => priority = p),
                          selectedColor: colors[p]!.withOpacity(0.2),
                          labelStyle: AppTypography.labelSmall.copyWith(
                            color: isSelected ? colors[p] : AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),
                Text('Category', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  children: ['Work', 'Personal', 'Health', 'Finance', 'Study'].map((c) {
                    return ChoiceChip(
                      label: Text(c),
                      selected: c == category,
                      onSelected: (_) => setModalState(() => category = c),
                    );
                  }).toList(),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty) {
                        final tasks = ref.read(tasksProvider);
                        final newTask = TaskModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleController.text,
                          description: descController.text.isNotEmpty ? descController.text : null,
                          priority: priority,
                          category: category,
                          status: 'pending',
                          dueDate: DateTime.now().add(const Duration(days: 1)),
                          createdAt: DateTime.now(),
                        );
                        ref.read(tasksProvider.notifier).state = [newTask, ...tasks];
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Create Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}