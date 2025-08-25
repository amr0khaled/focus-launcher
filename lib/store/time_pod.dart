import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClockTime extends ChangeNotifier {
  ClockTime();
  final Duration interval = const Duration(seconds: 45);
  late Timer _timer;
  bool state = false;
  String time = '00:00';

  void _callback(Timer? timer) {
    DateTime currentTime = DateTime.now();
    time = "${currentTime.hour.toString().padLeft(2, '0')}:"
        "${currentTime.hour.toString().padLeft(2, '0')}";
    notifyListeners();
  }

  void start() {
    state = true;
    _callback(null);
    _timer = Timer.periodic(interval, _callback);
  }

  void cancel() {
    _timer.cancel();
    state = false;
  }
}

final clockPod = ChangeNotifierProvider((ref) {
  var clock = ClockTime();
  ref.onDispose(() {
    clock.cancel();
  });
  return clock;
});
