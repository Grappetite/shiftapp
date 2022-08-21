import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shiftapp/screens/shift_start.dart';

import '../config/constants.dart';
import 'dart:io' show Platform;

import '../model/shifts_model.dart';
import '../services/workers_service.dart';
import '../widgets/elevated_button.dart';
import 'login.dart';

class EndShiftFinalScreen extends StatefulWidget {
  final int shiftId;
  final int processId;
  final String startTime;
  final String endTime;

  final ShiftItem selectedShift;

  final String comments;

  const EndShiftFinalScreen(
      {Key? key,
      required this.shiftId,
      required this.processId,
      required this.startTime,
      required this.endTime,
      required this.selectedShift,
      required this.comments})
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

            if(widget.selectedShift.timeRemaining.contains('Over')) {

              timeRemaining = widget.selectedShift.timeRemaining.replaceAll('Over ', '');
              isTimeOver = true;


            }
            else {
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
  void initState() {
    super.initState();
    setupFocusNode(doneButton);
    startTimer();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Shift'),
      ),
      body: Column(
        children: [
          TimerTopWidget(
              selectedShift: widget.selectedShift, timeElasped: timeElasped),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8,right: 8 , top: 8 , bottom: 16),
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
                          child:  Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                isTimeOver ? ('TIME OVER : $timeRemaining') : ('TIME REMAINING: $timeRemaining'),
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
                            padding:
                                EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                                  'Pallet Processed',
                                  style:
                                      TextStyle(color: kPrimaryColor, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
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
                          await EasyLoading.show(
                            status: 'Adding...',
                            maskType: EasyLoadingMaskType.black,
                          );

                          if (textController.text.isEmpty) {
                            return;
                          } else {
                            await EasyLoading.dismiss();

                            var check = await WorkersService.endShift(
                                widget.shiftId,
                                widget.processId,
                                textController.text,
                                widget.comments,
                                widget.endTime);

                            await EasyLoading.dismiss();

                            if (check) {
                              await EasyLoading.showSuccess(
                                'Closed shift successfully',
                                duration: const Duration(seconds: 2),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginScreen(),
                                ),
                              );
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
