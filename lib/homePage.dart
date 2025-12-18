import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimalist_pomodoro/databaseManager.dart';
import 'package:minimalist_pomodoro/presetsPage.dart';
import 'package:minimalist_pomodoro/timerPreset.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TimerPreset> _presets = [];
  bool _isLoading = true;
  String _dropdownValue = '';
  late TimerPreset activePreset;

  TimerMode timerMode = TimerMode.focus;
  TimerState timerState = TimerState.stopped;
  Timer? timer;

  int currentHour = 0;
  int currentMinute = 1;
  int currentSecond = 0;
  int totalSeconds = 60;
  int remainingSeconds = 60;
  double progress = 1.0;

  @override
  void initState() {
    super.initState();
    _initialLoad();
  }

  Future<void> _initialLoad() async {
    await DatabaseManager.turnOnDatabase();
    await _refreshPresets();
  }

  Future<void> _refreshPresets() async {
    final fetched = await DatabaseManager.getAllEntries();
    setState(() {
      _presets = fetched;
      if (_presets.isNotEmpty) {
        bool stillExists = _presets.any((p) => p.timerName == _dropdownValue);
        if (_dropdownValue.isEmpty || !stillExists) {
          activePreset = _presets.first;
          _dropdownValue = activePreset.timerName;
          resetTimer();
        }
      }
      _isLoading = false;
    });
  }

  void startTimer() {
    if (timerState == TimerState.started) return;

    setState(() {
      timerState = TimerState.started;
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (remainingSeconds > 0) {
          setState(() {
            remainingSeconds--;
            currentHour = remainingSeconds ~/ 3600;
            currentMinute = (remainingSeconds % 3600) ~/ 60;
            currentSecond = remainingSeconds % 60;
            progress = remainingSeconds / totalSeconds;
          });
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      timerState = TimerState.stopped;
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      int minutes;
      switch (timerMode) {
        case TimerMode.focus:
          minutes = activePreset.focusTime;
          break;
        case TimerMode.shortBreak:
          minutes = activePreset.shortBreak;
          break;
        case TimerMode.longBreak:
          minutes = activePreset.longBreak;
          break;
      }

      totalSeconds = minutes * 60;
      remainingSeconds = totalSeconds;
      currentHour = totalSeconds ~/ 3600;
      currentMinute = (totalSeconds % 3600) ~/ 60;
      currentSecond = totalSeconds % 60;
      progress = 1.0;
    });
  }

  void changeTimerMode(TimerMode mode) {
    setState(() {
      timerMode = mode;
      resetTimer();
    });
  }

  Widget timeDisplay() {
    DateTime time = DateTime(0, 0, 0, currentHour, currentMinute, currentSecond);
    String pattern = currentHour > 0 ? "HH:mm:ss" : "mm:ss";
    return Text(
      DateFormat(pattern).format(time),
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 80,
        fontWeight: FontWeight.w200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SegmentedButton<TimerMode>(
            style: ButtonStyle(side: WidgetStatePropertyAll(BorderSide(color: Theme.of(context).colorScheme.primary))),
            segments: const [
              ButtonSegment(icon: Icon(Icons.desk), value: TimerMode.focus, label: Text("Focus")),
              ButtonSegment(icon: Icon(Icons.coffee), value: TimerMode.shortBreak, label: Text("Short")),
              ButtonSegment(icon: Icon(Icons.bedtime), value: TimerMode.longBreak, label: Text("Long")),
            ],
            selected: {timerMode},
            onSelectionChanged: (Set<TimerMode> mode) => changeTimerMode(mode.first),
          ),
          const SizedBox(height: 80),
          GestureDetector(
            onTap: timerState == TimerState.started ? stopTimer : startTimer,
            child: SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: Colors.grey.shade200,
                    strokeCap: StrokeCap.round,
                    strokeWidth: 12,
                    value: progress,
                  ),
                  Center(child: timeDisplay()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_presets.isEmpty)
                const Text("No Presets Found")
              else
                DropdownMenu<String>(
                  textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  width: 200,
                  menuStyle: MenuStyle(
                    elevation: const WidgetStatePropertyAll(20),
                    backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                  ),
                  initialSelection: _dropdownValue,
                  dropdownMenuEntries: _presets.map((p) => DropdownMenuEntry(value: p.timerName, label: p.timerName)).toList(),
                  onSelected: (String? value) {
                    if (value != null) {
                      setState(() {
                        _dropdownValue = value;
                        activePreset = _presets.firstWhere((p) => p.timerName == value);
                        resetTimer();
                      });
                    }
                  },
                ),
              const SizedBox(width: 15),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => const PresetsPage()));
                  _refreshPresets();
                },
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

enum TimerState { stopped, started }
enum TimerMode { focus, shortBreak, longBreak }