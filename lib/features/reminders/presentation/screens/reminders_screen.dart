import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/providers/mock_data_provider.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Reminders',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddReminderBottomSheet(context),
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
      ),
      body: reminders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 64.sp,
                    color: AppColors.onSurfaceVariant.withOpacity(0.3),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No reminders yet',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton.icon(
                    onPressed: () => _showAddReminderBottomSheet(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Reminder'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                return _buildReminderCard(context, reminders[index], ref);
              },
            ),
    );
  }

  Widget _buildReminderCard(BuildContext context, dynamic reminder, WidgetRef ref) {
    final priorityColors = {
      'low': AppColors.priorityLow,
      'medium': AppColors.priorityMedium,
      'high': AppColors.priorityHigh,
    };

    final triggerIcons = {
      'time': Icons.schedule_rounded,
      'location': Icons.location_on_outlined,
    };

    return Dismissible(
      key: Key(reminder.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: Icon(
          Icons.delete_outline_rounded,
          color: AppColors.onPrimary,
          size: 28.sp,
        ),
      ),
      onDismissed: (_) {
        final reminders = ref.read(remindersProvider);
        ref.read(remindersProvider.notifier).state = 
          reminders.where((r) => r.id != reminder.id).toList();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
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
          children: [
            // Icon
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: (priorityColors[reminder.priority] ?? AppColors.priorityLow).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                triggerIcons[reminder.triggerType] ?? Icons.schedule_rounded,
                color: priorityColors[reminder.priority] ?? AppColors.priorityLow,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (reminder.description != null && reminder.description!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      reminder.description!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      if (reminder.dueDate != null)
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 14.sp,
                              color: AppColors.onSurfaceVariant,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              DateFormat('MMM d, h:mm a').format(reminder.dueDate!),
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      if (reminder.isRecurring) ...[
                        SizedBox(width: 12.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            'Recurring',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Toggle
            Switch.adaptive(
              value: reminder.isActive,
              onChanged: (value) {
                final reminders = ref.read(remindersProvider);
                final updatedReminders = reminders.map((r) {
                  if (r.id == reminder.id) {
                    return r.copyWith(isActive: value);
                  }
                  return r;
                }).toList();
                ref.read(remindersProvider.notifier).state = updatedReminders;
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReminderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              'New Reminder',
              style: AppTypography.h5.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 24.h),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Reminder title',
                prefixIcon: Icon(Icons.title_rounded),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Description (optional)',
                prefixIcon: Icon(Icons.description_outlined),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Date & Time',
                      prefixIcon: Icon(Icons.calendar_today_rounded),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (_) {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                Text(
                  'Recurring reminder',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Create Reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}