import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/input_view.dart';
import '../workers_listing.dart';
import 'alert_cancel_ok_buttons.dart';
import 'alert_title_label.dart';

class ChangeShiftTime extends StatefulWidget {
  const ChangeShiftTime({Key? key}) : super(key: key);

  @override
  State<ChangeShiftTime> createState() => _ChangeShiftTimeState();
}

class _ChangeShiftTimeState extends State<ChangeShiftTime> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  bool timeSelected = false;

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
                    Navigator.pop(context);
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
                    const AlertTitleLabel(
                      title: 'CHANGE SHIFT TIME',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (timeSelected) ...[
                      const Text('Please confirm shift time change:'),
                      const SizedBox(
                        height: 8,
                      ),
                      buildInfoItem('Date', '2021/01/15'),
                      const SizedBox(
                        height: 8,
                      ),
                      buildInfoItem('Start Time', '06:00'),
                      const SizedBox(
                        height: 8,
                      ),
                      buildInfoItem('End Time', '16:00'),
                      const SizedBox(
                        height: 8,
                      ),
                      buildInfoItem('Shift Length', '10 Hours'),
                    ] else ...[
                      InputView(
                        showError: false,
                        hintText: 'Start Time',
                        onChange: (newValue) {},
                        controller: controller,
                        text: '',
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      InputView(
                        showError: false,
                        hintText: 'End Time',
                        onChange: (newValue) {},
                        controller: controller2,
                        text: '',
                      ),
                    ],
                    const SizedBox(
                      height: 16,
                    ),
                    AlertCancelOk(
                      okHandler: () {

                        if(timeSelected) {

                          Navigator.pop(context,true);

                          return;


                        }


                        setState(() {
                          timeSelected = true;
                        });
                      },
                      okButton: timeSelected ? 'CONTINUE' : 'SAVE',
                    ),
                    Expanded(
                      child: Container(),
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

  Padding buildInfoItem(String labelName, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$labelName:',
              style: const TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: kPrimaryColor,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
