import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../data/sample_data.dart';
import '../../models/models.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late List<Task> _pending;
  late List<Task> _completed;

  @override
  void initState() {
    super.initState();
    _pending = List.from(SampleData.pendingTasks);
    _completed = List.from(SampleData.completedTasks);
  }

  void _toggleTask(int index) {
    setState(() {
      final task = _pending.removeAt(index);
      task.isCompleted = true;
      _completed.insert(0, task);
    });
  }

  void _deleteTask(int index) {
    setState(() => _pending.removeAt(index));
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add New Task', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: 'Task title'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: subtitleController,
              decoration: InputDecoration(hintText: 'Details (optional)'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    setState(() {
                      _pending.add(Task(
                        title: titleController.text.trim(),
                        subtitle: subtitleController.text.trim(),
                      ));
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Add Task', style: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date + Title
              Text('Thursday, Oct 24',
                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text('Daily Notes',
                  style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: -0.5)),
              const SizedBox(height: 20),

              // Stats Row
              _buildStatsRow(),
              const SizedBox(height: 28),

              // Pending Section
              _buildSectionHeader('Pending', badge: '${_pending.length} Items'),
              const SizedBox(height: 12),
              ..._pending.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildPendingTile(e.key, e.value),
                  )),
              const SizedBox(height: 32),

              // Completed Section
              Opacity(
                opacity: 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Completed'),
                    const SizedBox(height: 12),
                    ..._completed.map((task) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildCompletedTile(task),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),

        // FAB
        Positioned(
          right: 20,
          bottom: 16,
          child: GestureDetector(
            onTap: _showAddTaskDialog,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.assignment_turned_in, color: AppColors.secondary, size: 28),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_pending.length.toString().padLeft(2, '0'),
                        style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    Text('TASKS PENDING',
                        style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 1.5)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 5,
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.check_circle, color: AppColors.onSecondaryContainer, size: 28),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_completed.length.toString().padLeft(2, '0'),
                        style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.onSecondaryContainer)),
                    Text('COMPLETED',
                        style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSecondaryContainer.withValues(alpha: 0.8),
                            letterSpacing: 1.5)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {String? badge}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(badge, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.primary)),
          ),
      ],
    );
  }

  Widget _buildPendingTile(int index, Task task) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggleTask(index),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.outlineVariant, width: 2),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: AppColors.onSurface, fontSize: 15)),
                if (task.subtitle.isNotEmpty)
                  Text(task.subtitle, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _deleteTask(index),
            child: Icon(Icons.delete_outline, color: AppColors.onSurfaceVariant.withValues(alpha: 0.4), size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTile(Task task) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              task.title,
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
                decoration: TextDecoration.lineThrough,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
