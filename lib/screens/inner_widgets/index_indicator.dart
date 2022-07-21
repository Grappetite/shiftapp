import 'package:flutter/material.dart';
import 'package:shiftapp/config/constants.dart';

class IndexIndicator extends StatelessWidget {
  final int total;
  final int currentIndex;

  const IndexIndicator(
      {Key? key, required this.total, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < total; i++) ...[
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == currentIndex ? kPrimaryColor : Colors.white,
              border: Border.all(color: Colors.grey , width: 2),
            ),
          ),
          const SizedBox(width: 3,),
        ],
      ],
    );
  }
}
