import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shiftapp/screens/inner_widgets/alert_cancel_ok_buttons.dart';
import 'package:shiftapp/screens/workers_listing.dart';
import 'package:shiftapp/util/string.dart';

import '../config/constants.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../widgets/elevated_button.dart';
import 'inner_widgets/alert_title_label.dart';
import 'inner_widgets/change_shift_time.dart';

class ShiftStart extends StatefulWidget {
  final Process processSelected;

  final VoidCallback? popBack;

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (startTimeOriginal == null) {
                                startTimeOriginal =
                                    widget.selectedShift.startTime!;
                              }
                              if (endTimeOriginal == null) {
                                endTimeOriginal = widget.selectedShift.endTime!;
                              }
                              var maxtime = DateTime.parse(startTimeOriginal)
                                  .add(Duration(
                                      minutes: DateTime.parse(endTimeOriginal)
                                              .difference(DateTime.parse(
                                                  startTimeOriginal))
                                              .inHours *
                                          60));
                              var mintime = DateTime.parse(startTimeOriginal)
                                  .subtract(Duration(minutes: 120));
                              DateTime? newTime;
                              // = DateTime.now().subtract(
                              //     Duration(minutes: DateTime.now().minute));
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
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        "Set Start Time",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        "Shift time can only be re-set 2 hours in advance of the new time.",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          color: kPrimaryColor,
                                                        )),
                                                  ),
                                                  Expanded(
                                                    child: PElevatedButton(
                                                      onPressed: () {
                                                        // okHandler.call();
                                                        if (newTime == null) {
                                                          newTime =
                                                              DateTime.now()
                                                                  .roundDown();
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                      text: "Done",
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          Expanded(
                                            flex: 2,
                                            child: CupertinoDatePicker(
                                              mode: CupertinoDatePickerMode
                                                  .dateAndTime,
                                              onDateTimeChanged: (value) async {
                                                newTime = value;
                                              },
                                              minuteInterval: 15,
                                              initialDateTime: DateTime.now()
                                                      .roundDown()
                                                      .isBefore(mintime)
                                                  ? mintime
                                                  : DateTime.now().roundDown(),
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
                                      DateFormat("yyyy-MM-dd HH:mm:ss")
                                          .parse(startTimeOriginal);
                                  DateTime tempEnd =
                                      DateFormat("yyyy-MM-dd HH:mm:ss")
                                          .parse(endTimeOriginal);
                                  var differenceT =
                                      tempEnd.difference(tempStart).inMinutes;

                                  String endDate = '';

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
                                              .add(Duration(
                                                  minutes: differenceT))
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
                                    if (mounted)
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
                            },
                            child: Text(
                              buildShowStartTime(),
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
                          Text(
                            widget.selectedShift.showEndTime,
                            style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: 22,
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
              if (startTimeOriginal == null) {
                startTimeOriginal = widget.selectedShift.startTime!;
              }
              if (endTimeOriginal == null) {
                endTimeOriginal = widget.selectedShift.endTime!;
              }
              if (DateTime.parse(startTimeOriginal)
                          .difference(DateTime.now())
                          .inMinutes <
                      60 &&
                  DateTime.parse(startTimeOriginal)
                          .difference(DateTime.now())
                          .inMinutes >
                      -1) {
                // TextEditingController controller = TextEditingController();
                // TextEditingController controller2 = TextEditingController();
                //
                // bool timeSelected = true;
                // bool checkboxForComment = false;
                await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext contexts) {
                      return AlertDialog(
                          insetPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          backgroundColor: Colors.transparent,
                          content: Container(
                              width: MediaQuery.of(context).size.width / 1.15,
                              height: MediaQuery.of(context).size.height / 2.25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: Colors.grey, width: 3),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const AlertTitleLabel(
                                            title: 'Verify SHIFT TIME',
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          const Text(
                                              'Please confirm shift time change:'),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          buildInfoItem(
                                            'Date',
                                            widget.selectedShift
                                                .showStartDateOnly,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          buildInfoItem(
                                              'Start Time',
                                              widget.selectedShift.startTime!
                                                  .timeToShow),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          buildInfoItem(
                                              'End Time',
                                              widget.selectedShift.endTime!
                                                  .timeToShow),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          buildInfoItem(
                                            'Shift Length',
                                            widget.selectedShift.endDateObject
                                                    .difference(widget
                                                        .selectedShift
                                                        .startDateObject)
                                                    .inHours
                                                    .toString() +
                                                ' ' +
                                                'Hours : ' +
                                                (widget.selectedShift
                                                            .endDateObject
                                                            .difference(widget
                                                                .selectedShift
                                                                .startDateObject)
                                                            .inMinutes %
                                                        60)
                                                    .toString() +
                                                ' Minutes',
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          AlertCancelOk(
                                              okHandler: () async {
                                                Navigator.pop(context);
                                                var waitVal =
                                                    await Navigator.of(context)
                                                        .push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        WorkersListing(
                                                      shiftId: null,
                                                      processId: widget
                                                          .processSelected.id!,
                                                      selectedShift:
                                                          widget.selectedShift,
                                                      process: widget
                                                          .processSelected,
                                                    ),
                                                  ),
                                                );

                                                if (waitVal != null) {
                                                  if (waitVal == true) {
                                                    this.widget.popBack!.call();
                                                  }
                                                }
                                              },
                                              okButton: 'Correct'.toUpperCase(),
                                              cancelTitle: "Change start time",
                                              cancelHandler: () {
                                                Navigator.pop(contexts);

                                                if (startTimeOriginal == null) {
                                                  startTimeOriginal = widget
                                                      .selectedShift.startTime!;
                                                }
                                                if (endTimeOriginal == null) {
                                                  endTimeOriginal = widget
                                                      .selectedShift.endTime!;
                                                }
                                                var maxtime = DateTime.parse(
                                                        startTimeOriginal)
                                                    .add(Duration(
                                                        minutes: DateTime.parse(
                                                                    endTimeOriginal)
                                                                .difference(
                                                                    DateTime.parse(
                                                                        startTimeOriginal))
                                                                .inHours *
                                                            60));
                                                var mintime = DateTime.parse(
                                                        startTimeOriginal)
                                                    .subtract(
                                                        Duration(minutes: 120));
                                                DateTime? newTime;
                                                // =
                                                //     DateTime.now().subtract(
                                                //         Duration(
                                                //             minutes:
                                                //                 DateTime.now()
                                                //                     .minute));

                                                showCupertinoModalPopup(
                                                    context: context,
                                                    builder:
                                                        (BuildContext builder) {
                                                      return Container(
                                                        color: Colors.white,
                                                        height: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child: Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child: Text(
                                                                          "Shift time can only be re-set 2 hours in advance of the new time.",
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                          )),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          PElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          if (newTime ==
                                                                              null) {
                                                                            newTime =
                                                                                DateTime.now().roundDown();
                                                                          }
                                                                          Navigator.pop(
                                                                              context);
                                                                          // okHandler.call();
                                                                        },
                                                                        text:
                                                                            "Done",
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                            Expanded(
                                                              flex: 4,
                                                              child:
                                                                  CupertinoDatePicker(
                                                                mode: CupertinoDatePickerMode
                                                                    .dateAndTime,
                                                                initialDateTime: DateTime
                                                                            .now()
                                                                        .roundDown()
                                                                        .isBefore(
                                                                            mintime)
                                                                    ? mintime
                                                                    : DateTime
                                                                            .now()
                                                                        .roundDown(),
                                                                minuteInterval:
                                                                    15,
                                                                onDateTimeChanged:
                                                                    (value) async {
                                                                  newTime =
                                                                      value;
                                                                },
                                                                // initialDateTime:
                                                                //     DateTime
                                                                //         .now(),
                                                                minimumDate:
                                                                    mintime,
                                                                maximumDate:
                                                                    maxtime,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).then((value) async {
                                                  if (newTime != null) {
                                                    customSelectedStartTime = widget
                                                        .selectedShift
                                                        .makeTimeStringFromHourMinute(
                                                            newTime!.hour,
                                                            newTime!.minute);
                                                    DateTime tempStart = DateFormat(
                                                            "yyyy-MM-dd HH:mm:ss")
                                                        .parse(
                                                            startTimeOriginal);
                                                    DateTime tempEnd = DateFormat(
                                                            "yyyy-MM-dd HH:mm:ss")
                                                        .parse(endTimeOriginal);
                                                    var differenceT = tempEnd
                                                        .difference(tempStart)
                                                        .inMinutes;
                                                    String endDate = '';
                                                    bool? selected =
                                                        await showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return ChangeShiftTime(
                                                                hours: tempEnd
                                                                        .difference(
                                                                            tempStart)
                                                                        .inHours
                                                                        .toString() +
                                                                    ' ' +
                                                                    'Hours : ' +
                                                                    (tempEnd.difference(tempStart).inMinutes %
                                                                            60)
                                                                        .toString() +
                                                                    ' Minutes',
                                                                date: widget
                                                                    .selectedShift
                                                                    .showStartDateOnly,
                                                                endTime: newTime!
                                                                    .add(Duration(
                                                                        minutes:
                                                                            differenceT))
                                                                    .toString()
                                                                    .timeToShow,
                                                                startTime: newTime
                                                                    .toString()
                                                                    .timeToShow,
                                                              );
                                                            });

                                                    if (selected == true) {
                                                      if (endDate.isNotEmpty) {
                                                        widget.selectedShift
                                                            .endTime = endDate;
                                                      }
                                                      if (mounted)
                                                        setState(() {
                                                          widget.selectedShift
                                                                  .startTime =
                                                              customSelectedStartTime;
                                                          widget.selectedShift.endTime = widget
                                                              .selectedShift
                                                              .makeTimeStringFromHourMinuteMahboob(
                                                                  DateTime(
                                                                    newTime!
                                                                        .add(Duration(
                                                                            minutes:
                                                                                differenceT))
                                                                        .year,
                                                                    newTime!
                                                                        .add(Duration(
                                                                            minutes:
                                                                                differenceT))
                                                                        .month,
                                                                    newTime!
                                                                        .add(Duration(
                                                                            minutes:
                                                                                differenceT))
                                                                        .day,
                                                                  ),
                                                                  newTime!
                                                                      .add(Duration(
                                                                          minutes:
                                                                              differenceT))
                                                                      .hour,
                                                                  newTime!
                                                                      .add(Duration(
                                                                          minutes:
                                                                              differenceT))
                                                                      .minute);
                                                        });
                                                      var waitVal =
                                                          await Navigator.of(
                                                                  context)
                                                              .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              WorkersListing(
                                                            shiftId: null,
                                                            processId: widget
                                                                .processSelected
                                                                .id!,
                                                            selectedShift: widget
                                                                .selectedShift,
                                                            process: widget
                                                                .processSelected,
                                                          ),
                                                        ),
                                                      );

                                                      if (waitVal != null) {
                                                        if (waitVal == true) {
                                                          this
                                                              .widget
                                                              .popBack!
                                                              .call();
                                                        }
                                                      }
                                                    }
                                                  }
                                                });
                                              }),
                                          Expanded(
                                            child: Container(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )));
                    });
              } else {
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
                    this.widget.popBack!.call();
                  }
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

  Padding buildInfoItem(String labelName, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$labelName:',
              style: const TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: kPrimaryColor,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
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

extension round on DateTime {
  DateTime roundDown() {
    return DateTime(
        this.year,
        this.month,
        this.day,
        this.hour,
        (this.minute / 15).round() * 15,
        this.second,
        this.millisecond,
        this.microsecond);
  }
}
