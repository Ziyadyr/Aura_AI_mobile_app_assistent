import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/navigation_provider.dart';

class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final router = GoRouter.of(context);
    
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                  currentIndex: currentIndex,
                  onTap: () {
                    ref.read(bottomNavIndexProvider.notifier).state = 0;
                    router.go('/dashboard');
                  },
                ),
                _buildNavItem(
                  icon: Icons.calendar_today_rounded,
                  label: 'Calendar',
                  index: 1,
                  currentIndex: currentIndex,
                  onTap: () {
                    ref.read(bottomNavIndexProvider.notifier).state = 1;
                    router.go('/calendar');
                  },
                ),
                _buildFAB(),
                _buildNavItem(
                  icon: Icons.task_alt_rounded,
                  label: 'Tasks',
                  index: 2,
                  currentIndex: currentIndex,
                  onTap: () {
                    ref.read(bottomNavIndexProvider.notifier).state = 2;
                    router.go('/tasks');
                  },
                ),
                _buildNavItem(
                  icon: Icons.chat_bubble_rounded,
                  label: 'AI Chat',
                  index: 3,
                  currentIndex: currentIndex,
                  onTap: () {
                    ref.read(bottomNavIndexProvider.notifier).state = 3;
                    router.go('/ai-chat');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = index == currentIndex;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: () {
        // Show quick actions bottom sheet
      },
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.add_rounded,
          color: AppColors.onPrimary,
          size: 28.sp,
        ),
      ),
    );
  }
}