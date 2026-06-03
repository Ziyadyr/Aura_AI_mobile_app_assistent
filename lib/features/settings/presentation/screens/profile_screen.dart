import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Edit',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Profile Header
          Container(
            margin: EdgeInsets.all(20.w),
            padding: EdgeInsets.all(24.w),
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
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        color: AppColors.onPrimary.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.onPrimary.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'JD',
                          style: AppTypography.h2.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: AppColors.onPrimary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 16.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Name
                Text(
                  'John Doe',
                  style: AppTypography.h5.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),

                // Email
                Text(
                  'john.doe@company.com',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.onPrimary.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 4.h),

                // Role
                Container(
                  margin: EdgeInsets.only(top: 8.h),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.onPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Product Manager',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Stats
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Tasks', '24'),
                Container(width: 1.w, height: 40.h, color: AppColors.outline),
                _buildStat('Meetings', '12'),
                Container(width: 1.w, height: 40.h, color: AppColors.outline),
                _buildStat('Notes', '18'),
                Container(width: 1.w, height: 40.h, color: AppColors.outline),
                _buildStat('Events', '8'),
              ],
            ),
          ),

          // Personal Information
          _buildSectionHeader('Personal Information'),
          _buildInfoTile(
            icon: Icons.person_outline_rounded,
            label: 'Full Name',
            value: 'John Doe',
          ),
          _buildInfoTile(
            icon: Icons.email_outlined,
            label: 'Email',
            value: 'john.doe@company.com',
          ),
          _buildInfoTile(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: '+1 (555) 123-4567',
          ),
          _buildInfoTile(
            icon: Icons.business_outlined,
            label: 'Organization',
            value: 'TechCorp Inc.',
          ),
          _buildInfoTile(
            icon: Icons.work_outline_rounded,
            label: 'Job Title',
            value: 'Product Manager',
          ),

          // AI Preferences
          _buildSectionHeader('AI Preferences'),
          _buildInfoTile(
            icon: Icons.auto_awesome_rounded,
            label: 'AI Action Mode',
            value: 'Confirmation Mode',
          ),
          _buildInfoTile(
            icon: Icons.memory_rounded,
            label: 'AI Memory',
            value: 'Enabled',
          ),
          _buildInfoTile(
            icon: Icons.language_rounded,
            label: 'Language',
            value: 'English (US)',
          ),
          _buildInfoTile(
            icon: Icons.access_time_rounded,
            label: 'Timezone',
            value: 'EST (UTC-5)',
          ),

          // Account
          _buildSectionHeader('Account'),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
            leading: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 22.sp,
              ),
            ),
            title: Text(
              'Delete Account',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Permanently delete your account and data',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            onTap: () {},
          ),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 12.h),
      child: Text(
        title,
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      leading: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          color: AppColors.onSurfaceVariant,
          size: 22.sp,
        ),
      ),
      title: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        value,
        style: AppTypography.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}