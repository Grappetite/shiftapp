import 'dart:async';
import 'dart:io' show Platform;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shiftapp/Controllers/HomeController.dart';
import 'package:shiftapp/Network/API.dart';
import 'package:shiftapp/screens/shift_start.dart';

import '../config/constants.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../services/shift_service.dart';
import '../widgets/elevated_button.dart';
import '../widgets/input_view.dart';
import 'inner_widgets/alert_title_label.dart';

class EndShiftFinalScreen extends StatelessWidget {
  int? shiftId = Get.arguments["shiftId"];
  int? processId = Get.arguments["processId"];
  Process? process = Get.arguments["process"];

  int? executeShiftId = Get.arguments["executeShiftId"];

  String? startTime = Get.arguments["startTime"];
  String? endTime = Get.arguments["endTime"];

  ShiftItem? selectedShift = Get.arguments["selectedShift"];

  String? comments = Get.arguments["comments"];
  bool? autoOpen = Get.arguments["autoOpen"] ?? false;

  FocusNode doneButton = FocusNode();

  final textController = TextEditingController();
  var isTimeOver = false;

  String timeElasped = '00:00';
  late Timer _timer;

  String timeRemaining = '00:00';
  HomeController controller = Get.find();
  void startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (selectedShift!.timeRemaining.contains('Over')) {
          timeRemaining = selectedShift!.timeRemaining.replaceAll('Over ', '');
          isTimeOver = true;
        } else {
          timeRemaining = selectedShift!.timeRemaining;
        }

        timeElasped = selectedShift!.timeElasped;
        controller.update();

        print('');
      },
    );
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

  void setupFocusNode(FocusNode node, context) {
    node.addListener(
      () {
        bool hasFocus = node.hasFocus;
        if (hasFocus) {
          if (Platform.isIOS) {
            showDoneButtonOverlay(context);
          }
        } else {
          if (Platform.isIOS) {
            removeDoneButtonOverlay();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(initState: (c) {
      setupFocusNode(doneButton, context);
      startTimer();
    }, builder: (logic) {
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
                process!.name!,
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
                selectedShift: selectedShift!, timeElasped: timeElasped),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 8, bottom: 16),
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
                                        'UNIT PRODUCTS',
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
                                            FilteringTextInputFormatter
                                                .digitsOnly
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
                                    '${process!.unit} Processed',
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
// <<<<<<< HEAD
//                           await showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (BuildContext context) {
//                                 return ConfirmTimeEnd();
//                               });
//
//                           return;
//
// =======
// >>>>>>> master
                            if (textController.text.isEmpty) {
                              final result = await showAlertDialog(
                                context: context,
                                title: 'Error',
                                message: 'Please write down the units products',
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
                                      shiftItem: this.selectedShift!,
                                    );
                                  });

                              if (answer != null) {
                                if (answer == false) {
                                  return;
                                }
                              }

                              // await EasyLoading.show(
                              //   status: 'Adding...',
                              //   maskType: EasyLoadingMaskType.black,
                              // );

                              var check = await ShiftService.endShift(
                                executeShiftId!,
                                processId!,
                                textController.text,
                                answer,
                              );

// <<<<<<< HEAD
//                                 executeShiftId!,
//                                 processId!,
//                                 textController.text!,
//                                 comments!,
//                                 endTime!);
// =======

                              //await EasyLoading.dismiss();

                              if (check) {
                                await EasyLoading.showSuccess(
                                  'Closed shift successfully',
                                  duration: const Duration(seconds: 2),
                                );

                                // final prefs =
                                //     await SharedPreferences.getInstance();

                                Api().sp.remove('shiftId');

                                Api().sp.remove('selectedShiftName');
                                Api().sp.remove('selectedShiftEndTime');
                                Api().sp.remove('selectedShiftStartTime');
                                Api().sp.remove('username');
                                Api().sp.remove('password');

                                if (autoOpen!) {
// <<<<<<< HEAD
//                                 Get.back();
//                                 Get.back(result:true);
//                               } else {
//                                 Get.back();
// =======
                                  Get.back();
                                  Get.back(result: true);
                                } else {
                                  Get.back();
// >>>>>>> master
                                  Get.back(result: true);
                                  Get.back(result: true);
                                }
                              } else {
                                EasyLoading.showError('Error');
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
    });
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

  const ConfirmTimeEnd(
      {Key? key, required this.shiftItem, this.editing = false})
      : super(key: key);

  @override
  State<ConfirmTimeEnd> createState() => _ConfirmTimeEndState();
}

class _ConfirmTimeEndState extends State<ConfirmTimeEnd> {
  String timeToShow = '0';

  @override
  void initState() {
    super.initState();
  }

  TimeOfDay? newTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      backgroundColor: Colors.transparent,
      content: Container(
        width: MediaQuery.of(context).size.width / 1.15,
        height: widget.editing
            ? MediaQuery.of(context).size.height / 3.5
            : MediaQuery.of(context).size.height / 2.0,
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
                  )
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: Icon(
                  //     Icons.close,
                  //     color: kPrimaryColor,
                  //   ),
                  // ),
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
                          title:
                              widget.editing ? "Remove worker" : 'CLOST SHIFT',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),

                    widget.editing
                        ? Container()
                        : Text(
                            'Adjust shift ent time if different to current:',
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 12),
                          ),
                    widget.editing
                        ? Container()
                        : Expanded(
                            child: Container(),
                          ),
                    widget.editing
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: DateTime.now().hour,
                                    minute: DateTime.now().minute),
                                initialEntryMode: TimePickerEntryMode.dial,
                              );

                              if (newTime != null) {
                                var customSelectedStartTime = widget.shiftItem
                                    .makeTimeStringFromHourMinute(
                                        newTime.hour, newTime.minute);

                                setState(() {
                                  widget.shiftItem.endTime =
                                      customSelectedStartTime;
                                });
                              }
                            },
                            child: InputView(
                              isDisabled: true,
                              showError: false,
                              hintText: 'Shift End Time',
                              onChange: (newValue) {},
                              controller: TextEditingController(
                                  text: widget.shiftItem.showEndTime),
                              text: widget.shiftItem.showEndTime,
                              suffixIcon: Icons.expand_circle_down_outlined,
                            ),
                          ),
                    widget.editing
                        ? Container()
                        : Expanded(
                            child: Container(),
                          ),

                    widget.editing
                        ? Container()
                        : Align(
                            alignment: Alignment.center,
                            child: Text(
                              dataToDisplay(),
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                    widget.editing
                        ? Container()
                        : Expanded(
                            child: Container(),
                          ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.editing
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
                              Get.back(result: false);
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
                              Get.back(
                                  result: widget.editing
                                      ? DateTime.now().toString()
                                      : widget.shiftItem.endTime);
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

  String dataToDisplay() {
    return DateFormat("yyyy-MM-dd").format(DateTime.now());
  }
}
