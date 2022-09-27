import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../../widgets/input_view.dart';
import '../../widgets/pictureWithHeading.dart';
import 'alert_cancel_ok_buttons.dart';
import 'alert_title_label.dart';

class ChangeShiftTime extends StatefulWidget {
  final String startTime;
  final String endTime;
  final String hours;
  final String date;
  final bool sop;

  const ChangeShiftTime(
      {Key? key,
      required this.startTime,
      required this.endTime,
      required this.hours,
      required this.date,
      this.sop = false})
      : super(key: key);

  @override
  State<ChangeShiftTime> createState() => _ChangeShiftTimeState();
}

class _ChangeShiftTimeState extends State<ChangeShiftTime> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  bool timeSelected = true;
  bool checkboxForComment = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      backgroundColor: Colors.transparent,
      content: Container(
        width: MediaQuery.of(context).size.width / 1.15,
        height: MediaQuery.of(context).size.height / 2.25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey, width: 3),
        ),
        child: widget.sop
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 8.0),
                    child: Text(
                      "PPE",
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      trackVisibility: true,
                      controller: ScrollController(initialScrollOffset: 0.0),
                      child: ListView(
                        children: [
                          pictureWithHeading(
                              heading: "Standard safety",
                              subheading: "P00126",
                              image: "assets/icon/icon_logo.jpg",
                              assets: true),
                          pictureWithHeading(
                              heading: "Standard safety",
                              subheading: "P00126",
                              image: "assets/icon/icon_logo.jpg",
                              assets: true),
                          pictureWithHeading(
                              heading: "Standard safety",
                              subheading: "P00126",
                              image: "assets/icon/icon_logo.jpg",
                              assets: true),
                          pictureWithHeading(
                              heading: "Standard safety",
                              subheading: "P00126",
                              image: "assets/icon/icon_logo.jpg",
                              assets: true),
                          CheckboxListTile(
                            title: Text("title text"),
                            value: checkboxForComment,
                            onChanged: (newValue) {},
                            controlAffinity: ListTileControlAffinity
                                .leading, //  <-- leading Checkbox
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context, false);
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
                            buildInfoItem('Date', widget.date),
                            const SizedBox(
                              height: 8,
                            ),
                            buildInfoItem('Start Time', widget.startTime),
                            const SizedBox(
                              height: 8,
                            ),
                            buildInfoItem('End Time', widget.endTime),
                            const SizedBox(
                              height: 8,
                            ),
                            buildInfoItem('Shift Length', widget.hours),
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
                              if (timeSelected) {
                                Navigator.pop(context, true);

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
