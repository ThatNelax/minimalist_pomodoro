import 'package:flutter/material.dart';
import 'package:minimalist_pomodoro/timerPreset.dart';
import 'editPage.dart';

class PresetsPage extends StatefulWidget {
  const PresetsPage({super.key});

  @override
  State<PresetsPage> createState() => _PresetsPageState();
}

class _PresetsPageState extends State<PresetsPage> {
  List<TimerPreset> getTimerSettings() {
    return List.empty();
  }

  void addTimerSetting() {}
  List<TimerPreset> timerSettings = [
    TimerPresetManager.defaultTimer,
  ];


  void showBottomPicker() {}
  void applyTimerSetting(TimerPreset timerSetting) {
    print("Confirming apply for $timerSetting.name");
  }

  void editTimerSetting(TimerPreset timerSetting) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(timerSetting: timerSetting,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timer Presets")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => editTimerSetting(
          TimerPreset(
            name: '',
            focusTime: 240,
            shortBreak: 120,
            longBreak: 180,
          ),
        ),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: timerSettings.length,
                itemBuilder: (BuildContext context, int i) {
                  return GestureDetector(
                    onTap: () => applyTimerSetting(timerSettings[i]),
                    child: SizedBox(
                      height: 150,
                      child: Card(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.all(
                            Radius.circular(20),
                          ),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            title: Text(
                              timerSettings[i].name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 17,
                              ),
                            ),
                            subtitle: Text(
                              "Focus : ${timerSettings[i].focusTime ~/ 60} min \nShort Break : ${timerSettings[i].shortBreak ~/ 60} min \nLong Break : ${timerSettings[i].longBreak ~/ 60} min",
                            ),
                            trailing: IconButton.filled(
                              onPressed: () =>
                                  editTimerSetting(timerSettings[i]),
                              icon: Icon(Icons.edit),
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

