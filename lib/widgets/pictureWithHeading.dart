import 'package:flutter/material.dart';

import '../config/constants.dart';

class pictureWithHeading extends StatelessWidget {
  String? heading;
  String? heading2;
  String? subheading;
  String? subheading2;
  String? remaining;
  String? image;
  bool? assets;
  Widget? suffix;
  GestureTapCallback? onPress;
  pictureWithHeading({
    Key? key,
    this.assets = false,
    this.heading,
    this.heading2 = "",
    this.image,
    this.suffix,
    this.subheading,
    this.remaining = "",
    this.subheading2,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: EdgeInsets.all(10),
          height: suffix != null ? 100 : 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: kPrimaryColor,
            ),
          ),
          child: Row(
            children: [
              suffix != null
                  ? Container()
                  : Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            // color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color:kPrimaryColor),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              suffix != null
                                  ? RichText(
                                      text: TextSpan(children: [
                                      TextSpan(
                                        text: heading!,
                                        style: const TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: heading2!,
                                        style: const TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ]))
                                  : Text(
                                      heading!,
                                      style: const TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                              suffix != null
                                  ? Text(
                                      subheading!,
                                      style: const TextStyle(
                                          color: kPrimaryColor, fontSize: 12),
                                    )
                                  : Text(
                                      subheading!,
                                      style: const TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 18,
                                      ),
                                    ),
                              Spacer(),
                              suffix != null
                                  ? Text(
                                      subheading2!,
                                      style: const TextStyle(
                                          color: kPrimaryColor, fontSize: 12),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        suffix != null
                            ? Expanded(
                          flex:1,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    suffix!,
                                    Text(
                                      remaining!,
                                      style: const TextStyle(
                                          color: kPrimaryColor, fontSize: 12),
                                    ),
                                  ],
                                ),
                            )
                            : Container()
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
