import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../model/login_model.dart';
import '../model/shifts_model.dart';
import '../model/worker_type_model.dart';
import '../model/workers_model.dart';
import '../services/workers_service.dart';
import 'inner_widgets/worker_item_view.dart';

class EditWorkers extends StatefulWidget {
  final int shiftId;
  final int execShiftId;

  final int processId;
  final List<String> userId;
  final int totalUsersCount;
  final String startTime;
  final String endTime;
  final List<String> efficiencyCalculation;
  final ShiftItem selectedShift;
  final Process process;

  const EditWorkers(
      {Key? key,
      required this.shiftId,
      required this.processId,
      required this.userId,
      required this.totalUsersCount,
      required this.startTime,
      required this.endTime,
      required this.efficiencyCalculation,
      required this.selectedShift,
      required this.process,
      required this.execShiftId})
      : super(key: key);

  @override
  State<EditWorkers> createState() => _EditWorkersState();
}

class _EditWorkersState extends State<EditWorkers> {
  List<List<ShiftWorker>> listLists = [];
  List<String> listNames = [];

  @override
  void initState() {
    super.initState();

    loadWorkers();
  }

  int workersSelected = 0;

  bool showCategories = false;

  List<WorkerType> workerType = [];

  void loadWorkerTypes() async {

    //execute_shift_id

    var result = await WorkersService.getWorkTypes(widget.shiftId.toString(),widget.processId.toString());


    if(result != null) {
      setState(() {
        workerType = result.data!;
      });
      for(var currentItem in workerType){


        setState(() {
          listNames.add(currentItem.name!);
          listLists.add([]);
        });


      }

      await EasyLoading.dismiss();


    }
   // workerType = result!.data!;
    setState(() {
     // workerType = result.data!;
    });
  }

  void loadWorkers() async {
    await EasyLoading.show(
      status: 'Adding...',
      maskType: EasyLoadingMaskType.black,
    );

    var responseShift = await WorkersService.getShiftWorkers(
        widget.execShiftId, widget.processId);

    if (responseShift != null) {


      if (responseShift.data!.shiftWorker!.length == 0) {
        showCategories = true;
        loadWorkerTypes();

        return;
      }
      await EasyLoading.dismiss();



    } else {
      await EasyLoading.dismiss();

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

 //   responseShift!.data!.worker = responseShift.data!.shiftWorker!.where((e) => e.isAdded == false).toList();
   // responseShift.data!.shiftWorker = responseShift.data!.shiftWorker!.where((e) => e.isAdded == true).toList();


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
              widget.process.name!,
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
            processId: widget.processId,
            listLists: listLists,
            listNames: listNames,
            selectedShift: widget.selectedShift,
            shiftId: widget.shiftId,
            totalItems: widget.totalUsersCount,
            isEditing: true,
            process: this.widget.process,
            reloadData: () {
              loadWorkers();
            },
            execShiftId: widget.execShiftId,
            workerType: this.workerType,
          ),
        ),
      ),
    );
  }
}
