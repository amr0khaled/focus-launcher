import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClockTime extends ChangeNotifier {
  ClockTime();
  Duration interval = const Duration(minutes: 1);
  late Timer _timer;
  bool state = false;
  String time = '00:00';
  bool _24Hours = true;

  void set12Hours(bool value) => _24Hours = value;

  void _callback(Timer? timer) {
    DateTime currentTime = DateTime.now();
    if (timer == null) {
      int remainingSeconds = 60 - currentTime.second;
      interval = Duration(seconds: remainingSeconds);
    } else {
      if (interval.inSeconds != 60) {
        interval = const Duration(minutes: 1);
      }
    }
    int hour = currentTime.hour;
    int minute = currentTime.minute;
    if (!_24Hours) {
      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour -= 12;
      }
    }
    time = "${hour.toString().padLeft(2, '0')}:"
        "${minute.toString().padLeft(2, '0')}";
    print(time);
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
