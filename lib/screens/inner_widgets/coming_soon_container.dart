import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../end_shift.dart';


class ComingSoonContainer extends StatelessWidget {
  final Widget innerWidget;

  final EdgeInsetsGeometry padding;

  const ComingSoonContainer({Key? key, required this.innerWidget, required this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Stack(
        children: [
          innerWidget,
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                'Coming Soon',
                style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

