import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

import 'package:shiftapp/screens/shift_start.dart'; // import this

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {}
        });
        return Scaffold(
          appBar: AppBar(
            flexibleSpace: SizedBox(
              height: 80,
              child: Column(
                
                children: [

                  Expanded(
                      flex: 2,
                      child: Container()),

                  Row(
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: const FaIcon(
                          FontAwesomeIcons.arrowRightFromBracket,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const Text(
                        'Receiving',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        "• ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Main Warehouse',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),

                ],
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: [
                buildTabView('clock', 'SHIFTS'),
                buildTabView('cog', 'SOP'),
              ],
            ),
          ),
          body: const ShiftStart(),
        );
      }),
    );
  }

  Tab buildTabView(String icon, String name) {
    return Tab(
      child: Row(
        children: [
          Expanded(
            child: Container(),
          ),
          ImageIcon(
            AssetImage('assets/images/$icon.png' ),
            size: 24,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(name),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
