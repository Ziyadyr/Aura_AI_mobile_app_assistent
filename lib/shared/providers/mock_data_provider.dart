import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../models/calendar_event_model.dart';
import '../models/note_model.dart';
import '../models/meeting_model.dart';
import '../models/email_model.dart';
import '../models/reminder_model.dart';
import '../models/ai_message_model.dart';

// Tasks Provider
final tasksProvider = StateProvider<List<TaskModel>>((ref) => _mockTasks);

final calendarEventsProvider = StateProvider<List<CalendarEventModel>>((ref) => _mockEvents);

final notesProvider = StateProvider<List<NoteModel>>((ref) => _mockNotes);

final meetingsProvider = StateProvider<List<MeetingModel>>((ref) => _mockMeetings);

final emailsProvider = StateProvider<List<EmailModel>>((ref) => _mockEmails);

final remindersProvider = StateProvider<List<ReminderModel>>((ref) => _mockReminders);

final aiMessagesProvider = StateProvider<List<AiMessageModel>>((ref) => _mockMessages);

// Auth state
final authStateProvider = StateProvider<bool>((ref) => false);

// Mock Data
final List<TaskModel> _mockTasks = [
  TaskModel(
    id: '1',
    title: 'Review Q4 Financial Report',
    description: 'Analyze quarterly performance and prepare summary for board meeting',
    dueDate: DateTime.now().add(const Duration(hours: 3)),
    priority: 'high',
    category: 'Work',
    status: 'in_progress',
    tags: ['finance', 'quarterly', 'board'],
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  TaskModel(
    id: '2',
    title: 'Prepare Presentation Slides',
    description: 'Create slides for the product launch meeting',
    dueDate: DateTime.now().add(const Duration(days: 1)),
    priority: 'high',
    category: 'Work',
    status: 'pending',
    tags: ['presentation', 'product'],
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  TaskModel(
    id: '3',
    title: 'Team Sync Meeting',
    description: 'Weekly team synchronization and progress update',
    dueDate: DateTime.now().add(const Duration(hours: 5)),
    priority: 'medium',
    category: 'Work',
    status: 'pending',
    tags: ['meeting', 'team'],
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  TaskModel(
    id: '4',
    title: 'Gym Workout',
    description: 'Cardio and strength training session',
    dueDate: DateTime.now().add(const Duration(hours: 8)),
    priority: 'low',
    category: 'Health',
    status: 'pending',
    tags: ['health', 'fitness'],
    createdAt: DateTime.now(),
  ),
  TaskModel(
    id: '5',
    title: 'Buy Groceries',
    description: 'Milk, eggs, vegetables, fruits',
    dueDate: DateTime.now().add(const Duration(days: 2)),
    priority: 'low',
    category: 'Personal',
    status: 'pending',
    tags: ['shopping', 'personal'],
    createdAt: DateTime.now(),
  ),
  TaskModel(
    id: '6',
    title: 'Submit Tax Documents',
    description: 'Prepare and submit all required tax documentation',
    dueDate: DateTime.now().add(const Duration(days: 3)),
    priority: 'critical',
    category: 'Finance',
    status: 'pending',
    tags: ['tax', 'finance', 'urgent'],
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
];

final List<CalendarEventModel> _mockEvents = [
  CalendarEventModel(
    id: '1',
    title: 'Morning Standup',
    description: 'Daily team standup meeting',
    startTime: DateTime.now().copyWith(hour: 9, minute: 0),
    endTime: DateTime.now().copyWith(hour: 9, minute: 30),
    location: 'Conference Room A',
    category: 'Work',
    attendees: ['john@company.com', 'sarah@company.com'],
  ),
  CalendarEventModel(
    id: '2',
    title: 'Product Review',
    description: 'Review new product features with stakeholders',
    startTime: DateTime.now().copyWith(hour: 11, minute: 0),
    endTime: DateTime.now().copyWith(hour: 12, minute: 0),
    location: 'Meeting Room B',
    category: 'Work',
    attendees: ['stakeholder1@company.com'],
  ),
  CalendarEventModel(
    id: '3',
    title: 'Lunch with Client',
    description: 'Discuss partnership opportunities',
    startTime: DateTime.now().copyWith(hour: 13, minute: 0),
    endTime: DateTime.now().copyWith(hour: 14, minute: 30),
    location: 'The Grand Hotel Restaurant',
    category: 'Work',
  ),
  CalendarEventModel(
    id: '4',
    title: 'Design Sprint Workshop',
    description: 'Collaborative design session',
    startTime: DateTime.now().copyWith(hour: 15, minute: 0),
    endTime: DateTime.now().copyWith(hour: 17, minute: 0),
    location: 'Creative Lab',
    category: 'Work',
  ),
  CalendarEventModel(
    id: '5',
    title: 'Gym Session',
    description: 'Personal training',
    startTime: DateTime.now().copyWith(hour: 18, minute: 0),
    endTime: DateTime.now().copyWith(hour: 19, minute: 30),
    location: 'Fitness First Gym',
    category: 'Health',
  ),
];

final List<NoteModel> _mockNotes = [
  NoteModel(
    id: '1',
    title: 'Project Ideas 2024',
    content: '1. AI-powered document analyzer\n2. Smart calendar scheduler\n3. Automated email responder\n\nKey insights from the brainstorming session with the team. Need to prioritize based on market demand and technical feasibility.',
    category: 'Work',
    tags: ['ideas', 'planning', '2024'],
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    isFavorite: true,
  ),
  NoteModel(
    id: '2',
    title: 'Meeting Notes - Product Team',
    content: 'Discussion points:\n- New feature roadmap\n- User feedback analysis\n- Q2 targets\n\nAction items:\n- Follow up with design team\n- Schedule user interviews\n- Prepare PRD document',
    category: 'Work',
    tags: ['meeting', 'product'],
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now(),
    aiSummary: 'Product team discussed Q2 roadmap, user feedback, and set targets. 3 action items assigned.',
  ),
  NoteModel(
    id: '3',
    title: 'Personal Goals',
    content: '1. Learn Flutter advanced patterns\n2. Complete ML course\n3. Read 12 books this year\n4. Run a half marathon\n5. Build a side project',
    category: 'Personal',
    tags: ['goals', 'personal', 'growth'],
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    isFavorite: true,
  ),
  NoteModel(
    id: '4',
    title: 'Recipe - Healthy Smoothie',
    content: 'Ingredients:\n- 1 banana\n- 1 cup spinach\n- 1/2 cup Greek yogurt\n- 1 tbsp honey\n- 1/2 cup almond milk\n\nBlend until smooth. Great for breakfast!',
    category: 'Personal',
    tags: ['recipe', 'health'],
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
];

final List<MeetingModel> _mockMeetings = [
  MeetingModel(
    id: '1',
    title: 'Sprint Planning - Week 24',
    startTime: DateTime.now().subtract(const Duration(days: 1)),
    endTime: DateTime.now().subtract(const Duration(days: 1)).add(const Duration(hours: 1)),
    summary: 'Team planned sprint goals and assigned tasks for the upcoming week.',
    keyPoints: [
      'Sprint goal: Complete payment integration',
      '3 user stories assigned',
      '2 technical debt items to address',
      'API documentation needs updating'
    ],
    actionItems: [
      'Set up Stripe sandbox environment',
      'Write unit tests for payment flow',
      'Update API docs'
    ],
    attendees: ['Alice', 'Bob', 'Charlie', 'Diana'],
    status: 'completed',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  MeetingModel(
    id: '2',
    title: 'Client Discovery Call',
    startTime: DateTime.now().subtract(const Duration(days: 2)),
    endTime: DateTime.now().subtract(const Duration(days: 2)).add(const Duration(minutes: 45)),
    summary: 'Initial discovery call with potential enterprise client.',
    keyPoints: [
      'Client needs custom CRM integration',
      'Timeline: 3 months',
      'Budget approved for Phase 1',
      'Requires SOC 2 compliance'
    ],
    actionItems: [
      'Send proposal by Friday',
      'Schedule technical architecture review',
      'Prepare compliance checklist'
    ],
    attendees: ['John (Client)', 'Sarah (PM)', 'Mike (Tech Lead)'],
    status: 'completed',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
];

final List<EmailModel> _mockEmails = [
  EmailModel(
    id: '1',
    subject: 'Q4 Budget Approval Needed',
    sender: 'Finance Department',
    senderEmail: 'finance@company.com',
    body: 'Please review and approve the Q4 budget allocation for your department. The deadline for approval is this Friday.',
    summary: 'Budget approval request for Q4 with Friday deadline.',
    isRead: false,
    isImportant: true,
    receivedAt: DateTime.now().subtract(const Duration(hours: 2)),
    labels: ['Work', 'Important'],
  ),
  EmailModel(
    id: '2',
    subject: 'Welcome to the New Platform',
    sender: 'Product Team',
    senderEmail: 'product@company.com',
    body: 'We are excited to announce the launch of our new platform. Check out the new features and improvements.',
    isRead: true,
    receivedAt: DateTime.now().subtract(const Duration(hours: 5)),
    labels: ['Work'],
  ),
  EmailModel(
    id: '3',
    subject: 'Meeting Rescheduled: Design Review',
    sender: 'Sarah Johnson',
    senderEmail: 'sarah.j@company.com',
    body: 'The design review meeting has been moved to Thursday at 2 PM. Please update your calendar.',
    summary: 'Design review moved to Thursday 2 PM.',
    isRead: false,
    isStarred: true,
    receivedAt: DateTime.now().subtract(const Duration(hours: 8)),
    labels: ['Work', 'Follow-up Required'],
  ),
  EmailModel(
    id: '4',
    subject: 'Your Weekly Digest',
    sender: 'Newsletter',
    senderEmail: 'newsletter@techweekly.com',
    body: 'This week in tech: AI breakthroughs, new framework releases, and industry trends.',
    isRead: true,
    receivedAt: DateTime.now().subtract(const Duration(days: 1)),
    labels: ['Personal'],
  ),
];

final List<ReminderModel> _mockReminders = [
  ReminderModel(
    id: '1',
    title: 'Take Medication',
    description: 'Daily vitamin and supplements',
    dueDate: DateTime.now().copyWith(hour: 8, minute: 0),
    triggerType: 'time',
    priority: 'high',
    isRecurring: true,
    recurrenceRule: 'daily',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  ),
  ReminderModel(
    id: '2',
    title: 'Call Mom',
    description: 'Weekly catch-up call',
    dueDate: DateTime.now().copyWith(hour: 19, minute: 0),
    triggerType: 'time',
    priority: 'medium',
    isRecurring: true,
    recurrenceRule: 'weekly',
    createdAt: DateTime.now().subtract(const Duration(days: 14)),
  ),
  ReminderModel(
    id: '3',
    title: 'Water the Plants',
    description: 'Living room and balcony plants',
    dueDate: DateTime.now().copyWith(hour: 10, minute: 0),
    triggerType: 'time',
    priority: 'low',
    isRecurring: true,
    recurrenceRule: 'weekly',
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
];

final List<AiMessageModel> _mockMessages = [
  AiMessageModel(
    id: '1',
    content: 'Hello! I\'m AURA, your AI executive assistant. How can I help you today?',
    role: 'assistant',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    suggestedActions: [
      {'label': 'Show my schedule', 'action': 'show_schedule'},
      {'label': 'Create a task', 'action': 'create_task'},
      {'label': 'Summarize emails', 'action': 'summarize_emails'},
    ],
  ),
];