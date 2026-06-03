import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/ai_message_model.dart';
import '../../../../shared/providers/mock_data_provider.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final newMessage = AiMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text,
      role: 'user',
      timestamp: DateTime.now(),
    );

    final messages = ref.read(aiMessagesProvider);
    ref.read(aiMessagesProvider.notifier).state = [...messages, newMessage];
    _messageController.clear();

    // Simulate AI typing
    setState(() {
      _isTyping = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });

        final aiResponse = _generateAIResponse(text);
        final updatedMessages = ref.read(aiMessagesProvider);
        ref.read(aiMessagesProvider.notifier).state = [...updatedMessages, aiResponse];

        _scrollToBottom();
      }
    });

    _scrollToBottom();
  }

  AiMessageModel _generateAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    String response;
    List<Map<String, dynamic>>? actions;

    if (lowerMessage.contains('schedule') || lowerMessage.contains('meeting')) {
      response = 'I\'ll help you schedule that. I can see you have availability tomorrow at 2 PM and 4 PM. Would you like me to create a calendar event?\n\nI can also:\n- Check for conflicts\n- Find the best time for all attendees\n- Send invitations automatically';
      actions = [
        {'label': 'Create Event', 'action': 'create_event'},
        {'label': 'Check Availability', 'action': 'check_availability'},
        {'label': 'Suggest Times', 'action': 'suggest_times'},
      ];
    } else if (lowerMessage.contains('task') || lowerMessage.contains('todo')) {
      response = 'I\'ve analyzed your current workload. You have 3 high-priority tasks pending. Would you like me to:\n\n- Prioritize your tasks based on deadlines\n- Break down complex tasks into subtasks\n- Estimate completion time\n- Create a focused work session';
      actions = [
        {'label': 'View Tasks', 'action': 'view_tasks'},
        {'label': 'Auto-Prioritize', 'action': 'prioritize'},
        {'label': 'Create Task', 'action': 'create_task'},
      ];
    } else if (lowerMessage.contains('email') || lowerMessage.contains('message')) {
      response = 'I can help you with your emails. You have 4 unread emails, including 1 marked as important from Finance about Q4 budget approval.\n\nWould you like me to:\n- Summarize your unread emails\n- Draft responses\n- Flag items needing follow-up';
      actions = [
        {'label': 'Summarize Emails', 'action': 'summarize_emails'},
        {'label': 'Draft Response', 'action': 'draft_response'},
        {'label': 'View Inbox', 'action': 'view_inbox'},
      ];
    } else if (lowerMessage.contains('summarize') || lowerMessage.contains('summary')) {
      response = 'Here\'s your daily summary:\n\n**Schedule:** 3 events today (Standup, Product Review, Client Lunch)\n**Tasks:** 6 pending (2 high priority, 1 critical)\n**Emails:** 4 unread (1 important)\n**Reminders:** 3 active\n\nYour most urgent item is the Q4 Financial Report due in 3 hours. I recommend focusing on that first.';
      actions = [
        {'label': 'View Full Schedule', 'action': 'view_schedule'},
        {'label': 'Focus Mode', 'action': 'focus_mode'},
      ];
    } else {
      response = 'I understand. I\'m here to help you stay organized and productive. I can:\n\n- Manage your calendar and schedule meetings\n- Create and prioritize tasks\n- Take notes and extract action items\n- Summarize emails and meetings\n- Set smart reminders\n- Generate productivity plans\n\nWhat would you like to work on?';
      actions = [
        {'label': 'Schedule', 'action': 'schedule'},
        {'label': 'Tasks', 'action': 'tasks'},
        {'label': 'Notes', 'action': 'notes'},
        {'label': 'Plan Day', 'action': 'plan_day'},
      ];
    }

    return AiMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: response,
      role: 'assistant',
      timestamp: DateTime.now(),
      suggestedActions: actions,
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(aiMessagesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.onPrimary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AURA',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'AI Assistant',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: AppColors.onBackground),
            onSelected: (value) {
              if (value == 'clear') {
                ref.read(aiMessagesProvider.notifier).state = [
                  AiMessageModel(
                    id: 'welcome',
                    content: 'Hello! I\'m AURA, your AI executive assistant. How can I help you today?',
                    role: 'assistant',
                    timestamp: DateTime.now(),
                    suggestedActions: [
                      {'label': 'Show my schedule', 'action': 'show_schedule'},
                      {'label': 'Create a task', 'action': 'create_task'},
                      {'label': 'Summarize emails', 'action': 'summarize_emails'},
                    ],
                  ),
                ];
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: 8),
                    Text('Clear Chat'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    SizedBox(width: 8),
                    Text('AI Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Typing Indicator
          if (_isTyping)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.onPrimary,
                      size: 16.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDot(0),
                        SizedBox(width: 4.w),
                        _buildDot(1),
                        SizedBox(width: 4.w),
                        _buildDot(2),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Input Area
          Container(
            padding: EdgeInsets.all(16.w),
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
            child: SafeArea(
              child: Row(
                children: [
                  // Voice Button
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.mic_rounded,
                        color: AppColors.primary,
                        size: 22.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Text Field
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask AURA anything...',
                        filled: true,
                        fillColor: AppColors.surfaceVariant,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _messageController.text.isNotEmpty
                            ? IconButton(
                                onPressed: _messageController.clear,
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 18.sp,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              )
                            : null,
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Send Button
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(
                        Icons.send_rounded,
                        color: AppColors.onPrimary,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: AppColors.onSurfaceVariant.withOpacity(
              0.3 + (value * 0.7 * (index == 0 ? 1.0 : index == 1 ? 0.6 : 0.3)),
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(AiMessageModel message) {
    final isUser = message.role == 'user';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.onPrimary,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 8.w),
          ],

          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                      bottomLeft: Radius.circular(isUser ? 20.r : 4.r),
                      bottomRight: Radius.circular(isUser ? 4.r : 20.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isUser ? AppColors.onPrimary : AppColors.onBackground,
                      height: 1.5,
                    ),
                  ),
                ),

                // Suggested Actions
                if (message.suggestedActions != null && message.suggestedActions!.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 8.h),
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: message.suggestedActions!.map((action) {
                        return ActionChip(
                          label: Text(
                            action['label'] ?? '',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: AppColors.primaryContainer,
                          side: BorderSide.none,
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          onPressed: () {
                            _messageController.text = action['label'] ?? '';
                          },
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),

          if (isUser) ...[
            SizedBox(width: 8.w),
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  'JD',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}