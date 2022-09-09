import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiftapp/Controllers/HomeController.dart';

import '../../model/login_model.dart';
import '../model/shifts_model.dart';
import 'inner_widgets/worker_item_view.dart';

class EditWorkers extends StatelessWidget {
  int? shiftId = Get.arguments["shiftId"];
  int? execShiftId = Get.arguments["execShiftId"];

  int? processId = Get.arguments["processId"];
  List<dynamic>? userId = Get.arguments["userId"];
  int? totalUsersCount = Get.arguments["totalUsersCount"];
  String? startTime = Get.arguments["startTime"];
  String? endTime = Get.arguments["endTime"];
  List<dynamic>? efficiencyCalculation = Get.arguments["efficiencyCalculation"];
  ShiftItem? selectedShift = Get.arguments["selectedShift"];
  Process? process = Get.arguments["process"];

  HomeController controller = Get.find();

  // void loadWorkerTypes() async {
  //   //execute_shift_id
  //
  //   var result = await WorkersService.getWorkTypes(
  //       shiftId.toString(), processId.toString());
  //
  //   if (result != null) {
  //     setState(() {
  //       workerType = result.data!;
  //     });
  //     for (var currentItem in workerType) {
  //       setState(() {
  //         listNames.add(currentItem.name!);
  //         listLists.add([]);
  //       });
  //     }
  //
  //     // await EasyLoading.dismiss();
  //
  //   }
  //   // workerType = result!.data!;
  //   setState(() {
  //     // workerType = result.data!;
  //   });
  // }

  // void loadWorkers() async {
  //   // await EasyLoading.show(
  //   //   status: 'Adding...',
  //   //   maskType: EasyLoadingMaskType.black,
  //   // );
  //
  //   var responseShift = await WorkersService.getShiftWorkers(
  //       execShiftId, processId!);
  //
  //   if (responseShift != null) {
  //     if (responseShift.data!.shiftWorker!.length == 0) {
  //       showCategories = true;
  //       loadWorkerTypes();
  //
  //       return;
  //     }
  //     // await EasyLoading.dismiss();
  //
  //   } else {
  //     // await EasyLoading.dismiss();
  //
  //     showAlertDialog(
  //       context: context,
  //       title: 'Error',
  //       message: 'Error while loading data',
  //       actions: [
  //         AlertDialogAction(
  //           label: MaterialLocalizations.of(context).okButtonLabel,
  //           key: OkCancelResult.ok,
  //         )
  //       ],
  //     );
  //   }
  //
  //   List<ShiftWorker> shiftWorkers = [];
  //
  //   shiftWorkers.addAll(responseShift!.data!.worker!);
  //
  //   workersSelected = responseShift.data!.shiftWorker!.length;
  //
  //   for (var currentItem in responseShift.data!.shiftWorker!) {
  //     currentItem.isSelected = true;
  //
  //     shiftWorkers.add(currentItem);
  //   }
  //
  //   var seen = <String>{};
  //
  //   shiftWorkers.where((student) => seen.add(student.workerType!)).toList();
  //
  //   listNames = seen.toList();
  //
  //   for (var currentItem in listNames) {
  //     var response =
  //         shiftWorkers.where((e) => e.workerType == currentItem).toList();
  //     setState(() {
  //       listLists.add(response);
  //     });
  //   }
  // }

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
              process!.name!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
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
            processId: processId!,
            listLists: controller.listLists,
            listNames: controller.listNames,
            selectedShift: selectedShift!,
            shiftId: shiftId,
            totalItems: totalUsersCount!,
            isEditing: true,
            process: this.process!,
            reloadData: () {
              controller.loadWorkers(processId, context, shiftId);
            },
            execShiftId: execShiftId!,
            workerType: controller.workerType,
          ),
        ),
      ),
    );
  }
}
