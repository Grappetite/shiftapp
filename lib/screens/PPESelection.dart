import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/model/ppe_model.dart';
import 'package:shiftapp/model/shifts_model.dart';
import 'package:shiftapp/model/workers_model.dart';
import 'package:shiftapp/screens/inner_widgets/index_indicator.dart';
import 'package:shiftapp/screens/inner_widgets/worker_item_view.dart';
import 'package:shiftapp/screens/shift_start.dart';
import 'package:shiftapp/screens/start_shift_page.dart';
import 'package:shiftapp/services/ppe_service.dart';
import 'package:shiftapp/widgets/elevated_button.dart';
import 'package:shiftapp/widgets/pictureWithHeading.dart';

class PPESelection extends StatefulWidget {
  final int shiftId;
  final int processId;
  final List<String> userId;
  final int totalUsersCount;
  final String startTime;
  final String endTime;
  List<List<ShiftWorker>> listLists;

  final List<String> efficiencyCalculation;
  final ShiftItem selectedShift;
  final Process process;

  PPESelection(
      {Key? key,
      required this.shiftId,
      required this.processId,
      required this.listLists,
      required this.userId,
      required this.totalUsersCount,
      required this.startTime,
      required this.endTime,
      required this.efficiencyCalculation,
      required this.selectedShift,
      required this.process})
      : super(key: key);

  @override
  State<PPESelection> createState() => _PPESelectionState();
}

class _PPESelectionState extends State<PPESelection> {
  int workersSelected = 0;

  String workersLabel = 'PPE';

  // String get workerSelected {
  //   var workersSelectedInt = 0;
  //
  //   for (var currenList in widget.listLists) {
  //     for (var currentObject in currenList) {
  //       if (currentObject.isSelected) {
  //         workersSelectedInt = workersSelectedInt + 1;
  //       }
  //     }
  //   }
  //
  //   return workersSelectedInt.toString();
  // }
  PpeModel? ppeData;

  @override
  void initState() {
    getPpe(widget.processId);
    super.initState();
  }

  void getPpe(int? id) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    ppeData = await PPEService.getPPE(
      id!,
    );
    ppeData!.data!.removeWhere((element) {
      if (element.count == 0) {
        return true;
      }
      return false;
    });
    // ppeData!.data!.addAll(ppeData!.data!);
    await EasyLoading.dismiss();

    if (mounted) setState(() {});
  }

  List<String> workerIds = [];

  TextEditingController _controller = new TextEditingController();
  TextEditingController _controllerAlert = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/toplogo.png',
                    height: 20,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.process.name!,
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
            ],
          ),
        ),
        body: !EasyLoading.isShow
            ? Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TimerTopWidget(
                        selectedShift: widget.selectedShift,
                        timeElasped: "00:00",
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: Colors.grey, width: 3),
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Image(
                                                  image: const AssetImage(
                                                      'assets/images/construct.png'),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      18,
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Text(
                                                  workersLabel,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(),
                                                ),
                                                IndexIndicator(
                                                  total: 3,
                                                  currentIndex: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "CONFIRM WORKERS WEARING PPE",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          // Container(
                                          //   height: MediaQuery.of(context)
                                          //           .size
                                          //           .height /
                                          //       2.9,
                                          //   child:
                                          ListView.separated(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    _controllerAlert.clear();
                                                    ppeData!.data![index]
                                                            .ppeCheckBoxSelected =
                                                        false;
                                                    await showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                            return AlertDialog(
                                                                insetPadding:
                                                                    const EdgeInsets.fromLTRB(
                                                                        0, 0, 0, 0),
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                content:
                                                                    Container(
                                                                        width: MediaQuery.of(context).size.width /
                                                                            1.15,
                                                                        height: !ppeData!.data![index].ppeCheckBoxSelected!
                                                                            ? MediaQuery.of(context).size.height /
                                                                                1.75
                                                                            : MediaQuery.of(context).size.height /
                                                                                1.25,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(16),
                                                                          border: Border.all(
                                                                              color: Colors.grey,
                                                                              width: 3),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 8),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                                      child: Text(
                                                                                        "${ppeData!.data![index].name!} REQUIRED PPE".toUpperCase(),
                                                                                        style: const TextStyle(
                                                                                          color: kPrimaryColor,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: 18,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Align(
                                                                                    alignment: Alignment.topRight,
                                                                                    child: IconButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context, false);
                                                                                      },
                                                                                      icon: const Icon(
                                                                                        Icons.close,
                                                                                        color: kPrimaryColor,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              height: 10,
                                                                            ),
                                                                            Expanded(
                                                                                child: ListView.separated(
                                                                                    itemBuilder: (context, position) {
                                                                                      return pictureWithHeading(heading: ppeData!.data![index].details![position].name, subheading: ppeData!.data![index].details![position].itemnumber, image: ppeData!.data![index].details![position].imageUrl, assets: false);
                                                                                    },
                                                                                    separatorBuilder: (context, position) {
                                                                                      return Container(
                                                                                        height: 5,
                                                                                      );
                                                                                    },
                                                                                    itemCount: ppeData!.data![index].details!.length)),

                                                                            // pictureWithHeading(heading: "Standard safety", subheading: "P00126", image: "assets/icon/icon_logo.jpg", assets: true),
                                                                            // pictureWithHeading(heading: "Standard safety", subheading: "P00126", image: "assets/icon/icon_logo.jpg", assets: true),
                                                                            // pictureWithHeading(heading: "Standard safety", subheading: "P00126", image: "assets/icon/icon_logo.jpg", assets: true),
                                                                            CheckboxListTile(
                                                                              title: Text(
                                                                                "Listed PPE is incorrect and needs updates.",
                                                                                style: TextStyle(color: kPrimaryColor),
                                                                              ),
                                                                              value: ppeData!.data![index].ppeCheckBoxSelected!,
                                                                              onChanged: (newValue) {
                                                                                ppeData!.data![index].ppeCheckBoxSelected = newValue!;
                                                                                setState(() {});
                                                                              },
                                                                              controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            ppeData!.data![index].ppeCheckBoxSelected!
                                                                                ? Padding(
                                                                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                                                                                    child: Text(
                                                                                      'Discrepancy Comments',
                                                                                      style: TextStyle(
                                                                                        color: kPrimaryColor,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : Container(),
                                                                            ppeData!.data![index].ppeCheckBoxSelected!
                                                                                ? Padding(
                                                                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
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
                                                                                      controller: _controllerAlert,
                                                                                    ),
                                                                                  )
                                                                                : Container(),
                                                                            ppeData!.data![index].ppeCheckBoxSelected!
                                                                                ? SizedBox(
                                                                                    height: 10,
                                                                                  )
                                                                                : Container(),
                                                                            Center(
                                                                              child: PElevatedButton(
                                                                                onPressed: () async {
                                                                                  if (ppeData!.data![index].ppeCheckBoxSelected!) {
                                                                                    await EasyLoading.show(
                                                                                      status: 'loading...',
                                                                                      maskType: EasyLoadingMaskType.black,
                                                                                    );
                                                                                    await PPEService.postPpe(check: ppeData!.data![index].ppeCheckBoxSelected, ppe: ppeData!.data![index], comment: _controllerAlert.text, processId: widget.processId);
                                                                                    await EasyLoading.dismiss();
                                                                                    Navigator.pop(context);
                                                                                  } else {
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                },
                                                                                text: 'Continue'.toUpperCase(),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )));
                                                          });
                                                          // ChangeShiftTime(
                                                          // sop: true,
                                                          // );
                                                        });
                                                  },
                                                  child: UserItem(
                                                    keyNo: ppeData!
                                                            .data![index].count!
                                                            .toString() +
                                                        " PPE Required",
                                                    ppe: true,
                                                    personName: ppeData!
                                                        .data![index].name!,
                                                    initialSelected: ppeData!
                                                        .data![index].selected!,
                                                    picUrl: null,
                                                    changedStatus:
                                                        (bool newStatus) async {
                                                      ppeData!.data![index]
                                                          .selected = newStatus;
                                                    },
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return Container(
                                                  height: 20,
                                                );
                                              },
                                              itemCount: ppeData!.data!.length),
                                          // ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'Discrepancy Comments',
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                hintText: 'Enter Comments',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                      color: Colors.black38),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                      color: Colors.black38),
                                                ),
                                              ),
                                              minLines: 2,
                                              maxLines: 3,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              controller: _controller,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: PElevatedButton(
                                              onPressed: () async {
                                                workerIds = [];

                                                List<String> startTime = [];

                                                List<String>
                                                    efficiencyCalculation = [];
                                                String dateString = DateFormat(
                                                        "yyyy-MM-dd HH:mm:ss")
                                                    .format(DateTime.now());

                                                if (mounted)
                                                  setState(() {
                                                    for (var curentItem
                                                        in widget.listLists) {
                                                      for (var currentObject
                                                          in curentItem) {
                                                        if (currentObject
                                                            .isSelected) {
                                                          workerIds.add(
                                                              currentObject.id!
                                                                  .toString());
                                                          startTime
                                                              .add(dateString);
                                                          efficiencyCalculation
                                                              .add(currentObject
                                                                  .efficiencyCalculation!
                                                                  .toString());
                                                        }
                                                      }
                                                    }
                                                  });

                                                int totalCountTemp = 0;
                                                for (var currentItem
                                                    in widget.listLists) {
                                                  totalCountTemp =
                                                      totalCountTemp +
                                                          currentItem.length;
                                                }

                                                if (workerIds.isEmpty) {
                                                  return;
                                                }
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        StartShiftView(
                                                      shiftId: widget
                                                          .selectedShift!.id!,
                                                      endTime: widget
                                                          .selectedShift!
                                                          .endTime!,
                                                      processId:
                                                          widget.processId,
                                                      startTime: widget
                                                          .selectedShift!
                                                          .startTime!,
                                                      efficiencyCalculation:
                                                          efficiencyCalculation,
                                                      userId: workerIds,
                                                      totalUsersCount:
                                                          totalCountTemp,
                                                      selectedShift:
                                                          widget.selectedShift!,
                                                      process:
                                                          this.widget.process,
                                                      discrepancyComment:
                                                          _controller.text,
                                                      ppe: ppeData,
                                                    ),
                                                  ),
                                                );
                                              },
                                              text: 'Continue'.toUpperCase(),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: PElevatedButton(
                                              onPressed: () async {
                                                // Navigator.pop(context);
                                                Navigator.of(context).popUntil(
                                                    (route) => route.isFirst);
                                                // Navigator.popUntil(context, (route) => StartedShifts());
                                              },
                                              text: 'Cancel Shift Start'
                                                  .toUpperCase(),
                                            ),
                                          ),
                                        ],
                                      )),
                                ))),
                      ),
                    ]),
              )
            : Container());
  }
}
