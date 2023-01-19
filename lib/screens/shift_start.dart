import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shiftapp/screens/workers_listing.dart';
import 'package:shiftapp/util/string.dart';

import '../config/constants.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import 'inner_widgets/change_shift_time.dart';

class ShiftStart extends StatefulWidget {
  final Process processSelected;

  final VoidCallback popBack;

  final ShiftItem selectedShift;
  final yesterdayEfficiency;
  final bestEfficiency;
  const ShiftStart(
      {Key? key,
      required this.processSelected,
      this.yesterdayEfficiency,
      required this.selectedShift,
      this.bestEfficiency,
      required this.popBack})
      : super(key: key);

  @override
  State<ShiftStart> createState() => _ShiftStartState();
}

class _ShiftStartState extends State<ShiftStart> {
  bool showingWorkersListing = false;

  String timeElasped = '00:00';
  var startTimeOriginal;
  var endTimeOriginal;

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
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (widget.processSelected.type != "training")
                      Text(
                        widget.selectedShift.displayScreen == 2
                            ? 'CURRENT SHIFT'
                            : 'NEXT SHIFT:',
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
                      if (widget.processSelected.type != "training")
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
                              buildShowStartTime(),
                              style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      if (widget.selectedShift.displayScreenMessage !=
                          null) ...[
                        Text(
                          widget.selectedShift.displayScreenMessage!,
                          style: const TextStyle(
                              color: kPrimaryColor,
                              fontSize: 21,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ] else ...[
                      GestureDetector(
                          onTap: () async {
                            if (startTimeOriginal == null) {
                              startTimeOriginal =
                                  widget.selectedShift.startTime!;
                            }
                            if (endTimeOriginal == null) {
                              endTimeOriginal = widget.selectedShift.endTime!;
                            }
                            var maxtime = DateTime.parse(startTimeOriginal).add(
                                Duration(
                                    minutes: DateTime.parse(endTimeOriginal)
                                            .difference(DateTime.parse(
                                                startTimeOriginal))
                                            .inHours *
                                        60));
                            var mintime = DateTime.parse(startTimeOriginal)
                                .subtract(Duration(minutes: 120));
                            DateTime? newTime = DateTime.now();
                            showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext builder) {
                                  return Container(
                                    color: Colors.white,
                                    height: MediaQuery.of(context).size.width,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  "Shift time can only be re-set 2 hours in advance of the new time.",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: kPrimaryColor,
                                                  )),
                                            )),
                                        Expanded(
                                          flex: 4,
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode
                                                .dateAndTime,
                                            onDateTimeChanged: (value) async {
                                              newTime = value;
                                            },
                                            initialDateTime: DateTime.now(),
                                            minimumDate: mintime,
                                            maximumDate: maxtime,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).then((value) async {
                              if (newTime != null) {
                                customSelectedStartTime = widget.selectedShift
                                    .makeTimeStringFromHourMinute(
                                        newTime!.hour, newTime!.minute);
                                DateTime tempStart =
                                    DateFormat("yyyy-MM-dd hh:mm:ss")
                                        .parse(startTimeOriginal);
                                DateTime tempEnd =
                                    DateFormat("yyyy-MM-dd hh:mm:ss")
                                        .parse(endTimeOriginal);
                                var differenceT =
                                    tempEnd.difference(tempStart).inMinutes;

                                String endDate = '';

                                print('object');

                                bool? selected = await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return ChangeShiftTime(
                                        hours: tempEnd
                                                .difference(tempStart)
                                                .inHours
                                                .toString() +
                                            ' ' +
                                            'Hours : ' +
                                            (tempEnd
                                                        .difference(tempStart)
                                                        .inMinutes %
                                                    60)
                                                .toString() +
                                            ' Minutes',
                                        date: widget
                                            .selectedShift.showStartDateOnly,
                                        endTime: newTime!
                                            .add(Duration(minutes: differenceT))
                                            .toString()
                                            .timeToShow,
                                        startTime:
                                            newTime.toString().timeToShow,
                                      );
                                    });

                                if (selected == true) {
                                  if (endDate.isNotEmpty) {
                                    widget.selectedShift.endTime = endDate;
                                  }
                                  setState(() {
                                    widget.selectedShift.startTime =
                                        customSelectedStartTime;
                                    widget.selectedShift.endTime = widget
                                        .selectedShift
                                        .makeTimeStringFromHourMinuteMahboob(
                                            DateTime(
                                              newTime!
                                                  .add(Duration(
                                                      minutes: differenceT))
                                                  .year,
                                              newTime!
                                                  .add(Duration(
                                                      minutes: differenceT))
                                                  .month,
                                              newTime!
                                                  .add(Duration(
                                                      minutes: differenceT))
                                                  .day,
                                            ),
                                            newTime!
                                                .add(Duration(
                                                    minutes: differenceT))
                                                .hour,
                                            newTime!
                                                .add(Duration(
                                                    minutes: differenceT))
                                                .minute);
                                  });
                                }
                              }
                            });

                            print('');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                buildShowStartTime(),
                                style: const TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700),
                              ),
                              const Text(
                                ' to ',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                widget.selectedShift.showEndTime,
                                style: const TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          )),
                      if (widget.selectedShift.displayScreenMessage !=
                          null) ...[
                        Text(
                          widget.selectedShift.displayScreenMessage!,
                          style: const TextStyle(
                              color: kPrimaryColor,
                              fontSize: 21,
                              fontWeight: FontWeight.w700),
                        ),
                      ] else
                        ...[],
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
                                return Container();
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
                    if (widget.processSelected.type != "training")
                      Divider(
                        height: 10,
                        color: kPrimaryColor,
                        thickness: 1,
                      ),
                    widget.bestEfficiency != null &&
                            widget.yesterdayEfficiency != null
                        ? Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  Text(
                                    "Best Shift:",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.bestEfficiency + "%",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )),
                              Container(
                                color: kPrimaryColor,
                                height: 80,
                                width: 5,
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  Text(
                                    "Last Shift",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.yesterdayEfficiency + "%",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 30,
          child: TextButton(
            onPressed: () async {
              if (widget.selectedShift.displayScreen! == 1 ||
                  widget.selectedShift.displayScreen! == 3) {
                return;
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
            },
            child: Image.asset(imageName()),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  String buildShowStartTime() {
    return widget.selectedShift.showStartTime;
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
            '${selectedShift.name} :',
            style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis),
          ),
          Text(
            ' ${selectedShift.showDate}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "•",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            'Elapsed :  ${timeElasped}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
