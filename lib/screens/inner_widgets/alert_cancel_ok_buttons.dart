import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../../widgets/elevated_button.dart';

class AlertCancelOk extends StatelessWidget {
  final String? cancelTitle;
  final String okButton;
  final VoidCallback? okHandler;
  final VoidCallback? cancelHandler;

  AlertCancelOk(
      {Key? key,
      this.cancelTitle,
      required this.okButton,
      required this.okHandler,
      this.cancelHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              onSurface: kPrimaryColor,
              side: const BorderSide(
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            onPressed: () {
              if (cancelHandler == null) {
                Navigator.pop(context, false);
              } else {
                cancelHandler!.call();
              }
            },
            child: Text(
              cancelTitle ?? 'CANCEL',
              style: TextStyle(
                  fontSize: cancelTitle == null ? 20 : 10,
                  color: kPrimaryColor),
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: PElevatedButton(
            onPressed: () {
              okHandler!.call();
            },
            text: okButton,
          ),
        ),
      ],
    );
  }
}
