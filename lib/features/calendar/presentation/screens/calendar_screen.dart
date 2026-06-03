import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/providers/mock_data_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(calendarEventsProvider);
    final selectedEvents = _selectedDay != null
        ? events.where((e) => 
            e.startTime.year == _selectedDay!.year &&
            e.startTime.month == _selectedDay!.month &&
            e.startTime.day == _selectedDay!.day
          ).toList()
        : <dynamic>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Calendar',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
            icon: Icon(Icons.today_rounded, color: AppColors.primary),
          ),
          IconButton(
            onPressed: () => _showAddEventBottomSheet(context),
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
      body: Column(
        children: [
          // Calendar Widget
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: true,
                formatButtonDecoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                formatButtonTextStyle: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
                titleTextStyle: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.onBackground,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.onBackground,
                ),
              ),
              calendarStyle: CalendarStyle(
                cellPadding: EdgeInsets.zero,
                cellMargin: EdgeInsets.all(4.w),
                defaultTextStyle: AppTypography.bodyMedium,
                weekendTextStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
                selectedDecoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
                selectedTextStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
                outsideTextStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant.withOpacity(0.5),
                ),
                markerDecoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: AppTypography.labelSmall.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              eventLoader: (day) {
                return events.where((e) =>
                  e.startTime.year == day.year &&
                  e.startTime.month == day.month &&
                  e.startTime.day == day.day
                ).toList();
              },
            ),
          ),

          // Selected Day Events
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDay != null
                            ? DateFormat('EEEE, MMM d').format(_selectedDay!)
                            : 'Events',
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${selectedEvents.length} events',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: selectedEvents.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_available_outlined,
                                size: 48.sp,
                                color: AppColors.onSurfaceVariant.withOpacity(0.5),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'No events for this day',
                                style: AppTypography.bodyLarge.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextButton.icon(
                                onPressed: () => _showAddEventBottomSheet(context),
                                icon: const Icon(Icons.add),
                                label: const Text('Add Event'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          itemCount: selectedEvents.length,
                          itemBuilder: (context, index) {
                            return _buildEventCard(selectedEvents[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(dynamic event) {
    final categoryColors = {
      'Work': AppColors.primary,
      'Personal': AppColors.secondary,
      'Health': const Color(0xFFFF8A5C),
      'Meeting': AppColors.tertiary,
    };

    return Container(
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
          // Time Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat('h:mm').format(event.startTime),
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                width: 1.w,
                height: 20.h,
                color: AppColors.outline,
              ),
              SizedBox(height: 4.h),
              Text(
                DateFormat('h:mm a').format(event.endTime),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),

          // Category Indicator
          Container(
            width: 4.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: categoryColors[event.category] ?? AppColors.primary,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(width: 16.w),

          // Event Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                if (event.description != null)
                  Text(
                    event.description!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    if (event.location != null) ...[
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
                      ),
                    ],
                    if (event.attendees != null && event.attendees!.isNotEmpty) ...[
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.people_outline_rounded,
                        size: 14.sp,
                        color: AppColors.onSurfaceVariant,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${event.attendees!.length} attendees',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEventBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        padding: EdgeInsets.all(24.w),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
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
                'Add Event',
                style: AppTypography.h5.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 24.h),

              _buildBottomSheetField('Event Title', Icons.title_rounded),
              SizedBox(height: 16.h),
              _buildBottomSheetField('Description', Icons.description_outlined),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _buildBottomSheetField('Start Time', Icons.access_time_rounded),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildBottomSheetField('End Time', Icons.access_time_rounded),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildBottomSheetField('Location', Icons.location_on_outlined),
              SizedBox(height: 24.h),

              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'Create Event',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetField(String hint, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.onSurfaceVariant),
      ),
    );
  }
}