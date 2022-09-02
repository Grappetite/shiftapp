import 'package:flutter/material.dart';
import 'package:shiftapp/config/constants.dart';

class PElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isApiInProgress;

  final Color? backGroundColor;
  final Color textColor;

  PElevatedButton({
    required this.text,
    required this.onPressed,
    this.isApiInProgress = false,
    this.backGroundColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.35,
      child: ElevatedButton(
        onPressed: isApiInProgress ? () {} : onPressed,
        style: ButtonStyle(
          backgroundColor: backGroundColor != null ? MaterialStateProperty.all(backGroundColor!) : MaterialStateProperty.all(kPrimaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0 , ),
              side: BorderSide(color: kPrimaryColor , width: 1)
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
            : Text(text , style: TextStyle(color: textColor),),
      ),
    );
  }
}

