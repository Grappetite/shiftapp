import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/constants.dart';
import 'alert_title_label.dart';

class BaseAlert extends StatelessWidget {
  final String titleText;

  final Widget innerView;

  const BaseAlert({Key? key, required this.titleText, required this.innerView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      backgroundColor: Colors.transparent,
      content: Container(
        width: MediaQuery.of(context).size.width / 1.15,
        height: MediaQuery.of(context).size.height / 2.25,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AlertTitleLabel(
                      title: titleText,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: innerView,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
