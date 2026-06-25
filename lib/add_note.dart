// claude designable code

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'note_service.dart';
import 'note_model.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final NoteService _noteService = NoteService();

  String _selectedPriority = "Medium";
  String _selectedCategory = "Work";
  DateTime? _selectedDateTime;
  bool _hasReminder = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // Design constants
  static const _bg = Color(0xFF0D1117);
  static const _surface = Color(0xFF161B22);
  static const _surfaceAlt = Color(0xFF1C2128);
  static const _border = Color(0xFF30363D);
  static const _teal = Color(0xFF2DD4BF);
  static const _amber = Color(0xFFFBBF24);
  static const _coral = Color(0xFFF87171);
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
      initialDate: DateTime.now(),
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
          dialogBackgroundColor: _surfaceAlt,
        ),
        child: child!,
      ),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) => Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _teal,
              onPrimary: Colors.black,
              surface: _surface,
              onSurface: _textPrimary,
            ),
            dialogBackgroundColor: _surfaceAlt,
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

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;
    final newNote = Note(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      priority: _selectedPriority,
      category: _selectedCategory,
      dueDate: _selectedDateTime,
      isCompleted: false,
      createdAt: DateTime.now(),
      hasReminder: _hasReminder,
    );
    await _noteService.addNote(newNote);
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
            // Custom SliverAppBar
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
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                title: const Text(
                  'New Task',
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
                              _teal.withOpacity(0.18),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 60,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              _amber.withOpacity(0.15),
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

            SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── TITLE & DESCRIPTION CARD ──────────────────────────
                      _SectionLabel(label: 'TASK DETAILS'),
                      const SizedBox(height: 10),
                      _GlassCard(
                        child: Column(
                          children: [
                            // Title field
                            TextFormField(
                              controller: _titleController,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? "Enter title" : null,
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
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: _coral,
                                    width: 1.5,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: _coral,
                                    width: 1.5,
                                  ),
                                ),
                                errorStyle: const TextStyle(color: _coral),
                              ),
                            ),
                            Divider(color: _border, height: 1),
                            // Description field
                            TextFormField(
                              controller: _descController,
                              maxLines: 5,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 14,
                                height: 1.6,
                              ),
                              validator: (v) => v == null || v.isEmpty
                                  ? "Enter description"
                                  : null,
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
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: _coral,
                                    width: 1.5,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: _coral,
                                    width: 1.5,
                                  ),
                                ),
                                errorStyle: const TextStyle(color: _coral),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── PRIORITY ──────────────────────────────────────────
                      _SectionLabel(label: 'PRIORITY'),
                      const SizedBox(height: 10),
                      Row(
                        children: ["High", "Medium", "Low"].map((p) {
                          final selected = _selectedPriority == p;
                          final color = _priorityColors[p]!;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedPriority = p),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: EdgeInsets.only(
                                  right: p != "Low" ? 10 : 0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
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
                                          ? Icons
                                                .keyboard_double_arrow_up_rounded
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

                      // ── CATEGORY ──────────────────────────────────────────
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            color: selected
                                                ? color
                                                : _textMuted,
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

                      // ── DUE DATE ──────────────────────────────────────────
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          '${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year}  ${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}',
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

                      // ── REMINDER ──────────────────────────────────────────
                      _SectionLabel(label: 'REMINDER'),
                      const SizedBox(height: 10),
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
            ),
          ],
        ),
      ),

      // ── FLOATING SAVE BUTTON ─────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: _bg,
          border: Border(top: BorderSide(color: _border, width: 0.5)),
        ),
        child: GestureDetector(
          onTap: _saveNote,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2DD4BF), Color(0xFF0EA5E9)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2DD4BF).withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_rounded, color: Colors.white, size: 22),
                SizedBox(width: 10),
                Text(
                  'Save Task',
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

// ── REUSABLE WIDGETS ──────────────────────────────────────────────────────────

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
              colors: [Color(0xFF2DD4BF), Color(0xFF0EA5E9)],
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

// class AddNoteScreen extends StatefulWidget {
//   const AddNoteScreen({Key? key}) : super(key: key);

//   @override
//   State<AddNoteScreen> createState() => _AddNoteScreenState();
// }

// class _AddNoteScreenState extends State<AddNoteScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descController = TextEditingController();
//   final NoteService _noteService = NoteService();

//   String _selectedPriority = "Medium";
//   String _selectedCategory = "Work";
//   DateTime? _selectedDateTime;
//   bool _hasReminder = false;

//   Future<void> _pickDateTime() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2023),
//       lastDate: DateTime(2100),
//     );

//     if (date != null) {
//       final time = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
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

//   Future<void> _saveNote() async {
//     if (!_formKey.currentState!.validate()) return;

//     final newNote = Note(
//       title: _titleController.text.trim(),
//       description: _descController.text.trim(),
//       priority: _selectedPriority,
//       category: _selectedCategory,
//       dueDate: _selectedDateTime,
//       isCompleted: false,
//       createdAt: DateTime.now(),
//       hasReminder: _hasReminder,
//     );

//     await _noteService.addNote(newNote);

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Task"), centerTitle: true),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               /// TITLE
//               TextFormField(
//                 controller: _titleController,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "Enter title" : null,
//                 decoration: const InputDecoration(
//                   labelText: "Title",
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               /// DESCRIPTION
//               TextFormField(
//                 controller: _descController,
//                 maxLines: 4,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "Enter description" : null,
//                 decoration: const InputDecoration(
//                   labelText: "Description",
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               /// PRIORITY
//               DropdownButtonFormField<String>(
//                 value: _selectedPriority,
//                 decoration: const InputDecoration(
//                   labelText: "Priority",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: ["High", "Medium", "Low"]
//                     .map(
//                       (priority) => DropdownMenuItem(
//                         value: priority,
//                         child: Text(priority),
//                       ),
//                     )
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedPriority = value!;
//                   });
//                 },
//               ),

//               const SizedBox(height: 16),

//               /// CATEGORY
//               DropdownButtonFormField<String>(
//                 value: _selectedCategory,
//                 decoration: const InputDecoration(
//                   labelText: "Category",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: ["Work", "Study", "Personal", "Shopping", "Fitness"]
//                     .map(
//                       (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
//                     )
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedCategory = value!;
//                   });
//                 },
//               ),

//               const SizedBox(height: 16),

//               /// DATE PICKER
//               ElevatedButton.icon(
//                 onPressed: _pickDateTime,
//                 icon: const Icon(Icons.calendar_today),
//                 label: Text(
//                   _selectedDateTime == null
//                       ? "Select Due Date & Time"
//                       : "${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year}",
//                 ),
//               ),

//               const SizedBox(height: 12),

//               /// REMINDER SWITCH
//               SwitchListTile(
//                 title: const Text("Enable Reminder"),
//                 value: _hasReminder,
//                 onChanged: (value) {
//                   setState(() {
//                     _hasReminder = value;
//                   });
//                 },
//               ),

//               const SizedBox(height: 24),

//               /// SAVE BUTTON
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _saveNote,
//                   child: const Text("Save Task"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

