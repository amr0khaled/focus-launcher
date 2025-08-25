import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppsPod extends ChangeNotifier {
  AppsPod();

  List<Application> _list = [];
  void updateList(List<Application> value) {
    _list = value;
    notifyListeners();
  }

  List<String> get packages {
    return _list.map((e) => e.packageName).toList();
  }

  List<Application> get apps => _list;
}

var appsPod = ChangeNotifierProvider<AppsPod>((_) {
  return AppsPod();
});
