import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../config/constants.dart';
import '../../model/worker_type_model.dart';
import '../../model/workers_model.dart';
import '../../services/workers_service.dart';
import '../../widgets/drop_down.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/input_view.dart';
import 'alert_cancel_ok_buttons.dart';
import 'alert_title_label.dart';

class AddTempWorker extends StatefulWidget {
  final String shiftId;

  const AddTempWorker({Key? key, required this.shiftId}) : super(key: key);

  @override
  State<AddTempWorker> createState() => _AddTempWorkerState();
}

class _AddTempWorkerState extends State<AddTempWorker> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController personalNoController = TextEditingController();

  List<WorkerType> workerType = [];

  String selectedWorkerType = '';
  String selectedWorkerTypeID = '';

  void loadWorkerTypes() async {
    var result = await WorkersService.getWorkTypes(1);
    workerType = result!.data!;
    setState(() {
      workerType = result.data!;
    });
  }

  @override
  void initState() {
    super.initState();
    loadWorkerTypes();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      backgroundColor: Colors.transparent,
      content: Container(
        width: MediaQuery.of(context).size.width / 1.15,
        height: MediaQuery.of(context).size.height / 1.4,
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
                      hintText: 'Personal Key',
                      onChange: (newValue) {},
                      controller: personalNoController,
                      text: '',
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    if (workerType.isEmpty) ...[
                      const CircularProgressIndicator(),
                    ] else ...[
                      DropDown(
                        labelText: 'Title',
                        currentList:
                            workerType.map((e) => e.name!.trim()).toList(),
                        showError: false,
                        onChange: (newString) {
                          setState(() {
                            selectedWorkerType = newString;
                          });

                          selectedWorkerTypeID = workerType
                              .firstWhere((e) => e.name == newString)
                              .id!
                              .toString();

                          /*
                        setState(() {
                          selectedString = newString;
                        });*/

                          //final List<String> cityNames = cities.map((city) => city.name).toList();
                        },
                        placeHolderText: 'Worker Type',
                        preSelected: selectedWorkerType,
                      ),
                    ],
                    const SizedBox(
                      height: 16,
                    ),
                    PElevatedButton(
                      onPressed: () async {
                        //addTempWorkers
                        await EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );

                        var response = await WorkersService.addTempWorkers(
                            firstNameController.text,
                            surnameController.text,
                            personalNoController.text,
                            selectedWorkerTypeID,
                            this.widget.shiftId,
                            '2022-06-05 06:09:04');
                        await EasyLoading.dismiss();

                        if (response != null) {
                          Navigator.pop(context, response);
                        }
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
    );
    ;
  }
}
