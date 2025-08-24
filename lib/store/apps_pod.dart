import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/index.dart';

class AppsPod extends ChangeNotifier {
  AppsPod();

  List<AppInfo> _list = [];
  void updateList(List<AppInfo> value) {
    _list = value;
    notifyListeners();
  }

  List<String> get packages {
    return _list.map((e) => e.packageName).toList();
  }

  List<AppInfo> get apps => _list;
}

var appsPod = ChangeNotifierProvider<AppsPod>((_) {
  return AppsPod();
});
