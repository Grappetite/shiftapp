import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/model/login_model.dart';

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

  String selectedString = "";
  int processIndexSelected = -1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getprocess();
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
                            });

                            processIndexSelected = process!
                                .map((e) => e.name!.trim())
                                .toList()
                                .indexOf(newString);

                            //final List<String> cityNames = cities.map((city) => city.name).toList();
                          },
                          placeHolderText: 'Process',
                          preSelected: selectedString,
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

                            //shifts!.data!.first.displayScreen = 3;

                            if (shifts == null) {
                              EasyLoading.showError('Could not load shifts');
                            } else {
                              if (shifts.data!.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => HomeView(
                                      selectedShift: shifts.data!.first,
                                      processSelected: processSelected,
                                    ),
                                  ),
                                );
                              }
                            }
                            print("object");

                            //getShifts
                            return;
                          },
                          text: 'NEXT',
                        ),
                      )
              ],
            ),
    );
  }

  void getprocess() async {
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
