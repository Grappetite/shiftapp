import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/screens/shift_start.dart';

import '../Network/API.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../services/workers_service.dart';
import 'end_shift.dart';

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
      required this.selectedShift,
      required this.process})
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
    return Scaffold(
      //8171999927660000
      resizeToAvoidBottomInset: true,
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
            ExplainerWidget(
              iconName: 'construct',
              title: 'Workers',
              text1: text1(),
              text2: '',
              showWarning: true,
              showIcon: true,
              backgroundColor: lightGreenColor,
              postIcon: Icons.check,
              postIconColor: Colors.green,
            ),
            //
            const SizedBox(
              height: 16,
            ),
            ExplainerWidget(
              iconName: 'construct',
              title: 'PPE',
              text1: '2/5 Planned PPE per Worker Type',
              text2: '',
              showWarning: true,
              showIcon: true,
              backgroundColor: lightRedColor,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
              ),
            ),

            Row(
              children: [
                Expanded(
                  flex: 22,
                  child: Container(),
                ),
                Expanded(
                  flex: 56,
                  child: TextButton(
                    onPressed: () async {
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
                          widget.efficiencyCalculation);

                      await EasyLoading.dismiss();

                      if (result != null) {
                        if (result.code! == 200) {
                          //final prefs = await SharedPreferences.getInstance();
                          Api().sp.write('shiftId', widget.selectedShift.id!);
                          Api().sp.write('processId', widget.processId);
                          Api().sp.write('comment', _controller.text);

                          Api().sp.write(
                              'selectedShiftName', widget.selectedShift.name!);

                          Api().sp.write('selectedShiftStartTime',
                              widget.selectedShift.startTime!);

                          Api().sp.write('selectedShiftEndTime',
                              widget.selectedShift.endTime!);

                          Api().sp.write('selectedDisplayScreen',
                              widget.selectedShift.displayScreen!);

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
                                comment: _controller.text,
                                process: widget.process,
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
                Expanded(
                  flex: 22,
                  child: Container(),
                ),
              ],
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
    if (widget.process.headCount == null) {
      return '${widget.userId.length}/${widget.totalUsersCount} Workers';
    }
    return '${widget.userId.length}/${widget.process.headCount} Workers';
  }
}
