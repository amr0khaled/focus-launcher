import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_launcher/store/todos_pod.dart';

class TodoItem extends ConsumerStatefulWidget {
  const TodoItem({super.key, required this.item});

  final Task item;

  @override
  ConsumerState<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends ConsumerState<TodoItem> {
  void toggleCheckbox(bool? v) {
    final task = ref.watch(taskProvider.notifier);
    task.toggleTask(widget.item.id);
  }

  @override
  Widget build(BuildContext context) {
    Text title = Text(widget.item.title,
        style: const TextStyle(color: Colors.white70, fontSize: 18));
    Checkbox leading =
        Checkbox(value: widget.item.done, onChanged: toggleCheckbox);
    return widget.item.description != null
        ? ExpansionTile(
            title: title,
            leading: leading,
          )
        : ListTile(
            key: Key(widget.item.id),
            leading: leading,
            title: title,
          );
  }
}
