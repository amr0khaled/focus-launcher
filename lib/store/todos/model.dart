part of '../todos_pod.dart';

enum List { earlier, today, tomorrow, later, custom }

extension TaskListExtension on List {
  String fromList() {
    switch (this) {
      case List.earlier:
        return 'earlier';
      case List.today:
        return 'today';
      case List.tomorrow:
        return 'tomorrow';
      case List.later:
        return 'later';
      case List.custom:
        return 'custom';
    }
  }

  static List fromString(String value) {
    switch (value) {
      case 'earlier':
        return List.earlier;
      case 'today':
        return List.today;
      case 'tomorrow':
        return List.tomorrow;
      case 'later':
        return List.later;
      default:
        return List.custom;
    }
  }
}

const String table = 'todo';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDone = 'done';
const String columnDescription = 'description';
const String columnTaskList = 'task_list'; // table name of the task_list

class Todo extends ChangeNotifier {
  Todo(this.title,
      {this.id,
      this.description,
      this.done = false,
      this.taskList = List.today,
      DateTime? createdAt,
      DateTime? updatedAt}) {
    id ??= const UuidV4().toString();
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }
  String title;
  String? id;
  String? description;
  bool done;
  List taskList;
  String? listName;
  late DateTime createdAt;
  late DateTime updatedAt;

  factory Todo.fromMap(Map<String, Object?> map) {
    return Todo(
      map[columnTitle] as String,
      id: map[columnId] as String,
      done: map[columnDone] == 1,
      description: map[columnDescription] as String,
      taskList: TaskListExtension.fromString(map[columnTaskList] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
  Map<String, Object?> toMap() {
    return {
      columnId: id,
      columnTitle: title,
      columnTaskList: taskList.fromList(),
      columnDescription: description,
      columnDone: done ? 1 : 0,
      'list_name': listName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  void update({
    String? title,
    String? description,
    bool? done,
    List? taskList,
    String? listName,
  }) {
    this.title = title ?? this.title;
    this.description = description ?? this.description;
    this.done = done ?? this.done;
    switch (taskList) {
      case List.earlier:
        this.listName = 'Earlier';
        break;
      case List.today:
        this.listName = 'Today';
        break;
      case List.tomorrow:
        this.listName = 'tomorrow';
        break;
      default:
        this.taskList = List.custom;
        this.listName = listName;
    }
    updatedAt = DateTime.now();
    notifyListeners();
  }

  void checkListWithTime() {
    DateTime current = DateTime.now();
    if (taskList == List.custom || taskList == List.later) {
      return;
    }
    if (taskList == List.today) {
      if (createdAt.isBefore(current)) {
        taskList = List.earlier;
      }
      // Today -> tomorrow
      else if (createdAt.subtract(const Duration(days: 2)).isBefore(current)) {
        taskList = List.tomorrow;
      }
    }
    notifyListeners();
  }
}
