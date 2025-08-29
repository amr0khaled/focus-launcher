import 'package:flutter/material.dart';
import 'package:focus_launcher/components/todo_item.dart';
import 'package:focus_launcher/store/todos_pod.dart';

class TodoLists extends StatefulWidget {
  const TodoLists({super.key, required this.items});
  final List<Task> items;

  @override
  State<TodoLists> createState() => _TodoListsState();
}

class _TodoListsState extends State<TodoLists> {
  List<String> listNames = [];

  Map<String, List<Task>> organizeTasks(List<Task> tasks) {
    Map<String, List<Task>> result = {};
    for (Task task in tasks) {
      if (result[task.listTask.toValue(task.listName)] == null) {
        result[task.listTask.toValue(task.listName)] = [];
      }
      print(tasks.length);
      List<Task> currentList = result[task.listName]!;
      currentList.add(task);
      result[task.listTask.toValue(task.listName)] = currentList;
      setState(() => listNames = result.keys.toList());
    }
    return result;
  }

  Map<String, bool> expands = {};
  @override
  Widget build(BuildContext context) {
    Map<String, List<Task>> lists = organizeTasks(widget.items);

    print(widget.items);
    return ExpansionPanelList(
        expansionCallback: (i, value) {
          setState(() => expands[lists.keys.elementAt(i)] = value);
        },
        children: lists.keys.map((name) {
          if (expands[name] == null) expands[name] = false;
          return ExpansionPanel(
              isExpanded: expands[name]!,
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                    title: Text(name),
                    trailing: IconButton(
                        onPressed: () {
                          setState(() => expands[name] = !expands[name]!);
                        },
                        icon: isExpanded
                            ? const Icon(Icons.keyboard_arrow_up_rounded)
                            : const Icon(Icons.keyboard_arrow_down_rounded)));
              },
              body: Expanded(
                child: ListView(
                  children:
                      lists[name]!.map((task) => TodoItem(item: task)).toList(),
                ),
              ));
        }).toList());
  }
}
