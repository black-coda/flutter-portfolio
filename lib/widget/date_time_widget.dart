// For formatting the date/time

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portfolio/utility_method.dart';

class DateTimeWidget extends StatefulWidget {
  const DateTimeWidget({super.key});

  @override
  State createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  late String _currentTime;
  late String _currentDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = UtilityService.formatTime(DateTime.now());
    _currentDate = UtilityService.formatDate(DateTime.now());

    // Update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _currentTime = UtilityService.formatTime(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _currentTime,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          Text(
            _currentDate,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class DateTimeNotifier extends ValueNotifier<(String, String)> {
  late Timer _timer;

  DateTimeNotifier() : super((_getCurrentTime(), _getCurrentDate())) {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      value = (_getCurrentTime(), _getCurrentDate());
    });
  }

  static String _getCurrentTime() {
    return UtilityService.formatTime(DateTime.now());
  }

  static String _getCurrentDate() {
    return UtilityService.formatMacOSDate(DateTime.now());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
