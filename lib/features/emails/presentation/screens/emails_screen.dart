import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/providers/mock_data_provider.dart';

class EmailsScreen extends ConsumerStatefulWidget {
  const EmailsScreen({super.key});

  @override
  ConsumerState<EmailsScreen> createState() => _EmailsScreenState();
}

class _EmailsScreenState extends ConsumerState<EmailsScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Important', 'Work', 'Personal', 'Follow-up Required'];

  @override
  Widget build(BuildContext context) {
    final emails = ref.watch(emailsProvider);
    final filteredEmails = _selectedCategory == 'All'
        ? emails
        : emails.where((e) => e.labels?.contains(_selectedCategory) ?? false).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Emails',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.sync_rounded),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
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

          // Email Stats
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: AppColors.softGradient,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                _buildStatItem(
                  icon: Icons.mail_outline_rounded,
                  label: 'Unread',
                  value: emails.where((e) => !e.isRead).length.toString(),
                  color: AppColors.primary,
                ),
                Container(
                  width: 1.w,
                  height: 40.h,
                  color: AppColors.outline,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                ),
                _buildStatItem(
                  icon: Icons.star_rounded,
                  label: 'Starred',
                  value: emails.where((e) => e.isStarred).length.toString(),
                  color: AppColors.priorityMedium,
                ),
                Container(
                  width: 1.w,
                  height: 40.h,
                  color: AppColors.outline,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                ),
                _buildStatItem(
                  icon: Icons.warning_amber_rounded,
                  label: 'Important',
                  value: emails.where((e) => e.isImportant).length.toString(),
                  color: AppColors.priorityHigh,
                ),
              ],
            ),
          ),

          // Email List
          Expanded(
            child: filteredEmails.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail_outline_rounded,
                          size: 64.sp,
                          color: AppColors.onSurfaceVariant.withOpacity(0.3),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No emails found',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    itemCount: filteredEmails.length,
                    itemBuilder: (context, index) {
                      return _buildEmailCard(filteredEmails[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18.sp, color: color),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmailCard(dynamic email) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            icon: Icons.reply_rounded,
            label: 'Reply',
            borderRadius: BorderRadius.horizontal(right: Radius.circular(16.r)),
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: AppColors.success,
            foregroundColor: AppColors.onPrimary,
            icon: Icons.check_rounded,
            label: 'Read',
            borderRadius: BorderRadius.horizontal(left: Radius.circular(16.r)),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => _showEmailDetail(context, email),
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: email.isRead ? AppColors.surface : AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Sender Avatar
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: Text(
                        email.sender.isNotEmpty ? email.sender[0].toUpperCase() : '?',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Sender Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                email.sender,
                                style: AppTypography.bodyLarge.copyWith(
                                  fontWeight: email.isRead ? FontWeight.w500 : FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (email.isImportant)
                              Container(
                                margin: EdgeInsets.only(left: 8.w),
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: AppColors.priorityHigh.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  'IMPORTANT',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.priorityHigh,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          email.senderEmail,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Star
                  IconButton(
                    onPressed: () {
                      final emails = ref.read(emailsProvider);
                      final updatedEmails = emails.map((e) {
                        if (e.id == email.id) {
                          return e.copyWith(isStarred: !e.isStarred);
                        }
                        return e;
                      }).toList();
                      ref.read(emailsProvider.notifier).state = updatedEmails;
                    },
                    icon: Icon(
                      email.isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: email.isStarred ? AppColors.priorityMedium : AppColors.onSurfaceVariant,
                      size: 22.sp,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Subject
              Text(
                email.subject,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: email.isRead ? FontWeight.w500 : FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),

              // Body Preview
              Text(
                email.body ?? email.summary ?? '',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),

              // Footer
              Row(
                children: [
                  // Labels
                  if (email.labels != null)
                    Expanded(
                      child: Wrap(
                        spacing: 6.w,
                        children: email.labels!.map((label) =>
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: _getLabelColor(label).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              label,
                              style: AppTypography.labelSmall.copyWith(
                                color: _getLabelColor(label),
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ).toList(),
                      ),
                    ),

                  // Time
                  Text(
                    email.receivedAt != null
                        ? DateFormat('MMM d, h:mm a').format(email.receivedAt!)
                        : '',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLabelColor(String label) {
    final colors = {
      'Important': AppColors.priorityHigh,
      'Work': AppColors.primary,
      'Personal': AppColors.secondary,
      'Follow-up Required': AppColors.tertiary,
    };
    return colors[label] ?? AppColors.onSurfaceVariant;
  }

  void _showEmailDetail(BuildContext context, dynamic email) {
    // Mark as read
    final emails = ref.read(emailsProvider);
    final updatedEmails = emails.map((e) {
      if (e.id == email.id) {
        return e.copyWith(isRead: true);
      }
      return e;
    }).toList();
    ref.read(emailsProvider.notifier).state = updatedEmails;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Text(
                          email.sender.isNotEmpty ? email.sender[0].toUpperCase() : '?',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            email.sender,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            email.senderEmail,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Divider(color: AppColors.outlineVariant),

              // Subject
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  email.subject,
                  style: AppTypography.h6.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // AI Summary
              if (email.summary != null)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: AppColors.softGradient,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 18.sp,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'AI Summary',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        email.summary!,
                        style: AppTypography.bodyMedium.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

              // Body
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: EdgeInsets.all(20.w),
                  child: Text(
                    email.body ?? 'No content available.',
                    style: AppTypography.bodyLarge.copyWith(
                      height: 1.6,
                    ),
                  ),
                ),
              ),

              // Actions
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.reply_rounded),
                        label: const Text('Reply'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.forward_rounded),
                        label: const Text('Forward'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}