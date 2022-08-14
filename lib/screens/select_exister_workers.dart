import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../config/constants.dart';
import '../model/workers_model.dart';
import '../services/workers_service.dart';
import '../widgets/elevated_button.dart';
import 'inner_widgets/add_temp_worker.dart';
import 'inner_widgets/worker_item_view.dart';

class SelectExistingWorkers extends StatefulWidget {
  List<ShiftWorker>  workers;

  SelectExistingWorkers({Key? key,required this.workers}) : super(key: key);

  @override
  State<SelectExistingWorkers> createState() => _SelectExistingWorkersState();
}

class _SelectExistingWorkersState extends State<SelectExistingWorkers> {
  TextEditingController searchController = TextEditingController();

  bool isSearching = false;
  List<ShiftWorker>  workers = [];

  List<ShiftWorker>  filteredWorkers = [];

  void callSearchService() async {

    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );


    var response = await WorkersService.searchWorkers(widget.workers.first.workerTypeId!.toString());

    setState(() {
      workers = response!.searchWorker!;

    });

    filteredWorkers =  response!.searchWorker!;



    await EasyLoading.dismiss();


    for(var currentItem in widget.workers) {

      var find = workers.where((e) => e.userId == currentItem.userId && currentItem.isSelected == true).toList();

      if(find.isNotEmpty) {

        setState(() {
          find.first.isSelected = true;

        });

      }

    }


  }
  @override
  void initState() {
    super.initState();
    filteredWorkers =  widget.workers;
    callSearchService();


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
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey, width: 3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'SELECT EXISTING WORKERS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.close,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: kPrimaryColor,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: TextFormField(
                                controller: searchController,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16,
                                  ),
                                ),
                                onChanged: (v) {


                                  if(v.isEmpty) {
                                    setState(() {
                                      isSearching = false;
                                    });

                                    return;

                                  }



                                  filteredWorkers = workers.where((e) => (e.firstName! + ' ' + e.lastName!).contains(v)).toList();

                                  //filteredWorkers
                                  setState(() {
                                    isSearching = true;
                                  });



                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  PElevatedButton(
                    text: 'ADD SELECTED WORKERS (2)',
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                   if(isSearching) ... [
                     for(var currentItem in filteredWorkers) ... [

                       UserItem(
                         personId:
                         currentItem.firstName! + ' ' + currentItem.lastName!,
                         personName: currentItem.id!.toString(),
                         initialSelected: currentItem.isSelected,
                         changedStatus: (bool newStatus) {

                           var find = widget.workers.where((e) => e.userId == currentItem.userId).toList();
                           currentItem.isSelected = newStatus;

                           if(find.isNotEmpty) {
                             find.first.isSelected = newStatus;
                           }
                           else {

                             widget.workers.add(currentItem);

                           }

                         },
                       ),

                       const SizedBox(
                         height: 12,
                       ),

                     ],
                   ] else ... [
                     for(var currentItem in workers) ... [

                       UserItem(
                         personId:
                         currentItem.firstName! + ' ' + currentItem.lastName!,
                         personName: currentItem.id!.toString(),
                         initialSelected: currentItem.isSelected,
                         changedStatus: (bool newStatus) {

                           var find = widget.workers.where((e) => e.userId == currentItem.userId).toList();
                           currentItem.isSelected = newStatus;

                           if(find.isNotEmpty) {
                             find.first.isSelected = newStatus;
                           }
                           else {

                             widget.workers.add(currentItem);

                           }






                         },
                       ),

                       const SizedBox(
                         height: 12,
                       ),

                     ],
                   ],

                  const SizedBox(
                    height: 8,
                  ),
                  
                  const Text(
                    'Cannot find workers?',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      onSurface: kPrimaryColor,
                      side: const BorderSide(
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onPressed: () async {
                      bool? selected = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const AddTempWorker();
                          });
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        const Icon(Icons.add),
                        Expanded(
                          child: Container(),
                        ),
                        const Text(
                          'ADD TEMPORARY WORKER',
                          style: TextStyle(fontSize: 16, color: kPrimaryColor),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
