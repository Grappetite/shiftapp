import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../model/workers_model.dart';
import '../services/workers_service.dart';
import 'inner_widgets/worker_item_view.dart';

class WorkersListing extends StatefulWidget {
  final int? shiftId;

  WorkersListing({Key? key, required this.shiftId}) : super(key: key);

  @override
  State<WorkersListing> createState() => _WorkersListingState();
}

class _WorkersListingState extends State<WorkersListing> {
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
    var responseShift = await WorkersService.getShiftWorkers(widget.shiftId);

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

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text(
              'Main Warehouse',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Receiving',
              style: TextStyle(
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
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: PageView(
          controller: controller,
          children: [
            WorkItemView(
              currentIntex: 0,
              totalItems: 3,
              listNames: listNames,
              listLists: listLists,
              shiftId: widget.shiftId,
            ),
          ],
        ),
      ),
    );
  }
}
