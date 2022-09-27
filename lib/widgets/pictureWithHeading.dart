import 'package:flutter/material.dart';

import '../config/constants.dart';

class pictureWithHeading extends StatelessWidget {
  String? heading;
  String? subheading;
  String? image;
  bool? assets;
  pictureWithHeading(
      {Key? key,
      this.assets = false,
      this.heading,
      this.image,
      this.subheading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: EdgeInsets.all(10),
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: kPrimaryColor,
          ),
          // boxShadow: [
          //   BoxShadow(
          //       color: kPrimaryColor, //edited
          //       spreadRadius: 4,
          //       blurRadius: 1),
          // ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                // width: 150,
                // height: 150,
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                    image: assets!
                        ? DecorationImage(
                            image: AssetImage(image!), fit: BoxFit.fill)
                        : DecorationImage(image: NetworkImage(image!))),
              ),
            ),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        heading!,
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        subheading!,
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
