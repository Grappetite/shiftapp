import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/screens/StartedShiftList.dart';

import '../config/constants.dart';
import '../widgets/elevated_button.dart';

class EffeciencyView extends StatelessWidget {
  final Process? process;
  final effeciency;
  EffeciencyView({Key? key, this.process, this.effeciency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.offAll(StartedShifts());
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Get.offAll(StartedShifts());
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
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
                  process!.name!,
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   'Closed shift successfully',
                  //   style: const TextStyle(
                  //       color: mainBackGroundColor,
                  //       fontSize: 25,
                  //       fontWeight: FontWeight.w600),
                  // ),
                  Container(
                    height: MediaQuery.of(context).size.height / 5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kPrimaryColor,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kPrimaryColor,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                // bottomLeft: Radius.circular(16),
                                topRight: Radius.circular(15),
                                // bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Last Shift",
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        effeciency["yestEfficiency"] + "%",
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: kPrimaryColor,
                                  height:
                                      (MediaQuery.of(context).size.height / 4) /
                                          2.5,
                                  width: 5,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Best Efficiency",
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        effeciency["maxVale"] + "%",
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        // Divider(
                        //   height: 10,
                        //   color: kPrimaryColor,
                        //   thickness: 1,
                        // ),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Current Efficiency",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                effeciency["currentEfficiency"] + "%",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  PElevatedButton(
                    text: 'Back to Started Shifts',
                    onPressed: () async {
                      Get.offAll(StartedShifts());

                      // final prefs = await SharedPreferences.getInstance();
                      //
                      // prefs.remove('shiftId');
                      //
                      // prefs.remove('selectedShiftName');
                      // prefs.remove('selectedShiftEndTime');
                      // prefs.remove('selectedShiftStartTime');
                      // // prefs.remove('username');
                      // prefs.remove('password');
                      // await LoginService.logout();
                      // // var dyanc = await Navigator.pushReplacement(
                      // //   context,
                      // //   MaterialPageRoute(builder: (context) => const LoginScreen()),
                      // // );
                      // Get.offAll(LoginScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
