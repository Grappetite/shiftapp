import 'dart:async';
import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/model/shifts_model.dart';

import '../Network/API.dart';
import '../Routes/app_pages.dart';
import '../model/worker_type_model.dart';
import '../model/workers_model.dart';
import '../services/workers_service.dart';

class HomeController extends GetxController {
  int? executeShiftId;

  String timeElasped = '00:00';
  late Timer _timer;
  int totalUsersCount = 0;
  int numberSelected = 0;

  String timeRemaining = '00:00';

  var isTimeOver = false;
  int workersSelected = 0;

  bool showCategories = false;

  List<List<ShiftWorker>> listLists = [];
  List<String> listNames = [];
  List<WorkerType> workerType = [];

  bool isLoader = true;

  void loadWorkerTypesWorkersListing(context, shiftId, processId) async {
    //execute_shift_id

    var result = await WorkersService.getWorkTypes(
        shiftId.toString(), processId.toString());

    if (result != null) {
      workerType = result.data!;
      update();
      for (var currentItem in workerType) {
        listNames.add(currentItem.name!);
        listLists.add([]);
        update();
      }

      // await EasyLoading.dismiss();

    } else {
      // await EasyLoading.dismiss();

      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Error while loading data',
        actions: [
          AlertDialogAction(
            label: MaterialLocalizations.of(context).okButtonLabel,
            key: OkCancelResult.ok,
          )
        ],
      );
    }
    // workerType = result!.data!;
    update();
  }

  void loadDataWorkersListing(context, shiftId, processId) async {
    // await EasyLoading.show(
    //   status: 'loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );
    var responseShift =
        await WorkersService.getShiftWorkers(shiftId, processId!);

    if (responseShift == null) {
      // await EasyLoading.dismiss();
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Error while loading data',
        actions: [
          AlertDialogAction(
            label: MaterialLocalizations.of(context).okButtonLabel,
            key: OkCancelResult.ok,
          )
        ],
      );

      return;
    }

    if (responseShift.data!.worker!.isEmpty) {
      showCategories = true;
      loadWorkerTypesWorkersListing(context, shiftId, processId);
      return;

// >>>>>>> master
    }
    List<ShiftWorker> shiftWorkers = [];

    shiftWorkers.addAll(responseShift.data!.worker!);

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

    //await EasyLoading.dismiss();

    for (var currentItem in listNames) {
      var response =
          shiftWorkers.where((e) => e.workerType == currentItem).toList();

      listLists.add(response);
      update();
    }

    isLoader = false;
    update();

    print('');
  }

  void loadWorkerTypes(shiftId, processId) async {
    //execute_shift_id

    var result = await WorkersService.getWorkTypes(
        shiftId.toString(), processId.toString());

    if (result != null) {
      workerType = result.data!;
      update();
      for (var currentItem in workerType) {
        listNames.add(currentItem.name!);
        listLists.add([]);
        update();
      }

      // await EasyLoading.dismiss();

    }
    // workerType = result!.data!;
    update();
  }

  void loadWorkers(processId, context, shiftId) async {
    // await EasyLoading.show(
    //   status: 'Adding...',
    //   maskType: EasyLoadingMaskType.black,
    // );

    var responseShift =
        await WorkersService.getShiftWorkers(executeShiftId, processId!);

    if (responseShift != null) {
      if (responseShift.data!.shiftWorker!.length == 0) {
        showCategories = true;
        loadWorkerTypes(shiftId, processId);

        return;
      }
      // await EasyLoading.dismiss();

    } else {
      // await EasyLoading.dismiss();

      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Error while loading data',
        actions: [
          AlertDialogAction(
            label: MaterialLocalizations.of(context).okButtonLabel,
            key: OkCancelResult.ok,
          )
        ],
      );
    }

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

    for (var currentItem in listNames) {
      var response =
          shiftWorkers.where((e) => e.workerType == currentItem).toList();

      listLists.add(response);
      update();
    }
  }

  void loadShiftId(processId) async {
    // final prefs = await SharedPreferences.getInstance();

    executeShiftId = Api().sp.read('execute_shift_id');

    // this.executeShiftId = execShiftId;

    loadUsers(processId);
  }

  void loadUsers(processId) async {
    var responseShift =
        await WorkersService.getShiftWorkers(executeShiftId!, processId!);

    numberSelected = responseShift!.data!.shiftWorker!.length;

    totalUsersCount = responseShift.data!.shiftWorker!.length +
        responseShift.data!.worker!.length;
    update();

    print('');
  }

  onEndShiftInit({required selectedShift, required processId}) {
    loadShiftId(processId);

    // appMenu02 =

    startTimer(selectedShift);
  }

  void startTimer(selectedShift) {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (selectedShift!.timeRemaining.contains('Over')) {
          timeRemaining = selectedShift!.timeRemaining.replaceAll('Over ', '');
          isTimeOver = true;
        } else {
          timeRemaining = selectedShift!.timeRemaining;
        }

        timeElasped = selectedShift!.timeElasped;
        update();

        print('');
      },
    );
  }

  void moveToEndSession(
      {required Process processSelected,
      required ShiftItem selectedShift,
      required bool sessionStarted,
      required VoidCallback onLogout}) async {
    // await EasyLoading.show(
    //   status: 'loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );

    await Future.delayed(const Duration(seconds: 1));
    //await EasyLoading.dismiss();

    var executeShiftId = Api().sp.read('execute_shift_id');

    var response = await Get.offNamed(Routes.endShift, arguments: {
      "autoOpen": true,
      "userId": const [],
      "efficiencyCalculation": const [],
      "shiftId": selectedShift.id!,
      "processId": processSelected.id!,
      "selectedShift": selectedShift,
      "startedBefore": true,
      "process": processSelected,
      "execShiftId": executeShiftId!,
    });
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => EndShiftView(
    //       autoOpen: true,
    //       userId: const [],
    //       efficiencyCalculation: const [],
    //       shiftId: selectedShift.id!,
    //       processId: processSelected.id!,
    //       selectedShift: selectedShift,
    //       comment: comment!,
    //       startedBefore: true,
    //       process: processSelected,
    //       execShiftId: executeShiftId!,
    //     ),
    //   ),
    // );

    if (response != null) {
      if (response == true) {
        onLogout();
      }
    }
    print('=');
  }
}
