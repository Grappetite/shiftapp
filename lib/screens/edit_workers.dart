import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/login_model.dart';
import '../model/shifts_model.dart';
import '../model/workers_model.dart';
import '../services/workers_service.dart';
import 'inner_widgets/worker_item_view.dart';

class EditWorkers extends StatefulWidget {
  int? shiftId;
  int? execShiftId;

  int? processId;
  List<dynamic>? userId;
  int? totalUsersCount;
  String? startTime;
  String? endTime;
  List<dynamic>? efficiencyCalculation;
  ShiftItem? selectedShift;
  Process? process;

  EditWorkers(
      {Key? key,
      this.shiftId,
      this.processId,
      this.userId,
      this.totalUsersCount,
      this.startTime,
      this.endTime,
      this.efficiencyCalculation,
      this.selectedShift,
      this.process,
      this.execShiftId})
      : super(key: key);

  @override
  State<EditWorkers> createState() => _EditWorkersState();
}

class _EditWorkersState extends State<EditWorkers> {
  List<List<ShiftWorker>> listLists = [];
  List<String> listNames = [];

  @override
  void initState() {
    widget.shiftId = Get.arguments["shiftId"];
    widget.execShiftId = Get.arguments["execShiftId"];
    widget.processId = Get.arguments["processId"];
    widget.userId = Get.arguments["userId"];
    widget.totalUsersCount = Get.arguments["totalUsersCount"];
    widget.startTime = Get.arguments["startTime"];
    widget.endTime = Get.arguments["endTime"];
    widget.efficiencyCalculation = Get.arguments["efficiencyCalculation"];
    widget.selectedShift = Get.arguments["selectedShift"];
    widget.process = Get.arguments["process"];

    super.initState();

    loadWorkers();
  }

  int workersSelected = 0;

  void loadWorkers() async {
    // await EasyLoading.show(
    //   status: 'Adding...',
    //   maskType: EasyLoadingMaskType.black,
    // );

    var responseShift = await WorkersService.getShiftWorkers(
        widget.execShiftId, widget.processId!);

    List<ShiftWorker> shiftWorkers = [];

    shiftWorkers.addAll(responseShift!.data!.worker!);

    workersSelected = responseShift.data!.shiftWorker!.length;

    for (var currentItem in responseShift.data!.shiftWorker!) {
      currentItem.isSelected = true;

      shiftWorkers.add(currentItem);
    }

    var seen = <String>{};

    shiftWorkers.where((student) => seen.add(student.workerType!)).toList();

    listNames = seen.toList();
    //await EasyLoading.dismiss();

    for (var currentItem in listNames) {
      var response =
          shiftWorkers.where((e) => e.workerType == currentItem).toList();
      setState(() {
        listLists.add(response);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Image.asset(
              'assets/images/toplogo.png',
              height: 20,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              widget.process!.name!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 2,
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: WorkItemView(
            currentIntex: 0,
            processId: widget.processId!,
            listLists: listLists,
            listNames: listNames,
            selectedShift: widget.selectedShift!,
            shiftId: widget.shiftId,
            totalItems: widget.totalUsersCount!,
            isEditing: true,
            process: this.widget.process!,
            reloadData: () {},
            execShiftId: widget.execShiftId!,
          ),
        ),
      ),
    );
  }
}
