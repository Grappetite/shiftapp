import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

import '../config/constants.dart';


class UIUtitilies {
  static void showToast(String message, {int toastSeconds = 5}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: toastSeconds,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 12.0,
    );
  }

  static void showConfirmationDialog(BuildContext context,
      {String? title,
        String? description,
        String? button1Text,
        Color? button1Color,
        String? button2Text,
        Color? button2Color,
        VoidCallback? button1Clicked,
        VoidCallback? button2Clicked}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return PlatformAlertDialog(
            title: Text(
              title!,
              style: const TextStyle(
                color: kSecondaryColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.start,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  description!,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            actions: [
              PlatformDialogAction(
                child:
                Text(button1Text!, style: TextStyle(color: button1Color)),
                onPressed: () {
                  button1Clicked!();
                },
              ),
              PlatformDialogAction(
                child:
                Text(button2Text!, style: TextStyle(color: button2Color)),
                onPressed: () {
                  button2Clicked!();
                },
              ),
            ]);
      },
    );
  }

  static void showConfirmationDialogWithoutDescription(BuildContext context,
      {String? title,
        String? button1Text,
        Color? button1Color,
        String? button2Text,
        Color? button2Color,
        VoidCallback? button1Clicked,
        VoidCallback? button2Clicked}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return PlatformAlertDialog(
            title: Text(
              title!,
              style: TextStyle(
                color: kSecondaryColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.start,
            ),
            actions: [
              PlatformDialogAction(
                child:
                Text(button1Text!, style: TextStyle(color: button1Color)),
                onPressed: () {
                  button1Clicked!();
                },
              ),
              PlatformDialogAction(
                child:
                Text(button2Text!, style: TextStyle(color: button2Color)),
                onPressed: () {
                  button2Clicked!();
                },
              ),
            ]);
      },
    );
  }



  static Future<void> showDialogMessage(
      BuildContext context,
      {String? title,
        required String message,
        String? buttonFirstText,
        VoidCallback? firstButtonClicked,
        bool isShowClose = true}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => isShowClose,
          child: AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 16.0),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    title ?? 'Message',
                    style: TextStyle(color: kPrimaryColor, fontSize: 15),
                  ),
                ),
                Visibility(
                  visible: isShowClose,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      CupertinoIcons.clear,
                      size: 16,
                    ),
                  ),
                )
              ],
            ),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(
                  buttonFirstText ?? 'OK',
                  style: TextStyle(color: kPrimaryColor),
                ),
                onPressed: () {
                  if (firstButtonClicked != null) {
                    firstButtonClicked();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showErrorDialog(BuildContext context, String errorMessage,
      VoidCallback firstButtonClicked,
      {String? buttonText}) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 16.0),
          title: Text(
            'Opps...',
            style: TextStyle(color: kPrimaryColor, fontSize: 15),
          ),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text(
                buttonText ?? 'OK',
                style: TextStyle(color: kPrimaryColor),
              ),
              onPressed: () {
                firstButtonClicked();
              },
            ),
          ],
        );
      },
    );
  }

  //static Future<dynamic> showMessageDialogDisableBackBtn(BuildContext context,
  static Future<void> showErrorDialogDisableBackBtn(BuildContext context,
      String errorMessage, VoidCallback firstButtonClicked,
      {String? buttonText}) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              contentPadding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 16.0),
              title: Text(
                'Opps...',
                style: TextStyle(color: kPrimaryColor, fontSize: 15),
              ),
              content: Text(errorMessage),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    buttonText ?? 'OK',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  onPressed: () {
                    firstButtonClicked();
                  },
                ),
              ],
            ));
      },
    );
  }

  static Future<dynamic> showBottomSheet(
      BuildContext context, Widget widget) async {
    var check = await showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => SingleChildScrollView(
        child: Container(
          color: Colors.red,
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: widget,
        ),
      ),
    );

    if (check != null) {
      print(check);

      return check;
    }

    return null;
  }

  static void showSuccessDialog(BuildContext context, String successMessage,
      VoidCallback firstButtonClicked) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 16.0),
          title: const Center(
            child: Text(
              'Successful',
              style: TextStyle(color: kPrimaryColor, fontSize: 15),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(successMessage),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: kPrimaryColor),
              ),
              onPressed: () {
                firstButtonClicked();
              },
            ),
          ],
        );
      },
    );
  }

  static OverlayEntry? _overlayEntry;

  static void removeDoneButtonOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  static void showOkDialog(
      BuildContext context, String title, String description) {
    showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return PlatformAlertDialog(
            title: Text(title,
                style: TextStyle(color: kSecondaryColor, fontSize: 16)),
            content: Text(description),
            actions: [
              PlatformDialogAction(
                child: Text(
                  "OK",
                  style: TextStyle(color: kSecondaryColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]);
      },
    );
  }

  static void showMultiDialog(
      BuildContext context, {
        required String title,
        required List<String> buttonsText,
        required List<String?> buttonsSubText,
        required List<Color> buttonsColor,
        required Function(int) buttonActions,
      }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return PlatformAlertDialog(
            title: Text(
              title,
              style: TextStyle(
                color: kSecondaryColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              for (int i = 0; i < buttonsText.length; i++) ...[
                PlatformDialogAction(
                  child: Column(
                    children: [
                      Text(
                        buttonsText[i],
                        style: TextStyle(
                            fontSize: 14,
                            color: buttonsColor[i] == Colors.transparent
                                ? Colors.grey[400]
                                : buttonsColor[i]),
                      ),
                      if (buttonsSubText[i] != null) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            buttonsSubText[i]!,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);

                    buttonActions(i);
                  },
                ),
              ],
            ]);
      },
    );
  }

  Widget pinNumber(OutlineInputBorder outlineInputBorder,
      TextEditingController textEditingController) {
    return textEditingController.text == ''
        ? Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 15.0,
      height: 15.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
        ),
        color: textEditingController.text != ""
            ? Colors.white
            : Colors.transparent,
      ),
    )
        : Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 15.0,
      height: 15.0,
      child: Center(
        child: Text(
          textEditingController.text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

