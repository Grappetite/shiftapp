import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/model/shifts_model.dart';

import '../services/login_service.dart';
import '../widgets/drop_down.dart';
import '../widgets/elevated_button.dart';
import 'home.dart';

class DropDownPage extends StatefulWidget {
  DropDownPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DropDownPage> createState() => _DropDownPageState();
}

class _DropDownPageState extends State<DropDownPage> {
  List<Process>? process;
  List<ShiftItem>? shiftList = [];
  ShiftItem? selectedShift;
  String selectedString = "";
  int processIndexSelected = -1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProcess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: kPrimaryColor,
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: process == null
          ? Container()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage('assets/images/logo-colored.png'),
                  width: MediaQuery.of(context).size.width / 1.35,
                ),
                const SizedBox(
                  height: 24,
                ),
                process!.isEmpty
                    ? Container(
                        child: Center(child: Text("No process found")),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width / 1.21,
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Please select Process',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                process!.isEmpty
                    ? Container()
                    : const SizedBox(
                        height: 24,
                      ),
                process!.isEmpty
                    ? Container()
                    : SizedBox(
                        width: MediaQuery.of(context).size.width / 1.21,
                        child: DropDown(
                          labelText: 'Title',
                          currentList:
                              process!.map((e) => e.name!.trim()).toList(),
                          showError: false,
                          onChange: (newString) {
                            setState(() {
                              selectedString = newString;
                              shiftList = [];
                            });
                            processIndexSelected = process!
                                .map((e) => e.name!.trim())
                                .toList()
                                .indexOf(newString);
                          },
                          placeHolderText: 'Process',
                          preSelected: selectedString,
                        ),
                      ),
                shiftList!.isEmpty
                    ? Container()
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    shiftList!.forEach((element) {
                                      if (element.id == shiftList![index].id) {
                                        shiftList![index].started =
                                            !shiftList![index].started!;
                                        if (shiftList![index].started!) {
                                          selectedShift = shiftList![index];
                                        } else {
                                          selectedShift = null;
                                        }
                                      } else {
                                        element.started = false;
                                      }
                                    });
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: shiftList![index].started!
                                          ? lightGreenColor
                                          : lightBlueColor,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                            color: shiftList![index].started!
                                                ? lightGreenColor
                                                : lightBlueColor,
                                            spreadRadius: 4,
                                            blurRadius: 1),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 9,
                                              ),
                                              Text(
                                                shiftList![index]!.name!,
                                                style: const TextStyle(
                                                  color: kPrimaryColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 26,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 9,
                                              ),
                                              Text(
                                                // DateFormat('dd-MM-yyyy')
                                                //         .format(DateTime.parse(
                                                //             shiftsList![index]
                                                //                 .startTime!))
                                                //         .toString()
                                                //         .contains(DateFormat(
                                                //                 'dd-MM-yyyy')
                                                //             .format(
                                                //                 DateTime.now())
                                                //             .toString())
                                                //     ?
                                                "Scheduled Start Time: " +
                                                    DateFormat(
                                                            'HH:mm dd-MM-yyyy')
                                                        .format(DateTime.parse(
                                                            shiftList![index]
                                                                .startTime!))
                                                        .toString()
                                                // : "OverDue"
                                                ,
                                                style: const TextStyle(
                                                  color: kPrimaryColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 9,
                                              ),
                                              Text(
                                                "Scheduled End Time: " +
                                                    DateFormat(
                                                            'HH:mm dd-MM-yyyy')
                                                        .format(DateTime.parse(
                                                            shiftList![index]
                                                                .endTime!))
                                                        .toString(),
                                                style: const TextStyle(
                                                  color: kPrimaryColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 9,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    !shiftList![index].started!
                                                        ? Colors.white
                                                        : lightBlueColor),
                                            height: 20,
                                            width: 20,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Container(
                                  height: 10,
                                );
                              },
                              itemCount: shiftList!.length),
                        ),
                      ),
                process!.isEmpty
                    ? Container()
                    : Center(
                        child: PElevatedButton(
                          onPressed: () async {
                            if (processIndexSelected == -1) {
                              EasyLoading.showError('Please select a process');

                              return;
                            }
                            await EasyLoading.show(
                              status: 'loading...',
                              maskType: EasyLoadingMaskType.black,
                            );
                            var processSelected =
                                process![processIndexSelected];
                            var shifts = await LoginService.getShifts(
                                processSelected.id!);
                            await EasyLoading.dismiss();
                            if (shifts == null) {
                              EasyLoading.showError('Could not load shifts');
                            } else {
                              if (shifts.data!.isNotEmpty) {
                                if (shifts.data!.length == 1) {
                                  if (!shifts.data!.first.started!) {
                                    if (DateTime.now().isAfter(shifts
                                        .data!.first!.startDateObject
                                        .subtract(Duration(hours: 2)))) {
                                      if (DateTime.now().isBefore(
                                          shifts.data!.first!.endDateObject)) {
                                        shifts.data!.first!.displayScreen = 2;
                                      } else {
                                        shifts.data!.first!.displayScreen = 3;
                                      }
                                    } else {
                                      shifts.data!.first!.displayScreen = 3;
                                    }
                                    if (processSelected.type == "training") {
                                      shifts.data = [];
                                      shifts.data!.add(ShiftItem(
                                          id: 0,
                                          name: "Training",
                                          startTime: DateTime.now()
                                              .add(Duration(hours: 3))
                                              .toString(),
                                          endTime: DateTime.now()
                                              .add(Duration(hours: 3))
                                              .toString(),
                                          patternId: 0,
                                          breakTime: 60,
                                          shiftMinutes: 3600,
                                          shiftDuration: "Always",
                                          started: true));
                                      shifts.data!.first!.displayScreen = 3;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomeView(
                                          selectedShift: shifts.data!.first,
                                          processSelected: processSelected,
                                        ),
                                      ),
                                    ).then((value) {
                                      shiftList!.clear();
                                      setState(() {

                                    });
                                    });
                                  } else {
                                    EasyLoading.showError(
                                        'Shift already started by another supervisor');
                                  }
                                } else if (shiftList!.isEmpty) {
                                  if (processSelected.type == "training") {
                                    shifts.data = [];
                                    shifts.data!.add(ShiftItem(
                                        id: 0,
                                        name: "Training",
                                        startTime: DateTime.now()
                                            .add(Duration(hours: 3))
                                            .toString(),
                                        endTime: DateTime.now()
                                            .add(Duration(hours: 3))
                                            .toString(),
                                        patternId: 0,
                                        breakTime: 60,
                                        shiftMinutes: 3600,
                                        shiftDuration: "Always",
                                        started: true));
                                    shifts.data!.first!.displayScreen = 3;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomeView(
                                          selectedShift: shifts.data!.first,
                                          processSelected: processSelected,
                                        ),
                                      ),
                                    ).then((value) {
                                      shiftList!.clear();
                                      setState(() {

                                    });
                                    });
                                  } else {
                                    shiftList = shifts.data;
                                    setState(() {});
                                  }
                                } else if (selectedShift != null) {
                                  if (DateTime.now().isAfter(selectedShift!
                                      .startDateObject
                                      .subtract(Duration(hours: 2)))) {
                                    if (DateTime.now().isBefore(
                                        selectedShift!.endDateObject)) {
                                      selectedShift!.displayScreen = 2;
                                    } else {
                                      selectedShift!.displayScreen = 3;
                                    }
                                  } else {
                                    selectedShift!.displayScreen = 3;
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomeView(
                                        selectedShift: selectedShift!,
                                        processSelected: processSelected,
                                      ),
                                    ),
                                  ).then((value) {
                                    shiftList!.clear();
                                    setState(() {

                                    });
                                  });
                                } else {
                                  EasyLoading.showError('Please select shift');
                                }
                              }
                              else{
                                EasyLoading.showError('Could not load shifts');
                              }
                            }
                            // print("object");
                            return;
                          },
                          text: 'NEXT',
                        ),
                      )
              ],
            ),
    );
  }

  void getProcess() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      process = await LoginService.getProcess();
      setState(() {});
      await EasyLoading.dismiss();
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }
}
