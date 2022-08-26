import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/screens/shift_start.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:shiftapp/model/shifts_model.dart';
import 'package:shiftapp/model/login_model.dart';

import '../config/constants.dart';
import 'end_shift.dart';
import 'login.dart';

class HomeView extends StatefulWidget {
  final Process processSelected;

  final String? comment;

  final ShiftItem selectedShift;

  final bool sessionStarted;

  const HomeView(
      {Key? key,
      required this.processSelected,
      required this.selectedShift,
      this.sessionStarted = false,
      this.comment})
      : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  void goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: kPrimaryColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style3, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomeMainView(
        selectedShift: widget.selectedShift,
        processSelected: widget.processSelected,
        sessionStarted: widget.sessionStarted,
        comment: widget.comment,
        onLogout: () async {
          var dyanc = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );

          if(dyanc != null) {
            if(dyanc == true){


            }
          }
        },
      ),
      Container(
        child: const Center(
          child: Text('SOPs are not available right now'),
        ),
        color: Colors.white,
      )
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.clock),
        title: ("SHIFTS"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey.shade500,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.settings),
        title: ("SOP"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey.shade500,
      ),
    ];
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
  late AppPopupMenu<int> appMenu02;

  void moveToEndSession() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );

    await Future.delayed(const Duration(seconds: 1));
    await EasyLoading.dismiss();

    var response = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => EndShiftView(
          autoOpen: true,
          userId: const [],
          efficiencyCalculation: const [],
          shiftId: widget.selectedShift.id!,
          processId: widget.processSelected.id!,
          selectedShift: widget.selectedShift,
          comment: widget.comment!,
          startedBefore: true,
          process: widget.processSelected,
        ),
      ),
    );

    if(response != null) {
      if(response == true){
        widget.onLogout();

      }
    }
    print('=');

  }

  @override
  void initState() {
    super.initState();

    appMenu02 = AppPopupMenu<int>(
      menuItems: [
        PopupMenuItem(
          value: 1,
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();

            prefs.remove('shiftId');

            prefs.remove('selectedShiftName');
            prefs.remove('selectedShiftEndTime');
            prefs.remove('selectedShiftStartTime');
            prefs.remove('username');
            prefs.remove('password');

            widget.onLogout();

            print('');

            //Navigator.pushAndRemoveUntil(context, _homeRoute, (Route<dynamic> r) => false);

            //ModalRoute.withName("/")
            // Navigator.popUntil(context, (route) => false)
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

    if (widget.sessionStarted) {
      moveToEndSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: Column(
          children: [


            Image.asset('assets/images/toplogo.png',height: 20,),
            const SizedBox(
              height: 4,
            ),
            Text(
              widget.processSelected.name!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
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
        popBack: (){
          widget.onLogout.call();

        },
      ),
    );
  }
}
