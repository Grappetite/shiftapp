import 'dart:math';

import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/BaseConfig.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/model/shifts_model.dart';
import 'package:shiftapp/model/sop_model.dart';
import 'package:shiftapp/screens/SelectTrainingWorker.dart';
import 'package:shiftapp/screens/SopsList.dart';
import 'package:shiftapp/screens/login.dart';
import 'package:shiftapp/services/login_service.dart';
import 'package:shiftapp/services/sop_service.dart';
import 'package:shiftapp/widgets/elevated_button.dart';
import 'package:shiftapp/widgets/pictureWithHeading.dart';

import '../model/login_model.dart';

class SopView extends StatefulWidget {
  SopView(
      {Key? key,
      required this.processSelected,
      required this.selectedShift,
      this.executionShiftId})
      : super(key: key);
  final Process processSelected;
  final ShiftItem selectedShift;
  final int? executionShiftId;

  @override
  State<SopView> createState() => _SopViewState();
}

class _SopViewState extends State<SopView> {
  late AppPopupMenu<int> appMenu02;
  SopModel? sopData;

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
    getSop(widget.processSelected.id);
  }

  String timeElasped = '00:00';
  String timeRemaining = '00:00';

  var isTimeOver = false;

  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              Image.asset(
                Environment()
                    .config.imageUrl,
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
          // Expanded(
          //   flex: 6,
          //   child: TimerTopWidget(
          //       selectedShift: widget.selectedShift, timeElasped: timeElasped),
          // ),
          // const SizedBox(
          //   height: 16,
          // ),
          Expanded(
            flex: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            textInputAction: TextInputAction.go,
                            controller: searchText,
                            enableSuggestions: false,
                            enableIMEPersonalizedLearning: false,
                            enableInteractiveSelection: false,
                            expands: false,
                            maxLines: 1,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              prefixIcon: Icon(Icons.search),
                              prefixIconColor: Colors.grey,
                              hintText: "Search",
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 0.0),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 0.0),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 0.0),
                              ),
                            ),
                            onChanged: (v) {
                              if (mounted)
                                setState(
                                  () {},
                                );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  sopData != null
                      ? sopData!.data!.length != 0
                          ? Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  if (searchText.text.isEmpty) {
                                    return pictureWithHeading(
                                        heading:
                                            "${sopData!.data![index].name}",
                                        subheading:
                                            "Updated: ${DateFormat("yyyy-MM-dd").parse(sopData!.data![index].updatedAt.toString()).toString().split(" ")[0]}",
                                        subheading2:
                                            "${sopData!.data![index].sopStep!.length} Steps",
                                        heading2: "",
                                        image: "assets/icon/icon_logo.jpg",
                                        assets: true,
                                        remaining: sopData!.data![index]
                                                    .trainingRequired !=
                                                0
                                            ? "Training required: ${sopData!.data![index].trainingRequired}"
                                            : "",
                                        suffix: sopData!.data![index]
                                                    .trainingRequired !=
                                                0
                                            ? Transform.rotate(
                                                angle: pi,
                                                child: Icon(
                                                  Icons.info_outline_rounded,
                                                  color: Colors.red,
                                                ),
                                              )
                                            : Icon(
                                                Icons
                                                    .check_circle_outline_sharp,
                                                color: Colors.green,
                                              ),
                                        onPress: () {
                                          showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                        insetPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 0, 0),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        content: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.15,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              2.75,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 3),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        "${sopData!.data![index].name}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              kPrimaryColor,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "${"Process:"}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                      Text(
                                                                        "${"Updated:"}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                      Text(
                                                                        "${"Steps:"}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "${"${widget.processSelected.name}"}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                      Text(
                                                                        "${DateFormat("yyyy-MM-dd").parse(sopData!.data![index].updatedAt.toString()).toString().split(" ")[0]}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                      Text(
                                                                        "${sopData!.data![index].sopStep!.length}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Spacer(),
                                                              PElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (sopData!
                                                                          .data![
                                                                              index]
                                                                          .trainingRequired !=
                                                                      0) {
                                                                    Navigator.of(context).push(MaterialPageRoute(
                                                                        builder: (context) => SelectTrainingWorker(
                                                                            processSelected:
                                                                                widget.processSelected,
                                                                            selectedShift: widget.selectedShift,
                                                                            heading: sopData!.data![index].name.toString(),
                                                                            sopDetail: sopData!.data![index],
                                                                            executionShiftId: widget.executionShiftId)));
                                                                  }
                                                                },
                                                                backGroundColor: sopData!
                                                                            .data![
                                                                                index]
                                                                            .trainingRequired !=
                                                                        0
                                                                    ? kPrimaryColor
                                                                    : Colors
                                                                        .grey,
                                                                text:
                                                                    'Train SOP${sopData!.data![index].trainingRequired != 0 ? "(${sopData!.data![index].trainingRequired})" : ""}',
                                                              ),
                                                              PElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.of(context).push(MaterialPageRoute(
                                                                      builder: (context) => SopsList(
                                                                          processSelected: widget
                                                                              .processSelected,
                                                                          selectedShift: widget
                                                                              .selectedShift,
                                                                          heading: sopData!.data![index].name
                                                                              .toString(),
                                                                          train:
                                                                              false,
                                                                          sopDetail: sopData!.data![
                                                                              index],
                                                                          executionShiftId:
                                                                              widget.executionShiftId)));
                                                                },
                                                                text:
                                                                    'View SOP',
                                                              ),
                                                              Spacer(),
                                                            ],
                                                          ),
                                                        ));
                                                  })
                                              .then((value) => getSop(
                                                  widget.processSelected.id));
                                        });
                                  } else if (sopData!.data![index].name!
                                      .toLowerCase()
                                      .contains(
                                          searchText.text.toLowerCase())) {
                                    return pictureWithHeading(
                                        heading:
                                            "${sopData!.data![index].name}",
                                        subheading:
                                            "Updated: ${DateFormat("yyyy-MM-dd").parse(sopData!.data![index].updatedAt.toString()).toString().split(" ")[0]}",
                                        subheading2:
                                            "${sopData!.data![index].sopStep!.length} Steps",
                                        heading2: "",
                                        image: "assets/icon/icon_logo.jpg",
                                        assets: true,
                                        remaining: sopData!.data![index]
                                                    .trainingRequired !=
                                                0
                                            ? "Training required: ${sopData!.data![index].trainingRequired}"
                                            : "",
                                        suffix: sopData!.data![index]
                                                    .trainingRequired !=
                                                0
                                            ? Icon(
                                                Icons.info_outline_rounded,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons
                                                    .check_circle_outline_sharp,
                                                color: Colors.green,
                                              ),
                                        onPress: () {
                                          showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                        insetPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 0, 0),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        content: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.15,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              2.75,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 3),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        "${sopData!.data![index].name}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              kPrimaryColor,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "${"Process:"}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                      Text(
                                                                        "${"Updated:"}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                      Text(
                                                                        "${"Steps:"}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "${"${widget.processSelected.name}"}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                      Text(
                                                                        "${DateFormat("yyyy-MM-dd").parse(sopData!.data![index].updatedAt.toString()).toString().split(" ")[0]}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                      Text(
                                                                        "${sopData!.data![index].sopStep!.length}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Spacer(),
                                                              PElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (sopData!
                                                                          .data![
                                                                              index]
                                                                          .trainingRequired !=
                                                                      0) {
                                                                    Navigator.of(context).push(MaterialPageRoute(
                                                                        builder: (context) => SelectTrainingWorker(
                                                                            processSelected:
                                                                                widget.processSelected,
                                                                            selectedShift: widget.selectedShift,
                                                                            heading: sopData!.data![index].name.toString(),
                                                                            sopDetail: sopData!.data![index],
                                                                            executionShiftId: widget.executionShiftId)));
                                                                  }
                                                                },
                                                                backGroundColor: sopData!
                                                                            .data![
                                                                                index]
                                                                            .trainingRequired !=
                                                                        0
                                                                    ? kPrimaryColor
                                                                    : Colors
                                                                        .grey,
                                                                text:
                                                                    'Train SOP${sopData!.data![index].trainingRequired != 0 ? "(${sopData!.data![index].trainingRequired})" : ""}',
                                                              ),
                                                              PElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.of(context).push(MaterialPageRoute(
                                                                      builder: (context) => SopsList(
                                                                          processSelected: widget
                                                                              .processSelected,
                                                                          selectedShift: widget
                                                                              .selectedShift,
                                                                          heading: sopData!.data![index].name
                                                                              .toString(),
                                                                          train:
                                                                              false,
                                                                          sopDetail: sopData!.data![
                                                                              index],
                                                                          executionShiftId:
                                                                              widget.executionShiftId)));
                                                                },
                                                                text:
                                                                    'View SOP',
                                                              ),
                                                              Spacer(),
                                                            ],
                                                          ),
                                                        ));
                                                  })
                                              .then((value) => getSop(
                                                  widget.processSelected.id));
                                        });
                                  } else {
                                    return Container();
                                  }
                                },
                                separatorBuilder: (context, index) {
                                  return Container();
                                },
                                itemCount: sopData!.data!.length,
                                shrinkWrap: true,
                              ),
                            )
                          : Expanded(child: Center(child: Text("No Sops")))
                      : Container(),
                ],
              ),
            ),
          )
        ]));
  }

  void getSop(int? id) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    sopData = await SOPService.getSops(id!,
        executionShiftId: widget.executionShiftId);
    await EasyLoading.dismiss();
    if (mounted) setState(() {});
  }
}
