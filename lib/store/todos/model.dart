part of '../todos_pod.dart';

enum ListTask { earlier, today, custom }

extension ListTaskExtension on ListTask {
  String toValue(String? listName) {
    switch (this) {
      case ListTask.earlier:
        return 'Earlier';
      case ListTask.today:
        return 'Today';
      case ListTask.custom:
        if (listName != null && listName.isNotEmpty) {
          return listName;
        }
        throw ArgumentError('Custom list must have a name.');
    }
  }

  static ListTask fromString(String value) {
    switch ("${value[0].toUpperCase()}${value.substring(1)}") {
      case 'Earlier':
        return ListTask.earlier;
      case 'Today':
        return ListTask.today;
      default:
        return ListTask.custom;
    }
  }
}

const String table = 'tasks';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDone = 'done';
const String columnDescription = 'description';
const String columnListTask = 'list_task'; // table name of the task_list

class Task {
  Task(this.title,
      {String? id,
      this.description,
      this.done = false,
      this.listTask = ListTask.today,
      String? listName,
      DateTime? createdAt,
      DateTime? updatedAt})
      : id = id ?? const UuidV4().generate(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        listName = listTask.toValue(listName);

  final String title;
  final String id;
  final String? description;
  final bool done;
  final ListTask listTask;
  final String? listName;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Task.fromMap(Map<String, Object?> map) {
    return Task(
      map[columnTitle] as String,
      id: map[columnId] as String,
      done: map[columnDone] == 1,
      description: map[columnDescription] as String?,
      listTask: ListTaskExtension.fromString(map[columnListTask] as String),
      listName: map['list_name'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
  Map<String, Object?> toMap() {
    return {
      columnId: id,
      columnTitle: title,
      columnListTask: listTask.name,
      columnDescription: description ?? '',
      columnDone: done ? 1 : 0,
      'list_name': listName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Task copyWith({
    String? title,
    String? description,
    bool? done,
    ListTask? listTask,
    String? listName,
  }) {
    return Task(
      title ?? this.title,
      id: id,
      description: description ?? this.description,
      done: done ?? this.done,
      listTask: listTask ?? this.listTask,
      listName: listName ?? this.listName,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Task checkListWithTime() {
    DateTime current = DateTime.now();
    int age = current.difference(createdAt).inDays;
    ListTask _listTask;

    if (listTask == ListTask.custom) {
      return this;
    }
    if (age == 0) {
      _listTask = ListTask.today;
    } else {
      _listTask = ListTask.earlier;
    }
    return copyWith(listTask: _listTask);
  }
}
