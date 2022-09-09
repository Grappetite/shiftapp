import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiftapp/screens/shift_start.dart';

import '../Controllers/HomeController.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../model/worker_type_model.dart';
import '../model/workers_model.dart';
import 'inner_widgets/worker_item_view.dart';

class WorkersListing extends StatelessWidget {
  int? shiftId = Get.arguments["shiftId"];
  ShiftItem? selectedShift = Get.arguments["selectedShift"];

  int? processId = Get.arguments["processId"];
  Process? process = Get.arguments["process"];

  String timeElasped = '00:00';

  final PageController pagecontroller = PageController(viewportFraction: 0.94);
  List<String> listNames = [];

  List<List<ShiftWorker>> listLists = [];

  int workersSelected = 0;

  List<WorkerType> workerType = [];

  bool showCategories = false;

  // @override
  // void initState() {
  //   super.initState();
  //   //startTimer();
  //   loadDataWorkersListing();
  // }
  HomeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(initState: (c) {
      controller.loadDataWorkersListing(context, shiftId, processId);
    }, builder: (logic) {
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
                    process!.name!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
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
                selectedShift: selectedShift!,
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
                  shiftId: shiftId,
                  processId: processId!,
                  selectedShift: selectedShift!,
                  process: this.process!,
                  reloadData: () {
                    controller.loadDataWorkersListing(
                        context, shiftId, processId);
                  },
                  execShiftId: 0,
                  workerType: this.workerType,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      );
    });
  }
}
