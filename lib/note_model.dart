import 'package:hive/hive.dart';

// Hive adapter generate hogi ye file (tells hive which filed is saved on which index)
part 'note_model.g.dart';

// creating database schema for hive
// it explains hive how to store format of notes data

// type id is unique id for every model i create
@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String priority;

  @HiveField(3)
  String category;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  bool isCompleted;

  // 6 → Creation time (important for sorting)
  @HiveField(6)
  DateTime createdAt;

  // 7 → Reminder enabled or not
  @HiveField(7)
  bool hasReminder;

  Note({
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    this.dueDate,
    this.isCompleted = false,
    required this.createdAt,
    this.hasReminder = false,
  });
}
