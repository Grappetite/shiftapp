import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/screens/shift_start.dart';

import '../model/shifts_model.dart';
import '../services/workers_service.dart';
import 'end_shift.dart';
import '../model/login_model.dart';

class StartShiftView extends StatefulWidget {

  final int shiftId;
  final int processId;
  final List<String> userId;
  final int totalUsersCount;
  final String startTime;
  final String endTime;
  final List<String> efficiencyCalculation;
  final ShiftItem selectedShift;
  final Process process;


  const StartShiftView(
      {Key? key,
      required this.shiftId,
      required this.processId,
      required this.userId,
      required this.totalUsersCount,
      required this.startTime,
      required this.endTime,
      required this.efficiencyCalculation,
      required this.selectedShift, required this.process})
      : super(key: key);

  @override
  State<StartShiftView> createState() => _StartShiftViewState();
}

class _StartShiftViewState extends State<StartShiftView> {
  final TextEditingController _controller = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    //startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(//8171999927660000
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children:  [
            Image.asset('assets/images/toplogo.png',height: 20,),
            SizedBox(
              height: 4,
            ),
             Text(
              widget.process.name!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 2,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TimerTopWidget(
                selectedShift: widget.selectedShift, timeElasped: timeElasped),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ExplainerWidget(
                iconName: 'construct',
                title: 'Workers',
                text1:
                    text1(),
                text2: '',
                showWarning: true,
                showIcon: true,
                backgroundColor: lightGreenColor,
                postIcon: Icons.check,
                postIconColor: Colors.green,
              ),
            ),
            //
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ExplainerWidget(
                iconName: 'construct',
                title: 'PPE',
                text1: '2/5 Planned PPE per Worker Type',
                text2: '',
                showWarning: true,
                showIcon: true,
                backgroundColor: lightRedColor,
              ),
            ),

            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Comments',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                ),
                minLines: 2,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                controller: _controller,
              ),
            ),


            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: TextButton(
                onPressed: () async {

                  if(_controller.text.isEmpty) {

                    showAlertDialog(
                      context: context,
                      title: 'Error',
                      message: 'Please add comment.',
                      actions: [
                        AlertDialogAction(
                          label: MaterialLocalizations.of(context)
                              .okButtonLabel,
                          key: OkCancelResult.ok,
                        )
                      ],
                    );
                    return;

                  }
                  await EasyLoading.show(
                    status: 'loading...',
                    maskType: EasyLoadingMaskType.black,
                  );

                  var result = await WorkersService.addShiftWorker(
                      widget.shiftId,
                      widget.processId,
                      widget.startTime,
                      widget.endTime,
                      widget.userId,
                      widget.efficiencyCalculation,_controller.text);

                  await EasyLoading.dismiss();

                  if (result != null) {

                    if(result.status == 'error') {

                      showAlertDialog(
                        context: context,
                        title: 'Error',
                        message: result.message,
                        actions: [
                          AlertDialogAction(
                            label: MaterialLocalizations.of(context)
                                .okButtonLabel,
                            key: OkCancelResult.ok,
                          )
                        ],
                      );

                      return;
                    }

                    if (result.code! == 200) {

                      final prefs = await SharedPreferences.getInstance();
                      prefs.setInt('shiftId', widget.selectedShift.id!);
                      prefs.setInt('processId', widget.processId);

                      prefs.setString(
                          'selectedShiftName', widget.selectedShift.name!);

                      prefs.setString('selectedShiftStartTime',
                          widget.selectedShift.startTime!);

                      prefs.setString('selectedShiftEndTime',
                          widget.selectedShift.endTime!);

                      prefs.setInt('selectedDisplayScreen',
                          widget.selectedShift.displayScreen!);

                      prefs.setInt('execute_shift_id',
                          result.data!.executeShiftId!);




                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => EndShiftView(
                              userId: widget.userId,
                              efficiencyCalculation:
                              widget.efficiencyCalculation,
                              shiftId: widget.shiftId,
                              processId: widget.processId,
                              selectedShift: widget.selectedShift,
                              process: widget.process,
                              execShiftId : result.data!.executeShiftId!
                          ),
                        ),
                      );
                    }
                  } else {
                    EasyLoading.showError('Could not load data');
                  }
                },
                child: Image.asset('assets/images/start_button.png'),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  String text1() {
    if(widget.process.headCount == null) {
      return'${widget.userId.length}/${widget.totalUsersCount} Workers';
    }
    return'${widget.userId.length}/${widget.process.headCount} Workers';
  }
}
