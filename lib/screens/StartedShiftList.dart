import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/services/login_service.dart';
import 'package:shiftapp/services/shift_service.dart';

import '../config/constants.dart';
import '../model/shifts_model.dart';
import '../widgets/elevated_button.dart';
import 'NewDropdownPage.dart';
import 'home.dart';
import 'login.dart';

class StartedShifts extends StatefulWidget {
  StartedShifts({
    Key? key,
  }) : super(key: key);

  @override
  State<StartedShifts> createState() => _StartedShiftsState();
}

class _StartedShiftsState extends State<StartedShifts> {
  List<ShiftStartDetails>? shiftsList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getShiftsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage('assets/images/logo-colored.png'),
                    width: MediaQuery.of(context).size.width / 1.35,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Select Open Shift",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: shiftsList != null
                        ?
                        // shiftsList!.isEmpty
                        //         ? Container(
                        //             child: Center(
                        //               child: Text("No Shift Open"),
                        //             ),
                        //           )
                        //         :
                        RefreshIndicator(
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (shiftsList!.isEmpty) {
                                    return Container(
                                      height: 450,
                                      child: Center(
                                        child: Text("No Shift Open"),
                                      ),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      var shiftObject = ShiftItem(
                                        id: shiftsList![index].shiftId!,
                                        name:
                                            shiftsList![index].shiftItem!.name,
                                        startTime: shiftsList![index]
                                            .executeShiftStartTime,
                                        endTime: shiftsList![index]
                                            .executeShiftEndTime,
                                      );
                                      shiftObject.executedShiftId =
                                          shiftsList![index].executeShiftId;

                                      shiftObject.displayScreen = 2;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              HomeView(
                                            selectedShift: shiftObject,
                                            processSelected:
                                                shiftsList![index].process!,
                                            sessionStarted: true,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: lightGreenColor,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                              color: lightGreenColor,
                                              spreadRadius: 4,
                                              blurRadius: 1),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 9,
                                            ),
                                            Text(
                                              shiftsList![index].process!.name!,
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
                                              "Started at: " +
                                                  DateFormat('HH:mm dd-MM-yyyy')
                                                      .format(DateTime.parse(
                                                          shiftsList![index]
                                                              .executeShiftStartTime!))
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
                                            Text(
                                              "Scheduled End Time: " +
                                                  DateFormat('HH:mm dd-MM-yyyy')
                                                      .format(DateTime.parse(
                                                          shiftsList![index]
                                                              .executeShiftEndTime!))
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
                                            Text(
                                              "Status : " +
                                                  shiftsList![index]
                                                      .executeShiftStatus
                                                      .toString(),
                                              style: const TextStyle(
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Divider(
                                      height: 2,
                                    ),
                                  );
                                },
                                itemCount: shiftsList!.isEmpty
                                    ? 1
                                    : shiftsList!.length),
                            onRefresh: getShiftsList,
                          )
                        : Container(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  PElevatedButton(
                    text: 'START NEW SHIFT',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DropDownPage()));
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  PElevatedButton(
                    text: 'LOGOUT',
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.remove('selectedShiftName');
                      prefs.remove('selectedShiftEndTime');
                      prefs.remove('selectedShiftStartTime');
                      prefs.remove('password');
                      await LoginService.logout();
                      Get.offAll(LoginScreen());
                    },
                  ),
                ]),
          ),
        ));
  }

  Future getShiftsList() async {
    await EasyLoading.show(
      status: 'Getting Shifts...',
      maskType: EasyLoadingMaskType.black,
    );
    await LoginService.updateFcm();
    shiftsList = await ShiftService.startedShiftsList();
    setState(() {});
    await EasyLoading.dismiss();
  }

  @override
  void activate() {
    super.activate();
    getShiftsList();
  }
}
