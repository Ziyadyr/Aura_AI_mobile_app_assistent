import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/note_model.dart';
import '../../../../shared/providers/mock_data_provider.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesProvider);
    final filteredNotes = notes.where((n) =>
      n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      n.content.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    final favoriteNotes = filteredNotes.where((n) => n.isFavorite).toList();
    final regularNotes = filteredNotes.where((n) => !n.isFavorite).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Notes',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddNoteBottomSheet(context),
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
          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
              ),
            ),
          ),

          // Notes Grid
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Favorites Section
                if (favoriteNotes.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 18.sp,
                            color: AppColors.priorityMedium,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Favorites',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childCount: favoriteNotes.length,
                      itemBuilder: (context, index) {
                        return _buildNoteCard(favoriteNotes[index]);
                      },
                    ),
                  ),
                ],

                // All Notes Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 8.h),
                    child: Text(
                      'All Notes',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childCount: regularNotes.length,
                    itemBuilder: (context, index) {
                      return _buildNoteCard(regularNotes[index]);
                    },
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(height: 100.h),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(NoteModel note) {
    final cardColors = [
      const Color(0xFFFFF3E0),
      const Color(0xFFE3F2FD),
      const Color(0xFFE8F5E9),
      const Color(0xFFF3E5F5),
      const Color(0xFFE0F2F1),
      const Color(0xFFFCE4EC),
    ];

    final colorIndex = note.title.hashCode.abs() % cardColors.length;

    return GestureDetector(
      onTap: () => _showNoteDetailBottomSheet(context, note),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: cardColors[colorIndex],
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
                Expanded(
                  child: Text(
                    note.title,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (note.isFavorite)
                  Icon(
                    Icons.star_rounded,
                    size: 18.sp,
                    color: AppColors.priorityMedium,
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              note.content,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
            if (note.aiSummary != null) ...[
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 12.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        'AI Summary available',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 12.h),
            Row(
              children: [
                if (note.tags != null && note.tags!.isNotEmpty)
                  Expanded(
                    child: Wrap(
                      spacing: 4.w,
                      children: note.tags!.take(2).map((tag) =>
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            tag,
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                Text(
                  note.updatedAt != null
                      ? DateFormat('MMM d').format(note.updatedAt!)
                      : DateFormat('MMM d').format(note.createdAt ?? DateTime.now()),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNoteDetailBottomSheet(BuildContext context, NoteModel note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
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
                    Expanded(
                      child: Text(
                        note.title,
                        style: AppTypography.h5.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        final notes = ref.read(notesProvider);
                        final updatedNotes = notes.map((n) {
                          if (n.id == note.id) {
                            return n.copyWith(isFavorite: !n.isFavorite);
                          }
                          return n;
                        }).toList();
                        ref.read(notesProvider.notifier).state = updatedNotes;
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        note.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: note.isFavorite ? AppColors.priorityMedium : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // AI Summary Card
              if (note.aiSummary != null)
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
                        note.aiSummary!,
                        style: AppTypography.bodyMedium.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: EdgeInsets.all(20.w),
                  child: Text(
                    note.content,
                    style: AppTypography.bodyLarge.copyWith(
                      height: 1.6,
                    ),
                  ),
                ),
              ),

              // Action Bar
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
                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      onTap: () {},
                    ),
                    _buildActionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      onTap: () {},
                    ),
                    _buildActionButton(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                      onTap: () {
                        final notes = ref.read(notesProvider);
                        ref.read(notesProvider.notifier).state = 
                          notes.where((n) => n.id != note.id).toList();
                        Navigator.pop(context);
                      },
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            children: [
              Icon(icon, size: 22.sp, color: AppColors.onSurfaceVariant),
              SizedBox(height: 4.h),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddNoteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 24.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.w,
        ),
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
              'New Note',
              style: AppTypography.h5.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 24.h),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Note title',
                prefixIcon: Icon(Icons.title_rounded),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Start writing...',
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(16.w),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Save Note'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}