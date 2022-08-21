import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shiftapp/screens/shift_start.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:shiftapp/model/shifts_model.dart';
import 'package:shiftapp/model/login_model.dart';

import '../config/constants.dart';
import 'end_shift.dart';

class HomeView extends StatefulWidget {
  final Process processSelected;


  final String? comment;


  final ShiftItem selectedShift;

  final bool sessionStarted;

  const HomeView(
      {Key? key, required this.processSelected, required this.selectedShift, this.sessionStarted = false, this.comment})
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
        processSelected: widget.processSelected, sessionStarted: widget.sessionStarted,
        comment: widget.comment,
      ),
      Container(
        color: Colors.green,
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

  const HomeMainView(
      {Key? key, required this.processSelected, required this.selectedShift, required this.sessionStarted, this.comment})
      : super(key: key);

  @override
  State<HomeMainView> createState() => _HomeMainViewState();
}

class _HomeMainViewState extends State<HomeMainView> {
  late AppPopupMenu<int> appMenu02;

  void moveToEndSession() async {

    await Future.delayed(const Duration(seconds: 1));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => EndShiftView(
          userId: const [],
          efficiencyCalculation:
          const [],
          shiftId: widget.selectedShift.id!,
          processId: widget.processSelected.id!,
          selectedShift: widget.selectedShift,
          comment: widget.comment!,
          startedBefore: true,
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();

    appMenu02 = AppPopupMenu<int>(
      menuItems: const [
        PopupMenuItem(
          value: 1,
          child: Text(
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

    if(widget.sessionStarted) {


      moveToEndSession();


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'Main Warehouse',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              widget.processSelected.name!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
      ),
    );
  }
}
