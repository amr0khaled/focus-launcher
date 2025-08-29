import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_launcher/layouts/todo_lists.dart';
import 'package:focus_launcher/store/todos_pod.dart';

class TodosScreen extends ConsumerStatefulWidget {
  const TodosScreen({super.key});

  @override
  ConsumerState<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends ConsumerState<TodosScreen> {
  final appBarColor = Colors.black;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: appBarColor, statusBarBrightness: Brightness.dark));
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => ref.read(taskProvider.notifier).getTasks());
    return SafeArea(
        child: Column(
      children: [
        Container(
            width: double.infinity,
            height: 64,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
                color: appBarColor,
                border:
                    const Border(bottom: BorderSide(color: Colors.white24))),
            alignment: Alignment.center,
            child: const Text("Tasks",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20))),
        Expanded(
          child: SingleChildScrollView(
            child: TodoLists(items: ref.read(taskProvider)),
          ),
        ),
      ],
    ));
  }
}
