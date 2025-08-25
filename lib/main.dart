import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_launcher/screens/apps.dart';
import 'package:focus_launcher/screens/home.dart';
import 'package:focus_launcher/screens/todos.dart';
import 'package:focus_launcher/store/apps_pod.dart';
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
    List<Application> _apps = [];
    print(apps.length);
    for (Application app in apps.toSet().toList()) {
      bool names = app.packageName.startsWith('com.android') &&
          app.category == ApplicationCategory.undefined &&
          app.packageName != 'com.android.settings' &&
          !app.packageName.startsWith('com.android.camera');
      print("${app.packageName} ${names}");
      if (!names) {
        _apps.add(app);
      }
    }
    _apps = _apps.toSet().toList();
    _apps.sort((a, b) => a.appName.compareTo(b.appName));
    print(_apps.length);
    ref.watch(appsPod).updateList(_apps);
    print(_apps.length);
  }

  @override
  void initState() {
    super.initState();
    loadApps();
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
