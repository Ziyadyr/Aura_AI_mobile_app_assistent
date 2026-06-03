import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/screens/splash_screen.dart';
import '../../../auth/presentation/screens/onboarding_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/screens/register_screen.dart';
import '../../../auth/presentation/screens/forgot_password_screen.dart';
import '../../presentation/screens/app_shell.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../ai_chat/presentation/screens/ai_chat_screen.dart';
import '../../../calendar/presentation/screens/calendar_screen.dart';
import '../../../tasks/presentation/screens/tasks_screen.dart';
import '../../../notes/presentation/screens/notes_screen.dart';
import '../../../meetings/presentation/screens/meetings_screen.dart';
import '../../../emails/presentation/screens/emails_screen.dart';
import '../../../reminders/presentation/screens/reminders_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../settings/presentation/screens/profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      // Splash
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Auth
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      // App Shell with Bottom Navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/calendar',
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const TasksScreen(),
          ),
          GoRoute(
            path: '/ai-chat',
            builder: (context, state) => const AiChatScreen(),
          ),
        ],
      ),
      // Full Screen Routes
      GoRoute(
        path: '/notes',
        builder: (context, state) => const NotesScreen(),
      ),
      GoRoute(
        path: '/meetings',
        builder: (context, state) => const MeetingsScreen(),
      ),
      GoRoute(
        path: '/emails',
        builder: (context, state) => const EmailsScreen(),
      ),
      GoRoute(
        path: '/reminders',
        builder: (context, state) => const RemindersScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});

// Navigation index provider
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// Navigation helper
class AppNavigation {
  static void goToDashboard(BuildContext context) => context.go('/dashboard');
  static void goToCalendar(BuildContext context) => context.go('/calendar');
  static void goToTasks(BuildContext context) => context.go('/tasks');
  static void goToAiChat(BuildContext context) => context.go('/ai-chat');
  static void goToNotes(BuildContext context) => context.push('/notes');
  static void goToMeetings(BuildContext context) => context.push('/meetings');
  static void goToEmails(BuildContext context) => context.push('/emails');
  static void goToReminders(BuildContext context) => context.push('/reminders');
  static void goToSettings(BuildContext context) => context.push('/settings');
  static void goToProfile(BuildContext context) => context.push('/profile');
  static void goToLogin(BuildContext context) => context.go('/login');
  static void goToRegister(BuildContext context) => context.go('/register');
  static void goToOnboarding(BuildContext context) => context.go('/onboarding');
  static void goBack(BuildContext context) => context.pop();
}