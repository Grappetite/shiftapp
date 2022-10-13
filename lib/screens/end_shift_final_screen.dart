import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/screens/login.dart';
import 'package:shiftapp/screens/shift_start.dart';
import 'package:shiftapp/services/login_service.dart';
import 'package:shiftapp/util/string.dart';

import '../config/constants.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../services/shift_service.dart';
import '../services/workers_service.dart';
import '../widgets/drop_down.dart';
import '../widgets/elevated_button.dart';
import '../widgets/input_view.dart';
import 'inner_widgets/alert_title_label.dart';

class EndShiftFinalScreen extends StatefulWidget {
  final int shiftId;
  final int processId;
  final Process process;

  final int executeShiftId;

  final String startTime;
  final String endTime;

  final ShiftItem selectedShift;

  final bool autoOpen;

  const EndShiftFinalScreen(
      {Key? key,
      required this.shiftId,
      required this.processId,
      required this.startTime,
      required this.endTime,
      required this.selectedShift,
      required this.process,
      this.autoOpen = false,
      required this.executeShiftId})
      : super(key: key);

  @override
  State<EndShiftFinalScreen> createState() => _EndShiftFinalScreenState();
}

class _EndShiftFinalScreenState extends State<EndShiftFinalScreen> {
  FocusNode doneButton = FocusNode();

  final textController = TextEditingController();
  var isTimeOver = false;

  String timeElasped = '00:00';
  late Timer _timer;

  String timeRemaining = '00:00';

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget.selectedShift.timeRemaining.contains('Over')) {
          timeRemaining =
              widget.selectedShift.timeRemaining.replaceAll('Over ', '');
          isTimeOver = true;
        } else {
          timeRemaining = widget.selectedShift.timeRemaining;
        }
        setState(() {
          timeElasped = widget.selectedShift.timeElasped;
        });

        print('');
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    doneButton.dispose();
    setupFocusNode(doneButton);
  }

  static OverlayEntry? _overlayEntry;

  static void showDoneButtonOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }

    OverlayState overlayState = Overlay.of(context) as OverlayState;
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: KeypadDoneButton(),
        );
      },
    );

    overlayState.insert(_overlayEntry!);
  }

  static void removeDoneButtonOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void setupFocusNode(FocusNode node) {
    // node.addListener(
    //   () {
    //     bool hasFocus = node.hasFocus;
    //     if (hasFocus) {
    //       if (Platform.isIOS) {
    //         showDoneButtonOverlay(context);
    //       }
    //     } else {
    //       if (Platform.isIOS) {
    //         removeDoneButtonOverlay();
    //       }
    //     }
    //   },
    // );
  }

  @override
  void initState() {
    super.initState();
    setupFocusNode(doneButton);
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Image.asset(
              'assets/images/toplogo.png',
              height: 20,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              widget.process.name!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 2,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          TimerTopWidget(
              selectedShift: widget.selectedShift, timeElasped: timeElasped),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey, width: 3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle_outline,
                            color: kPrimaryColor,
                          ),
                          Text(
                            'END SHIFT: SHIFT SUMMARY',
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: lightRedColor,
                              width: 3,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                24,
                              ),
                            ),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                isTimeOver
                                    ? ('TIME OVER : $timeRemaining')
                                    : ('TIME REMAINING: $timeRemaining'),
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kPrimaryColor,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                24,
                              ),
                            ),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.handyman,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      '${widget.process.unit} Processed',
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: textController,
                                        textAlign: TextAlign.center,
                                        focusNode: doneButton,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ], // Only numbers can be entered
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '${widget.process.unit} Processed',
                                  style: const TextStyle(
                                      color: kPrimaryColor, fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                const Text(
                                  'Enter the volume above',
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      PElevatedButton(
                        onPressed: () async {
                          if (textController.text.isEmpty) {
                            showAlertDialog(
                              context: context,
                              title: 'Error',
                              message:
                                  'Please write down the ${widget.process.unit} Processed',
                              actions: [
                                AlertDialogAction(
                                  label: MaterialLocalizations.of(context)
                                      .okButtonLabel,
                                  key: OkCancelResult.ok,
                                )
                              ],
                            );

                            print('');

                            return;
                          } else {
                            var answer = await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return ConfirmTimeEnd(
                                    shiftItem: this.widget.selectedShift,
                                  );
                                });

                            if (answer != null) {
                              if (answer != false) {
                                // return;

                                await EasyLoading.show(
                                  status: 'Adding...',
                                  maskType: EasyLoadingMaskType.black,
                                );

                                var check = await ShiftService.endShift(
                                  widget.executeShiftId,
                                  widget.processId,
                                  textController.text,
                                  answer,
                                );
                                await LoginService.logout();
                                await EasyLoading.dismiss();

                                if (check) {
                                  await EasyLoading.showSuccess(
                                    'Closed shift successfully',
                                    duration: const Duration(seconds: 2),
                                  );

                                  final prefs =
                                      await SharedPreferences.getInstance();

                                  prefs.remove('shiftId');

                                  prefs.remove('selectedShiftName');
                                  prefs.remove('selectedShiftEndTime');
                                  prefs.remove('selectedShiftStartTime');
                                  // prefs.remove('username');
                                  prefs.remove('password');

                                  Get.offAll(LoginScreen());
                                  // if (widget.autoOpen) {
                                  //   Navigator.pop(context);
                                  //   Navigator.pop(context, true);
                                  // } else {
                                  //   Navigator.pop(context);
                                  //   Navigator.pop(context, true);
                                  //   Navigator.pop(context, true);
                                  // }
                                } else {
                                  EasyLoading.showError('Error');
                                }
                              }
                            }
                          }
                        },
                        text: 'CLOSE SHIFT',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KeypadDoneButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[100],
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: CupertinoButton(
            padding: EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: const Text('Done',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

class ConfirmTimeEnd extends StatefulWidget {
  final ShiftItem shiftItem;
  final bool editing;
  final bool moveWorker;
  final List<Process>? processList;
  final int? workerId;
  const ConfirmTimeEnd(
      {Key? key,
      required this.shiftItem,
      this.editing = false,
      this.processList,
      this.moveWorker = false,
      this.workerId})
      : super(key: key);

  @override
  State<ConfirmTimeEnd> createState() => _ConfirmTimeEndState();
}

class _ConfirmTimeEndState extends State<ConfirmTimeEnd> {
  String timeToShow = '0';

  String customTimeSelectedToSend = '';

  @override
  void initState() {
    super.initState();
  }

  // TimeOfDay? newTime;
  String selectedString = "";
  String selectedWorkerType = "";
  int processIndexSelected = -1;
  int workerTypeIndexSelected = -1;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      backgroundColor: Colors.transparent,
      content: Container(
        width: MediaQuery.of(context).size.width / 1.15,
        height: MediaQuery.of(context).size.height / 2.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey, width: 3),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 4),
              child: Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  height: 15,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_alarm,
                          color: kPrimaryColor,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        AlertTitleLabel(
                          title: widget.moveWorker
                              ? "Send Worker"
                              : widget.editing
                                  ? "Remove worker"
                                  : 'CLOSE SHIFT',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),

                    Text(
                      widget.moveWorker
                          ? ""
                          : widget.editing
                              ? "Adjust worker removal time if different to current:"
                              : 'Adjust shift end time if different to current:',
                      style: TextStyle(color: kPrimaryColor, fontSize: 12),
                    ),

                    widget.moveWorker
                        ? Container()
                        : Expanded(
                            child: Container(),
                          ),

                    GestureDetector(
                      onTap: () async {
                        // TimeOfDay? newTime = await showTimePicker(
                        //   context: context,
                        //   initialTime: TimeOfDay(
                        //       hour: DateTime.now().hour,
                        //       minute: DateTime.now().minute),
                        //   initialEntryMode: TimePickerEntryMode.dial,
                        // );
                        DateTime? newTime;
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext builder) {
                              return Container(
                                color: Colors.white,
                                height: MediaQuery.of(context).size.width,
                                width: MediaQuery.of(context).size.width,
                                child: CupertinoDatePicker(
                                  //use24hFormat: true,
                                  mode: CupertinoDatePickerMode.dateAndTime,
                                  onDateTimeChanged: (value) async {
                                    newTime = value;
                                  },
                                  initialDateTime: widget.editing
                                      ? DateTime.now()
                                      : widget.shiftItem.startDateObject
                                          .add(Duration(hours: 3)),
                                  minimumDate: widget.editing
                                      ? widget.shiftItem.startDateObject
                                      : widget.shiftItem.startDateObject
                                          .add(Duration(hours: 3)),
                                  maximumDate: widget.editing
                                      ? DateTime.now()
                                      : widget.shiftItem.startDateObject
                                          .add(Duration(hours: 15)),
                                ),
                              );
                            }).then((value) {
                          if (newTime != null) {
                            var customSelectedStartTime = widget.shiftItem
                                .makeTimeStringFromHourMinute(
                                    newTime!.hour, newTime!.minute);

                            setState(() {
                              customTimeSelectedToSend =
                                  customSelectedStartTime;
                              // widget.shiftItem.endTime = customSelectedStartTime;
                            });
                          }
                        });
                      },
                      child: InputView(
                        isDisabled: true,
                        showError: false,
                        hintText: widget.editing
                            ? "Worker removal time"
                            : 'Shift End Time',
                        onChange: (newValue) {},
                        controller: TextEditingController(
                            text: findEndTime().timeToShow),
                        text: findEndTime().timeToShow,
                        suffixIcon: Icons.expand_circle_down_outlined,
                      ),
                    ),

                    widget.moveWorker
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Text(
                                "Select Process",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Container(),
                          ),

                    widget.moveWorker
                        ? DropDown(
                            labelText: 'Title',
                            currentList: (widget.processList! as List)
                                .map((e) => e.name!.trim() as String)
                                .toList(),
                            showError: false,
                            onChange: (newString) {
                              setState(() {
                                selectedString = newString;
                                workerTypeIndexSelected = -1;
                                selectedWorkerType = "";
                                processIndexSelected = -1;
                              });

                              Future.delayed(Duration(milliseconds: 50), () {
                                processIndexSelected = widget.processList!
                                    .map((e) => e.name!.trim())
                                    .toList()
                                    .indexOf(newString);
                                setState(() {});
                              });

                              //final List<String> cityNames = cities.map((city) => city.name).toList();
                            },
                            placeHolderText: 'Process',
                            preSelected: selectedString,
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: Text(
                              dataToDisplay(),
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),

                    Expanded(
                      child: Container(),
                    ),
                    processIndexSelected != -1
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Text(
                                "Select Worker Type",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Container(),
                          ),

                    processIndexSelected != -1
                        ? DropDown(
                            labelText: 'Title',
                            currentList: (widget
                                    .processList![processIndexSelected]
                                    .workerType!)
                                .map((e) {
                              return e.workerTypeName!.trim();
                            }).toList(),
                            showError: false,
                            onChange: (newString) {
                              setState(() {
                                selectedWorkerType = newString;
                              });

                              workerTypeIndexSelected = widget
                                  .processList![processIndexSelected]
                                  .workerType!
                                  .map((e) => e.workerTypeName!.trim())
                                  .toList()
                                  .indexOf(newString);

                              //final List<String> cityNames = cities.map((city) => city.name).toList();
                            },
                            placeHolderText: 'Worker Type',
                            preSelected: selectedWorkerType,
                          )
                        : Container(),
                    Expanded(
                      child: Container(),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.moveWorker
                            ? "Are you sure you want to move this worker?"
                            : widget.editing
                                ? "Are you sure you want to remove this worker?"
                                : 'Are you sure you want to close this shift?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),

                    //
                    Expanded(
                      child: Container(),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: PElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context, false);
                            },
                            text: 'NO',
                            backGroundColor: Colors.white,
                            textColor: kPrimaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: PElevatedButton(
                            onPressed: () async {
                              if (widget.moveWorker) {
                                if (processIndexSelected != -1 &&
                                    workerTypeIndexSelected != -1) {
                                  await EasyLoading.show(
                                    status: 'Moving...',
                                    maskType: EasyLoadingMaskType.black,
                                  );

                                  var response =
                                      await WorkersService.moveWorkers(
                                          startedExecuteShiftId: widget
                                              .processList![
                                                  processIndexSelected]
                                              .startedExecutionShiftId
                                              .toString(),
                                          moveTime: findEndTime(),
                                          exshiftId: widget
                                              .shiftItem.executedShiftId!
                                              .toInt(),
                                          workerUserId:
                                              widget.workerId!.toInt(),
                                          workerTypeId: widget
                                              .processList![
                                                  processIndexSelected]
                                              .workerType![
                                                  workerTypeIndexSelected]
                                              .workerTypeId!);
                                  if (response) {
                                    await EasyLoading.dismiss();
                                    Navigator.pop(context, true);
                                  } else {
                                    await EasyLoading.dismiss();
                                  }
                                } else {
                                  if (processIndexSelected == -1) {
                                    EasyLoading.showError(
                                        'Please select process');
                                  } else {
                                    EasyLoading.showError(
                                        'Please select Worker Type');
                                  }
                                }
                              } else {
                                String result = findEndTime();
                                Navigator.pop(context, result);
                              }
                            },
                            text: 'YES',
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String findEndTime() {
    var result = '';
    // if (widget.editing) {
    //   result = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    // } else {
    result = widget.shiftItem.endTime!;

    if (customTimeSelectedToSend.isNotEmpty) {
      return customTimeSelectedToSend;
    }
    var difference = DateTime.now().difference(widget.shiftItem.endDateObject);

    var minutesRemaining = difference.inMinutes;

    if (minutesRemaining > -30 && minutesRemaining < 30) {
    } else {
      String endTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

      result = endTime;
    }
    print('');
    // }
    return result;
  }

  String dataToDisplay() {
    return DateFormat("yyyy-MM-dd").format(DateTime.now());
  }
}
