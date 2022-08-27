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

  final VoidCallback popBack;

  final ShiftItem selectedShift;

  const ShiftStart(
      {Key? key,
      required this.processSelected,
      required this.selectedShift,
      required this.popBack})
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: TimerTopWidget(
              selectedShift: widget.selectedShift, timeElasped: timeElasped),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          flex: 30,
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
                    if (widget.selectedShift.displayScreen! == 1 ||
                        widget.selectedShift.displayScreen == 3) ...[
                      const Text(
                        'NO AVAILABLE SHIFTS',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Next Shift available at ',
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            widget.selectedShift.showStartTime,
                            style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: 21,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ] else ...[
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

                              if (newTime != null) {
                                customSelectedStartTime = widget.selectedShift
                                    .makeTimeStringFromHourMinute(
                                        newTime.hour, newTime.minute);

                                setState(() {
                                  widget.selectedShift.startTime =
                                      customSelectedStartTime;
                                });


                                bool? selected = await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return ChangeShiftTime(
                                        hours: widget.selectedShift.endDateObject.difference(widget.selectedShift.startDateObject).inHours.toString() + ' ' + 'Hours',
                                        date: widget.selectedShift.showStartDateOnly,
                                        endTime: widget.selectedShift.showEndTime,
                                        startTime:
                                            widget.selectedShift.showStartTime,
                                      );
                                    });

                                if (selected != null) {
                                  return;
                                }
                              }

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

                              if(newTime == null) {
                                return;

                              }
                              customSelectedEndTime = widget.selectedShift
                                  .makeTimeStringFromHourMinute(
                                      newTime.hour, newTime.minute);

                              setState(() {
                                widget.selectedShift.endTime =
                                    customSelectedEndTime;
                              });


                              bool? selected = await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return ChangeShiftTime(
                                      hours: widget.selectedShift.endDateObject.difference(widget.selectedShift.startDateObject).inHours.toString() + ' ' + 'Hours',
                                      date: widget.selectedShift.showStartDateOnly,
                                      endTime: widget.selectedShift.showEndTime,
                                      startTime:
                                      widget.selectedShift.showStartTime,
                                    );
                                  });

                              if (selected != null) {
                                return;
                              }

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
                    ],
                    if (1 == 2) ...[
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
                                return  Container();//ChangeShiftTime();
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
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 44,
          child: TextButton(
            onPressed: () async {
              if (widget.selectedShift.displayScreen! == 1 ||
                  widget.selectedShift.displayScreen! == 3) {
               // return;
              }

              var waitVal = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WorkersListing(
                    shiftId: null,
                    processId: widget.processSelected.id!,
                    selectedShift: widget.selectedShift,
                    process: widget.processSelected,
                  ),
                ),
              );

              if (waitVal != null) {
                if (waitVal == true) {
                  this.widget.popBack.call();
                }
              }
              //
            },
            child: Image.asset(imageName()),
          ),
        ),
        Expanded(
          flex: 20,
          child: Center(
            child: PElevatedButton(
              onPressed: () {},
              text: 'VIEW PREVIOUS SHIFT',
              backGroundColor: Colors.grey,
            ),
          ),
        ),

        const SizedBox(
          height: 16,
        ),

//#5EC1DC40
      ],
    );
  }

  String imageName() {
    if (widget.selectedShift.displayScreen! == 1 ||
        widget.selectedShift.displayScreen! == 3) {
      return 'assets/images/start_disable.png';
    }
    return 'assets/images/start_button.png';
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
            'Elapsed :  ${timeElasped}',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
