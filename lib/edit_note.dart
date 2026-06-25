// claude designable code

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'note_service.dart';
import 'note_model.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;
  final int index;

  const EditNoteScreen({Key? key, required this.note, required this.index})
    : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  late String _selectedPriority;
  late String _selectedCategory;
  DateTime? _selectedDateTime;
  late bool _isCompleted;
  late bool _hasReminder;

  final NoteService _noteService = NoteService();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // ── Design Constants ──────────────────────────────────────────────────────
  static const _bg = Color(0xFF0D1117);
  static const _surface = Color(0xFF161B22);
  static const _border = Color(0xFF30363D);
  static const _teal = Color(0xFF2DD4BF);
  static const _amber = Color(0xFFFBBF24);
  static const _coral = Color(0xFFF87171);
  static const _violet = Color(0xFFA78BFA);
  static const _textPrimary = Color(0xFFE6EDF3);
  static const _textMuted = Color(0xFF8B949E);

  final Map<String, Color> _priorityColors = {
    "High": _coral,
    "Medium": _amber,
    "Low": _teal,
  };

  final Map<String, IconData> _categoryIcons = {
    "Work": Icons.work_outline_rounded,
    "Study": Icons.school_outlined,
    "Personal": Icons.person_outline_rounded,
    "Shopping": Icons.shopping_bag_outlined,
    "Fitness": Icons.fitness_center_rounded,
  };

  final Map<String, Color> _categoryColors = {
    "Work": Color(0xFF60A5FA),
    "Study": Color(0xFFA78BFA),
    "Personal": Color(0xFF2DD4BF),
    "Shopping": Color(0xFFF472B6),
    "Fitness": Color(0xFF34D399),
  };

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.note.title);
    _descController = TextEditingController(text: widget.note.description);
    _selectedPriority = widget.note.priority;
    _selectedCategory = widget.note.category;
    _selectedDateTime = widget.note.dueDate;
    _isCompleted = widget.note.isCompleted;
    _hasReminder = widget.note.hasReminder;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _teal,
            onPrimary: Colors.black,
            surface: _surface,
            onSurface: _textPrimary,
          ),
          dialogBackgroundColor: Color(0xFF1C2128),
        ),
        child: child!,
      ),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _selectedDateTime ?? DateTime.now(),
        ),
        builder: (context, child) => Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _teal,
              onPrimary: Colors.black,
              surface: _surface,
              onSurface: _textPrimary,
            ),
            dialogBackgroundColor: Color(0xFF1C2128),
          ),
          child: child!,
        ),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _updateNote() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Text(
                "All fields are required",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: _coral,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    await _noteService.updateNote(
      widget.index,
      Note(
        title: _titleController.text,
        description: _descController.text,
        priority: _selectedPriority,
        category: _selectedCategory,
        dueDate: _selectedDateTime,
        isCompleted: _isCompleted,
        hasReminder: _hasReminder,
        createdAt: widget.note.createdAt,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: _bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            // ── Collapsing Header ───────────────────────────────────────────
            SliverAppBar(
              backgroundColor: _bg,
              expandedHeight: 130,
              pinned: true,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _border),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: _textPrimary,
                      size: 16,
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: _violet.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _violet.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.edit_rounded, color: _violet, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'Editing',
                          style: TextStyle(
                            color: _violet,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                title: const Text(
                  'Edit Task',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                background: Stack(
                  children: [
                    Container(color: _bg),
                    Positioned(
                      top: -20,
                      right: 20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              _violet.withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 70,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              _teal.withOpacity(0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Body ────────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: 'TASK DETAILS'),
                    const SizedBox(height: 10),
                    _GlassCard(
                      child: Column(
                        children: [
                          TextField(
                            controller: _titleController,
                            style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Task title...',
                              hintStyle: TextStyle(
                                color: _textMuted.withOpacity(0.6),
                                fontSize: 16,
                              ),
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: _teal.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.title_rounded,
                                  color: _teal,
                                  size: 18,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: _teal,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          Divider(color: _border, height: 1),
                          // Description
                          TextField(
                            controller: _descController,
                            maxLines: 5,
                            style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 14,
                              height: 1.6,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Describe your task...',
                              hintStyle: TextStyle(
                                color: _textMuted.withOpacity(0.6),
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 12,
                                  top: 14,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    color: _amber.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.notes_rounded,
                                    color: _amber,
                                    size: 18,
                                  ),
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                maxWidth: 52,
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: _amber,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Priority ────────────────────────────────────────────
                    _SectionLabel(label: 'PRIORITY'),
                    const SizedBox(height: 10),
                    Row(
                      children: ["High", "Medium", "Low"].map((p) {
                        final selected = _selectedPriority == p;
                        final color = _priorityColors[p]!;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedPriority = p),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: EdgeInsets.only(
                                right: p != "Low" ? 10 : 0,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: selected
                                    ? color.withOpacity(0.15)
                                    : _surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: selected ? color : _border,
                                  width: selected ? 1.5 : 1,
                                ),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: color.withOpacity(0.25),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    p == "High"
                                        ? Icons.keyboard_double_arrow_up_rounded
                                        : p == "Medium"
                                        ? Icons.drag_handle_rounded
                                        : Icons
                                              .keyboard_double_arrow_down_rounded,
                                    color: selected ? color : _textMuted,
                                    size: 22,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    p,
                                    style: TextStyle(
                                      color: selected ? color : _textMuted,
                                      fontSize: 13,
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // ── Category ────────────────────────────────────────────
                    _SectionLabel(label: 'CATEGORY'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 86,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            [
                              "Work",
                              "Study",
                              "Personal",
                              "Shopping",
                              "Fitness",
                            ].map((cat) {
                              final selected = _selectedCategory == cat;
                              final color = _categoryColors[cat]!;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedCategory = cat),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? color.withOpacity(0.15)
                                        : _surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: selected ? color : _border,
                                      width: selected ? 1.5 : 1,
                                    ),
                                    boxShadow: selected
                                        ? [
                                            BoxShadow(
                                              color: color.withOpacity(0.2),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _categoryIcons[cat],
                                        color: selected ? color : _textMuted,
                                        size: 24,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        cat,
                                        style: TextStyle(
                                          color: selected ? color : _textMuted,
                                          fontSize: 12,
                                          fontWeight: selected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Due Date ────────────────────────────────────────────
                    _SectionLabel(label: 'DUE DATE & TIME'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickDateTime,
                      child: _GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF60A5FA,
                                  ).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Color(0xFF60A5FA),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedDateTime == null
                                          ? 'Select Due Date & Time'
                                          : 'Due Date Set',
                                      style: TextStyle(
                                        color: _selectedDateTime == null
                                            ? _textMuted
                                            : _textPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (_selectedDateTime != null) ...[
                                      const SizedBox(height: 3),
                                      Text(
                                        '${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year}  '
                                        '${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}',
                                        style: const TextStyle(
                                          color: Color(0xFF60A5FA),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(
                                _selectedDateTime == null
                                    ? Icons.add_circle_outline_rounded
                                    : Icons.check_circle_rounded,
                                color: _selectedDateTime == null
                                    ? _textMuted
                                    : const Color(0xFF34D399),
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Status & Reminder ───────────────────────────────────
                    _SectionLabel(label: 'STATUS & REMINDER'),
                    const SizedBox(height: 10),

                    // Completed toggle
                    _GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF34D399,
                                ).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.check_circle_outline_rounded,
                                color: Color(0xFF34D399),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mark as Completed',
                                    style: TextStyle(
                                      color: _textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Toggle task completion status',
                                    style: TextStyle(
                                      color: _textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              value: _isCompleted,
                              onChanged: (v) =>
                                  setState(() => _isCompleted = v),
                              activeColor: const Color(0xFF34D399),
                              activeTrackColor: const Color(
                                0xFF34D399,
                              ).withOpacity(0.3),
                              inactiveThumbColor: _textMuted,
                              inactiveTrackColor: _border,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Reminder toggle
                    _GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF472B6,
                                ).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.notifications_active_outlined,
                                color: Color(0xFFF472B6),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Enable Reminder',
                                    style: TextStyle(
                                      color: _textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Get notified before due date',
                                    style: TextStyle(
                                      color: _textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              value: _hasReminder,
                              onChanged: (v) =>
                                  setState(() => _hasReminder = v),
                              activeColor: const Color(0xFFF472B6),
                              activeTrackColor: const Color(
                                0xFFF472B6,
                              ).withOpacity(0.3),
                              inactiveThumbColor: _textMuted,
                              inactiveTrackColor: _border,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Floating Update Button ───────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: _bg,
          border: Border(top: BorderSide(color: _border, width: 0.5)),
        ),
        child: GestureDetector(
          onTap: _updateNote,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFA78BFA), Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA78BFA).withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save_rounded, color: Colors.white, size: 22),
                SizedBox(width: 10),
                Text(
                  'Update Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable Widgets ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFA78BFA), Color(0xFF7C3AED)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8B949E),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF30363D), width: 1),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: child),
    );
  }
}

// old gpt code

// import 'package:flutter/material.dart';
// import 'note_service.dart';
// import 'note_model.dart';

// class EditNoteScreen extends StatefulWidget {
//   final Note note;
//   final int index;

//   const EditNoteScreen({Key? key, required this.note, required this.index})
//     : super(key: key);

//   @override
//   State<EditNoteScreen> createState() => _EditNoteScreenState();
// }

// class _EditNoteScreenState extends State<EditNoteScreen> {
//   late TextEditingController _titleController;
//   late TextEditingController _descController;

//   late String _selectedPriority;
//   late String _selectedCategory;
//   DateTime? _selectedDateTime;
//   late bool _isCompleted;
//   late bool _hasReminder;

//   final NoteService _noteService = NoteService();

//   @override
//   void initState() {
//     super.initState();

//     _titleController = TextEditingController(text: widget.note.title);
//     _descController = TextEditingController(text: widget.note.description);

//     _selectedPriority = widget.note.priority;
//     _selectedCategory = widget.note.category;
//     _selectedDateTime = widget.note.dueDate;
//     _isCompleted = widget.note.isCompleted;
//     _hasReminder = widget.note.hasReminder;
//   }

//   Future<void> _pickDateTime() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: _selectedDateTime ?? DateTime.now(),
//       firstDate: DateTime(2023),
//       lastDate: DateTime(2100),
//     );

//     if (date != null) {
//       final time = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.fromDateTime(
//           _selectedDateTime ?? DateTime.now(),
//         ),
//       );

//       if (time != null) {
//         setState(() {
//           _selectedDateTime = DateTime(
//             date.year,
//             date.month,
//             date.day,
//             time.hour,
//             time.minute,
//           );
//         });
//       }
//     }
//   }

//   Future<void> _updateNote() async {
//     if (_titleController.text.isEmpty || _descController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("All fields are required")));
//       return;
//     }

//     await _noteService.updateNote(
//       widget.index,
//       Note(
//         title: _titleController.text,
//         description: _descController.text,
//         priority: _selectedPriority,
//         category: _selectedCategory,
//         dueDate: _selectedDateTime,
//         isCompleted: _isCompleted,
//         hasReminder: _hasReminder,
//         createdAt: widget.note.createdAt, // original time preserved
//       ),
//     );

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Task"), centerTitle: true),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             /// Title
//             TextField(
//               controller: _titleController,
//               decoration: const InputDecoration(
//                 labelText: "Title",
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 16),

//             /// Description
//             TextField(
//               controller: _descController,
//               maxLines: 4,
//               decoration: const InputDecoration(
//                 labelText: "Description",
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 16),

//             /// Priority
//             DropdownButtonFormField<String>(
//               value: _selectedPriority,
//               decoration: const InputDecoration(
//                 labelText: "Priority",
//                 border: OutlineInputBorder(),
//               ),
//               items: ["High", "Medium", "Low"]
//                   .map(
//                     (priority) => DropdownMenuItem(
//                       value: priority,
//                       child: Text(priority),
//                     ),
//                   )
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedPriority = value!;
//                 });
//               },
//             ),

//             const SizedBox(height: 16),

//             /// Category
//             DropdownButtonFormField<String>(
//               value: _selectedCategory,
//               decoration: const InputDecoration(
//                 labelText: "Category",
//                 border: OutlineInputBorder(),
//               ),
//               items: ["Work", "Study", "Personal", "Shopping", "Fitness"]
//                   .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedCategory = value!;
//                 });
//               },
//             ),

//             const SizedBox(height: 16),

//             /// Due Date Picker
//             ElevatedButton.icon(
//               onPressed: _pickDateTime,
//               icon: const Icon(Icons.calendar_today),
//               label: Text(
//                 _selectedDateTime == null
//                     ? "Select Due Date & Time"
//                     : _selectedDateTime.toString(),
//               ),
//             ),

//             const SizedBox(height: 16),

//             /// Completed Switch
//             SwitchListTile(
//               title: const Text("Mark as Completed"),
//               value: _isCompleted,
//               onChanged: (value) {
//                 setState(() {
//                   _isCompleted = value;
//                 });
//               },
//             ),

//             /// Reminder Switch
//             SwitchListTile(
//               title: const Text("Enable Reminder"),
//               value: _hasReminder,
//               onChanged: (value) {
//                 setState(() {
//                   _hasReminder = value;
//                 });
//               },
//             ),

//             const SizedBox(height: 24),

//             /// Update Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _updateNote,
//                 child: const Text("Update Task"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
