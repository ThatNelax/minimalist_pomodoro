import 'package:flutter/material.dart';
import 'package:minimalist_pomodoro/databaseManager.dart';
import 'package:minimalist_pomodoro/timerPreset.dart';

class EditPage extends StatefulWidget {

  EditPage({this.isEditing = false});
  EditPage.edit({required this.timerSetting, this.isEditing = true});
  late TimerPreset timerSetting;

  late bool isEditing;
  
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late String timerName;
  late int focusTime;
  late int shortBreak;
  late int longBreak;

  void confirmEdit() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
      if(!widget.isEditing) {
        await DatabaseManager.addEntry(timerName: timerName, focusTime: focusTime, shortBreak: shortBreak, longBreak: longBreak);
      } else {
        await DatabaseManager.editEntry(oldTimerName: widget.timerSetting.timerName, timerName: timerName, focusTime: focusTime, shortBreak: shortBreak, longBreak: longBreak);
      }
      Navigator.pop(context);

    }
  }
  void deleteEntry(){
    DatabaseManager.deleteWithName(timerName);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? "Edit" : "Add", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
      ),
      floatingActionButton: SizedBox(
        width: 350,
        child: FloatingActionButton.extended(
          onPressed: () => confirmEdit(),
          label: Text("Confirm"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                color: Theme.of(context).colorScheme.secondary,
                child:
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.isEditing ? widget.timerSetting.timerName : null,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          labelText: "Timer Name",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => timerName = value!,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.isEditing ? "${widget.timerSetting.focusTime}" : null,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                            labelText: "Focus Time",
                            border: OutlineInputBorder(),
                            suffixText: "min"
                        ),
                        onSaved: (value) => focusTime = int.parse(value!),
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        initialValue: widget.isEditing ? "${widget.timerSetting.shortBreak}"  : null,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                            labelText: "Short Break",
                            border: OutlineInputBorder(),
                            suffixText: "min"
                        ),
                        onSaved: (value) => shortBreak = int.parse(value!),
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        initialValue: widget.isEditing ? "${widget.timerSetting.longBreak}" : null,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                            labelText: "Long Break",
                            border: OutlineInputBorder(),
                            suffixText: "min"
                        ),
                        onSaved: (value) => longBreak = int.parse(value!),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
