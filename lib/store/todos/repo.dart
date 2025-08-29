part of '../todos_pod.dart';

class TaskRepository {
  final Database _db;
  TaskRepository(this._db);
  List<Task> _tasks = [];
  List<Task> getAll() {
    if (_tasks.isEmpty) {
      _db.query(_table).then((List<Map<String, Object?>> items) {
        _tasks = items.map((item) => Task.fromMap(item)).toList();
      });
      print("tasks $_tasks");
    }
    return List.unmodifiable(_tasks);
  }

  late Task _removedTask;
  late int _removedTaskIndex;
  final _table = 'tasks';

  void add(Task task) {
    _tasks.add(task);
    _db.insert(_table, task.toMap());
  }

  void update(Task task) {
    int index = _tasks.indexWhere((_task) => _task.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      _db.update(_table, _tasks[index].toMap());
    }
  }

  void remove(String id) {
    _removedTaskIndex = _tasks.indexWhere((task) => task.id == id);
    _removedTask = _tasks.removeAt(_removedTaskIndex);
    _db.delete(_table, where: "id = ?", whereArgs: [id]);
  }

  void undo() {
    _tasks.insert(_removedTaskIndex, _removedTask);
    _db.insert(_table, _removedTask.toMap());
  }
}

final taskRepoProvider = Provider<TaskRepository>((ref) {
  final dbManager = ref.read(databaseManagerProvider);
  return TaskRepository(dbManager.db);
});
