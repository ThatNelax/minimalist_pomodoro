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
  void editTimerSetting(TimerPreset timerSetting) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage.edit(timerSetting: timerSetting)));
      _loadData();
  }

  void addTimerSetting() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage()));
      _loadData();
  }
  void deleteTimerSetting(String name) async {
    await DatabaseManager.deleteWithName(name);
    _loadData();
  }
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
                  return SizedBox(
                    height: 100,
                    child: GestureDetector(
                      onTap: () => editTimerSetting(timerEntries[i]),
                      child: Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(20),
                          tileColor: Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
                          title: Text(timerEntries[i].timerName),
                          trailing:
                            IconButton(
                                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)),
                                onPressed: () => deleteTimerSetting(timerEntries[i].timerName),
                                icon: Icon(Icons.delete)),
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

