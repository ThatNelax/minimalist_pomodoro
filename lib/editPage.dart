import 'package:flutter/material.dart';
import 'package:minimalist_pomodoro/timerSetting.dart';

class EditPage extends StatefulWidget {
  
  const EditPage({super.key, required this.timerSetting});

  final TimerSetting timerSetting;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController focusTime = TextEditingController();

  void confirmEdit() {
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
                          child: TextFormField(
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            initialValue: widget.timerSetting.name,
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
                          child: TextFormField(
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            initialValue: "${widget.timerSetting.focusTime ~/ 60}",
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
                          child: TextFormField(
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            initialValue: "${widget.timerSetting.shortBreak ~/ 60}",
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
                          child: TextFormField(
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            initialValue: "${widget.timerSetting.longBreak ~/ 60}",
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
