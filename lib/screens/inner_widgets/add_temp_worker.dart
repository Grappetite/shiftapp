import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../../config/constants.dart';
import '../../model/worker_type_model.dart';
import '../../services/workers_service.dart';
import '../../widgets/drop_down.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/input_view.dart';
import 'alert_title_label.dart';

class AddTempWorker extends StatefulWidget {
  final String shiftId;

  final int exId;

  final String processId;
  final String listname;

  const AddTempWorker(
      {Key? key,
      required this.shiftId,
      required this.processId,
      required this.listname,
      required this.exId})
      : super(key: key);

  @override
  State<AddTempWorker> createState() => _AddTempWorkerState();
}

class _AddTempWorkerState extends State<AddTempWorker> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController personalNoController = TextEditingController();

  int? tempWorkerId;

  List<WorkerType> workerType = [];

  String selectedWorkerType = '';
  String selectedWorkerTypeID = '';

  void loadWorkerTypes() async {
    var result = await WorkersService.getWorkTypes(
        this.widget.shiftId, widget.processId);
    workerType = result!.data!;
    if (mounted) {
      for (var element in workerType) {
        if (element.name == this.widget.listname) {
          selectedWorkerTypeID = element.id.toString();
          selectedWorkerType = element.name.toString();
        }
      }
      setState(() {
        workerType = result.data!;
      });
    }
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
        height: MediaQuery.of(context).size.height / 1.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey, width: 3),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 4),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
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
                      customHeight: 50,
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
                      customHeight: 50,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: InputView(
                              showError: false,
                              hintText: 'Employee nr',
                              onChange: (newValue) {},
                              controller: personalNoController,
                              text: '',
                              customHeight: 50,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          if (workerType.isEmpty) ...[
                            Expanded(
                              child: Center(
                                child: SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: const CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ] else ...[
                            Expanded(
                              child: DropDown(
                                labelText: 'Title',
                                currentList: workerType
                                    .map((e) => e.name!.trim())
                                    .toList(),
                                enabled: false,
                                showError: false,
                                onChange: (newString) {
                                  if (mounted)
                                    setState(() {
                                      selectedWorkerType = newString;
                                    });

                                  selectedWorkerTypeID = workerType
                                      .firstWhere((e) => e.name == newString)
                                      .id!
                                      .toString();
                                },
                                placeHolderText: 'Worker Type',
                                preSelected: selectedWorkerType,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    PElevatedButton(
                      onPressed: () async {
                        await EasyLoading.show(
                          dismissOnTap: false,
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );

                        String dateString =
                            DateFormat("yyyy-MM-dd HH:mm:ss").format(
                          DateTime.now(),
                        );

                        var response = await WorkersService.addTempWorkers(
                            firstNameController.text,
                            surnameController.text,
                            personalNoController.text,
                            selectedWorkerTypeID,
                            widget.exId.toString(),
                            dateString);

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
