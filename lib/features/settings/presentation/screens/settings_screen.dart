import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        children: [
          // Account Section
          _buildSectionHeader('Account'),
          _buildSettingTile(
            icon: Icons.person_outline_rounded,
            iconColor: AppColors.primary,
            title: 'Profile',
            subtitle: 'Manage your personal information',
            onTap: () => context.push('/profile'),
          ),
          _buildSettingTile(
            icon: Icons.security_rounded,
            iconColor: AppColors.success,
            title: 'Security',
            subtitle: 'Password, biometric authentication',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.notifications_outlined,
            iconColor: AppColors.warning,
            title: 'Notifications',
            subtitle: 'Push, email, SMS preferences',
            onTap: () {},
          ),

          // AI Settings Section
          _buildSectionHeader('AI Assistant'),
          _buildSettingTile(
            icon: Icons.auto_awesome_rounded,
            iconColor: AppColors.primary,
            title: 'AI Action Mode',
            subtitle: 'Current: Confirmation Mode',
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Change',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onTap: () => _showAIModeBottomSheet(context),
          ),
          _buildSettingTile(
            icon: Icons.memory_rounded,
            iconColor: AppColors.secondary,
            title: 'AI Memory',
            subtitle: 'Manage what AURA remembers',
            trailing: Switch.adaptive(
              value: true,
              onChanged: (_) {},
              activeColor: AppColors.primary,
            ),
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.mic_none_rounded,
            iconColor: AppColors.tertiary,
            title: 'Voice Settings',
            subtitle: 'Speech-to-text, voice commands',
            onTap: () {},
          ),

          // Integrations Section
          _buildSectionHeader('Integrations'),
          _buildSettingTile(
            icon: Icons.calendar_today_rounded,
            iconColor: const Color(0xFF4285F4),
            title: 'Calendar',
            subtitle: 'Google Calendar, Outlook',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.email_outlined,
            iconColor: const Color(0xFFEA4335),
            title: 'Email',
            subtitle: 'Gmail, Outlook integration',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.cloud_outlined,
            iconColor: const Color(0xFF3ECF8E),
            title: 'Cloud Storage',
            subtitle: 'Supabase, Google Drive',
            onTap: () {},
          ),

          // Appearance Section
          _buildSectionHeader('Appearance'),
          _buildSettingTile(
            icon: Icons.palette_outlined,
            iconColor: AppColors.primary,
            title: 'Theme',
            subtitle: 'Light mode',
            onTap: () {},
          ),

          // Privacy Section
          _buildSectionHeader('Privacy & Data'),
          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: AppColors.primary,
            title: 'Privacy Controls',
            subtitle: 'Data sharing, permissions',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.storage_rounded,
            iconColor: AppColors.secondary,
            title: 'Data Retention',
            subtitle: 'Manage your stored data',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.download_rounded,
            iconColor: AppColors.tertiary,
            title: 'Export Data',
            subtitle: 'Download your data',
            onTap: () {},
          ),

          // About Section
          _buildSectionHeader('About'),
          _buildSettingTile(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.onSurfaceVariant,
            title: 'About AURA',
            subtitle: 'Version ${AppConstants.appVersion}',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.help_outline_rounded,
            iconColor: AppColors.onSurfaceVariant,
            title: 'Help & Support',
            subtitle: 'FAQ, contact support',
            onTap: () {},
          ),

          // Logout
          Padding(
            padding: EdgeInsets.all(20.w),
            child: SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error.withOpacity(0.1),
                  foregroundColor: AppColors.error,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 8.h),
      child: Text(
        title,
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      leading: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, color: iconColor, size: 22.sp),
      ),
      title: Text(
        title,
        style: AppTypography.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: trailing ?? Icon(
        Icons.chevron_right_rounded,
        color: AppColors.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  void _showAIModeBottomSheet(BuildContext context) {
    final modes = [
      {
        'name': 'Suggest Only',
        'description': 'AI only recommends actions, never executes',
        'icon': Icons.lightbulb_outline_rounded,
      },
      {
        'name': 'Confirmation Mode',
        'description': 'User must approve all AI actions',
        'icon': Icons.check_circle_outline_rounded,
      },
      {
        'name': 'Trusted Mode',
        'description': 'Safe actions executed automatically',
        'icon': Icons.verified_user_outlined,
      },
      {
        'name': 'Autonomous Mode',
        'description': 'AI can perform actions independently',
        'icon': Icons.auto_fix_high_rounded,
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        padding: EdgeInsets.all(24.w),
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
              'AI Action Mode',
              style: AppTypography.h5.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8.h),
            Text(
              'Choose how AURA interacts with your data',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h),
            ...modes.map((mode) => Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: mode['name'] == 'Confirmation Mode'
                    ? AppColors.primaryContainer
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16.r),
                border: mode['name'] == 'Confirmation Mode'
                    ? Border.all(color: AppColors.primary)
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      mode['icon'] as IconData,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mode['name'] as String,
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          mode['description'] as String,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (mode['name'] == 'Confirmation Mode')
                    Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}