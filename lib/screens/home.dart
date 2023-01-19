import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/model/shifts_model.dart';
import 'package:shiftapp/screens/SopView.dart';
import 'package:shiftapp/screens/shift_start.dart';

import '../config/constants.dart';
import '../main.dart';
import '../services/login_service.dart';
import '../services/shift_service.dart';
import 'end_shift.dart';
import 'end_shift_final_screen.dart';
import 'login.dart';

class HomeView extends StatefulWidget {
  final Process processSelected;

  final ShiftItem selectedShift;

  final bool sessionStarted;

  const HomeView(
      {Key? key,
      required this.processSelected,
      required this.selectedShift,
      this.sessionStarted = false})
      : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }

  void goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.processSelected.type=="training"? SopView(
      processSelected: widget.processSelected,
      selectedShift: widget.selectedShift,
    ):DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            HomeMainView(
              selectedShift: widget.selectedShift,
              processSelected: widget.processSelected,
              sessionStarted: widget.sessionStarted,
              onLogout: () async {},
            ),
            SopView(
              processSelected: widget.processSelected,
              selectedShift: widget.selectedShift,
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: kPrimaryColor,
          child: TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.white, width: 5.0),
                insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 45.0),
              ),
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        Text("Home")
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      children: [
                        const Icon(CupertinoIcons.settings),
                        Text("SOP")
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
    ;
  }
}

class HomeMainView extends StatefulWidget {
  final Process processSelected;

  final ShiftItem selectedShift;
  final bool sessionStarted;
  final String? comment;
  final VoidCallback onLogout;

  const HomeMainView(
      {Key? key,
      required this.processSelected,
      required this.selectedShift,
      required this.sessionStarted,
      this.comment,
      required this.onLogout})
      : super(key: key);

  @override
  State<HomeMainView> createState() => _HomeMainViewState();
}

class _HomeMainViewState extends State<HomeMainView> {
  void moveToEndSession() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );

    await Future.delayed(const Duration(milliseconds: 10));
    await EasyLoading.dismiss();

    var executeShiftId = this.widget.selectedShift.executedShiftId;
    var response;
    if (DateFormat("yyyy-MM-dd hh:mm:ss")
        .parse(DateTime.now().toString())
        .isAfter(
            this.widget.selectedShift.endDateObject.add(Duration(hours: 4)))) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EndShiftFinalScreen(
            autoOpen: true,
            startTime: widget.selectedShift.startTime!,
            selectedShift: widget.selectedShift,
            shiftId: widget.selectedShift.id!,
            processId: widget.processSelected.id!,
            endTime: widget.selectedShift.endTime!,
            process: widget.processSelected,
            executeShiftId: executeShiftId!,
          ),
        ),
      );
    } else {
      response = await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => EndShiftView(
            autoOpen: true,
            userId: const [],
            efficiencyCalculation: const [],
            shiftId: widget.selectedShift.id!,
            processId: widget.processSelected.id!,
            selectedShift: widget.selectedShift,
            startedBefore: true,
            process: widget.processSelected,
            execShiftId: executeShiftId!,
          ),
        ),
      );
    }
    if (response != null) {
      if (response == true) {
        widget.onLogout();
      }
    }
    print('=');
  }

  late AppPopupMenu<int> appMenu02;
  @override
  void initState() {
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
      icon: const Icon(Icons.more_vert),
      offset: const Offset(0, 65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: kPrimaryColor,
    );
    setState(() {});
    if (widget.sessionStarted) {
      moveToEndSession();
    } else {
      if (widget.processSelected.type != "training") getEffeciency();
    }
    super.initState();
  }

  var yesterdayEfficiency;
  var bestEfficiency;
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
      body: ShiftStart(
        selectedShift: widget.selectedShift,
        processSelected: widget.processSelected,
        yesterdayEfficiency: yesterdayEfficiency,
        bestEfficiency: bestEfficiency,
        popBack: () {
          widget.onLogout.call();
        },
      ),
    );
  }

  void getEffeciency() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var response = await ShiftService.getEffeciency(
        widget.processSelected.id, widget.selectedShift.id);
    yesterdayEfficiency = response["yestEfficiency"];
    bestEfficiency = response["maxVale"];
    if (mounted) setState(() {});
    await EasyLoading.dismiss();
  }
}
