import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/main.dart';
import 'package:shiftapp/model/incident_model.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/model/shifts_model.dart';
import 'package:shiftapp/model/workers_model.dart';
import 'package:shiftapp/screens/StartedShiftList.dart';
import 'package:shiftapp/screens/inner_widgets/HandOverShift.dart';
import 'package:shiftapp/screens/inner_widgets/worker_item_view.dart';
import 'package:shiftapp/screens/shift_start.dart';
import 'package:shiftapp/services/incident_service.dart';
import 'package:shiftapp/services/login_service.dart';
import 'package:shiftapp/services/shift_service.dart';
import 'package:shiftapp/widgets/drop_down.dart';
import 'package:shiftapp/widgets/elevated_button.dart';

class AddIncident extends StatefulWidget {
  final ShiftItem selectedShift;
  final int execShiftId;
  final Process process;

  const AddIncident({
    Key? key,
    required this.selectedShift,
    required this.execShiftId,
    required this.process,
  }) : super(key: key);

  @override
  State<AddIncident> createState() => _AddIncidentState();
}

class _AddIncidentState extends State<AddIncident> {
  late AppPopupMenu<int> appMenu02;
  String timeElasped = '00:00';
  late Timer _timer;
  String timeRemaining = '00:00';
  var incidentTypeIndexSelected = -1;
  List<IncidentType> incidentType = [];
  var selectedIncidentTypeString = "";
  List<IncidentType> severity = [];
  List<ShiftWorker> sectionManagers = [];
  List selectedWorker = [];
  bool isDowntime = true;
  var selectedSeverityTypeString = "";
  var selectedIsDowntime = "";
  var severityIndexSelected = -1;
  var isTimeOver = false;
  List? imageFileList;

  void _setImageFileListFromFile(XFile? value) {
    imageFileList = (value == null ? null : <dynamic>[value])!;
  }

  dynamic _pickImageError;
  TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String dateTimeIncident = DateTime.now().toString();

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
  }

  @override
  void initState() {
    // TODO: implement initState
    appMenu02 = AppPopupMenu<int>(
      menuItems: [
        PopupMenuItem(
          value: 1,
          onTap: () async {
            await Future.delayed(Duration(seconds: 1), () async {
              var answer = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return HandOverShift(execShiftId: widget.execShiftId);
                  }).then((value) async {
                if (value) {
                  final prefs = await SharedPreferences.getInstance();
                  await flutterLocalNotificationsPlugin
                      .cancel(widget.execShiftId);

                  try {
                    List<String> test =
                        prefs.getStringList(widget.execShiftId.toString())!;
                    for (var ids in test) {
                      await flutterLocalNotificationsPlugin.cancel(int.parse(
                          widget.execShiftId.toString() + ids.toString()));
                    }
                  } finally {
                    prefs.remove(widget.execShiftId.toString());

                    prefs.remove('selectedShiftName');
                    prefs.remove('selectedShiftEndTime');
                    prefs.remove('selectedShiftStartTime');
                    _timer.cancel();
                    await Future.delayed(Duration(seconds: 1));
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => StartedShifts()),
                        (route) => false);
                  }
                }
              });
            });
          },
          child: const Text(
            'Transfer Shift',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          onTap: () async {
            await Future.delayed(Duration(seconds: 1), () async {
              var result = await showOkCancelAlertDialog(
                context: context,
                title: 'Warning',
                message: 'Are you sure you want to discard this shift?',
                okLabel: 'YES',
                cancelLabel: 'NO',
              );

              if (result.index == 1) {
                return;
              }

              String endTime =
                  DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

              ShiftService.cancelShift(this.widget.execShiftId, endTime);
              var process = await LoginService.getProcess();
              final prefs = await SharedPreferences.getInstance();
              await flutterLocalNotificationsPlugin.cancel(widget.execShiftId);
              try {
                List<String> test =
                    prefs.getStringList(widget.execShiftId.toString())!;
                for (var ids in test) {
                  await flutterLocalNotificationsPlugin.cancel(int.parse(
                      widget.execShiftId.toString() + ids.toString()));
                }
              } finally {
                prefs.remove('selectedShiftName');
                prefs.remove('selectedShiftEndTime');
                prefs.remove('selectedShiftStartTime');

                _timer.cancel();
                await Future.delayed(Duration(seconds: 1));
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => StartedShifts()),
                    (route) => false);
              }
            });
          },
          child: const Text(
            'Discard Shift',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
      initialValue: 0,
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
    getAll();
    startTimer();
    super.initState();
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (isMultiImage) {
      try {
        final List<XFile> pickedFileList = await _picker.pickMultiImage(
          imageQuality: 50,
        );
        Navigator.pop(context!);

        setState(() {
          imageFileList = pickedFileList;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    } else {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          imageQuality: 50,
        );
        Navigator.pop(context!);

        setState(() {
          _setImageFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          _timer.cancel();
          Navigator.pop(context);
          return Future.value(true);
        },
        child: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                  onTap: () {
                    _timer.cancel();
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              automaticallyImplyLeading: false,
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
                    widget.process.name!,
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
              actions: [appMenu02],
            ),
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  TimerTopWidget(
                      selectedShift: widget.selectedShift,
                      timeElasped: timeElasped),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: Text(
                      'REPORT INCIDENTS',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: Text(
                      "Date and Time",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      dateTimeIncident = DateTime.now().toString();
                      showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext builder) {
                            return Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.width,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 30,
                                    child: PElevatedButton(
                                      onPressed: () {
                                        dateTimeIncident = dateTimeIncident;
                                        Navigator.pop(context);
                                        // okHandler.call();
                                      },
                                      text: "Done",
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.dateAndTime,
                                      initialDateTime: DateTime.now(),
                                      onDateTimeChanged: (value) async {
                                        dateTimeIncident = value.toString();
                                      },
                                      // initialDateTime:
                                      //     DateTime
                                      //         .now(),
                                      minimumDate:
                                          widget.selectedShift.startDateObject,
                                      maximumDate: DateTime.now(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).then((value) => setState(() {}));
                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dateTimeIncident.split(".")[0],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(
                                    Icons.access_time_outlined,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: Text(
                      "Process",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8),
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Text(
                              widget.process.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ))),
                  incidentType.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8),
                          child: Text(
                            "Incident Type",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                  incidentType.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8),
                          child: DropDown(
                            labelText: 'Title',
                            currentList: incidentType
                                .map((e) => e.name!.trim())
                                .toList(),
                            showError: false,
                            onChange: (newString) {
                              if (mounted)
                                setState(() {
                                  selectedIncidentTypeString = newString;
                                });
                              incidentTypeIndexSelected = incidentType
                                  .map((e) => e.name!.trim())
                                  .toList()
                                  .indexOf(newString);
                            },
                            placeHolderText: 'Incident Type',
                            preSelected: "",
                          ),
                        ),
                  severity.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8),
                          child: Text(
                            "Severity",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                  severity.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8),
                          child: DropDown(
                            labelText: 'Title',
                            currentList:
                                severity.map((e) => e.name!.trim()).toList(),
                            showError: false,
                            onChange: (newString) {
                              if (mounted)
                                setState(() {
                                  selectedSeverityTypeString = newString;
                                });
                              severityIndexSelected = severity
                                  .map((e) => e.name!.trim())
                                  .toList()
                                  .indexOf(newString);
                            },
                            placeHolderText: 'Severity',
                            preSelected: "",
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: Text(
                      "Cause Downtime",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: DropDown(
                      search: false,
                      labelText: 'Title',
                      currentList: ["Yes", "No"],
                      showError: false,
                      onChange: (newString) {
                        if (mounted)
                          setState(() {
                            isDowntime = newString == "Yes" ? true : false;
                          });
                        selectedIsDowntime = newString;
                      },
                      placeHolderText: 'Cause Downtime',
                      preSelected: "Yes",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: Text(
                      "Description",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "Description",
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
                      maxLines: 10,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: PElevatedButton(
                      backGroundColor: Colors.white,
                      shrink: true,
                      onPressed: () async {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 100,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _onImageButtonPressed(
                                          ImageSource.camera,
                                          context: context,
                                        );
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 14),
                                          child: Text(
                                            "Camera",
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          )),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _onImageButtonPressed(
                                          ImageSource.gallery,
                                          context: context,
                                          isMultiImage: true,
                                        );
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 14),
                                          child: Text(
                                            "Gallery",
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      text: '+ Upload Photo'.toUpperCase(),
                      style: TextStyle(color: Color(0xFF0E577F), fontSize: 16),
                    ),
                  ),
                  imageFileList == null
                      ? Container()
                      : imageFileList!.isNotEmpty
                          ? Container(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, ind) {
                                      return Container(
                                        height: 180,
                                        width: 180,
                                        child: Stack(
                                          children: [
                                            Image.file(
                                                File(imageFileList![ind].path),
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object error,
                                                    StackTrace? stackTrace) {
                                              return Container(
                                                  height: 180,
                                                  width: 180,
                                                  child: Stack(
                                                    children: [
                                                      Image.network(
                                                          "https://dev-shift.grappetite.com/images/logo/logo-m.png"),
                                                      Center(
                                                          child: Text("Error"))
                                                    ],
                                                  ));
                                            }),
                                            GestureDetector(
                                              onTap: () {
                                                imageFileList!.removeAt(ind);
                                                setState(() {});
                                              },
                                              child: Container(
                                                color: kPrimaryColor,
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, ind) {
                                      return Container(
                                        width: 20,
                                      );
                                    },
                                    itemCount: imageFileList!.length),
                              ),
                            )
                          : Container(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: Text(
                      'SEND REPORTS TO?',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return UserItem(
                            keyNo: sectionManagers[index].role!,
                            personName: sectionManagers[index].firstName! +
                                ' ' +
                                sectionManagers[index].lastName!,
                            worker: sectionManagers[index],
                            initialSelected: sectionManagers[index].isSelected,
                            picUrl: sectionManagers[index].picture,
                            changedStatus: (bool newStatus) async {
                              if (mounted)
                                setState(() {
                                  sectionManagers[index].isSelected = newStatus;
                                });
                              if (newStatus) {
                                selectedWorker.add(sectionManagers[index].id);
                              } else {
                                selectedWorker.removeWhere((element) {
                                  if (element == sectionManagers[index].id) {
                                    return true;
                                  } else {
                                    return false;
                                  }
                                });
                              }
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Container(
                            height: 10,
                          );
                        },
                        itemCount: sectionManagers.length),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PElevatedButton(
                        shrink: true,
                        backGroundColor: kPrimaryColor,
                        onPressed: () async {
                          if (incidentTypeIndexSelected != -1 &&
                              severityIndexSelected != -1) {
                            await EasyLoading.show(
                              status: 'loading...',
                              maskType: EasyLoadingMaskType.black,
                            );
                            await IncidentService.postIncident(
                              dateTimeIncident: dateTimeIncident,
                              process_id: widget.process.id!,
                              execute_shift_id: widget.execShiftId,
                              incidentType:
                                  incidentType[incidentTypeIndexSelected],
                              severity: severity[severityIndexSelected],
                              isDowntime: isDowntime,
                              description: descriptionController.text,
                              selectedWorker: selectedWorker,
                              imageFileList: imageFileList ?? [],
                            );
                            await EasyLoading.dismiss()
                                .then((value) => Navigator.pop(context));
                          } else {
                            if (incidentTypeIndexSelected == -1) {
                              EasyLoading.showError(
                                  "Please select incident type",
                                  dismissOnTap: true,
                                  duration: Duration(seconds: 2));
                            } else if (severityIndexSelected == -1) {
                              EasyLoading.showError(
                                  "Please select severity type",
                                  dismissOnTap: true,
                                  duration: Duration(seconds: 2));
                            } else {
                              EasyLoading.showError(
                                  "Please fill up all the details",
                                  dismissOnTap: true,
                                  duration: Duration(seconds: 2));
                            }
                          }
                        },
                        text: "Save".toUpperCase(),
                        style: TextStyle(fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: PElevatedButton(
                      backGroundColor: Colors.white,
                      shrink: true,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      text: 'Cancel'.toUpperCase(),
                      style: TextStyle(color: Color(0xFF0E577F), fontSize: 16),
                    ),
                  ),
                ]))));
  }

  void getAll() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      incidentType = (await IncidentService.getIncidentType())!;
      severity = (await IncidentService.getSeverity())!;
      sectionManagers = (await IncidentService.getSectionManager())!;

      if (mounted) setState(() {});
      await EasyLoading.dismiss();
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }
}
