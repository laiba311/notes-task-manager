import 'package:hive/hive.dart';
import 'note_model.dart';

class NoteService {
  final Box<Note> _box = Hive.box<Note>('notesBox');

  Future<void> addNote(Note note) async {
    await _box.add(note);
  }

  List<Note> getNotes() {
    return _box.values.toList();
  }

  Future<void> updateNote(int index, Note updatedNote) async {
    await _box.putAt(index, updatedNote);
  }

  Future<void> deleteNote(int index) async {
    await _box.deleteAt(index);
  }

  Future<void> toggleComplete(int index) async {
    final note = _box.getAt(index);
    if (note != null) {
      note.isCompleted = !note.isCompleted;
      await note.save();
    }
  }

  List<Note> getCompletedNotes() {
    return _box.values.where((note) => note.isCompleted).toList();
  }

  List<Note> getPendingNotes() {
    return _box.values.where((note) => !note.isCompleted).toList();
  }

  List<Note> getNotesByPriority(String priority) {
    return _box.values.where((note) => note.priority == priority).toList();
  }

  List<Note> getNotesByCategory(String category) {
    return _box.values.where((note) => note.category == category).toList();
  }

  List<Note> getNotesByDate(DateTime date) {
    return _box.values.where((note) {
      return note.dueDate != null &&
          note.dueDate!.year == date.year &&
          note.dueDate!.month == date.month &&
          note.dueDate!.day == date.day;
    }).toList();
  }

  List<Note> sortByDueDate() {
    final notes = _box.values.toList();
    notes.sort((a, b) {
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return notes;
  }

  List<Note> sortByPriority() {
    final notes = _box.values.toList();

    notes.sort((a, b) {
      const priorityOrder = {'High': 1, 'Medium': 2, 'Low': 3};

      return (priorityOrder[a.priority] ?? 4).compareTo(
        priorityOrder[b.priority] ?? 4,
      );
    });

    return notes;
  }
}
