import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimalist_pomodoro/presetsPage.dart';
import 'package:minimalist_pomodoro/timerPreset.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class MenuEntry {
  final String value;
  final String label;

  const MenuEntry({required this.value, required this.label});
}

class _HomePageState extends State<HomePage> {
  TimerMode timerMode = TimerMode.focus;
  late TimerPreset activeTimer;
  static final List<DropdownMenuEntry<String>> timerMenuEntries = TimerPresetManager
      .getTimerNames()
      .map<DropdownMenuEntry<String>>((String name) {
    return DropdownMenuEntry<String>(
      value: name,      
      label: name,       
    );
  }).toList(); 
  String dropdownValue = TimerPresetManager.getTimerNames()[0];
  
  late TimerPreset activePreset;
  
  int currentPage = 0;
  
  int currentHour = 0;
  int currentMinute = 1;
  int currentSecond = 0;

  int totalSeconds = 120;
  Timer? timer;
  int remainingSeconds = 120;
  double progress = 1;

  TimerState timerState = TimerState.stopped;

  void startTimer() {
    setState(() {
      timerState = TimerState.started;
      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if(timerState == TimerState.started){
          setState(() {

            currentSecond--;
            if(currentSecond <= 0 && currentMinute > 0) {
              currentSecond = 59;
              currentMinute--;
            }
            if(currentMinute <= 0 && currentHour > 0) {
              currentMinute = 59;
              currentHour--;
            }

            updateProgressBar();
          });
        }
      });
    });
  }

  void updateProgressBar() {
    setState(() {
      remainingSeconds--;
      progress = remainingSeconds / totalSeconds;
      if (remainingSeconds <= 0) {
        timer?.cancel();
        progress = 0;
      }
    });

  }

  void resetTimer(){
    setState(() {
      currentHour = activePreset.focusTime ~/ 3600;
      currentMinute = activePreset.focusTime ~/ 60;
      currentSecond = activePreset.focusTime % 3600;

      remainingSeconds = totalSeconds;
      progress = 1;
    });
  }

  void stopTimer(){
    setState(() {
      timerState = TimerState.stopped;
      timer?.cancel();
    });
  }

  Widget timeDisplay(){
    dynamic format;
    if(currentHour != 0)
      format = DateFormat("hh:mm:ss");
    else
      format = DateFormat("mm:ss");
    DateTime time = DateTime(0, 0, 0, currentHour, currentMinute, currentSecond);
    String formatted = format.format(time);
    return Text(formatted, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 80),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) => setState(() {
            currentPage = index;;
          }),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: currentPage,
          destinations: const <Widget> [
            NavigationDestination(icon: Icon(Icons.timer), label: "Timer"),
            NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: "Log")
          ]
      ),
      body: <Widget> [
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SegmentedButton(
                style: ButtonStyle(side: WidgetStatePropertyAll(BorderSide(color: Theme.of(context).colorScheme.primary)) ),
                  segments: const <ButtonSegment<TimerMode>>[
                ButtonSegment(
                    label: Text("Focus"),
                    icon: Icon(Icons.desk),
                    value: TimerMode.focus
                ),
                ButtonSegment(
                  label: Text("Short Break"),
                    icon: Icon(Icons.timer),
                    value: TimerMode.short),
                ButtonSegment(
                    label: Text("Long Break"),
                    icon: Icon(Icons.bedtime),
                    value: TimerMode.long),
                ], 
                selected: <TimerMode>{timerMode},
                onSelectionChanged: (Set<TimerMode> mode) {setState(() {
                  timerMode = mode.first;
                  
                  switch(mode.first){
                    case TimerMode.focus:
                      
                    case TimerMode.short:
                      // TODO: Handle this case.
                      throw UnimplementedError();
                    case TimerMode.long:
                      // TODO: Handle this case.
                      throw UnimplementedError();
                  }
                });
              }
              ),
              SizedBox(height: 120,),
              SizedBox(
                width: 300,
                height: 300,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeCap: StrokeCap.round,
                      strokeWidth: 15,
                      value: progress,
                    ),
                    Center(child: timeDisplay()),
                  ],
                ),
              ),
              SizedBox(height: 120,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //buildButtons()
                ],
              ),
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownMenu<String>(
                    menuStyle: MenuStyle(elevation: WidgetStatePropertyAll(20), backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),surfaceTintColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary) ),
                    inputDecorationTheme: InputDecorationTheme(enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary,width: 3)), suffixIconColor: Theme.of(context).colorScheme.primary,),
                    textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    initialSelection: dropdownValue,
                      dropdownMenuEntries: timerMenuEntries,
                    onSelected: (String? value) => setState(() {
                      dropdownValue = value!;
                    }),
                  ),
                  SizedBox(width: 20,),
                  IconButton(
                    icon: Icon(Icons.settings),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PresetsPage())),
                      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)),
                  ),
                ],
              )
            ]
        ),
        Column(children: [

        ],)
      ][currentPage],
    );
  }

  Widget buildButtons(){
    if(TimerState.stopped == timerState){
      return Row(
        children: [
          ElevatedButton(onPressed: startTimer, style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)), child: Icon(Icons.play_arrow, color: Theme.of(context).colorScheme.onPrimary, size: 30,),),
          SizedBox(width: 100,),
          ElevatedButton(onPressed: resetTimer, style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)), child: Icon(Icons.loop, color: Theme.of(context).colorScheme.onPrimary, size: 30,),),
        ],
      );
    }
    else{
      return ElevatedButton(onPressed: stopTimer, style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)), child: Icon(Icons.pause, color: Theme.of(context).colorScheme.onPrimary, size: 30,),);
    }
  }
}

enum TimerState{
  stopped,
  started,
}

enum TimerMode { focus, short, long }