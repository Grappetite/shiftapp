import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/screens/shift_start.dart';

import '../model/shifts_model.dart';
import '../services/workers_service.dart';
import 'edit_workers.dart';
import 'end_shift_final_screen.dart';

class EndShiftView extends StatefulWidget {
  final bool startedBefore;
  final int shiftId;
  final int processId;
  final List<String> userId;
  final List<String> efficiencyCalculation;
  final ShiftItem selectedShift;
  final String comment;


  const EndShiftView(
      {Key? key,
      required this.shiftId,
      required this.processId,
      required this.userId,
      required this.efficiencyCalculation,
      required this.selectedShift, this.comment = '', this.startedBefore = false})
      : super(key: key);

  @override
  State<EndShiftView> createState() => _EndShiftViewState();
}

class _EndShiftViewState extends State<EndShiftView> {
  String timeElasped = '00:00';
  late Timer _timer;
  int totalUsersCount = 0;
  int numberSelected = 0;

  String timeRemaining = '00:00';

  var isTimeOver = false;


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
  void initState() {
    super.initState();

    startTimer();


      loadUsers();


  }

  void loadUsers() async {

    var  responseShift = await WorkersService.getShiftWorkers(widget.selectedShift.id);

    numberSelected = responseShift!.data!.shiftWorker!.length;

    setState(() {
      totalUsersCount = responseShift.data!.shiftWorker!.length + responseShift.data!.worker!.length;
    });

    print('');



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
        leading: Container(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TimerTopWidget(
                selectedShift: widget.selectedShift, timeElasped: timeElasped),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kPrimaryColor,
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
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      isTimeOver ? ('TIME OVER : $timeRemaining') : ('TIME REMAINING: $timeRemaining'),
                      style: const TextStyle(
                          color: kPrimaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ExplainerWidget(
                iconName: 'construct',
                title: 'SOP REQUIRED',
                text1: '4 Workers requir SOP Training',
                text2: 'Tap to train now or swipe to ignore',
                showWarning: true,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ExplainerWidget(
              iconName: 'filled-walk',
              title: 'MANAGE WORKERS',
              text1:
                  '$numberSelected /$totalUsersCount Workers',
              text2: 'Tap to train now or swipe to ignore',
              showWarning: true,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditWorkers(
                      startTime: widget.selectedShift.startTime!,
                      processId: widget.processId,
                      endTime: widget.selectedShift.endTime!,
                      userId: [],
                      efficiencyCalculation: [],
                      shiftId: widget.shiftId,
                      totalUsersCount: widget.userId.length,
                      selectedShift: widget.selectedShift,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ExplainerWidget(
              iconName: 'exclamation',
              title: 'INCIDENTS',
              text1: '5',
              text2: 'Tap to train now or swipe to ignore',
              showWarning: false,
              text1_2: '01:50:00',
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  flex: 26,
                  child: Container(),
                ),
                Expanded(
                  flex: 52,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EndShiftFinalScreen(
                            startTime: widget.selectedShift.startTime!,
                            selectedShift: widget.selectedShift,
                            shiftId: widget.shiftId,
                            processId: widget.processId,
                            endTime: widget.selectedShift.endTime!,
                            comments: '',
                          ),
                        ),
                      );
                    },
                    child: Image.asset('assets/images/end-shift.png'),
                  ),
                ),
                Expanded(
                  flex: 26,
                  child: Container(),
                ),
              ],
            ),
            const SizedBox(
              height: 26,
            )
          ],
        ),
      ),
    );
  }
}

class ExplainerWidget extends StatelessWidget {
  final String iconName;
  final String title;
  final String text1;
  final String text1_2;
  final String text2;

  final VoidCallback? onTap;

  final IconData? postIcon;

  final Color backgroundColor;

  bool showIcon;

  final bool showWarning;

  final Color? postIconColor;

  ExplainerWidget({
    Key? key,
    required this.iconName,
    required this.title,
    required this.text1,
    required this.text2,
    this.showWarning = false,
    this.text1_2 = '',
    this.showIcon = false,
    this.backgroundColor = Colors.white,
    this.postIcon,
    this.postIconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
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
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  if (showIcon) ...[
                    Icon(
                      Icons.directions_walk,
                      size: MediaQuery.of(context).size.width / 12,
                      color: kPrimaryColor,
                    ),
                  ] else ...[
                    Image(
                      image: AssetImage('assets/images/$iconName.png'),
                      width: MediaQuery.of(context).size.width / 12,
                    ),
                  ],
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        if (text1_2.isNotEmpty) ...[
                          Row(
                            children: [
                              const Text(
                                'Incidents Recorded:',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                text1,
                                style: const TextStyle(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Downtime Recorded:',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                text1_2,
                                style: const TextStyle(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Text(
                            text1,
                            style: const TextStyle(
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                        if (text2.isNotEmpty) ...[
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            text2,
                            style: const TextStyle(
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  if (postIcon != null) ...[
                    Icon(
                      postIcon,
                      size: MediaQuery.of(context).size.width / 12,
                      color: postIconColor ?? Colors.cyan,
                    ),
                  ] else if (showWarning) ...[
                    Image(
                      image: const AssetImage('assets/images/warning.png'),
                      width: MediaQuery.of(context).size.width / 12,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
