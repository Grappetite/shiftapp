import 'package:flutter/material.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'index_indicator.dart';

class WorkItemView extends StatelessWidget {
  final int currentIntex;

  final int totalItems;

  const WorkItemView(
      {Key? key, required this.currentIntex, required this.totalItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey, width: 3),
          /*
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 4,
              blurRadius: 10, //edited
            )
          ],*/
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image(
                    image: const AssetImage('assets/images/walk.png'),
                    width: MediaQuery.of(context).size.width / 18,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    'WORKERS',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  IndexIndicator(
                    total: totalItems,
                    currentIndex: currentIntex,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
