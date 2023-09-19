import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiftapp/config/BaseConfig.dart';
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
                  Environment()
                      .config.imageUrl,
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
                                topRight: Radius.circular(15),
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
                                        (double.parse(effeciency["maxVale"]) >
                                                    double.parse(effeciency[
                                                        "currentEfficiency"])
                                                ? effeciency["maxVale"]
                                                : effeciency[
                                                    "currentEfficiency"]) +
                                            "%",
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
                    text: 'Back To Open Shifts',
                    onPressed: () async {
                      Get.offAll(StartedShifts());
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
