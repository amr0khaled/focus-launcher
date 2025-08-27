import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_launcher/store/time_pod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Timer clockInterval;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<String, double> startSwipe = {'x': 0, 'y': 0};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
              child: Center(
                child: Text(ref.read(clockPod).time,
                    style: const TextStyle(
                        fontSize: 64, fontWeight: FontWeight.w600)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
