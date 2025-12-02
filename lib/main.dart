import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const MyHomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
            brightness: Brightness.dark,
            primary: const Color(0xff121212),
            onPrimary: const Color(0xffE0E0E0),
            secondary: const Color(0xff00BCD4),
            onSecondary: const Color(0xff121212),
            error: const Color(0xffCF6679),
            onError: const Color(0xff121212),
            surface: const Color(0xff1E1E1E),
            onSurface: const Color(0xffF0F0F0)),
        textTheme: GoogleFonts.jetBrainsMonoTextTheme(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  int currentPage = 0;
  
  int setHour = 0;
  int setMinute = 2;
  int setSecond = 0;
  
  int currentHour = 0;
  int currentMinute = 2;
  int currentSecond = 0;

  int totalSeconds = 120;
  Timer? timer;
  int remainingSeconds = 120;
  double progress = 1;
  
  TimerState timerState = TimerState.stopped;

  TimerMode timerMode = TimerMode.work;
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
      currentHour = setHour;
      currentMinute = setMinute;
      currentSecond = setSecond;
      
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
  
  void setTimer(Duration time) {
    setState(() {
      setHour = time.inHours;
      setMinute = time.inMinutes % 60;
      setSecond = time.inSeconds % 60;
      currentHour = setHour;
      currentMinute = setMinute;
      currentSecond = setSecond;
      totalSeconds = (currentHour * 3600 + currentMinute * 60 + currentSecond);
      if (totalSeconds == 0) return;

      remainingSeconds = totalSeconds;
      progress = 1.0;
    });
  }
  
  void showSettings(){}
  
  String camelToSentence(String text) {
    var result = text.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), ' ');
    result = result.split('.').last; // remove "TimerMode."
    return result[0].toUpperCase() + result.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) => setState(() {
          currentPage = index;;
        }),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
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
            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 20,
                    value: progress,
                  )
                ],
              ),
            ),
            SizedBox(height: 80,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButtons()
              ],
            )
          ]
        ),
        
      ][currentPage], 
    );
  }
  
  Widget buildButtons(){
    print("trying to build buttons according to state : " + timerState.toString());
    if(TimerState.stopped == timerState){
      return Row(
        children: [
          IconButton(onPressed: startTimer, icon: Icon(Icons.play_arrow), style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary)),),
          SizedBox(width: 50,),
          IconButton(onPressed: resetTimer, icon: Icon(Icons.loop), style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary)),)
        ],
      );
    }
    else{
      return IconButton(onPressed: stopTimer, icon: Icon(Icons.stop));
    }
  }
}

enum TimerState{
  stopped,
  started,
}

enum TimerMode{
  work,
  shortBreak,
  longBreak
}
