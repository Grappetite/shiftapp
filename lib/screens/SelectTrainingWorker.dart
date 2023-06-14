import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:shiftapp/services/login_service.dart';
import 'package:shiftapp/services/sop_service.dart';
import 'package:shiftapp/services/workers_service.dart';
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

  String timeElasped = '00:00';
  String timeRemaining = '00:00';
  TextEditingController searchController = TextEditingController();

  var isTimeOver = false;

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
                          GestureDetector(
                            onTap: () {
                              searchController.clear();
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return SimpleDialog(
                                        insetPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 80.0),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                12.0, 12.0, 5.0, 12.0),
                                        // title: Text(""),
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
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
                                                        controller:
                                                            searchController,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                        decoration:
                                                            InputDecoration
                                                                .collapsed(
                                                          hintText: 'Search',
                                                          hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[500],
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        onChanged: (v) {
                                                          if (searchController
                                                                  .text
                                                                  .length >=
                                                              3) {
                                                            _pagingControllerSearch
                                                                .itemList!
                                                                .clear();
                                                            _pagingControllerSearch
                                                                .notifyListeners();
                                                            getSopWorker(
                                                              widget
                                                                  .sopDetail.id,
                                                              dialog: true,
                                                              searchParam:
                                                                  searchController
                                                                      .text,
                                                            );
                                                          }
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          PElevatedButton(
                                            text: 'ADD SELECTED WORKERS ',
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.5,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child:
                                                PagedListView<int, ShiftWorker>(
                                              pagingController:
                                                  _pagingControllerSearch,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              builderDelegate:
                                                  PagedChildBuilderDelegate<
                                                          ShiftWorker>(
                                                      itemBuilder: (context,
                                                          item, index) {
                                                return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: UserItem(
                                                      reloadTest: () {
                                                        TextEditingController
                                                            issueDate =
                                                            new TextEditingController();
                                                        TextEditingController
                                                            expiryDate =
                                                            new TextEditingController();

                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                  insetPadding:
                                                                      const EdgeInsets.fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  content:
                                                                      Container(
                                                                          width: MediaQuery.of(context).size.width /
                                                                              1.15,
                                                                          height: MediaQuery.of(context).size.height /
                                                                              2.35,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                            border:
                                                                                Border.all(color: Colors.grey, width: 3),
                                                                          ),
                                                                          child:
                                                                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 8,
                                                                                ),
                                                                                Container(
                                                                                  child: Image(
                                                                                    image: const AssetImage('assets/images/warning.png'),
                                                                                    width: MediaQuery.of(context).size.width / 18,
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 8,
                                                                                ),
                                                                                const Text(
                                                                                  'Expired License',
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
                                                                            // Padding(
                                                                            //   padding:
                                                                            //   const EdgeInsets.all(4),
                                                                            //   child: Text(
                                                                            //     "Worker with expired license:",
                                                                            //     style: const TextStyle(
                                                                            //         color: kPrimaryColor,
                                                                            //         fontSize: 15),
                                                                            //   ),
                                                                            // ),
                                                                            // const SizedBox(
                                                                            //   height: 8,
                                                                            // ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(4),
                                                                              child: Text(
                                                                                "Enter new issuance date",
                                                                                style: const TextStyle(color: kPrimaryColor, fontSize: 12),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Container(
                                                                                padding: EdgeInsets.all(4),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                  border: Border.all(color: kPrimaryColor),
                                                                                ),
                                                                                child: Row(
                                                                                  children: [
                                                                                    item.picture != null
                                                                                        ? Container(
                                                                                            padding: EdgeInsets.all(4),
                                                                                            // Border width
                                                                                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                                            child: ClipOval(
                                                                                              child: SizedBox.fromSize(
                                                                                                size: const Size.fromRadius(24),
                                                                                                // Image radius
                                                                                                child: Image.network(item.picture, fit: BoxFit.cover),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        : Container(),
                                                                                    item.picture != null
                                                                                        ? SizedBox(
                                                                                            width: 12,
                                                                                          )
                                                                                        : Container(),
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            item.firstName! + ' ' + item.lastName!,
                                                                                            style: TextStyle(
                                                                                              fontSize: 15,
                                                                                              fontWeight: FontWeight.w700,
                                                                                              color: kPrimaryColor,
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 8,
                                                                                          ),
                                                                                          Text(
                                                                                            item.licenseName!,
                                                                                            style: const TextStyle(color: kPrimaryColor, fontSize: 10),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 8,
                                                                                          ),
                                                                                          Text(
                                                                                            "Expiry: " + item.license_expiry.toString(),
                                                                                            // DateFormat("yyyy-MM-dd").parse(item.license_expiry.toString()).toString().split(" ")[0],
                                                                                            style: const TextStyle(color: kPrimaryColor, fontSize: 10),
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
                                                                                            onTap: () {
                                                                                              issueDate.text = DateTime.now().toString().split(" ")[0];
                                                                                              expiryDate.text = DateTime.now().add(Duration(days: item.expiryDays!)).toString();
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
                                                                                                          expiryDate.text = value.add(Duration(days: item.expiryDays!)).toString();
                                                                                                          setState(() {});
                                                                                                        },
                                                                                                        initialDateTime: DateTime.now(),
                                                                                                        minimumDate: DateTime.now().subtract(Duration(days: item.expiryDays! - 3)),
                                                                                                        maximumDate: DateTime.now(),
                                                                                                      ),
                                                                                                    );
                                                                                                  });
                                                                                            },
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(4.0),
                                                                                              child: TextFormField(
                                                                                                enabled: false,
                                                                                                controller: issueDate,
                                                                                                decoration: const InputDecoration(
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
                                                                                          //   onTap: () {
                                                                                          //     expiryDate.text = DateTime.now().toString().split(" ")[0];
                                                                                          //
                                                                                          //     showCupertinoModalPopup(
                                                                                          //         context: context,
                                                                                          //         builder: (BuildContext builder) {
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
                                                                                          //   child: Padding(
                                                                                          //     padding: const EdgeInsets.all(4.0),
                                                                                          //     child: TextFormField(
                                                                                          //       enabled: false,
                                                                                          //       controller: expiryDate,
                                                                                          //       decoration: const InputDecoration(
                                                                                          //         labelText: 'New Expiry Date',
                                                                                          //         border: OutlineInputBorder(
                                                                                          //           borderRadius: BorderRadius.all(
                                                                                          //             Radius.circular(10.0),
                                                                                          //           ),
                                                                                          //           borderSide: BorderSide(color: kPrimaryColor),
                                                                                          //         ),
                                                                                          //         enabledBorder: OutlineInputBorder(
                                                                                          //           borderRadius: BorderRadius.all(
                                                                                          //             Radius.circular(10.0),
                                                                                          //           ),
                                                                                          //           borderSide: BorderSide(color: kPrimaryColor),
                                                                                          //         ),
                                                                                          //         disabledBorder: OutlineInputBorder(
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
                                                                                  await EasyLoading.show(
                                                                                    status: 'loading...',
                                                                                    maskType: EasyLoadingMaskType.black,
                                                                                  );
                                                                                  var test = await WorkersService.updateExpiry(worker: item!, issueDate: issueDate.text, expiryDate: expiryDate.text);

                                                                                  await EasyLoading.dismiss();
                                                                                  Navigator.pop(context);
                                                                                  if (test!) {
                                                                                    item.license_expiry = expiryDate.text;
                                                                                    setState(() {});
                                                                                  }
                                                                                },
                                                                                text: 'CONTINUE',
                                                                              ),
                                                                            )
                                                                          ])));
                                                            });
                                                      },
                                                      keyNo: item.key != null
                                                          ? item.key!
                                                          : '',
                                                      personName:
                                                          item.firstName! +
                                                              ' ' +
                                                              item.lastName!,
                                                      initialSelected:
                                                          item.isSelected,
                                                      picUrl: item.picture,
                                                      worker: item,
                                                      changedStatus: (bool
                                                          newStatus) async {
                                                        if (mounted)
                                                          setState(() {
                                                            item.isSelected =
                                                                newStatus;
                                                          });
                                                        if (newStatus) {
                                                          selectedWorkers
                                                              .removeWhere(
                                                                  (element) {
                                                            if (element
                                                                    .userId ==
                                                                item.userId) {
                                                              return true;
                                                            } else {
                                                              return false;
                                                            }
                                                          });
                                                          _pagingController
                                                              .itemList!
                                                              .removeWhere(
                                                                  (element) {
                                                            if (element
                                                                    .userId ==
                                                                item.userId) {
                                                              return true;
                                                            } else {
                                                              return false;
                                                            }
                                                          });
                                                          _pagingController
                                                              .notifyListeners();
                                                          selectedWorkers
                                                              .add(item);
                                                          _pagingController
                                                              .itemList!
                                                              .insert(0, item);
                                                          _pagingController
                                                              .notifyListeners();
                                                        } else {
                                                          selectedWorkers
                                                              .removeWhere(
                                                                  (element) {
                                                            if (element
                                                                    .userId ==
                                                                item.userId) {
                                                              return true;
                                                            } else {
                                                              return false;
                                                            }
                                                          });
                                                          _pagingController
                                                              .itemList!
                                                              .removeWhere(
                                                                  (element) {
                                                            if (element
                                                                    .userId ==
                                                                item.userId) {
                                                              return true;
                                                            } else {
                                                              return false;
                                                            }
                                                          });
                                                          _pagingController
                                                              .notifyListeners();
                                                        }
                                                      },
                                                    ));
                                              }),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                                  });
                              // .then((value) => getSopWorker(
                              //     widget.sopDetail.id,
                              //     dialog: false,
                              //     searchParam: searchController.text));
                            },
                            child: Icon(
                              Icons.search,
                              color: kPrimaryColor,
                            ),
                          )
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
                          builderDelegate:
                              PagedChildBuilderDelegate<ShiftWorker>(
                                  itemBuilder: (context, item, index) =>
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: UserItem(
                                            keyNo: item.key != null
                                                ? item.key!
                                                : '',
                                            personName: item.firstName! +
                                                ' ' +
                                                item.lastName!,
                                            initialSelected: item.isSelected,
                                            reloadTest: () {
                                              TextEditingController issueDate =
                                                  new TextEditingController();
                                              TextEditingController expiryDate =
                                                  new TextEditingController();

                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                        insetPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 0, 0),
                                                        backgroundColor: Colors
                                                            .transparent,
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
                                                                2.35,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
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
                                                                        width:
                                                                            8,
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Image(
                                                                          image:
                                                                              const AssetImage('assets/images/warning.png'),
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 18,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            8,
                                                                      ),
                                                                      const Text(
                                                                        'Expired License',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          color:
                                                                              kPrimaryColor,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Container(),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            const Padding(
                                                                          padding:
                                                                              EdgeInsets.all(4.0),
                                                                          child:
                                                                              Icon(
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
                                                                  //   const EdgeInsets.all(4),
                                                                  //   child: Text(
                                                                  //     "Worker with expired license:",
                                                                  //     style: const TextStyle(
                                                                  //         color: kPrimaryColor,
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
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              4),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        border: Border.all(
                                                                            color:
                                                                                kPrimaryColor),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          item.picture != null
                                                                              ? Container(
                                                                                  padding: EdgeInsets.all(4),
                                                                                  // Border width
                                                                                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                                  child: ClipOval(
                                                                                    child: SizedBox.fromSize(
                                                                                      size: const Size.fromRadius(24),
                                                                                      // Image radius
                                                                                      child: Image.network(item.picture, fit: BoxFit.cover),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : Container(),
                                                                          item.picture != null
                                                                              ? SizedBox(
                                                                                  width: 12,
                                                                                )
                                                                              : Container(),
                                                                          Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  item.firstName! + ' ' + item.lastName!,
                                                                                  style: TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: kPrimaryColor,
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                Text(
                                                                                  item.licenseName!,
                                                                                  style: const TextStyle(color: kPrimaryColor, fontSize: 10),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                Text(
                                                                                  "Expiry: " + item.license_expiry.toString(),
                                                                                  // DateFormat("yyyy-MM-dd").parse(item.license_expiry.toString()).toString().split(" ")[0],
                                                                                  style: const TextStyle(color: kPrimaryColor, fontSize: 10),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                4,
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    issueDate.text = DateTime.now().toString().split(" ")[0];
                                                                                    expiryDate.text = DateTime.now().add(Duration(days: item.expiryDays!)).toString();
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
                                                                                                expiryDate.text = value.add(Duration(days: item.expiryDays!)).toString();
                                                                                                setState(() {});
                                                                                              },
                                                                                              initialDateTime: DateTime.now(),
                                                                                              minimumDate: DateTime.now().subtract(Duration(days: item.expiryDays! - 3)),
                                                                                              maximumDate: DateTime.now(),
                                                                                            ),
                                                                                          );
                                                                                        });
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(4.0),
                                                                                    child: TextFormField(
                                                                                      enabled: false,
                                                                                      controller: issueDate,
                                                                                      decoration: const InputDecoration(
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
                                                                                //   onTap: () {
                                                                                //     expiryDate.text = DateTime.now().toString().split(" ")[0];
                                                                                //
                                                                                //     showCupertinoModalPopup(
                                                                                //         context: context,
                                                                                //         builder: (BuildContext builder) {
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
                                                                                //   child: Padding(
                                                                                //     padding: const EdgeInsets.all(4.0),
                                                                                //     child: TextFormField(
                                                                                //       enabled: false,
                                                                                //       controller: expiryDate,
                                                                                //       decoration: const InputDecoration(
                                                                                //         labelText: 'New Expiry Date',
                                                                                //         border: OutlineInputBorder(
                                                                                //           borderRadius: BorderRadius.all(
                                                                                //             Radius.circular(10.0),
                                                                                //           ),
                                                                                //           borderSide: BorderSide(color: kPrimaryColor),
                                                                                //         ),
                                                                                //         enabledBorder: OutlineInputBorder(
                                                                                //           borderRadius: BorderRadius.all(
                                                                                //             Radius.circular(10.0),
                                                                                //           ),
                                                                                //           borderSide: BorderSide(color: kPrimaryColor),
                                                                                //         ),
                                                                                //         disabledBorder: OutlineInputBorder(
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
                                                                              EasyLoadingMaskType.black,
                                                                        );
                                                                        var test = await WorkersService.updateExpiry(
                                                                            worker:
                                                                                item!,
                                                                            issueDate:
                                                                                issueDate.text,
                                                                            expiryDate: expiryDate.text);

                                                                        await EasyLoading
                                                                            .dismiss();
                                                                        Navigator.pop(
                                                                            context);
                                                                        if (test!) {
                                                                          item.license_expiry =
                                                                              expiryDate.text;
                                                                          setState(
                                                                              () {});
                                                                        }
                                                                      },
                                                                      text:
                                                                          'CONTINUE',
                                                                    ),
                                                                  )
                                                                ])));
                                                  });
                                            },
                                            picUrl: item.picture,
                                            worker: item,
                                            changedStatus:
                                                (bool newStatus) async {
                                              if (mounted)
                                                setState(() {
                                                  item.isSelected = newStatus;
                                                });
                                              if (newStatus) {
                                                selectedWorkers.add(item);
                                              } else {
                                                selectedWorkers
                                                    .removeWhere((element) {
                                                  if (element.userId ==
                                                      item.userId) {
                                                    return true;
                                                  } else {
                                                    return false;
                                                  }
                                                });
                                              }
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
          // for (var element in _pagingController.itemList!) {
          //   for (var remove in workerData!.data!.data!) {
          //     if (element.userId == remove.userId) {
          //       workerData!.data!.data!.remove(remove);
          //       break;
          //     }
          //   }
          // }
          _pagingControllerSearch.appendLastPage(workerData!.data!.data!);
        } else {
          _pagingController.appendLastPage(workerData!.data!.data!);
        }
      } else {
        // final nextPageKey = pageKey + newItems.length;
        if (dialog) {
          // for (var element in _pagingController.itemList!) {
          //   for (var remove in workerData!.data!.data!) {
          //     if (element.userId == remove.userId) {
          //       workerData!.data!.data!.remove(remove);
          //       break;
          //     }
          //   }
          // }
          _pagingControllerSearch.appendPage(
              workerData!.data!.data!, workerData!.data!.currentPage! + 1);
        } else {
          _pagingController.appendPage(
              workerData!.data!.data!, workerData!.data!.currentPage! + 1);
        }
      }
      _pagingControllerSearch.notifyListeners();
      _pagingController.notifyListeners();
    } catch (error) {
      // } catch (error) {
      if (!dialog) {
        _pagingController.error = error;
      } else {
        _pagingControllerSearch.error = error;
      }
    }
    // await EasyLoading.dismiss();
    if (mounted) setState(() {});
  }
}
