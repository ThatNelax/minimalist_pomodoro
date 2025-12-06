import 'package:flutter/material.dart';

class TimerSetting {
  Icon icon;
  String name;
  int focusTime;
  int shortBreak;
  int longBreak;
  TimerSetting({required this.icon, required this.name, required this.focusTime, required this.shortBreak, required this.longBreak});
  
  static TimerSetting defaultTimer = TimerSetting(icon: Icon(Icons.desk), name: "Study", focusTime: 1800, shortBreak: 300, longBreak: 900);
  static TimerSetting defaultTimer2 = TimerSetting(icon: Icon(Icons.sports_baseball_rounded), name: "Sport", focusTime: 3600, shortBreak: 480, longBreak: 1080);
  
  static List<String> getTimerNames(){
    return [defaultTimer.name, defaultTimer2.name];
  }
}
