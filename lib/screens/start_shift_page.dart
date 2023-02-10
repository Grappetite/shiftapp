import 'dart:async';
import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/screens/shift_start.dart';
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../services/workers_service.dart';
import 'end_shift.dart';
import 'inner_widgets/coming_soon_container.dart';

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
  bool? willpop = true;
  void startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted)setState(() {
          timeElasped = widget.selectedShift.timeElasped;
        });

        print('');
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(willpop);
      },
      child: Scaffold(
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 2,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                TimerTopWidget(
                    selectedShift: widget.selectedShift,
                    timeElasped: timeElasped),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ExplainerWidget(
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
                ),
                const SizedBox(
                  height: 16,
                ),
                ComingSoonContainer(
                  innerWidget: ExplainerWidget(
                    comingSoon: true,
                    iconName: 'construct',
                    title: 'PPE',
                    text1: '2/5 Planned PPE per Worker Type',
                    text2: '',
                    showWarning: true,
                    showIcon: true,
                    backgroundColor: lightRedColor,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
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
                      if (_controller.text.isEmpty && 1 == 2) {
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
                      if (mounted)setState(() {
                        willpop = false;
                      });
                      await EasyLoading.show(
                        status: 'loading...',
                        maskType: EasyLoadingMaskType.black,
                      );

                      var result = await WorkersService.addShiftWorker(
                          widget.shiftId,
                          widget.processId,

                          ///before at
                          widget.startTime,

                          ///after
                          widget.endTime,
                          widget.userId,
                          widget.efficiencyCalculation,
                          _controller.text);

                      await EasyLoading.dismiss();

                      if (result != null) {
                        if (result.status == 'error') {
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

                          prefs.setInt(
                              'execute_shift_id', result.data!.executeShiftId!);
                          if (prefs.getStringList(
                                  result.data!.executeShiftId!.toString()) ==
                              null) {
                            List<String> test = [];
                            var rng = Random();
                            for (var i = 1; i <= 25; i++) {
                              test.add(rng.nextInt(100000).toString());
                              await show(
                                  widget.selectedShift.endDateObject
                                      .add(Duration(hours: i)),
                                  int.parse(
                                      result.data!.executeShiftId!.toString() +
                                          test[i - 1].toString()),
                                  "Did you forget to end your shift?",
                                  "Your scheduled shift ended.  If you've completed today's work please end your shift.");
                            }
                            prefs.setStringList(
                                result.data!.executeShiftId!.toString(), test);
                          }

                          await show(
                              widget.selectedShift.endDateObject
                                  .subtract(Duration(minutes: 10)),
                              result.data!.executeShiftId!,
                              "Don't forget to end your shift!",
                              "Your shift is about to end, don't forget to register today's work.");

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
                                  execShiftId: result.data!.executeShiftId!),
                            ),
                          );
                        }
                      } else {
                        EasyLoading.showError('Could not load data');
                        if (mounted)setState(() {
                          willpop = true;
                        });
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

  tz.TZDateTime _nextInstanceOfNotification(String test) {
    tz.TZDateTime now =
        tz.TZDateTime.parse(tz.getLocation("Africa/Johannesburg"), test);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.getLocation("Africa/Johannesburg"),
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute);
    print("Notification Scheduled Date : " + "$scheduledDate");
    return scheduledDate;
  }

  show(
    DateTime chosen,
    id,
    title,
    body,
  ) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    print(await flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .toString());
    flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfNotification(chosen.toString()),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'your other channel id',
            'your other channel name',
            channelDescription: 'your other channel description',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidAllowWhileIdle: true,
        payload: "End Shift",
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }
}
