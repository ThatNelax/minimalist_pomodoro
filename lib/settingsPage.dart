import 'package:flutter/material.dart';
import 'package:minimalist_pomodoro/timerSetting.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<TimerSetting> getTimerSettings(){
    return List.empty();
  }
  void addTimerSetting(){}
  late List<TimerSetting> timerSettings;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        FloatingActionButton(onPressed: addTimerSetting, child: Icon(Icons.add),)

    );
  }
}
