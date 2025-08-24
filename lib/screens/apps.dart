import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_launcher/store/apps_pod.dart';
import 'package:installed_apps/index.dart';

class AppsScreen extends ConsumerStatefulWidget {
  const AppsScreen({super.key});

  @override
  ConsumerState<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends ConsumerState<AppsScreen> {
  void getApps() async {
    List<AppInfo> apps = [];
    for (BuiltWith built in BuiltWith.values) {
      List<AppInfo> _apps =
          await InstalledApps.getInstalledApps(false, false, '', built);
      apps.addAll(_apps);
    }
    List<AppInfo> _apps = [];
    print(apps.length);
    for (AppInfo app in apps.toSet().toList()) {
      bool names = app.name.startsWith('com.');
      bool packages = app.packageName.startsWith('com.android');
      bool packagesGoogle =
          app.packageName.startsWith('com.google.android.apps');
      if (!packages && !names && packagesGoogle) {
        print("${app.packageName} $names");
        _apps.add(app);
      }
    }
    print(_apps.length);
    ref.watch(appsPod).updateList(_apps.toSet().toList());
    print(_apps.length);
  }

  List<Widget> viewApps(List<AppInfo> apps) {
    return List.generate(apps.length, (i) {
      return ListTile(
        key: Key('$i'),
        title: Text(apps[i].name, style: const TextStyle(color: Colors.white)),
        onTap: () async => await InstalledApps.startApp(apps[i].packageName),
        onLongPress: () =>
            setState(() => longPressedAppPackage = apps[i].packageName),
      );
    });
  }

  List<Application> newlyInstalledApps = [];
  List<Widget> newlyInstalledAppsViews = [];
  @override
  void initState() {
    super.initState();
    getApps();
  }

  String longPressedAppPackage = '';
  String longPressedApp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: viewApps(ref.read(appsPod).apps),
        ),
      ),
      //bottomSheet: BottomSheet(
      //    enableDrag: true,
      //    showDragHandle: true,
      //    onClosing: () {},
      //    builder: (context) {
      //      return Container(
      //          child: ListView(
      //        children: [
      //          ListTile(
      //              onTap: () async =>
      //                  await DeviceApps.openAppSettings(longPressedAppPackage),
      //              title: const Text("App Info")),
      //          ListTile(
      //              onTap: () async =>
      //                  await DeviceApps.uninstallApp(longPressedAppPackage),
      //              title: Text("Uninstall $longPressedApp"))
      //        ],
      //      ));
      //    }),
    );
  }
}
