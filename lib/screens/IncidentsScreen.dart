import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/main.dart';
import 'package:shiftapp/model/incident_model.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/model/shifts_model.dart';
import 'package:shiftapp/screens/AddIncident.dart';
import 'package:shiftapp/screens/StartedShiftList.dart';
import 'package:shiftapp/screens/end_shift.dart';
import 'package:shiftapp/screens/inner_widgets/HandOverShift.dart';
import 'package:shiftapp/screens/shift_start.dart';
import 'package:shiftapp/services/incident_service.dart';
import 'package:shiftapp/services/login_service.dart';
import 'package:shiftapp/services/shift_service.dart';
import 'package:shiftapp/services/workers_service.dart';
import 'package:shiftapp/widgets/elevated_button.dart';

class Incidents extends StatefulWidget {
  final ShiftItem selectedShift;
  final int execShiftId;
  final Process process;
  String totalDowntime;
  String totalIncident;

  Incidents({
    Key? key,
    required this.selectedShift,
    required this.execShiftId,
    required this.process,
    required this.totalDowntime,
    required this.totalIncident,
  }) : super(key: key);

  @override
  State<Incidents> createState() => _IncidentsState();
}

class _IncidentsState extends State<Incidents> {
  late AppPopupMenu<int> appMenu02;

  String timeElasped = '00:00';
  late Timer _timer;
  String timeRemaining = '00:00';

  var isTimeOver = false;

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
        if (mounted)
          setState(() {
            timeElasped = widget.selectedShift.timeElasped;
          });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appMenu02 = AppPopupMenu<int>(
      menuItems: [
        PopupMenuItem(
          value: 1,
          onTap: () async {
            await Future.delayed(Duration(seconds: 1), () async {
              var answer = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return HandOverShift(execShiftId: widget.execShiftId);
                  }).then((value) async {
                if (value) {
                  final prefs = await SharedPreferences.getInstance();
                  await flutterLocalNotificationsPlugin
                      .cancel(widget.execShiftId);

                  try {
                    List<String> test =
                        prefs.getStringList(widget.execShiftId.toString())!;
                    for (var ids in test) {
                      await flutterLocalNotificationsPlugin.cancel(int.parse(
                          widget.execShiftId.toString() + ids.toString()));
                    }
                  } finally {
                    prefs.remove(widget.execShiftId.toString());

                    prefs.remove('selectedShiftName');
                    prefs.remove('selectedShiftEndTime');
                    prefs.remove('selectedShiftStartTime');
                    _timer.cancel();
                    await Future.delayed(Duration(seconds: 1));
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => StartedShifts()),
                        (route) => false);
                  }
                }
              });
            });
          },
          child: const Text(
            'Transfer Shift',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          onTap: () async {
            await Future.delayed(Duration(seconds: 1), () async {
              var result = await showOkCancelAlertDialog(
                context: context,
                title: 'Warning',
                message: 'Are you sure you want to discard this shift?',
                okLabel: 'YES',
                cancelLabel: 'NO',
              );

              if (result.index == 1) {
                return;
              }

              String endTime =
                  DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

              ShiftService.cancelShift(this.widget.execShiftId, endTime);
              var process = await LoginService.getProcess();
              final prefs = await SharedPreferences.getInstance();
              await flutterLocalNotificationsPlugin.cancel(widget.execShiftId);
              try {
                List<String> test =
                    prefs.getStringList(widget.execShiftId.toString())!;
                for (var ids in test) {
                  await flutterLocalNotificationsPlugin.cancel(int.parse(
                      widget.execShiftId.toString() + ids.toString()));
                }
              } finally {
                prefs.remove('selectedShiftName');
                prefs.remove('selectedShiftEndTime');
                prefs.remove('selectedShiftStartTime');

                _timer.cancel();
                await Future.delayed(Duration(seconds: 1));
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => StartedShifts()),
                    (route) => false);
              }
            });
          },
          child: const Text(
            'Discard Shift',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
      initialValue: 0,
      onSelected: (int value) {},
      onCanceled: () {},
      elevation: 4,
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      offset: const Offset(0, 65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: kPrimaryColor,
    );
    getIncidents();
    startTimer();
  }

  IncidentsModel? incidentData;

  getIncidents() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    incidentData = await IncidentService.getIncident(
        widget.process.id!, widget.execShiftId);
    var shiftWorkerList =
        await WorkersService.getAllShiftWorkersList(widget.execShiftId);
    widget.totalDowntime =
        shiftWorkerList!.totalDowntime!.totalDowntime.toString();
    widget.totalIncident =
        shiftWorkerList!.totalDowntime!.totalIncident.toString();
    await EasyLoading.dismiss();

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          _timer.cancel();
          Navigator.pop(context);
          return Future.value(true);
        },
        child: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                  onTap: () {
                    _timer.cancel();
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              automaticallyImplyLeading: false,
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
              actions: [appMenu02],
            ),
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  TimerTopWidget(
                      selectedShift: widget.selectedShift,
                      timeElasped: timeElasped),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.warning_amber,
                            color: kPrimaryColor,
                          ),
                        ),
                        Text(
                          'INCIDENTS',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: lightBlueColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Color(0xFF0E577F), width: 1),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Downtime:".toUpperCase(),
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 60.0),
                                      child: Text(
                                        widget.totalDowntime,
                                        style: const TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  ]),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Incidents:".toUpperCase(),
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 60.0),
                                      child: Text(
                                        widget.totalIncident,
                                        style: const TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                    child: Text(
                      "Tap to record or update downtime if applicable",
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  incidentData != null
                      ? ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                TextEditingController controller =
                                    TextEditingController(
                                        text: incidentData!
                                                .data![index].downtime ??
                                            "Record Downtime");
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                            insetPadding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                            backgroundColor: Colors.transparent,
                                            content: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.15,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.25,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 3),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: Text(
                                                              "${incidentData!.data![index].incident!.name!} Incidents"
                                                                  .toUpperCase(),
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    kPrimaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: IconButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    false);
                                                              },
                                                              icon: const Icon(
                                                                Icons.close,
                                                                color:
                                                                    kPrimaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                // TextFormField(
                                                                //   controller:
                                                                //       controller,
                                                                //   decoration:
                                                                //       InputDecoration(
                                                                //     hintText:
                                                                //         "Record Downtime",
                                                                //     border:
                                                                //         OutlineInputBorder(
                                                                //       borderRadius:
                                                                //           BorderRadius
                                                                //               .all(
                                                                //         Radius.circular(
                                                                //             20.0),
                                                                //       ),
                                                                //       borderSide:
                                                                //           BorderSide(
                                                                //               color: Colors.black38),
                                                                //     ),
                                                                //     enabledBorder:
                                                                //         OutlineInputBorder(
                                                                //       borderRadius:
                                                                //           BorderRadius
                                                                //               .all(
                                                                //         Radius.circular(
                                                                //             20.0),
                                                                //       ),
                                                                //       borderSide:
                                                                //           BorderSide(
                                                                //               color: Colors.black38),
                                                                //     ),
                                                                //   ),
                                                                // ),
                                                                incidentData!
                                                                            .data![index]
                                                                            .isDowntime ==
                                                                        "Yes"
                                                                    ? Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.0,
                                                                            vertical:
                                                                                8),
                                                                        child:
                                                                            Text(
                                                                          "Down till",
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.grey[500],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(),

                                                                incidentData!
                                                                            .data![index]
                                                                            .isDowntime ==
                                                                        "Yes"
                                                                    ? GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          controller.text =
                                                                              DateTime.now().toString();
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
                                                                                        flex: 4,
                                                                                        child: CupertinoDatePicker(
                                                                                          mode: CupertinoDatePickerMode.dateAndTime,
                                                                                          initialDateTime: DateTime.now(),
                                                                                          onDateTimeChanged: (value) async {
                                                                                            controller.text = value.toString();
                                                                                          },
                                                                                          // initialDateTime:
                                                                                          //     DateTime
                                                                                          //         .now(),
                                                                                          minimumDate: widget.selectedShift.startDateObject,
                                                                                          maximumDate: DateTime.now(),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              }).then((value) => setState(() {}));
                                                                        },
                                                                        child: Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                                                                            child: Container(
                                                                                width: double.infinity,
                                                                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: const BorderRadius.all(Radius.circular(8))),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        controller.text.toString().split(".")[0].replaceAll("T", " "),
                                                                                        maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: const TextStyle(
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),
                                                                                      Icon(
                                                                                        Icons.access_time_outlined,
                                                                                        color: Colors.grey,
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ))),
                                                                      )
                                                                    : Container(),

                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          8),
                                                                  child: Text(
                                                                    "Date and Time",
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                              .grey[
                                                                          500],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0,
                                                                        vertical:
                                                                            8),
                                                                    child: Container(
                                                                        width: double.infinity,
                                                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: const BorderRadius.all(Radius.circular(8))),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 16,
                                                                              vertical: 16),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                incidentData!.data![index].createdAt.toString().split(".")[0].replaceAll("T", " "),
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                              Icon(
                                                                                Icons.access_time_outlined,
                                                                                color: Colors.grey,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ))),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          8),
                                                                  child: Text(
                                                                    "Description",
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                              .grey[
                                                                          500],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0,
                                                                        vertical:
                                                                            8),
                                                                    child: Container(
                                                                        width: double.infinity,
                                                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: const BorderRadius.all(Radius.circular(8))),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 16,
                                                                              vertical: 16),
                                                                          child:
                                                                              Text(
                                                                            incidentData!.data![index].details!,
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ))),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          8),
                                                                  child: Text(
                                                                    "Severity",
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                              .grey[
                                                                          500],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0,
                                                                        vertical:
                                                                            8),
                                                                    child: Container(
                                                                        width: double.infinity,
                                                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: const BorderRadius.all(Radius.circular(8))),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 16,
                                                                              vertical: 16),
                                                                          child:
                                                                              Text(
                                                                            incidentData!.data![index].incident!.name.toString().split(".")[0].replaceAll("T",
                                                                                " "),
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ))),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          8),
                                                                  child: Text(
                                                                    "Process",
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                              .grey[
                                                                          500],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0,
                                                                        vertical:
                                                                            8),
                                                                    child: Container(
                                                                        width: double.infinity,
                                                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: const BorderRadius.all(Radius.circular(8))),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 16,
                                                                              vertical: 16),
                                                                          child:
                                                                              Text(
                                                                            incidentData!.data![index].process!.name!,
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ))),
                                                                Container(
                                                                  height: 200,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0,
                                                                        vertical:
                                                                            8),
                                                                    child: ListView.separated(
                                                                        shrinkWrap: true,
                                                                        scrollDirection: Axis.horizontal,
                                                                        itemBuilder: (context, ind) {
                                                                          return Container(
                                                                            height:
                                                                                180,
                                                                            width:
                                                                                180,
                                                                            child: Image.network(incidentData!.data![index].images![ind].image!, errorBuilder: (BuildContext context,
                                                                                Object error,
                                                                                StackTrace? stackTrace) {
                                                                              return Container(
                                                                                  height: 180,
                                                                                  width: 180,
                                                                                  child: Stack(
                                                                                    children: [
                                                                                      Image.network("https://dev-shift.grappetite.com/images/logo/logo-m.png"),
                                                                                      Center(child: Text("Error"))
                                                                                    ],
                                                                                  ));
                                                                            }),
                                                                          );
                                                                        },
                                                                        separatorBuilder: (context, ind) {
                                                                          return Container(
                                                                            width:
                                                                                20,
                                                                          );
                                                                        },
                                                                        itemCount: incidentData!.data![index].images!.length),
                                                                  ),
                                                                )
                                                              ]),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: PElevatedButton(
                                                            shrink: true,
                                                            backGroundColor:
                                                                kPrimaryColor,
                                                            onPressed:
                                                                () async {
                                                              if (incidentData!
                                                                      .data![
                                                                          index]
                                                                      .isDowntime ==
                                                                  "Yes") {
                                                                await EasyLoading
                                                                    .show(
                                                                  status:
                                                                      'loading...',
                                                                  maskType:
                                                                      EasyLoadingMaskType
                                                                          .black,
                                                                );
                                                                await IncidentService.updateIncident(
                                                                    dateTimeIncident: controller
                                                                        .text
                                                                        .toString()
                                                                        .split(".")[
                                                                            0]
                                                                        .replaceAll(
                                                                            "T",
                                                                            " "),
                                                                    incidentId:
                                                                        incidentData!
                                                                            .data![index]
                                                                            .id);
                                                                await EasyLoading
                                                                    .dismiss();
                                                                Navigator.pop(
                                                                    context);
                                                                await getIncidents();
                                                              } else {
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            },
                                                            text: "Save"
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8.0,
                                                                vertical: 8),
                                                        child: PElevatedButton(
                                                          backGroundColor:
                                                              Colors.white,
                                                          shrink: true,
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          text: 'Cancel'
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF0E577F),
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )));
                                      });
                                    });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ExplainerWidget(
                                  // comingSoon: true,
                                  iconName: incidentData!
                                      .data![index]!.incidentType!.icon_url!,
                                  title: incidentData!
                                      .data![index].incident!.name!,
                                  text1:
                                      '${DateFormat("yyyy-MM-dd HH:mm").parse(incidentData!.data![index].createdAt!.replaceAll("T", " ")).toString().split(".")[0]}',
                                  text2: "Description: " +
                                      incidentData!.data![index].details!,
                                  showWarning: incidentData!
                                              .data![index].isDowntime ==
                                          "Yes"
                                      ? incidentData!.data![index].downtime !=
                                              null
                                          ? true
                                          : false
                                      : false,
                                  text1_2: incidentData!
                                              .data![index].isDowntime ==
                                          "Yes"
                                      ? incidentData!.data![index].downtime !=
                                              null
                                          ? '${DateTime.parse(incidentData!.data![index].downtime!).difference(DateTime.parse(incidentData!.data![index].createdAt!)).toString().split(".")[0]}'
                                          : "None:Tap to Record"
                                      : " ",
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              height: 15,
                            );
                          },
                          itemCount: incidentData!.data!.length!)
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: PElevatedButton(
                      backGroundColor: Colors.white,
                      shrink: true,
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddIncident(
                                      selectedShift: widget.selectedShift,
                                      execShiftId: widget.execShiftId,
                                      process: widget.process,
                                    ))).then((value) => getIncidents());
                      },
                      text: '+ record more incidents'.toUpperCase(),
                      style: TextStyle(color: Color(0xFF0E577F), fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PElevatedButton(
                        shrink: true,
                        backGroundColor: kPrimaryColor,
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        text: "Return to shift".toUpperCase(),
                        style: TextStyle(fontSize: 16)),
                  ),
                ]))));
  }
}
