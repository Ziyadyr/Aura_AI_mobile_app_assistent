class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'AURA';
  static const String appTagline = 'Your AI Executive Assistant';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://api.aura.app/v1';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String themeKey = 'app_theme';
  static const String localeKey = 'app_locale';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // AI
  static const String openAiModel = 'gpt-4';
  static const int maxTokens = 2000;
  static const double temperature = 0.7;

  // Audio
  static const String audioFormat = 'm4a';
  static const int maxRecordingDuration = 3600; // seconds
  static const int sampleRate = 44100;

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String displayDateFormat = 'MMMM d, yyyy';
  static const String displayTimeFormat = 'h:mm a';
  static const String displayDateTimeFormat = 'MMM d, h:mm a';

  // Features
  static const List<String> quickActions = [
    'Add Task',
    'Add Note',
    'Schedule Meeting',
    'Ask AI',
    'Record Meeting',
  ];

  static const List<String> aiActionModes = [
    'Suggest Only',
    'Confirmation Mode',
    'Trusted Mode',
    'Autonomous Mode',
  ];

  // Priority Levels
  static const Map<String, int> priorityLevels = {
    'Low': 1,
    'Medium': 2,
    'High': 3,
    'Critical': 4,
  };

  // Categories
  static const List<String> taskCategories = [
    'Work',
    'Personal',
    'Study',
    'Health',
    'Finance',
    'Family',
    'Shopping',
    'Travel',
  ];

  // Email Categories
  static const List<String> emailCategories = [
    'Important',
    'Work',
    'Personal',
    'Follow-up Required',
  ];
}