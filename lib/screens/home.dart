import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/model/shifts_model.dart';
import 'package:shiftapp/screens/shift_start.dart';

import '../Controllers/HomeController.dart';
import '../Network/API.dart';
import '../Routes/app_pages.dart';
import '../config/constants.dart';

class HomeView extends StatelessWidget {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  Process? processSelected = Get.arguments["processSelected"];
  ShiftItem? selectedShift = Get.arguments["selectedShift"];
  bool? sessionStarted = Get.arguments["sessionStarted"] ?? false;

  // @override
  // void initState() {
  //   super.initState();
  //   // comment = Get.arguments["comment"];
  //   _controller = PersistentTabController(initialIndex: 0);
  // }

  void goBack() {
    Get.back();
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
        selectedShift: selectedShift!,
        processSelected: processSelected!,
        sessionStarted: sessionStarted ?? false,
        onLogout: () async {
          var dyanc = await Get.toNamed(Routes.login);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const LoginScreen()),
          // );

          if (dyanc != null) {
            if (dyanc == true) {}
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

class HomeMainView extends StatelessWidget {
  final Process processSelected;

  final ShiftItem selectedShift;
  final bool sessionStarted;
  final String? comment;
  final VoidCallback onLogout;

  HomeMainView(
      {Key? key,
      required this.processSelected,
      required this.selectedShift,
      required this.sessionStarted,
      this.comment,
      required this.onLogout})
      : super(key: key);

  HomeController controller = Get.find();
  late AppPopupMenu<int> appMenu02 = AppPopupMenu<int>(
    menuItems: [
      PopupMenuItem(
        value: 1,
        onTap: () async {
          //final prefs = await SharedPreferences.getInstance();

          Api().sp.remove('shiftId');

          Api().sp.remove('selectedShiftName');
          Api().sp.remove('selectedShiftEndTime');
          Api().sp.remove('selectedShiftStartTime');
          Api().sp.remove('username');
          Api().sp.remove('password');

          onLogout();
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

  // @override
  // void initState() {
  //   super.initState();

  // appMenu02 = AppPopupMenu<int>(
  //   menuItems: [
  //     PopupMenuItem(
  //       value: 1,
  //       onTap: () async {
  //         //final prefs = await SharedPreferences.getInstance();
  //
  //         Api().sp.remove('shiftId');
  //
  //         Api().sp.remove('selectedShiftName');
  //         Api().sp.remove('selectedShiftEndTime');
  //         Api().sp.remove('selectedShiftStartTime');
  //         Api().sp.remove('username');
  //         Api().sp.remove('password');
  //
  //         onLogout();
  //       },
  //       child: const Text(
  //         'Logout',
  //         style: TextStyle(
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   ],
  //   initialValue: 2,
  //   onSelected: (int value) {},
  //   onCanceled: () {},
  //   elevation: 4,
  //   icon: const Icon(Icons.more_vert),
  //   offset: const Offset(0, 65),
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(16),
  //   ),
  //   color: kPrimaryColor,
  // );
  // if (sessionStarted) {
  // moveToEndSession();
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      initState: (s) {
        if (sessionStarted) {
          controller.moveToEndSession(
              processSelected: processSelected,
              selectedShift: selectedShift,
              sessionStarted: sessionStarted,
              onLogout: onLogout);
        }
      },
      builder: (logic) {
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
                  processSelected.name!,
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
            selectedShift: selectedShift,
            processSelected: processSelected,
            popBack: () {
              onLogout.call();
            },
          ),
        );
      },
    );
  }
}
