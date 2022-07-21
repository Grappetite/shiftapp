import 'package:flutter/material.dart';

class PElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isApiInProgress;

  final Color? backGroundColor;
  final Color? textColor;

  PElevatedButton({
    required this.text,
    required this.onPressed,
    this.isApiInProgress = false,
    this.backGroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.35,
      child: ElevatedButton(
        onPressed: isApiInProgress ? () {} : onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
        child: isApiInProgress
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Please Wait'),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 3,
                    ),
                  ),
                ],
              )
            : Text(text),
      ),
    );
  }
}

