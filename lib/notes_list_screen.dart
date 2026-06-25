// claude

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_database_app/add_note.dart';
import 'package:notes_database_app/edit_note.dart';
import 'note_service.dart';
import 'note_model.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({Key? key}) : super(key: key);

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen>
    with SingleTickerProviderStateMixin {
  final NoteService _noteService = NoteService();
  List<Note> _notes = [];

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // ── Design Constants ──────────────────────────────────────────────────────
  static const _bg = Color(0xFF0D1117);
  static const _surface = Color(0xFF161B22);
  static const _surfaceAlt = Color(0xFF1C2128);
  static const _border = Color(0xFF30363D);
  static const _teal = Color(0xFF2DD4BF);
  static const _amber = Color(0xFFFBBF24);
  static const _coral = Color(0xFFF87171);
  static const _violet = Color(0xFFA78BFA);
  static const _blue = Color(0xFF60A5FA);
  static const _green = Color(0xFF34D399);
  static const _pink = Color(0xFFF472B6);
  static const _textPrimary = Color(0xFFE6EDF3);
  static const _textMuted = Color(0xFF8B949E);

  final Map<String, Color> _priorityColors = {
    "High": _coral,
    "Medium": _amber,
    "Low": _teal,
  };

  final Map<String, IconData> _priorityIcons = {
    "High": Icons.keyboard_double_arrow_up_rounded,
    "Medium": Icons.drag_handle_rounded,
    "Low": Icons.keyboard_double_arrow_down_rounded,
  };

  final Map<String, Color> _categoryColors = {
    "Work": Color(0xFF60A5FA),
    "Study": Color(0xFFA78BFA),
    "Personal": Color(0xFF2DD4BF),
    "Shopping": Color(0xFFF472B6),
    "Fitness": Color(0xFF34D399),
  };

  final Map<String, IconData> _categoryIcons = {
    "Work": Icons.work_outline_rounded,
    "Study": Icons.school_outlined,
    "Personal": Icons.person_outline_rounded,
    "Shopping": Icons.shopping_bag_outlined,
    "Fitness": Icons.fitness_center_rounded,
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _loadNotes();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _loadNotes() {
    setState(() {
      _notes = _noteService.getNotes();
    });
  }

  void _deleteNote(int index) async {
    await _noteService.deleteNote(index);
    _loadNotes();
  }

  Future<void> _toggleComplete(int index) async {
    await _noteService.toggleComplete(index);
    _loadNotes();
  }

  Color _priorityColor(String priority) {
    return _priorityColors[priority] ?? _textMuted;
  }

  // ── Stats ─────────────────────────────────────────────────────────────────
  int get _totalNotes => _notes.length;
  int get _completedNotes => _notes.where((n) => n.isCompleted).length;
  int get _highPriority => _notes.where((n) => n.priority == 'High').length;

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
            // ── Collapsing Header ─────────────────────────────────────────
            SliverAppBar(
              backgroundColor: _bg,
              expandedHeight: 220,
              pinned: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  children: [
                    Container(color: _bg),
                    // Ambient glows
                    Positioned(
                      top: -30,
                      right: -20,
                      child: Container(
                        width: 180,
                        height: 180,
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
                      top: 20,
                      left: -40,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              _violet.withOpacity(0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Header content
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.07),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _green,
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      const Text(
                                        'My Notes',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.07),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.sort_rounded,
                                    color: Colors.white60,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Your Tasks',
                              style: TextStyle(
                                color: _textPrimary,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Stats row
                            Row(
                              children: [
                                _MiniStat(
                                  value: '$_totalNotes',
                                  label: 'Total',
                                  color: _blue,
                                ),
                                const SizedBox(width: 10),
                                _MiniStat(
                                  value: '$_completedNotes',
                                  label: 'Done',
                                  color: _green,
                                ),
                                const SizedBox(width: 10),
                                _MiniStat(
                                  value: '$_highPriority',
                                  label: 'Urgent',
                                  color: _coral,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Pinned title when collapsed
              title: const Text(
                'My Tasks',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // ── Empty State ───────────────────────────────────────────────
            if (_notes.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: _surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: _border),
                        ),
                        child: const Icon(
                          Icons.notes_rounded,
                          color: _textMuted,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No Tasks Yet',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap + to create your first task',
                        style: TextStyle(color: _textMuted, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Notes List ────────────────────────────────────────────────
            if (_notes.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final note = _notes[index];
                    return _NoteCard(
                      note: note,
                      index: index,
                      priorityColor: _priorityColor(note.priority),
                      priorityIcon:
                          _priorityIcons[note.priority] ??
                          Icons.drag_handle_rounded,
                      categoryColor:
                          _categoryColors[note.category] ?? _textMuted,
                      categoryIcon:
                          _categoryIcons[note.category] ??
                          Icons.label_outline_rounded,
                      onToggle: () => _toggleComplete(index),
                      onEdit: () async {
                        await Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, animation, __) =>
                                EditNoteScreen(note: note, index: index),
                            transitionsBuilder: (_, animation, __, child) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                          ),
                        );
                        _loadNotes();
                      },
                      onDelete: () => _deleteNote(index),
                    );
                  }, childCount: _notes.length),
                ),
              ),
          ],
        ),
      ),

      // ── FAB ───────────────────────────────────────────────────────────────
      floatingActionButton: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, animation, __) => const AddNoteScreen(),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
          _loadNotes();
        },
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_teal, Color(0xFF0EA5E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: _teal.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

// ── Note Card ─────────────────────────────────────────────────────────────────
class _NoteCard extends StatelessWidget {
  final Note note;
  final int index;
  final Color priorityColor;
  final IconData priorityIcon;
  final Color categoryColor;
  final IconData categoryIcon;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _NoteCard({
    required this.note,
    required this.index,
    required this.priorityColor,
    required this.priorityIcon,
    required this.categoryColor,
    required this.categoryIcon,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  static const _surface = Color(0xFF161B22);
  static const _border = Color(0xFF30363D);
  static const _textPrimary = Color(0xFFE6EDF3);
  static const _textMuted = Color(0xFF8B949E);
  static const _green = Color(0xFF34D399);

  @override
  Widget build(BuildContext context) {
    final isCompleted = note.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCompleted ? _green.withOpacity(0.35) : _border,
          width: 1,
        ),
        boxShadow: isCompleted
            ? [
                BoxShadow(
                  color: _green.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          // ── Priority accent bar ─────────────────────────────────────────
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  priorityColor.withOpacity(0.8),
                  priorityColor.withOpacity(0.2),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: category + priority badge + switch ──────────
                Row(
                  children: [
                    // Category chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: categoryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(categoryIcon, color: categoryColor, size: 12),
                          const SizedBox(width: 5),
                          Text(
                            note.category,
                            style: TextStyle(
                              color: categoryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Priority badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: priorityColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(priorityIcon, color: priorityColor, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            note.priority,
                            style: TextStyle(
                              color: priorityColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Completion switch
                    Transform.scale(
                      scale: 0.8,
                      child: Switch.adaptive(
                        value: note.isCompleted,
                        onChanged: (_) => onToggle(),
                        activeColor: _green,
                        activeTrackColor: _green.withOpacity(0.25),
                        inactiveThumbColor: _textMuted,
                        inactiveTrackColor: _border,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Title ─────────────────────────────────────────────────
                Text(
                  note.title,
                  style: TextStyle(
                    color: isCompleted ? _textMuted : _textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    decorationColor: _textMuted,
                  ),
                ),

                const SizedBox(height: 6),

                // ── Description ───────────────────────────────────────────
                Text(
                  note.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isCompleted
                        ? _textMuted.withOpacity(0.6)
                        : _textMuted,
                    fontSize: 13,
                    height: 1.5,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    decorationColor: _textMuted,
                  ),
                ),

                const SizedBox(height: 14),

                // ── Bottom row: due date + actions ────────────────────────
                Row(
                  children: [
                    // Due date
                    if (note.dueDate != null) ...[
                      Icon(
                        Icons.calendar_today_rounded,
                        color: _textMuted,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${note.dueDate!.day}/${note.dueDate!.month}/${note.dueDate!.year}',
                        style: const TextStyle(
                          color: _textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    // Reminder indicator
                    if (note.hasReminder) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF472B6).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFF472B6).withOpacity(0.3),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.notifications_active_outlined,
                              color: Color(0xFFF472B6),
                              size: 11,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Reminder',
                              style: TextStyle(
                                color: Color(0xFFF472B6),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const Spacer(),
                    // Edit button
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFF60A5FA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF60A5FA).withOpacity(0.25),
                          ),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Color(0xFF60A5FA),
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Delete button
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF87171).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFF87171).withOpacity(0.25),
                          ),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFF87171),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mini Stat Widget ──────────────────────────────────────────────────────────
class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _MiniStat({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// old gpt code

// import 'package:flutter/material.dart';
// import 'package:notes_database_app/add_note.dart';
// import 'package:notes_database_app/edit_note.dart';
// import 'note_service.dart';
// import 'note_model.dart';

// class NotesListScreen extends StatefulWidget {
//   const NotesListScreen({Key? key}) : super(key: key);

//   @override
//   State<NotesListScreen> createState() => _NotesListScreenState();
// }

// class _NotesListScreenState extends State<NotesListScreen> {
//   final NoteService _noteService = NoteService();
//   List<Note> _notes = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadNotes();
//   }

//   void _loadNotes() {
//     setState(() {
//       _notes = _noteService.getNotes();
//     });
//   }

//   void _deleteNote(int index) async {
//     await _noteService.deleteNote(index);
//     _loadNotes();
//   }

//   Future<void> _toggleComplete(int index) async {
//     await _noteService.toggleComplete(index);
//     _loadNotes();
//   }

//   Color _priorityColor(String priority) {
//     switch (priority) {
//       case 'High':
//         return Colors.red;
//       case 'Medium':
//         return Colors.orange;
//       case 'Low':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("My Notes"), centerTitle: true),
//       body: _notes.isEmpty
//           ? const Center(
//               child: Text("No Notes Yet", style: TextStyle(fontSize: 18)),
//             )
//           : ListView.builder(
//               itemCount: _notes.length,
//               itemBuilder: (context, index) {
//                 final note = _notes[index];

//                 return Card(
//                   color: note.isCompleted
//                       ? Colors.green.shade100
//                       : Colors.white,
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   elevation: 3,
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(12),

//                     title: Text(
//                       note.title,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         decoration: note.isCompleted
//                             ? TextDecoration.lineThrough
//                             : null,
//                         color: note.isCompleted ? Colors.grey : Colors.black,
//                       ),
//                     ),

//                     // 🔹 SUBTITLE (Description + Date + Priority)
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 4),
//                         Text(
//                           note.description,
//                           style: TextStyle(
//                             decoration: note.isCompleted
//                                 ? TextDecoration.lineThrough
//                                 : null,
//                             color: note.isCompleted
//                                 ? Colors.grey
//                                 : Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 6),

//                         // 📅 Due Date
//                         if (note.dueDate != null)
//                           Text(
//                             "Due: ${note.dueDate!.day}/${note.dueDate!.month}/${note.dueDate!.year}",
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.blueGrey,
//                             ),
//                           ),

//                         const SizedBox(height: 4),

//                         Row(
//                           children: [
//                             const Text("Priority: "),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 2,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: _priorityColor(
//                                   note.priority,
//                                 ).withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 note.priority,
//                                 style: TextStyle(
//                                   color: _priorityColor(note.priority),
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),

//                     // 🔹 TRAILING ACTIONS
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Switch(
//                           value: note.isCompleted,
//                           onChanged: (value) {
//                             _toggleComplete(index);
//                           },
//                         ),

//                         // ✏ Edit
//                         IconButton(
//                           icon: const Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () async {
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     EditNoteScreen(note: note, index: index),
//                               ),
//                             );
//                             _loadNotes();
//                           },
//                         ),

//                         // 🗑 Delete
//                         IconButton(
//                           icon: const Icon(Icons.delete, color: Colors.red),
//                           onPressed: () {
//                             _deleteNote(index);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const AddNoteScreen()),
//           );
//           _loadNotes();
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
