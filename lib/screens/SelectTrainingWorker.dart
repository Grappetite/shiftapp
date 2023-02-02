import 'dart:async';

import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/model/shifts_model.dart';
import 'package:shiftapp/model/sop_model.dart' as sopmodel;
import 'package:shiftapp/model/worker_sop_model.dart';
import 'package:shiftapp/model/workers_model.dart';
import 'package:shiftapp/screens/SopsList.dart';
import 'package:shiftapp/screens/inner_widgets/worker_item_view.dart';
import 'package:shiftapp/screens/login.dart';
import 'package:shiftapp/screens/shift_start.dart';
import 'package:shiftapp/services/login_service.dart';
import 'package:shiftapp/services/sop_service.dart';
import 'package:shiftapp/widgets/elevated_button.dart';

class SelectTrainingWorker extends StatefulWidget {
  SelectTrainingWorker(
      {Key? key,
      required this.processSelected,
      required this.selectedShift,
      required this.heading,
      required this.sopDetail,
      this.executionShiftId})
      : super(key: key);
  final Process processSelected;
  final ShiftItem selectedShift;
  final String heading;
  final sopmodel.Datum sopDetail;
  final int? executionShiftId;

  @override
  State<SelectTrainingWorker> createState() => _SelectTrainingWorkerState();
}

class _SelectTrainingWorkerState extends State<SelectTrainingWorker> {
  late AppPopupMenu<int> appMenu02;
  WorkerModel? workerData;
  List<ShiftWorker> selectedWorkers = [];
  final PagingController<int, ShiftWorker> _pagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, ShiftWorker> _pagingControllerSearch =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    // TODO: implement initState
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
      icon: const Icon(Icons.more_vert,color: Colors.white,),
      offset: const Offset(0, 65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: kPrimaryColor,
    );
    // startTimer();
    // getSopWorker(widget.sopDetail.id);
    _pagingController.addPageRequestListener((pageKey) {
      if (pageKey == 0) {
        getSopWorker(
          widget.sopDetail.id,
        );
      } else {
        getSopWorker(widget.sopDetail.id, url: workerData!.data!.nextPageUrl);
      }
    });
    _pagingControllerSearch.addPageRequestListener((pageKey) {
      if (pageKey == 0) {
        getSopWorker(widget.sopDetail.id,
            dialog: true, searchParam: searchController.text);
      } else {
        getSopWorker(widget.sopDetail.id,
            url: workerData!.data!.nextPageUrl,
            dialog: true,
            searchParam: searchController.text);
      }
    });
  }

  late Timer _timer;
  String timeElasped = '00:00';
  String timeRemaining = '00:00';
  TextEditingController searchController = TextEditingController();

  var isTimeOver = false;
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
    print('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              Image.asset(
                'assets/images/toplogo.png',
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
          // TimerTopWidget(
          //     selectedShift: widget.selectedShift, timeElasped: timeElasped),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.heading}",
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Select Workers to Train",
                            style: const TextStyle(
                                color: kPrimaryColor, fontSize: 14),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     searchController.clear();
                          //     showDialog(
                          //             context: context,
                          //             builder: (context) {
                          //               return StatefulBuilder(
                          //                   builder: (context, setState) {
                          //                 return SimpleDialog(
                          //                   insetPadding:
                          //                       const EdgeInsets.symmetric(
                          //                           vertical: 80.0),
                          //                   contentPadding:
                          //                       const EdgeInsets.fromLTRB(
                          //                           12.0, 12.0, 5.0, 12.0),
                          //                   // title: Text(""),
                          //                   children: [
                          //                     Row(
                          //                       children: [
                          //                         const SizedBox(
                          //                           height: 8,
                          //                         ),
                          //                         const Text(
                          //                           'SELECT EXISTING WORKERS',
                          //                           style: TextStyle(
                          //                             fontSize: 16,
                          //                             fontWeight:
                          //                                 FontWeight.w700,
                          //                             color: kPrimaryColor,
                          //                           ),
                          //                         ),
                          //                         Expanded(
                          //                           child: Container(),
                          //                         ),
                          //                         GestureDetector(
                          //                           onTap: () {
                          //                             Navigator.pop(context);
                          //                           },
                          //                           child: const Padding(
                          //                             padding:
                          //                                 EdgeInsets.all(4.0),
                          //                             child: Icon(
                          //                               Icons.close,
                          //                               color: kPrimaryColor,
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     const SizedBox(
                          //                       height: 8,
                          //                     ),
                          //                     Container(
                          //                       decoration: BoxDecoration(
                          //                         border: Border.all(
                          //                           color: Colors.grey,
                          //                         ),
                          //                         borderRadius:
                          //                             const BorderRadius.all(
                          //                           Radius.circular(8),
                          //                         ),
                          //                       ),
                          //                       child: Padding(
                          //                         padding: const EdgeInsets
                          //                                 .symmetric(
                          //                             vertical: 8,
                          //                             horizontal: 8),
                          //                         child: Row(
                          //                           children: [
                          //                             const Icon(
                          //                               Icons.search,
                          //                               color: kPrimaryColor,
                          //                             ),
                          //                             const SizedBox(
                          //                               width: 4,
                          //                             ),
                          //                             Expanded(
                          //                               child: TextFormField(
                          //                                   controller:
                          //                                       searchController,
                          //                                   maxLines: 1,
                          //                                   style:
                          //                                       const TextStyle(
                          //                                     fontSize: 18,
                          //                                   ),
                          //                                   decoration:
                          //                                       InputDecoration
                          //                                           .collapsed(
                          //                                     hintText:
                          //                                         'Search',
                          //                                     hintStyle:
                          //                                         TextStyle(
                          //                                       color: Colors
                          //                                           .grey[500],
                          //                                       fontSize: 16,
                          //                                     ),
                          //                                   ),
                          //                                   onChanged: (v) {
                          //                                     if (searchController
                          //                                                 .text
                          //                                                 .length %
                          //                                             3 ==
                          //                                         0) {
                          //                                       _pagingControllerSearch
                          //                                           .itemList!
                          //                                           .clear();
                          //                                       _pagingControllerSearch
                          //                                           .notifyListeners();
                          //                                       getSopWorker(
                          //                                         widget
                          //                                             .sopDetail
                          //                                             .id,
                          //                                         dialog: true,
                          //                                         searchParam:
                          //                                             searchController
                          //                                                 .text,
                          //                                       );
                          //                                     }
                          //                                   }),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     const SizedBox(
                          //                       height: 8,
                          //                     ),
                          //                     PElevatedButton(
                          //                       text: 'ADD SELECTED WORKERS ',
                          //                       onPressed: () {
                          //                         Navigator.pop(context, true);
                          //                       },
                          //                     ),
                          //                     const SizedBox(
                          //                       height: 8,
                          //                     ),
                          //                     Container(
                          //                       height: MediaQuery.of(context)
                          //                               .size
                          //                               .height /
                          //                           2.5,
                          //                       width: MediaQuery.of(context)
                          //                           .size
                          //                           .width,
                          //                       child: PagedListView<int,
                          //                           ShiftWorker>(
                          //                         pagingController:
                          //                             _pagingControllerSearch,
                          //                         shrinkWrap: true,
                          //                         scrollDirection:
                          //                             Axis.vertical,
                          //                         builderDelegate:
                          //                             PagedChildBuilderDelegate<
                          //                                     ShiftWorker>(
                          //                                 itemBuilder: (context,
                          //                                     item, index) {
                          //                           return Padding(
                          //                               padding:
                          //                                   const EdgeInsets
                          //                                       .all(8.0),
                          //                               child: UserItem(
                          //                                 keyNo:
                          //                                     item.key != null
                          //                                         ? item.key!
                          //                                         : '',
                          //                                 personName: item
                          //                                         .firstName! +
                          //                                     ' ' +
                          //                                     item.lastName!,
                          //                                 initialSelected:
                          //                                     item.isSelected,
                          //                                 picUrl: item.picture,
                          //                                 changedStatus: (bool
                          //                                     newStatus) async {
                          //                                   setState(() {
                          //                                     item.isSelected =
                          //                                         newStatus;
                          //                                   });
                          //                                   if (newStatus) {
                          //                                     selectedWorkers!
                          //                                         .add(item);
                          //                                     _pagingController
                          //                                         .itemList!
                          //                                         .add(item);
                          //                                     _pagingController
                          //                                         .notifyListeners();
                          //                                   } else {
                          //                                     selectedWorkers!
                          //                                         .removeWhere(
                          //                                             (element) {
                          //                                       if (element
                          //                                               .userId ==
                          //                                           item.userId) {
                          //                                         return true;
                          //                                       } else {
                          //                                         return false;
                          //                                       }
                          //                                     });
                          //                                     _pagingController
                          //                                         .itemList!
                          //                                         .removeWhere(
                          //                                             (element) {
                          //                                       if (element
                          //                                               .userId ==
                          //                                           item.userId) {
                          //                                         return true;
                          //                                       } else {
                          //                                         return false;
                          //                                       }
                          //                                     });
                          //                                     _pagingController
                          //                                         .notifyListeners();
                          //                                   }
                          //                                 },
                          //                               ));
                          //                         }),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 );
                          //               });
                          //             })
                          //         .then((value) => getSopWorker(
                          //             widget.sopDetail.id,
                          //             dialog: true,
                          //             searchParam: searchController.text));
                          //   },
                          //   child: Icon(
                          //     Icons.search,
                          //     color: kPrimaryColor,
                          //   ),
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        flex: 15,
                        child: PagedListView<int, ShiftWorker>(
                          pagingController: _pagingController,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          builderDelegate: PagedChildBuilderDelegate<
                                  ShiftWorker>(
                              itemBuilder: (context, item, index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: UserItem(
                                    keyNo: item.key != null ? item.key! : '',
                                    personName:
                                        item.firstName! + ' ' + item.lastName!,
                                    initialSelected: item.isSelected,
                                    picUrl: item.picture,
                                    changedStatus: (bool newStatus) async {
                                      setState(() {
                                        item.isSelected = newStatus;
                                      });
                                      if (newStatus) {
                                        selectedWorkers!.add(item);
                                      } else {
                                        selectedWorkers!.removeWhere((element) {
                                          if (element.userId == item.userId) {
                                            return true;
                                          } else {
                                            return false;
                                          }
                                        });
                                      }

                                      // String dateString =
                                      // widget.selectedShift!.startTime!;
                                      //
                                      // ///previously
                                      // // DateFormat("yyyy-MM-dd hh:mm:ss")
                                      // //     .format(DateTime.now());
                                      // ///end
                                      // if (widget.isEditing && newStatus) {
                                      //   setState(() {
                                      //     currentItem.isSelected = newStatus;
                                      //   });
                                      //
                                      //   await EasyLoading.show(
                                      //     status: 'Adding...',
                                      //     maskType: EasyLoadingMaskType.black,
                                      //   );
                                      //
                                      //   var response =
                                      //   await WorkersService.addWorkers(
                                      //       widget.execShiftId, [
                                      //     currentItem.id!.toString()
                                      //   ], [
                                      //     dateString
                                      //   ], [], [
                                      //     currentItem.efficiencyCalculation
                                      //         .toString()
                                      //   ]);
                                      //
                                      //   await EasyLoading.dismiss();
                                      //
                                      //   if (response) {
                                      //   } else {
                                      //     EasyLoading.showError('Error');
                                      //   }
                                      // } else if (widget.isEditing && !newStatus) {
                                      //   setState(() {
                                      //     currentItem.isSelected =
                                      //         currentItem.isSelected;
                                      //   });
                                      //   await showDialog(
                                      //       context: context,
                                      //       barrierDismissible: false,
                                      //       builder: (BuildContext context) {
                                      //         return ConfirmTimeEnd(
                                      //           shiftItem:
                                      //           this.widget.selectedShift!,
                                      //           editing: widget.isEditing,
                                      //         );
                                      //       }).then((value) async {
                                      //     if (value != false) {
                                      //       // dateString = DateFormat("yyyy-MM-dd hh:mm:ss")
                                      //       //     .format(DateTime.parse(value));
                                      //       dateString = value;
                                      //       setState(() {
                                      //         currentItem.isSelected = newStatus;
                                      //       });
                                      //
                                      //       /// end
                                      //       await EasyLoading.show(
                                      //         status: 'Removing...',
                                      //         maskType: EasyLoadingMaskType.black,
                                      //       );
                                      //
                                      //       var response = await WorkersService
                                      //           .removeWorkers(
                                      //           widget.execShiftId, [
                                      //         currentItem.id!.toString()
                                      //       ], [
                                      //         dateString
                                      //       ], [], [
                                      //         currentItem.efficiencyCalculation
                                      //             .toString()
                                      //       ]);
                                      //       widget.listLists[i]
                                      //           .remove(currentItem);
                                      //       setState(() {});
                                      //       await EasyLoading.dismiss();
                                      //
                                      //       if (response) {
                                      //       } else {
                                      //         EasyLoading.showError('Error');
                                      //       }
                                      //     } else {
                                      //       setState(() {
                                      //         currentItem.isSelected =
                                      //             currentItem.isSelected;
                                      //       });
                                      //     }
                                      //   });
                                      // } else {
                                      //   setState(() {
                                      //     currentItem.isSelected = newStatus;
                                      //   });
                                      // }
                                    },
                                  ))),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: PElevatedButton(
                            shrink: true,
                            onPressed: () async {
                              if (selectedWorkers.length != 0) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SopsList(
                                        processSelected: widget.processSelected,
                                        selectedShift: widget.selectedShift,
                                        heading:
                                            widget.sopDetail.name.toString(),
                                        train: true,
                                        sopDetail: widget.sopDetail,
                                        executionShiftId:
                                            widget.executionShiftId,
                                        workerListToTrain: selectedWorkers)));
                              } else {
                                EasyLoading.showError("Please select Workers");
                              }
                              // Navigator.of(context)
                              //     .push(MaterialPageRoute(
                              //         builder: (context) => SopsList(
                              //               processSelected:
                              //                   widget.processSelected,
                              //               selectedShift:
                              //                   widget.selectedShift,
                              //             )));
                            },
                            text:
                                'START TRAINING ${selectedWorkers.length == 0 ? "" : "(${selectedWorkers.length})"}',
                            style: TextStyle(fontSize: 15)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: PElevatedButton(
                          backGroundColor: Colors.white,
                          shrink: true,
                          onPressed: () async {
                            Navigator.pop(context);
                            //     .push(MaterialPageRoute(
                            //         builder: (context) => SopsList(
                            //               processSelected:
                            //                   widget.processSelected,
                            //               selectedShift:
                            //                   widget.selectedShift,
                            //             )));
                          },
                          text: 'CANCEL',
                          style:
                              TextStyle(color: Color(0xFF0E577F), fontSize: 15),
                        ),
                      ),
                    ])),
          )
        ]));
  }

  void getSopWorker(int? id, {url, dialog = false, String? searchParam}) async {
    // await EasyLoading.show(
    //   status: 'loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );
    workerData = await SOPService.getWorker(id!, url,
        executionShiftId: widget.executionShiftId, searchParam: searchParam);
    try {
      if (workerData!.data!.currentPage == workerData!.data!.lastPage!) {
        if (dialog) {
          for (var element in _pagingController.itemList!) {
            for (var remove in workerData!.data!.data!) {
              if (element.userId == remove.userId) {
                workerData!.data!.data!.remove(remove);
                break;
              }
            }
          }
          _pagingControllerSearch.appendLastPage(workerData!.data!.data!);
        } else {
          _pagingController.appendLastPage(workerData!.data!.data!);
        }
      } else {
        // final nextPageKey = pageKey + newItems.length;
        if (dialog) {
          for (var element in _pagingController.itemList!) {
            for (var remove in workerData!.data!.data!) {
              if (element.userId == remove.userId) {
                workerData!.data!.data!.remove(remove);
                break;
              }
            }
          }
          _pagingControllerSearch.appendPage(
              workerData!.data!.data!, workerData!.data!.currentPage! + 1);
        } else {
          _pagingController.appendPage(
              workerData!.data!.data!, workerData!.data!.currentPage! + 1);
        }
      }
    } catch (error) {
      // } catch (error) {
      _pagingController.error = error;
    }
    // await EasyLoading.dismiss();
    setState(() {});
  }
}
