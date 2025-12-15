import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TimerPreset {
  String timerName;
  int focusTime;
  int shortBreak;
  int longBreak;
  TimerPreset({required this.timerName, required this.focusTime, required this.shortBreak, required this.longBreak});

  factory TimerPreset.fromMap(Map<String, dynamic> map) {
    return TimerPreset(
      timerName: map['timerName'] as String? ?? '',
      focusTime: map['focusTime'] as int? ?? 0,
      shortBreak: map['shortBreak'] as int? ?? 0,
      longBreak: map['longBreak'] as int? ?? 0,
    );
  }
}
