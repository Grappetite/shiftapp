import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/input_view.dart';
import 'alert_cancel_ok_buttons.dart';
import 'alert_title_label.dart';

class AddTempWorker extends StatefulWidget {
  const AddTempWorker({Key? key}) : super(key: key);

  @override
  State<AddTempWorker> createState() => _AddTempWorkerState();
}

class _AddTempWorkerState extends State<AddTempWorker> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController personalNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      backgroundColor: Colors.transparent,
      content: Container(
        width: MediaQuery.of(context).size.width / 1.15,
        height: MediaQuery.of(context).size.height / 1.8,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey, width: 3),
        ),

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
                      title: 'ADD TEMPORARY WORKER',
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                      InputView(
                        showError: false,
                        hintText: 'First Name',
                        onChange: (newValue) {},
                        controller: firstNameController,
                        text: '',
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      InputView(
                        showError: false,
                        hintText: 'Surname',
                        onChange: (newValue) {},
                        controller: surnameController,
                        text: '',
                      ),
                    Expanded(
                      child: Container(),
                    ),
                    InputView(
                      showError: false,
                      hintText: 'Personal Number',
                      onChange: (newValue) {},
                      controller: personalNoController,
                      text: '',
                    ),



                    const SizedBox(
                      height: 16,
                    ),
                    PElevatedButton(
                      onPressed: () {

                      },
                      text: 'ADD AND ASSIGN',
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
    );;
  }
}
