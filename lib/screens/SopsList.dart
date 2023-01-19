import 'dart:async';

import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/model/shifts_model.dart';
import 'package:shiftapp/model/sop_model.dart';
import 'package:shiftapp/model/workers_model.dart' as workerList;
import 'package:shiftapp/screens/SelectTrainingWorker.dart';
import 'package:shiftapp/screens/SopWorkerSign.dart';
import 'package:shiftapp/screens/login.dart';
import 'package:shiftapp/screens/shift_start.dart';
import 'package:shiftapp/widgets/elevated_button.dart';

import '../model/login_model.dart';
import '../services/login_service.dart';

class SopsList extends StatefulWidget {
  const SopsList(
      {Key? key,
      required this.processSelected,
      required this.selectedShift,
      required this.sopDetail,
      required this.heading,
      required this.train,
      this.workerListToTrain,
      this.executionShiftId})
      : super(key: key);
  final Process processSelected;
  final ShiftItem selectedShift;
  final List<workerList.ShiftWorker>? workerListToTrain;
  final Datum sopDetail;
  final String heading;
  final bool train;
  final int? executionShiftId;

  @override
  State<SopsList> createState() => _SopsListState();
}

class _SopsListState extends State<SopsList> {
  late AppPopupMenu<int> appMenu02;

  @override
  void initState() {
    super.initState();
    appMenu02 = AppPopupMenu<int>(
      menuItems: [
        PopupMenuItem(
          value: 1,
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.remove('selectedShiftName');
            prefs.remove('selectedShiftEndTime');
            prefs.remove('selectedShiftStartTime');
            prefs.remove('password');
            await LoginService.logout();
            Get.offAll(LoginScreen());
          },
          child: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
      initialValue: 2,
      onSelected: (int value) {},
      onCanceled: () {},
      elevation: 4,
      icon: const Icon(Icons.more_vert),
      offset: const Offset(0, 65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: kPrimaryColor,
    );
  }

  late Timer _timer;
  String timeElasped = '00:00';
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
    print('');
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
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.processSelected.name!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 2,
              ),
            ],
          ),
          actions: [appMenu02],
        ),
        body: Column(children: [
          // TimerTopWidget(
          //     selectedShift: widget.selectedShift, timeElasped: timeElasped),
          Expanded(
            child: PageView.builder(
                itemCount: widget.sopDetail.sopStep!.length,
                pageSnapping: true,
                controller: PageController(viewportFraction: 0.85),
                onPageChanged: (page) {
                },
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, pagePosition) {
                  var workers = "";
                  widget.sopDetail.sopStep![pagePosition].sopWorkerType!
                      .forEach((element) {
                    workers += "${element.name} \n";
                  });

                  return Container(
                    width: MediaQuery.of(context).size.width / 1.15,
                    height: MediaQuery.of(context).size.height / 3.75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey, width: 3),
                    ),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.heading}",
                            style: const TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: "Step",
                              style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: " ${pagePosition + 1}",
                              style: const TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: " of",
                              style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: " ${widget.sopDetail.sopStep!.length}",
                              style: const TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ])),
                          SizedBox(
                            height: 10,
                          ),
                          widget.train &&
                                  pagePosition ==
                                      widget.sopDetail.sopStep!.length - 1
                              ? Container(
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: [
                                    Expanded(
                                      child: PElevatedButton(
                                          shrink: true,
                                          onPressed: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => SopWorkerSign(
                                                        processSelected: widget
                                                            .processSelected,
                                                        selectedShift: widget
                                                            .selectedShift,
                                                        heading: widget
                                                            .sopDetail.name
                                                            .toString(),
                                                        sopDetail:
                                                            widget.sopDetail,
                                                        workerListToTrain: widget
                                                            .workerListToTrain,
                                                        executionShiftId: widget
                                                            .executionShiftId)));
                                          },
                                          text:
                                              'Complete Training'.toUpperCase(),
                                          style: TextStyle(fontSize: 15)),
                                    ),
                                  ]))
                              : Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: lightBlueColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Color(0xFF0E577F), width: 1),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.train
                                            ? "Training SOP: ${widget.workerListToTrain!.length} Workers"
                                            : "Viewing SOP",
                                        style: const TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      widget.train
                                          ? Expanded(
                                              child: PElevatedButton(
                                                backGroundColor: Colors.white,
                                                shrink: true,
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                                text: 'STOP',
                                                style: TextStyle(
                                                    color: Color(0xFF0E577F),
                                                    fontSize: 8),
                                              ),
                                            )
                                          : Expanded(
                                              child: PElevatedButton(
                                                  shrink: true,
                                                  backGroundColor: widget
                                                              .sopDetail
                                                              .trainingRequired !=
                                                          0
                                                      ? kPrimaryColor
                                                      : Colors.grey,
                                                  onPressed: () async {
                                                    if (widget.sopDetail
                                                            .trainingRequired !=
                                                        0) {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) => SelectTrainingWorker(
                                                                  processSelected:
                                                                      widget
                                                                          .processSelected,
                                                                  selectedShift:
                                                                      widget
                                                                          .selectedShift,
                                                                  heading: widget
                                                                      .sopDetail
                                                                      .name
                                                                      .toString(),
                                                                  sopDetail: widget
                                                                      .sopDetail,
                                                                  executionShiftId:
                                                                      widget
                                                                          .executionShiftId
                                                                  )));
                                                    }
                                                  },
                                                  text:
                                                      'Train ${widget.sopDetail.trainingRequired != 0 ? "(${widget.sopDetail.trainingRequired})" : ""}',
                                                  style:
                                                      TextStyle(fontSize: 8)),
                                            ),
                                      widget.train
                                          ? Container()
                                          : SizedBox(
                                              width: 10,
                                            ),
                                      widget.train
                                          ? Container()
                                          : Expanded(
                                              child: PElevatedButton(
                                                backGroundColor: Colors.white,
                                                shrink: true,
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                                text: 'Close',
                                                style: TextStyle(
                                                    color: Color(0xFF0E577F),
                                                    fontSize: 8),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Text(
                              "Step Name",
                              style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Text(
                              "${widget.sopDetail.sopStep![pagePosition].name}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          widget.sopDetail.sopStep![pagePosition].detail != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 8.0),
                                  child: Text(
                                    "Description",
                                    style: const TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : Container(),
                          widget.sopDetail.sopStep![pagePosition].detail != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 8.0),
                                  child: Html(
                                    data:
                                        "${widget.sopDetail.sopStep![pagePosition].detail}",
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Text(
                              "Worker Type",
                              style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Text(
                              "${workers}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Text(
                              "Equipments required",
                              style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Text(
                              "${widget.sopDetail.sopStep![pagePosition].equipment}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Text(
                              "Photo",
                              style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Container(
                              height: 260,
                              width: 260,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "${widget.sopDetail.sopStep![pagePosition].imageUrl}"),
                                      fit: BoxFit.fill)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ]));
  }
}
