import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shiftapp/services/shift_service.dart';

import '../../config/constants.dart';
import '../../model/login_model.dart';
import '../../widgets/drop_down.dart';
import '../../widgets/elevated_button.dart';

class HandOverShift extends StatefulWidget {
  const HandOverShift({Key? key, this.execShiftId}) : super(key: key);
  final int? execShiftId;
  @override
  State<HandOverShift> createState() => _HandOverShiftState();
}

class _HandOverShiftState extends State<HandOverShift> {
  List<User>? response;
  String selectedString = "";
  int processIndexSelected = -1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsersToTransfer();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        backgroundColor: Colors.transparent,
        content: Container(
          width: MediaQuery.of(context).size.width / 1.15,
          height: MediaQuery.of(context).size.height / 3.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey, width: 3),
          ),
          child: response != null
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          child: Text(
                            "Select User",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      DropDown(
                        labelText: 'User',
                        currentList: response!
                            .map((e) => e.fullName!.trim() as String)
                            .toList(),
                        showError: false,
                        onChange: (newString) {
                          setState(() {
                            selectedString = newString;

                            processIndexSelected = -1;
                          });

                          Future.delayed(Duration(milliseconds: 50), () {
                            processIndexSelected = response!
                                .map((e) => e.fullName!.trim())
                                .toList()
                                .indexOf(newString);
                            setState(() {});
                          });
                        },
                        placeHolderText: 'Select User',
                        preSelected: selectedString,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Are you sure you want to hand over the shift?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: PElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context, false);
                              },
                              text: 'NO',
                              backGroundColor: Colors.white,
                              textColor: kPrimaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: PElevatedButton(
                              onPressed: () async {
                                if (processIndexSelected != -1) {
                                  await EasyLoading.show(
                                    status: 'Moving...',
                                    maskType: EasyLoadingMaskType.black,
                                  );

                                  var response =
                                      await ShiftService.handOverShift(
                                          executionShiftId: widget.execShiftId!,
                                          userId: this
                                              .response![processIndexSelected]
                                              .id!);

                                  if (response) {
                                    await EasyLoading.dismiss();
                                    Navigator.pop(context, true);
                                  } else {
                                    await EasyLoading.dismiss();
                                  }
                                } else {
                                  EasyLoading.showError('Please select User');
                                }
                              },
                              text: 'YES',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(),
        ));
  }

  void getUsersToTransfer() async {
    await EasyLoading.show(
      status: 'Loading Users...',
      maskType: EasyLoadingMaskType.black,
    );

    response = await ShiftService.getOnlineUsers();
    setState(() {});
    await EasyLoading.dismiss();
  }
}
