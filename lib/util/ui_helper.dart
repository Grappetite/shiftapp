import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UIHelper {
  static Widget getCardItem(String title, String count, Color bgColor,
      {double width = 140, double height = 115}) {
    return Card(
      elevation: 5,
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
              // Expanded(child: SizedBox()),
              Text(
                count,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static showInfoMenu(GlobalKey key, BuildContext context, String? text) {
    var dx = getWidgetPosition(key).dx;
    var dy = getWidgetPosition(key).dy - 10;
    RenderBox renderBox = (key.currentContext!.findRenderObject() as RenderBox);

    showDialog(
      context: context,
      builder: (builder) => Stack(
        children: [
          Positioned(
            left: dx,
            top: dy,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                width: MediaQuery.of(context).size.width -
                    renderBox.size.width -
                    160,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(text ?? ''),
              ),
            ),
          ),
        ],
      ),
      barrierColor: Colors.transparent,
    );
  }

  static Offset getWidgetPosition(GlobalKey key) {
    var containerRenderBox =
        (key.currentContext!.findRenderObject() as RenderBox);
    final containerPosition = containerRenderBox.localToGlobal(Offset.zero);

    return containerPosition;
  }
}
