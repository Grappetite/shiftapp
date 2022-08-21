import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/screens/shift_start.dart';

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

  const StartShiftView(
      {Key? key,
      required this.shiftId,
      required this.processId,
      required this.userId,
      required this.totalUsersCount,
      required this.startTime,
      required this.endTime,
      required this.efficiencyCalculation,
      required this.selectedShift})
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
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text(
              'Main Warehouse',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Receiving',
              style: TextStyle(
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
      body: Column(
        children: [
          TimerTopWidget(
              selectedShift: widget.selectedShift, timeElasped: timeElasped),
          const SizedBox(
            height: 16,
          ),
          ExplainerWidget(
            iconName: 'construct',
            title: 'Workers',
            text1:
                '${widget.userId.length}/${widget.totalUsersCount.toString()} Workers',
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
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setInt('shiftId', widget.selectedShift.id!);
                        prefs.setInt('processId', widget.processId);
                        prefs.setString('comment', _controller.text);

                        prefs.setString(
                            'selectedShiftName', widget.selectedShift.name!);

                        prefs.setString('selectedShiftStartTime',
                            widget.selectedShift.startTime!);

                        prefs.setString('selectedShiftEndTime',
                            widget.selectedShift.endTime!);

                        prefs.setInt('selectedDisplayScreen',
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
    );
  }
}
