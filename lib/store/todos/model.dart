part of '../todos_pod.dart';

enum List { earlier, today, tommorow, custom }

class Todo extends ChangeNotifier {
  Todo(this.title,
      {this.id,
      this.description,
      this.done = false,
      this.taskList = List.today,
      this.listName = 'Today'}) {
    id ??= const UuidV4().toString();
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }
  String title;
  String? id;
  String? description;
  bool done;
  List taskList;
  String? listName;
  late DateTime createdAt;
  late DateTime updatedAt;

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
      case List.tommorow:
        this.listName = 'Tommorow';
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
    if (taskList == List.custom) {
      return;
    }
    if (createdAt.year != current.year || createdAt.month == current.month) {
      taskList = List.earlier;
    } else if (createdAt.year == current.year &&
        createdAt.month == current.month) {
      // Today -> Earlier
      if ((createdAt.day + 2) <= current.day) {
        taskList == List.earlier;
      }
      // Today -> Tommorow
      else if ((createdAt.day + 1) == current.day) {
        taskList = List.tommorow;
      }
    }
    notifyListeners();
  }
}
