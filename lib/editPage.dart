import 'package:flutter/material.dart';
import 'package:minimalist_pomodoro/timerPreset.dart';

class EditPage extends StatefulWidget {
  
  EditPage({super.key, required this.timerSetting});

  final TimerPreset timerSetting;
  
  late TextEditingController name = TextEditingController(text: "${timerSetting.name}");
  late TextEditingController focusTime = TextEditingController(text: "${timerSetting.focusTime ~/ 60}");
  late TextEditingController shortBreak = TextEditingController(text: "${timerSetting.shortBreak ~/ 60}");
  late TextEditingController longBreak = TextEditingController(text:  "${timerSetting.longBreak ~/ 60}");
  
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {


  // In _EditPageState.confirmEdit()
  void confirmEdit() {
    // Safely parse and convert minutes to seconds
    int focusSec = int.tryParse(widget.focusTime.text) ?? 0;
    int shortSec = int.tryParse(widget.shortBreak.text) ?? 0;
    int longSec = int.tryParse(widget.longBreak.text) ?? 0;

    TimerPreset newPreset = TimerPreset(
        name: widget.name.text,
        focusTime: focusSec * 60,   // Multiply by 60
        shortBreak: shortSec * 60, // Multiply by 60
        longBreak: longSec * 60   // Multiply by 60
    );

    TimerPresetManager.savePreset(newPreset);
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: SizedBox(
        width: 350,
        child: FloatingActionButton.extended(
          onPressed: () => confirmEdit(),
          label: Text("Confirm"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 30),
        child: SizedBox(
          width: 500,
          height: 275,
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(16)
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Timer Name : ",
                          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                        ),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            controller: widget.name,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Focus Time : ",
                          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                        ),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            controller: widget.focusTime,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixText: "min"
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Short Break : ",
                          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                        ),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            controller: widget.shortBreak,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixText: "min"
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Long Break : ",
                          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                        ),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            controller: widget.longBreak,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixText: "min"
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
