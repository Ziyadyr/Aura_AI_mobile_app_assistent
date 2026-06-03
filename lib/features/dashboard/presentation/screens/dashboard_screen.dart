import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/providers/mock_data_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final events = ref.watch(calendarEventsProvider);
    final pendingTasks = tasks.where((t) => t.status == 'pending' || t.status == 'in_progress').toList();
    final upcomingEvents = events.where((e) => e.startTime.isAfter(DateTime.now())).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverToBoxAdapter(
            child: _buildAppBar(context),
          ),

          // AI Daily Briefing
          SliverToBoxAdapter(
            child: _buildAIBriefing(context),
          ),

          // Quick Actions
          SliverToBoxAdapter(
            child: _buildQuickActions(context),
          ),

          // Today's Schedule
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              'Today\'s Schedule',
              '${upcomingEvents.length} events',
              () => context.push('/calendar'),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildScheduleList(upcomingEvents.take(3).toList()),
          ),

          // Pending Tasks
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              'Pending Tasks',
              '${pendingTasks.length} tasks',
              () => context.push('/tasks'),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= pendingTasks.take(4).length) return null;
                  return _buildTaskCard(pendingTasks[index]);
                },
              ),
            ),
          ),

          // Recent Notes
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              'Recent Notes',
              'View all',
              () => context.push('/notes'),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildNotesPreview(),
          ),

          // Bottom Padding
          SliverToBoxAdapter(
            child: SizedBox(height: 100.h),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
      child: Row(
        children: [
          // Profile Avatar
          GestureDetector(
            onTap: () => context.push('/profile'),
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  'JD',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),

          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  'John Doe',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Notification Bell
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.onBackground,
                  size: 24.sp,
                ),
              ),
              Positioned(
                right: 8.w,
                top: 8.h,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIBriefing(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.onPrimary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'AI Daily Briefing',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'You have 3 high-priority tasks today and 2 meetings scheduled. Your Q4 report deadline is approaching in 2 days. I\'ve prepared a suggested schedule for you.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onPrimary.withOpacity(0.9),
              height: 1.6,
            ),
          ),
          SizedBox(height: 16.h),
          InkWell(
            onTap: () => context.push('/ai-chat'),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.onPrimary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ask AURA',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.onPrimary,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.add_task_rounded, 'label': 'Add Task', 'color': const Color(0xFF4A90D9)},
      {'icon': Icons.note_add_rounded, 'label': 'Add Note', 'color': const Color(0xFF50C8A3)},
      {'icon': Icons.video_call_rounded, 'label': 'Meeting', 'color': const Color(0xFF7B8CDE)},
      {'icon': Icons.mic_rounded, 'label': 'Record', 'color': const Color(0xFFFF8A5C)},
      {'icon': Icons.smart_toy_rounded, 'label': 'Ask AI', 'color': const Color(0xFF9B59B6)},
    ];

    return Container(
      height: 100.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final action = actions[index];
          return InkWell(
            onTap: () {
              if (action['label'] == 'Ask AI') {
                context.push('/ai-chat');
              }
            },
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              width: 72.w,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: (action['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      color: action['color'] as Color,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    action['label'] as String,
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              action,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList(List<dynamic> events) {
    if (events.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: Text(
              'No upcoming events',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 160.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final event = events[index];
          return Container(
            width: 280.w,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        DateFormat('h:mm a').format(event.startTime),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (event.location != null)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14.sp,
                            color: AppColors.onSurfaceVariant,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            event.location!,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  event.title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  event.description ?? '',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                if (event.attendees != null && event.attendees!.isNotEmpty)
                  Row(
                    children: [
                      ...event.attendees!.take(3).map((_) => 
                        Container(
                          margin: EdgeInsets.only(right: -4.w),
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surface, width: 2),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 12.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ).toList(),
                      if (event.attendees!.length > 3)
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surface, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              '+${event.attendees!.length - 3}',
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 9.sp,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(dynamic task) {
    final priorityColors = {
      'low': AppColors.priorityLow,
      'medium': AppColors.priorityMedium,
      'high': AppColors.priorityHigh,
      'critical': AppColors.priorityCritical,
    };

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
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
          // Checkbox
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: task.status == 'completed' ? AppColors.success : AppColors.outline,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8.r),
              color: task.status == 'completed' ? AppColors.success : Colors.transparent,
            ),
            child: task.status == 'completed'
                ? Icon(Icons.check, size: 16.sp, color: AppColors.onPrimary)
                : null,
          ),
          SizedBox(width: 12.w),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: task.status == 'completed'
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.status == 'completed'
                        ? AppColors.onSurfaceVariant
                        : AppColors.onBackground,
                  ),
                ),
                if (task.dueDate != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      'Due ${DateFormat('MMM d, h:mm a').format(task.dueDate!)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ),

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
        ],
      ),
    );
  }

  Widget _buildNotesPreview() {
    return Container(
      height: 140.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final colors = [
            const Color(0xFFFFF3E0),
            const Color(0xFFE3F2FD),
            const Color(0xFFE8F5E9),
          ];
          final titles = ['Project Ideas', 'Meeting Notes', 'Personal Goals'];
          final previews = [
            '1. AI document analyzer\n2. Smart calendar\n3. Auto email responder',
            'Sprint goals assigned\n3 user stories\nAPI docs update needed',
            'Learn Flutter patterns\nComplete ML course\nRead 12 books',
          ];

          return Container(
            width: 200.w,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titles[index],
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Text(
                  previews[index],
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}