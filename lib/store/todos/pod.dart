part of '../todos_pod.dart';

class TasksPod extends StateNotifier<List<Task>> {
  TasksPod(this._repo) : super(_repo.getAll());
  final TaskRepository _repo;

  // Get Tasks
  void getTasks() {
    state = _repo.getAll();
  }

  // Add Task
  void addTask(
      String title, String? description, ListTask listTask, String? listName) {
    final task = Task(title,
        description: description,
        listTask: listTask,
        listName: listName,
        done: false);
    _repo.add(task);
    state = _repo.getAll();
  }

  // Toggle Task
  void toggleTask(String id) {
    final task = state.firstWhere((item) => item.id == id);
    _repo.update(task.copyWith(done: !task.done));
    state = _repo.getAll();
  }

  // Delete Task
  void removeTask(String id) {
    _repo.remove(id);
    state = _repo.getAll();
  }

  void updateTasksWithTimeChecking() {
    List<Task> tasks = state.map((item) {
      if (item.listTask == ListTask.custom) {
        return item;
      }
      return item.checkListWithTime();
    }).toList();
    state = tasks;
  }
}

final taskProvider = StateNotifierProvider<TasksPod, List<Task>>((ref) {
  final repo = ref.watch(taskRepoProvider);
  return TasksPod(repo);
});
