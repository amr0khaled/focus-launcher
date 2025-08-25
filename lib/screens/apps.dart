import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_launcher/store/apps_pod.dart';

class AppsScreen extends ConsumerStatefulWidget {
  const AppsScreen({super.key});

  @override
  ConsumerState<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends ConsumerState<AppsScreen> {
  List<Widget> viewApps(List<Application> apps) {
    return List.generate(apps.length, (i) {
      return ListTile(
        key: Key('$i'),
        title:
            Text(apps[i].appName, style: const TextStyle(color: Colors.white)),
        onTap: () async => await DeviceApps.openApp(apps[i].packageName),
        onLongPress: () =>
            setState(() => longPressedAppPackage = apps[i].packageName),
      );
    });
  }

  List<Application> newlyDeviceApps = [];
  List<Widget> newlyDeviceAppsViews = [];
  @override
  void initState() {
    super.initState();
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
