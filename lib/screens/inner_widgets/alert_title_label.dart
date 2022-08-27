import 'package:flutter/material.dart';
import 'package:shiftapp/config/constants.dart';

class AlertTitleLabel extends StatelessWidget {
  final String title;

  const AlertTitleLabel({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        title ,
        style: const TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 18,

        ),
      ),
    );
  }
}
