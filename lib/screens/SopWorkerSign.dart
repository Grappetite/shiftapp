import 'dart:async';
import 'dart:io';

import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:painter/painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/model/shifts_model.dart';
import 'package:shiftapp/model/sop_model.dart';
import 'package:shiftapp/model/workers_model.dart' as workerList;
import 'package:shiftapp/screens/login.dart';
import 'package:shiftapp/screens/shift_start.dart';
import 'package:shiftapp/services/login_service.dart';
import 'package:shiftapp/services/sop_service.dart';
import 'package:shiftapp/widgets/elevated_button.dart';

class SopWorkerSign extends StatefulWidget {
  SopWorkerSign({
    Key? key,
    required this.processSelected,
    required this.selectedShift,
    required this.sopDetail,
    required this.heading,
    this.executionShiftId,
    this.workerListToTrain,
  }) : super(key: key);
  final Process processSelected;
  final ShiftItem selectedShift;
  final List<workerList.ShiftWorker>? workerListToTrain;
  final Datum sopDetail;
  final String heading;
  final int? executionShiftId;

  @override
  State<SopWorkerSign> createState() => _SopWorkerSignState();
}

class _SopWorkerSignState extends State<SopWorkerSign> {
  late AppPopupMenu<int> appMenu02;
  PageController pageController = PageController(viewportFraction: 1);

  @override
  void initState() {
    // TODO: implement initState
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

  String timeElasped = '00:00';
  String timeRemaining = '00:00';

  var isTimeOver = false;


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
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline_sharp,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.heading} COMPLETED",
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: PageView.builder(
                        itemCount: widget.workerListToTrain!.length,
                        pageSnapping: true,
                        physics: NeverScrollableScrollPhysics(),
                        controller: pageController,
                        onPageChanged: (page) {
                          // setState(() {
                          //   activePage = page;
                          // });
                        },
                        itemBuilder: (context, pagePosition) {
                          widget.workerListToTrain![pagePosition]
                              .painterController.backgroundColor = Colors.white;
                          widget.workerListToTrain![pagePosition]
                              .painterController.drawColor = Colors.black;
                          widget.workerListToTrain![pagePosition]
                              .painterController.thickness = 5;
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4), // Border width
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: ClipOval(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(
                                              24), // Image radius
                                          child: Image.network(
                                              widget
                                                  .workerListToTrain![
                                                      pagePosition]
                                                  .picture,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.workerListToTrain![pagePosition].firstName} ${widget.workerListToTrain![pagePosition].lastName}",
                                          style: const TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${widget.workerListToTrain![pagePosition].key}",
                                          style: const TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "${widget.workerListToTrain![pagePosition].workerType}",
                                          style: const TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Color(0xFF0E577F),
                                                  width: 1),
                                            ),
                                            child: Text(
                                                "WORKER ${pagePosition + 1} of ${widget.workerListToTrain!.length}"),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: PElevatedButton(
                                                shrink: true,
                                                onPressed: () async {
                                                  pageController.nextPage(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    curve: Curves
                                                        .fastLinearToSlowEaseIn,
                                                  );
                                                  if (pagePosition ==
                                                      widget.workerListToTrain!
                                                              .length -
                                                          1) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }
                                                  // Navigator.of(context)
                                                  //     .push(MaterialPageRoute(
                                                  //         builder: (context) => SopsList(
                                                  //               processSelected:
                                                  //                   widget.processSelected,
                                                  //               selectedShift:
                                                  //                   widget.selectedShift,
                                                  //             )));
                                                },
                                                text: 'SKIP',
                                                style: TextStyle(fontSize: 15)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "WORKER SIGNATURE:",
                                  style: const TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 250,
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Color(0xFF0E577F), width: 1),
                                  ),
                                  child: Painter(
                                    widget.workerListToTrain![pagePosition]
                                        .painterController,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: PElevatedButton(
                                      shrink: true,
                                      onPressed: () async {
                                        widget.workerListToTrain![pagePosition]
                                            .painterController
                                            .clear();
                                        // setState(() {});
                                      },
                                      text: 'CLEAR SIGNATURE',
                                      style: TextStyle(fontSize: 15)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    "I have received adequate training in the ${widget.heading}"),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: PElevatedButton(
                                      shrink: true,
                                      onPressed: () async {
                                        await EasyLoading.show(
                                          status: 'loading...',
                                          maskType: EasyLoadingMaskType.black,
                                        );
                                        PictureDetails pictureDetails = widget
                                            .workerListToTrain![pagePosition]
                                            .painterController
                                            .finish();
                                        // String link =
                                        //     await FirebaseClient.submitPicture(await pictureDetails.toPNG(), 'png');
                                        List<int> imageBytes =
                                            (await pictureDetails.toPNG());

                                        String tempPath =
                                            (await getTemporaryDirectory()).path;
                                        File file = File(
                                            '$tempPath/${DateTime.now().microsecondsSinceEpoch}.png');
                                        await file.writeAsBytes(imageBytes);

                                        await SOPService.postSign(
                                          file,
                                          widget.sopDetail,
                                          widget.workerListToTrain![pagePosition],
                                          executionShiftId:
                                              widget.executionShiftId,
                                        );
                                        await EasyLoading.dismiss();
                                        pageController.nextPage(
                                          duration: Duration(seconds: 1),
                                          curve: Curves.fastLinearToSlowEaseIn,
                                        );
                                        if (pagePosition ==
                                            widget.workerListToTrain!.length -
                                                1) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                        // Navigator.of(context)
                                        //     .push(MaterialPageRoute(
                                        //         builder: (context) => SopsList(
                                        //               processSelected:
                                        //                   widget.processSelected,
                                        //               selectedShift:
                                        //                   widget.selectedShift,
                                        //             )));
                                      },
                                      text: 'I AGREE',
                                      style: TextStyle(fontSize: 15)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                PElevatedButton(
                                  backGroundColor: Colors.white,
                                  shrink: true,
                                  onPressed: () async {
                                    pageController.nextPage(
                                      duration: Duration(seconds: 1),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                    );
                                    if (pagePosition ==
                                        widget.workerListToTrain!.length - 1) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                    // Navigator.of(context)
                                    //     .push(MaterialPageRoute(
                                    //         builder: (context) => SopsList(
                                    //               processSelected:
                                    //                   widget.processSelected,
                                    //               selectedShift:
                                    //                   widget.selectedShift,
                                    //             )));
                                    // Navigator.pop(context);
                                  },
                                  text: 'DECLINE',
                                  style: TextStyle(
                                      color: Color(0xFF0E577F), fontSize: 15),
                                )
                              ],
                            ),
                          );
                        }),
                  )
                ])),
          )
        ]));
  }
}
