import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String time = '';
  bool _cancel = false;

  late Timer clockInterval;
  @override
  void initState() {
    void clockCallback(Timer timer) {
      if (_cancel) {
        timer.cancel();
      }
      DateTime now = DateTime.now().toLocal();
      String hour = now.hour > 9 ? "${now.hour}" : "0${now.hour}";
      String minute = now.minute > 9 ? "${now.minute}" : "0${now.minute}";
      print('$hour:$minute');
      setState(() => time = '$hour:$minute');
    }

    super.initState();
    clockInterval = Timer.periodic(const Duration(minutes: 1), clockCallback);
  }

  @override
  void dispose() {
    super.dispose();
    _cancel = true;
  }

  Map<String, double> startSwipe = {'x': 0, 'y': 0};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(time,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w600)),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Divider(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
