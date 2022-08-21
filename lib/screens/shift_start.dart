import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shiftapp/screens/workers_listing.dart';

import '../config/constants.dart';
import '../model/shifts_model.dart';
import '../model/login_model.dart';
import '../services/shift_service.dart';
import '../widgets/elevated_button.dart';
import 'inner_widgets/change_shift_time.dart';

class ShiftStart extends StatefulWidget {
  final Process processSelected;

  final ShiftItem selectedShift;

  const ShiftStart(
      {Key? key, required this.processSelected, required this.selectedShift})
      : super(key: key);

  @override
  State<ShiftStart> createState() => _ShiftStartState();
}

class _ShiftStartState extends State<ShiftStart> {
  bool showingWorkersListing = false;

  String timeElasped = '00:00';

  late Timer _timer;



  void startTimer() {

    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {

        setState(() {
          timeElasped = widget.selectedShift.timeElasped;
        });

        print('');
      },
    );
  }

  String customSelectedStartTime = '';
  String customSelectedEndTime = '';

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: TimerTopWidget(selectedShift: widget.selectedShift ,  timeElasped: timeElasped),
        ),

        const SizedBox(
          height: 16,
        ),
        if (showingWorkersListing) ...[
          Expanded(
            child: WorkersListing(
              shiftId: 1,
              processId: widget.processSelected.id!,
              selectedShift: widget.selectedShift,
            ),
            flex: 96,
          ),
        ] else ...[
          Expanded(
            flex: 34,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.14,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryColor,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'NEXT SHIFT:',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var currenHours =
                                  widget.selectedShift.showStartTimeHour;
                              var currenMinute =
                                  widget.selectedShift.showStartTimeMinute;

                              final TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: currenHours, minute: currenMinute),
                                initialEntryMode: TimePickerEntryMode.dial,
                              );

                              customSelectedStartTime = widget.selectedShift
                                  .makeTimeStringFromHourMinute(
                                      newTime!.hour, newTime.minute);

                              setState(() {
                                widget.selectedShift.startTime =
                                    customSelectedStartTime;
                              });

                              print('');

                              //yyyy-MM-dd hh:mm:ss

                              // newTime.hour;
                              //  newTime.minute;
                            },
                            child: Text(
                              widget.selectedShift.showStartTime,
                              style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const Text(
                            ' to ',
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          ),
                          GestureDetector(
                            onTap: () async {
                              var currenHours =
                                  widget.selectedShift.showEndTimeHour;
                              var currenMinute =
                                  widget.selectedShift.showEndTimeMinute;

                              final TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: currenHours, minute: currenMinute),
                                initialEntryMode: TimePickerEntryMode.dial,
                              );

                              customSelectedEndTime = widget.selectedShift
                                  .makeTimeStringFromHourMinute(
                                      newTime!.hour, newTime.minute);

                              setState(() {
                                widget.selectedShift.endTime =
                                    customSelectedEndTime;
                              });

                              print('');
                            },
                            child: Text(
                              widget.selectedShift.showEndTime,
                              style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          onSurface: kPrimaryColor,
                          side: const BorderSide(
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: () async {
                          bool? selected = await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const ChangeShiftTime();
                              });

                          if (selected != null) {
                            return;
                          }
                        },
                        child: const Text(
                          'CHANGE SHIFT TIMES',
                          style: TextStyle(fontSize: 20, color: kPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 40,
            child: TextButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WorkersListing(
                      shiftId: null,
                      processId: widget.processSelected.id!,
                      selectedShift: widget.selectedShift,
                    ),
                  ),
                );

                //
              },
              child: Image.asset('assets/images/start_button.png'),
            ),
          ),
          Expanded(
            flex: 20,
            child: Center(
              child: PElevatedButton(
                onPressed: () {},
                text: 'VIEW PREVIOUS SHIFT',
              ),
            ),
          ),
        ],

        const SizedBox(
          height: 16,
        ),

//#5EC1DC40
      ],
    );
  }
}

class TimerTopWidget extends StatelessWidget {
  const TimerTopWidget({
    Key? key,
    required this.selectedShift,
    required this.timeElasped,
  }) : super(key: key);


  final ShiftItem selectedShift;
  final String timeElasped;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: lightBlueColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${selectedShift.name} : ${selectedShift.showDate}',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "•",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
           Text(
            'Elapsed :  $timeElasped',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
