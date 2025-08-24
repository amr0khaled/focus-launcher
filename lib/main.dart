import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_launcher/screens/apps.dart';
import 'package:focus_launcher/screens/home.dart';
import 'package:focus_launcher/screens/todos.dart';
import 'package:focus_launcher/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus',
      theme: theme,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 1;
  List<Widget> pages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: PageView(
      pageSnapping: true,
      controller: PageController(keepPage: true, initialPage: index),
      onPageChanged: (i) => setState(() => index = i),
      children: const [TodosScreen(), HomeScreen(), AppsScreen()],
    )));
  }
}
