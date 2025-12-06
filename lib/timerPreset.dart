import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TimerPreset {
  late int id;
  String name;
  int focusTime;
  int shortBreak;
  int longBreak;
  TimerPreset({required this.name, required this.focusTime, required this.shortBreak, required this.longBreak});
  
  TimerPreset.fromJson(Map<String, dynamic> json):
      name = json["name"],
      focusTime = json["focusTime"],
      shortBreak = json["shortBreak"],
      longBreak = json["longBreak"];
  
  Map<String, dynamic> toJson() => {
      "name" : name,
      "focusTime" : focusTime,
      "shortBreak" : shortBreak,
      "longBreak" : longBreak
  };
}

class TimerPresetManager{
  static TimerPreset defaultTimer = TimerPreset(name: "Study", focusTime: 1800, shortBreak: 300, longBreak: 900);
  static TimerPreset defaultTimer2 = TimerPreset(name: "Sport", focusTime: 3600, shortBreak: 480, longBreak: 1080);
  // In TimerPresetManager class
  static Future<void> savePreset(TimerPreset toSave) async {
    final prefs = await SharedPreferences.getInstance();

    // FIX: Use jsonEncode to convert the Map to a proper JSON string.
    var saveData = jsonEncode(toSave.toJson());

    await prefs.setString("${toSave.name}", saveData);
  }
  static List<String> getTimerNames(){
    return [defaultTimer.name, defaultTimer2.name];
  }
}