import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../config/constants.dart';
import '../model/login_model.dart';
import '../model/workers_model.dart';
import '../services/workers_service.dart';
import '../widgets/elevated_button.dart';
import 'inner_widgets/add_temp_worker.dart';
import 'inner_widgets/worker_item_view.dart';

class SelectExistingWorkers extends StatefulWidget {
  final List<ShiftWorker> workers;

  final int? workerTypeId;

  final Function(AddTempResponse) tempWorkerAdded;
  final Function(ShiftWorker) otherTypeTempWorkerAdded;

  final String listName;

  final int shiftId;
  final int exShiftId;

  final bool isEditing;

  final String processId;
  final Process process;

  SelectExistingWorkers({
    Key? key,
    required this.workers,
    this.isEditing = false,
    required this.shiftId,
    required this.tempWorkerAdded,
    required this.processId,
    this.workerTypeId,
    required this.otherTypeTempWorkerAdded,
    required this.listName,
    required this.exShiftId,
    required this.process,
  }) : super(key: key);

  @override
  State<SelectExistingWorkers> createState() => _SelectExistingWorkersState();
}

class _SelectExistingWorkersState extends State<SelectExistingWorkers> {
  TextEditingController searchController = TextEditingController();

  String timeElasped = '00:00';

  int currentWorkTypeId = 0;

  bool isSearching = true;
  List<ShiftWorker> workers = [];

  List<ShiftWorker> filteredWorkers = [];

  /*
  void startTimer() {

    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {

        if (mounted)setState(() {
          timeElasped = widget.selectedShift.timeElasped;
        });

       
      },
    );
  }
*/

  void callSearchService() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );

    if (this.widget.workerTypeId != null) {
      currentWorkTypeId = widget.workerTypeId!;
    } else {
      currentWorkTypeId = widget.workers.first.workerTypeId!;
    }
    var response = widget.isEditing
        ? await WorkersService.searchWorkers(currentWorkTypeId.toString(),
            executionid: widget.exShiftId)
        : await WorkersService.searchWorkers(currentWorkTypeId.toString());

    workers = response!.searchWorker!;

    filteredWorkers = response.searchWorker!;

    await EasyLoading.dismiss();

    for (var currentItem in widget.workers) {
      if (mounted)
        setState(() {
          workers.removeWhere((e) => e.id == currentItem.id);
        });
    }
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callSearchService();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (workers.where((e) => e.isSelected).toList().length > 0) {
          var result = await showOkCancelAlertDialog(
            context: context,
            title: 'Warning',
            message: "Selected workers will not be added! Are you sure?",
            okLabel: 'YES',
            cancelLabel: 'NO',
          );
          if (result == OkCancelResult.ok) {
            Navigator.pop(context);
          }
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.process.name!,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          leading: GestureDetector(
              onTap: () async {
                if (workers.where((e) => e.isSelected).toList().length > 0) {
                  var result = await showOkCancelAlertDialog(
                    context: context,
                    title: 'Warning',
                    message:
                        "Selected workers will not be added! Are you sure?",
                    okLabel: 'YES',
                    cancelLabel: 'NO',
                  );
                  if (result == OkCancelResult.ok) {
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                }
              },
              child: Icon(Icons.arrow_back)),
        ),
        body: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey, width: 3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'SELECT EXISTING WORKERS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.close,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: kPrimaryColor,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: TextFormField(
                                controller: searchController,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16,
                                  ),
                                ),
                                onChanged: (v) {
                                  if (v.isEmpty) {
                                    if (mounted)
                                      setState(() {
                                        isSearching = true;
                                      });

                                    return;
                                  }

                                  filteredWorkers = workers
                                      .where((e) =>
                                          (e.firstName! + ' ' + e.lastName!)
                                              .toLowerCase()
                                              .contains(v.toLowerCase()))
                                      .toList();

                                  if (mounted)
                                    setState(() {
                                      isSearching = true;
                                    });
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  PElevatedButton(
                    text:
                        'ADD SELECTED WORKERS (${(workers.where((e) => e.isSelected).toList().length)})',
                    onPressed: () {
                      for (var currentItem in workers) {
                        if (currentItem.isSelected) {
                          if (currentWorkTypeId != currentItem.workerTypeId) {
                            widget.otherTypeTempWorkerAdded(currentItem);
                          } else {
                            widget.workers.add(currentItem);
                          }
                        }
                      }

                      Navigator.pop(context, true);
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // GestureDetector(
                  //   onTap: (){
                  //     for(var a in workers)
                  //       {
                  //         a.isSelected=true;
                  //         a.newAdded = true;
                  //       }
                  //     setState(() {});
                  //   },
                  //   child:
                  const Text(
                    'Cannot find workers?',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  // ),
                  const SizedBox(
                    height: 4,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      onSurface: kPrimaryColor,
                      side: const BorderSide(
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onPressed: () async {
                      AddTempResponse? selected = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AddTempWorker(
                                shiftId: this.widget.shiftId.toString(),
                                processId: this.widget.processId,
                                exId: this.widget.exShiftId,
                                listname: this.widget.listName);
                          });
                      if (selected != null) {
                        selected.data!.isSelected = true;
                        selected.data!.isTemp = true;
                        selected.data!.newAdded = true;
                        if (!this.isSearching) {
                          if (mounted)
                            setState(() {
                              this.workers.insert(0, selected.data!);
                            });
                        } else {
                          if (mounted)
                            setState(() {
                              this.workers.insert(0, selected.data!);
                            });
                        }

                        if (this.isSearching) {
                          this.searchController.text = '';
                          if (mounted)
                            setState(() {
                              this.isSearching = true;
                            });
                        }
                        String dateString =
                            DateFormat("yyyy-MM-dd HH:mm:ss").format(
                          DateTime.now(),
                        );
                        if (widget.exShiftId != 0) {
                          await WorkersService.addWorkers(widget.exShiftId, [
                            selected.data!.id.toString()
                          ], [
                            dateString
                          ], [
                            this.widget.exShiftId.toString()
                          ], [
                            selected.data!.efficiencyCalculation.toString()
                          ]);
                        }
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        const Icon(Icons.add),
                        Expanded(
                          child: Container(),
                        ),
                        const Text(
                          'ADD TEMPORARY WORKER',
                          style: TextStyle(fontSize: 16, color: kPrimaryColor),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (isSearching) ...[
                            for (var currentItem in filteredWorkers) ...[
                              UserItem(
                                picUrl: currentItem.picture,
                                personName: currentItem.firstName! +
                                    ' ' +
                                    currentItem.lastName!,
                                reloadTest: () {
                                  TextEditingController issueDate =
                                      new TextEditingController();
                                  TextEditingController expiryDate =
                                      new TextEditingController();

                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            insetPadding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                            backgroundColor: Colors.transparent,
                                            content: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.15,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2.35,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 3),
                                                ),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Container(
                                                            child: Image(
                                                              image: const AssetImage(
                                                                  'assets/images/warning.png'),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  18,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          const Text(
                                                            'Expired License',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  kPrimaryColor,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Icon(
                                                                Icons.close,
                                                                color:
                                                                    kPrimaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      // Padding(
                                                      //   padding:
                                                      //       const EdgeInsets
                                                      //           .all(4),
                                                      //   child: Text(
                                                      //     "Worker with expired license:",
                                                      //     style: const TextStyle(
                                                      //         color:
                                                      //             kPrimaryColor,
                                                      //         fontSize: 15),
                                                      //   ),
                                                      // ),
                                                      // const SizedBox(
                                                      //   height: 8,
                                                      // ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        child: Text(
                                                          "Enter new issuance date",
                                                          style: const TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            border: Border.all(
                                                                color:
                                                                    kPrimaryColor),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              currentItem.picture !=
                                                                      null
                                                                  ? Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              4),
                                                                      // Border width
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          shape:
                                                                              BoxShape.circle),
                                                                      child:
                                                                          ClipOval(
                                                                        child: SizedBox
                                                                            .fromSize(
                                                                          size:
                                                                              const Size.fromRadius(24),
                                                                          // Image radius
                                                                          child: Image.network(
                                                                              currentItem.picture,
                                                                              fit: BoxFit.cover),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                              currentItem.picture !=
                                                                      null
                                                                  ? SizedBox(
                                                                      width: 12,
                                                                    )
                                                                  : Container(),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      currentItem
                                                                              .firstName! +
                                                                          ' ' +
                                                                          currentItem
                                                                              .lastName!,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        color:
                                                                            kPrimaryColor,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Text(
                                                                      widget
                                                                          .listName,
                                                                      style: const TextStyle(
                                                                          color:
                                                                              kPrimaryColor,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Text(
                                                                      currentItem
                                                                          .licenseName!,
                                                                      style: const TextStyle(
                                                                          color:
                                                                              kPrimaryColor,
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Text(
                                                                      "Expiry: " +
                                                                          currentItem
                                                                              .license_expiry
                                                                              .toString(),
                                                                      // DateFormat("yyyy-MM-dd")
                                                                      //         .parse(currentItem.license_expiry.toString())
                                                                      //         .toString()
                                                                      //         .split(" ")[0],
                                                                      style: const TextStyle(
                                                                          color:
                                                                              kPrimaryColor,
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        issueDate
                                                                            .text = DateTime
                                                                                .now()
                                                                            .toString()
                                                                            .split(" ")[0];
                                                                        expiryDate
                                                                            .text = DateTime
                                                                                .now()
                                                                            .add(Duration(days: currentItem.expiryDays!))
                                                                            .toString();
                                                                        showCupertinoModalPopup(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext builder) {
                                                                              return Container(
                                                                                color: Colors.white,
                                                                                height: MediaQuery.of(context).size.width,
                                                                                width: MediaQuery.of(context).size.width,
                                                                                child: CupertinoDatePicker(
                                                                                  mode: CupertinoDatePickerMode.date,
                                                                                  onDateTimeChanged: (value) async {
                                                                                    issueDate.text = value.toString().split(" ")[0];
                                                                                    expiryDate.text = value.add(Duration(days: currentItem.expiryDays!)).toString();
                                                                                    setState(() {});
                                                                                  },
                                                                                  initialDateTime: DateTime.now(),
                                                                                  minimumDate: DateTime.now().subtract(Duration(days: currentItem.expiryDays! - 3)),
                                                                                  maximumDate: DateTime.now(),
                                                                                ),
                                                                              );
                                                                            });
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(4.0),
                                                                        child:
                                                                            TextFormField(
                                                                          enabled:
                                                                              false,
                                                                          controller:
                                                                              issueDate,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            labelText:
                                                                                'New Issue Date',
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10.0),
                                                                              ),
                                                                              borderSide: BorderSide(color: kPrimaryColor),
                                                                            ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10.0),
                                                                              ),
                                                                              borderSide: BorderSide(color: kPrimaryColor),
                                                                            ),
                                                                            disabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10.0),
                                                                              ),
                                                                              borderSide: BorderSide(color: kPrimaryColor),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    // GestureDetector(
                                                                    //   onTap:
                                                                    //       () {
                                                                    //     expiryDate
                                                                    //         .text = DateTime
                                                                    //             .now()
                                                                    //         .toString()
                                                                    //         .split(" ")[0];
                                                                    //
                                                                    //     showCupertinoModalPopup(
                                                                    //         context:
                                                                    //             context,
                                                                    //         builder:
                                                                    //             (BuildContext builder) {
                                                                    //           return Container(
                                                                    //             color: Colors.white,
                                                                    //             height: MediaQuery.of(context).size.width,
                                                                    //             width: MediaQuery.of(context).size.width,
                                                                    //             child: CupertinoDatePicker(
                                                                    //               mode: CupertinoDatePickerMode.date,
                                                                    //               onDateTimeChanged: (value) async {
                                                                    //                 expiryDate.text = value.toString().split(" ")[0];
                                                                    //                 setState(() {});
                                                                    //               },
                                                                    //               initialDateTime: DateTime.now().add(Duration(hours: 1)),
                                                                    //               minimumDate: DateTime.now(),
                                                                    //               maximumDate: DateTime.now().add(Duration(days: (365 * 11))),
                                                                    //             ),
                                                                    //           );
                                                                    //         });
                                                                    //   },
                                                                    //   child:
                                                                    //       Padding(
                                                                    //     padding:
                                                                    //         const EdgeInsets.all(4.0),
                                                                    //     child:
                                                                    //         TextFormField(
                                                                    //       enabled:
                                                                    //           false,
                                                                    //       controller:
                                                                    //           expiryDate,
                                                                    //       decoration:
                                                                    //           const InputDecoration(
                                                                    //         labelText:
                                                                    //             'New Expiry Date',
                                                                    //         border:
                                                                    //             OutlineInputBorder(
                                                                    //           borderRadius: BorderRadius.all(
                                                                    //             Radius.circular(10.0),
                                                                    //           ),
                                                                    //           borderSide: BorderSide(color: kPrimaryColor),
                                                                    //         ),
                                                                    //         enabledBorder:
                                                                    //             OutlineInputBorder(
                                                                    //           borderRadius: BorderRadius.all(
                                                                    //             Radius.circular(10.0),
                                                                    //           ),
                                                                    //           borderSide: BorderSide(color: kPrimaryColor),
                                                                    //         ),
                                                                    //         disabledBorder:
                                                                    //             OutlineInputBorder(
                                                                    //           borderRadius: BorderRadius.all(
                                                                    //             Radius.circular(10.0),
                                                                    //           ),
                                                                    //           borderSide: BorderSide(color: kPrimaryColor),
                                                                    //         ),
                                                                    //       ),
                                                                    //     ),
                                                                    //   ),
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: PElevatedButton(
                                                          onPressed: () async {
                                                            await EasyLoading
                                                                .show(
                                                              status:
                                                                  'loading...',
                                                              maskType:
                                                                  EasyLoadingMaskType
                                                                      .black,
                                                            );
                                                            var test = await WorkersService
                                                                .updateExpiry(
                                                                    worker:
                                                                        currentItem!,
                                                                    issueDate:
                                                                        issueDate
                                                                            .text,
                                                                    expiryDate:
                                                                        expiryDate
                                                                            .text);

                                                            await EasyLoading
                                                                .dismiss();
                                                            Navigator.pop(
                                                                context);
                                                            if (test!) {
                                                              currentItem
                                                                      .license_expiry =
                                                                  expiryDate
                                                                      .text;
                                                              setState(() {});
                                                            }
                                                          },
                                                          text: 'CONTINUE',
                                                        ),
                                                      )
                                                    ])));
                                      });
                                },
                                keyNo: currentItem.key ?? '',
                                initialSelected: currentItem.isSelected,
                                disableRatio: widget.isEditing
                                    ? (currentItem.isSelected &&
                                        !currentItem.newAdded)
                                    : false,
                                worker: currentItem,
                                changedStatus: (bool newStatus) {
                                  var find = workers
                                      .where(
                                          (e) => e.userId == currentItem.userId)
                                      .toList();

                                  if (mounted)
                                    setState(() {
                                      currentItem.isSelected = newStatus;

                                      if (find.isNotEmpty) {
                                        if (mounted)
                                          setState(() {
                                            find.first.isSelected = newStatus;
                                          });
                                      } else {
                                        if (mounted)
                                          setState(() {
                                            workers.add(currentItem);
                                          });
                                      }
                                    });

                                  if (widget.isEditing) {
                                    if (newStatus) {
                                      if (currentItem.newRemove) {
                                      } else {
                                        currentItem.newAdded = true;
                                      }
                                    } else {
                                      if (currentItem.newAdded) {
                                      } else {
                                        currentItem.newRemove = true;
                                      }
                                    }
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ] else ...[
                            for (var currentItem in workers) ...[
                              if (currentItem.isSelected) ...[
                                UserItem(
                                  picUrl: currentItem.picture,
                                  personName: currentItem.firstName! +
                                      ' ' +
                                      currentItem.lastName!,
                                  reloadTest: () {
                                    TextEditingController issueDate =
                                        new TextEditingController();
                                    TextEditingController expiryDate =
                                        new TextEditingController();

                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              insetPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                              backgroundColor:
                                                  Colors.transparent,
                                              content: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.15,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.35,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 3),
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Container(
                                                              child: Image(
                                                                image: const AssetImage(
                                                                    'assets/images/warning.png'),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    18,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            const Text(
                                                              'Expired License',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    kPrimaryColor,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  Container(),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                                  const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            4.0),
                                                                child: Icon(
                                                                  Icons.close,
                                                                  color:
                                                                      kPrimaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        // Padding(
                                                        //   padding:
                                                        //       const EdgeInsets
                                                        //           .all(4),
                                                        //   child: Text(
                                                        //     "Worker with expired license:",
                                                        //     style: const TextStyle(
                                                        //         color:
                                                        //             kPrimaryColor,
                                                        //         fontSize: 15),
                                                        //   ),
                                                        // ),
                                                        // const SizedBox(
                                                        //   height: 8,
                                                        // ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          child: Text(
                                                            "Enter new issuance date",
                                                            style: const TextStyle(
                                                                color:
                                                                    kPrimaryColor,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              border: Border.all(
                                                                  color:
                                                                      kPrimaryColor),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                currentItem.picture !=
                                                                        null
                                                                    ? Container(
                                                                        padding:
                                                                            EdgeInsets.all(4),
                                                                        // Border width
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            shape: BoxShape.circle),
                                                                        child:
                                                                            ClipOval(
                                                                          child:
                                                                              SizedBox.fromSize(
                                                                            size:
                                                                                const Size.fromRadius(24),
                                                                            // Image radius
                                                                            child:
                                                                                Image.network(currentItem.picture, fit: BoxFit.cover),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                                currentItem.picture !=
                                                                        null
                                                                    ? SizedBox(
                                                                        width:
                                                                            12,
                                                                      )
                                                                    : Container(),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        currentItem.firstName! +
                                                                            ' ' +
                                                                            currentItem.lastName!,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          color:
                                                                              kPrimaryColor,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      Text(
                                                                        widget
                                                                            .listName,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                15),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      Text(
                                                                        currentItem
                                                                            .licenseName!,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                10),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      Text(
                                                                        "Expiry: " +
                                                                            currentItem.license_expiry.toString(),
                                                                        // DateFormat("yyyy-MM-dd").parse(currentItem.license_expiry.toString()).toString().split(" ")[0],
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                10),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 4,
                                                                ),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Column(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          issueDate.text = DateTime.now()
                                                                              .toString()
                                                                              .split(" ")[0];
                                                                          expiryDate.text = DateTime.now()
                                                                              .add(Duration(days: currentItem.expiryDays!))
                                                                              .toString();
                                                                          showCupertinoModalPopup(
                                                                              context: context,
                                                                              builder: (BuildContext builder) {
                                                                                return Container(
                                                                                  color: Colors.white,
                                                                                  height: MediaQuery.of(context).size.width,
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  child: CupertinoDatePicker(
                                                                                    mode: CupertinoDatePickerMode.date,
                                                                                    onDateTimeChanged: (value) async {
                                                                                      issueDate.text = value.toString().split(" ")[0];
                                                                                      expiryDate.text = value.add(Duration(days: currentItem.expiryDays!)).toString();
                                                                                      setState(() {});
                                                                                    },
                                                                                    initialDateTime: DateTime.now(),
                                                                                    minimumDate: DateTime.now().subtract(Duration(days: currentItem.expiryDays! - 3)),
                                                                                    maximumDate: DateTime.now(),
                                                                                  ),
                                                                                );
                                                                              });
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              TextFormField(
                                                                            enabled:
                                                                                false,
                                                                            controller:
                                                                                issueDate,
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              labelText: 'New Issue Date',
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(10.0),
                                                                                ),
                                                                                borderSide: BorderSide(color: kPrimaryColor),
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(10.0),
                                                                                ),
                                                                                borderSide: BorderSide(color: kPrimaryColor),
                                                                              ),
                                                                              disabledBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(10.0),
                                                                                ),
                                                                                borderSide: BorderSide(color: kPrimaryColor),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      // GestureDetector(
                                                                      //   onTap:
                                                                      //       () {
                                                                      //     expiryDate
                                                                      //         .text = DateTime
                                                                      //             .now()
                                                                      //         .toString()
                                                                      //         .split(" ")[0];
                                                                      //
                                                                      //     showCupertinoModalPopup(
                                                                      //         context:
                                                                      //             context,
                                                                      //         builder:
                                                                      //             (BuildContext builder) {
                                                                      //           return Container(
                                                                      //             color: Colors.white,
                                                                      //             height: MediaQuery.of(context).size.width,
                                                                      //             width: MediaQuery.of(context).size.width,
                                                                      //             child: CupertinoDatePicker(
                                                                      //               mode: CupertinoDatePickerMode.date,
                                                                      //               onDateTimeChanged: (value) async {
                                                                      //                 expiryDate.text = value.toString().split(" ")[0];
                                                                      //                 setState(() {});
                                                                      //               },
                                                                      //               initialDateTime: DateTime.now().add(Duration(hours: 1)),
                                                                      //               minimumDate: DateTime.now(),
                                                                      //               maximumDate: DateTime.now().add(Duration(days: (365 * 11))),
                                                                      //             ),
                                                                      //           );
                                                                      //         });
                                                                      //   },
                                                                      //   child:
                                                                      //       Padding(
                                                                      //     padding:
                                                                      //         const EdgeInsets.all(4.0),
                                                                      //     child:
                                                                      //         TextFormField(
                                                                      //       enabled:
                                                                      //           false,
                                                                      //       controller:
                                                                      //           expiryDate,
                                                                      //       decoration:
                                                                      //           const InputDecoration(
                                                                      //         labelText:
                                                                      //             'New Expiry Date',
                                                                      //         border:
                                                                      //             OutlineInputBorder(
                                                                      //           borderRadius: BorderRadius.all(
                                                                      //             Radius.circular(10.0),
                                                                      //           ),
                                                                      //           borderSide: BorderSide(color: kPrimaryColor),
                                                                      //         ),
                                                                      //         enabledBorder:
                                                                      //             OutlineInputBorder(
                                                                      //           borderRadius: BorderRadius.all(
                                                                      //             Radius.circular(10.0),
                                                                      //           ),
                                                                      //           borderSide: BorderSide(color: kPrimaryColor),
                                                                      //         ),
                                                                      //         disabledBorder:
                                                                      //             OutlineInputBorder(
                                                                      //           borderRadius: BorderRadius.all(
                                                                      //             Radius.circular(10.0),
                                                                      //           ),
                                                                      //           borderSide: BorderSide(color: kPrimaryColor),
                                                                      //         ),
                                                                      //       ),
                                                                      //     ),
                                                                      //   ),
                                                                      // ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child:
                                                              PElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              await EasyLoading
                                                                  .show(
                                                                status:
                                                                    'loading...',
                                                                maskType:
                                                                    EasyLoadingMaskType
                                                                        .black,
                                                              );
                                                              var test = await WorkersService.updateExpiry(
                                                                  worker:
                                                                      currentItem!,
                                                                  issueDate:
                                                                      issueDate
                                                                          .text,
                                                                  expiryDate:
                                                                      expiryDate
                                                                          .text);

                                                              await EasyLoading
                                                                  .dismiss();
                                                              Navigator.pop(
                                                                  context);
                                                              if (test!) {
                                                                currentItem
                                                                        .license_expiry =
                                                                    expiryDate
                                                                        .text;
                                                                setState(() {});
                                                              }
                                                            },
                                                            text: 'CONTINUE',
                                                          ),
                                                        )
                                                      ])));
                                        });
                                  },
                                  keyNo: currentItem.key ?? '',
                                  initialSelected: currentItem.isSelected,
                                  disableRatio: widget.isEditing
                                      ? (currentItem.isSelected &&
                                          !currentItem.newAdded)
                                      : false,
                                  worker: currentItem,
                                  changedStatus: (bool newStatus) {
                                    var find = workers
                                        .where((e) =>
                                            e.userId == currentItem.userId)
                                        .toList();
                                    currentItem.isSelected = newStatus;

                                    if (find.isNotEmpty) {
                                      if (mounted)
                                        setState(() {
                                          find.first.isSelected = newStatus;
                                        });
                                    } else {
                                      if (mounted)
                                        setState(() {
                                          workers.add(currentItem);
                                        });
                                    }

                                    if (widget.isEditing) {
                                      if (newStatus) {
                                        if (currentItem.newRemove) {
                                        } else {
                                          currentItem.newAdded = true;
                                        }
                                      } else {
                                        if (currentItem.newAdded) {
                                        } else {
                                          currentItem.newRemove = true;
                                        }
                                      }
                                    } else {}
                                  },
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            ],
                          ],
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
