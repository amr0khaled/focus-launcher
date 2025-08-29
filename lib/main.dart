import 'dart:developer';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_launcher/screens/apps.dart';
import 'package:focus_launcher/screens/home.dart';
import 'package:focus_launcher/screens/todos.dart';
import 'package:focus_launcher/store/apps_pod.dart';
import 'package:focus_launcher/store/database.dart';
import 'package:focus_launcher/store/time_pod.dart';
import 'package:focus_launcher/store/todos_pod.dart';
import 'package:focus_launcher/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);

  final dbManager = DatabaseManager();
  dbManager.registerTable('schemas/tasks/table.sql');
  await dbManager.init(dbName: 'app.db', version: 1);

  runApp(ProviderScope(
      overrides: [databaseManagerProvider.overrideWithValue(dbManager)],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int index = 1;
  List<Widget> pages = [];
  void loadApps() async {
    var apps = await DeviceApps.getInstalledApplications(
        includeSystemApps: true, onlyAppsWithLaunchIntent: true);
    List<Application> filteredApps = [];
    for (Application app in apps.toSet().toList()) {
      bool names = app.packageName.startsWith('com.android') &&
          app.category == ApplicationCategory.undefined &&
          app.packageName != 'com.android.settings' &&
          !app.packageName.startsWith('com.android.camera');
      if (!names) {
        filteredApps.add(app);
      }
    }
    filteredApps = filteredApps.toSet().toList();
    filteredApps.sort((a, b) => a.appName.compareTo(b.appName));
    ref.watch(appsPod).updateList(filteredApps);
  }

  @override
  void initState() {
    super.initState();
    loadApps();
    Future.microtask(() => ref.read(clockPod).start());
    // Future.microtask(() {
    //   final task = ref.watch(taskProvider.notifier);
    //   print(ref.read(taskProvider).length);
    //   // if (ref.read(taskProvider).length < 8) {
    //   //   task.addTask("task 1", null, ListTask.today, null);
    //   //   task.addTask("task 2", null, ListTask.today, null);
    //   //   task.addTask("task 3", null, ListTask.today, null);
    //   //   task.addTask("task 4", null, ListTask.today, null);
    //   // }
    //   final tasks = ref.read(taskProvider);
    //   print(tasks.length);
    // });
  }

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
