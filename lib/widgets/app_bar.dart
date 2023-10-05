import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GetAppBar {
  static AppBar appBarWithOnlyTitle(
      String title, String backText, VoidCallback? onBackTapped) {
    return AppBar(
      toolbarHeight: 100,
      flexibleSpace: Container(
        height: 100,
        child: Row(
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
              'Recieving',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
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
      ),
    );
  }
}
