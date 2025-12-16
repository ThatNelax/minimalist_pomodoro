import 'package:flutter/material.dart';
import 'package:minimalist_pomodoro/databaseManager.dart';
import 'package:minimalist_pomodoro/timerPreset.dart';
import 'editPage.dart';

class PresetsPage extends StatefulWidget {
  const PresetsPage({super.key});

  @override
  State<PresetsPage> createState() => _PresetsPageState();
}

class _PresetsPageState extends State<PresetsPage> {
  List<TimerPreset> timerEntries = const [];

  @override
  void initState(){
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
      await DatabaseManager.turnOnDatabase();
      List<TimerPreset> fetchedEntries = await DatabaseManager.getAllEntries();

      setState(() {
        timerEntries = fetchedEntries;
      });
  }

  void applyTimerSetting(TimerPreset timerSetting) {
    print("Confirming apply for $timerSetting.name");
  }

  void editTimerSetting(TimerPreset timerSetting) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage.edit(timerSetting: timerSetting)));
  }

  void addTimerSetting() => Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Presets")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addTimerSetting(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: timerEntries.length,
                itemBuilder: (BuildContext context, int i) {
                  return Dismissible(
                    key: Key(i.toString()),
                    child: SizedBox(
                      height: 150,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.all(
                            Radius.circular(20),
                          ),
                        ),
                        elevation: 5,
                        child: Card(
                          color: Theme.of(context).colorScheme.secondary,
                          child: Row(

                          )
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

