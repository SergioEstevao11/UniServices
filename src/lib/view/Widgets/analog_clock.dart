import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ClockDemo extends StatefulWidget {
  ClockDemoState clockState;

  ClockDemo(DateTime initDateTime){
    clockState = ClockDemoState(initDateTime);
  }

  @override
  State<StatefulWidget> createState() {
    return clockState;
  }

  getInputTime(){
    return clockState.getSelectedTimeOfDay();
  }
}

typedef EntryModeChangeCallback = void Function(TimePickerEntryMode);

class ClockDemoState extends State<ClockDemo> {
  TimeOfDay selectedTime;
  String textHolder;
  DateTime clockTime;

  ClockDemoState(DateTime initDateTime){
    textHolder = initDateTime.toString().substring(11,16);
    selectedTime = TimeOfDay.fromDateTime(initDateTime);
  }

  changeText(newText) {
    setState(() {
      textHolder = newText;
      clockTime = DateTime.parse('2022-05-30 ' + '$textHolder' + ':00z');
      createAnalogClock(clockTime);
    });
  }

  _selectTime(BuildContext context) async {
    TimeOfDay nowTime = TimeOfDay.now();
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      onEntryModeChanged: null,
    );

    double doubleSelected = timeOfDay.hour.toDouble() +
        (timeOfDay.minute.toDouble() / 60);
    double doubleNowTime = nowTime.hour.toDouble() +
        (nowTime.minute.toDouble() / 60);
    double timeDiff = doubleSelected - doubleNowTime ;

    if(timeDiff <= 0){
      Alert(
          context: context,
          title: '',
          content:
          Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("The hour you chose is not available!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )
                    )
                ),
                const SizedBox(height:15),
              ]
          ),
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Back",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18),
              ),
            ),
          ]).show();
    }
    else if(timeOfDay != null && timeOfDay != selectedTime)
    {
      selectedTime = timeOfDay;
      changeText(selectedTime.toString().substring(10,15));
    }
  }

  getSelectedTimeOfDay(){
    return selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _selectTime(context);
          });
        },
        child:
        Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              createAnalogClock(clockTime),
              const SizedBox(height: 20),
              Text('$textHolder',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme
                        .of(context)
                        .accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )
              ),
              const SizedBox(height: 20),
            ]
        )
    );
  }

  Widget createAnalogClock(clockTime) {
    return FlutterAnalogClock(
      dateTime: clockTime,
      dialPlateColor: Colors.white,
      hourHandColor: Colors.black,
      minuteHandColor: Colors.black,
      secondHandColor: Colors.black,
      numberColor: Colors.black,
      borderColor: Colors.black,
      tickColor: Theme.of(context).accentColor,
      centerPointColor: Colors.black,
      showBorder: true,
      showTicks: true,
      showMinuteHand: true,
      showSecondHand: false,
      showNumber: true,
      borderWidth: 8.0,
      hourNumberScale: .10,
      hourNumbers: ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI', 'XII'],
      isLive: true,
      width: 150.0,
      height: 150.0,
      decoration: const BoxDecoration(),
    );
  }

}