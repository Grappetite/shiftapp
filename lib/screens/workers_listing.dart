import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shiftapp/screens/shift_start.dart';

import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../model/workers_model.dart';
import '../services/workers_service.dart';
import 'inner_widgets/worker_item_view.dart';

class WorkersListing extends StatefulWidget {
  int? shiftId;
  ShiftItem? selectedShift;

  int? processId;
  Process? process;

  WorkersListing(
      {Key? key,
      this.shiftId,
      this.processId,
      this.selectedShift,
      this.process})
      : super(key: key);

  @override
  State<WorkersListing> createState() => _WorkersListingState();
}

class _WorkersListingState extends State<WorkersListing> {
  String timeElasped = '00:00';
  late Timer _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          timeElasped = widget.selectedShift!.timeElasped;
        });

        print('');
      },
    );
  }

  final PageController controller = PageController(viewportFraction: 0.94);
  List<String> listNames = [];

  List<List<ShiftWorker>> listLists = [];

  int workersSelected = 0;

  bool isLoader = true;

  void loadData() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var responseShift =
        await WorkersService.getShiftWorkers(widget.shiftId, widget.processId!);

    if (responseShift!.data!.worker!.isEmpty) {
      responseShift = await WorkersService.getShiftWorkers(
          widget.selectedShift!.id, widget.processId!);
    }
    List<ShiftWorker> shiftWorkers = [];

    shiftWorkers.addAll(responseShift!.data!.worker!);

    workersSelected = responseShift.data!.shiftWorker!.length;

    for (var currentItem in responseShift.data!.shiftWorker!) {
      currentItem.isSelected = true;

      shiftWorkers.add(currentItem);
    }

    var seen = <String>{};

    if (shiftWorkers.isNotEmpty) {
      shiftWorkers.where((student) => seen.add(student.workerType!)).toList();

      listNames = seen.toList();
    } else {
      listNames = [];
    }

    await EasyLoading.dismiss();

    for (var currentItem in listNames) {
      var response =
          shiftWorkers.where((e) => e.workerType == currentItem).toList();
      setState(() {
        listLists.add(response);
      });
    }

    setState(() {
      isLoader = false;
    });

    print('');
  }

  @override
  void initState() {
    super.initState();
    //startTimer();
    widget.shiftId = Get.arguments["shiftId"];
    widget.processId = Get.arguments["processId"];
    widget.selectedShift = Get.arguments["selectedShift"];
    widget.process = Get.arguments["process"];
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/toplogo.png',
                  height: 20,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.process!.name!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 2,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TimerTopWidget(
              selectedShift: widget.selectedShift!,
              timeElasped: timeElasped,
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: WorkItemView(
                currentIntex: 0,
                totalItems: 3,
                listNames: listNames,
                listLists: listLists,
                shiftId: widget.shiftId,
                processId: widget.processId!,
                selectedShift: widget.selectedShift!,
                process: this.widget.process!,
                reloadData: () {
                  loadData();
                }, execShiftId: 0,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
