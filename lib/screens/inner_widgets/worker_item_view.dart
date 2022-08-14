import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shiftapp/config/constants.dart';

import '../../model/workers_model.dart';
import '../../services/workers_service.dart';
import '../../widgets/elevated_button.dart';
import '../end_shift.dart';
import '../select_exister_workers.dart';
import 'index_indicator.dart';

class WorkItemView extends StatefulWidget {
  final int currentIntex;

  final int? shiftId;

  final int totalItems;
  List<String> listNames;
  List<List<ShiftWorker>> listLists;

  WorkItemView(
      {Key? key,
      required this.currentIntex,
      required this.totalItems,
      required this.listNames,
      required this.listLists, required this.shiftId})
      : super(key: key);

  @override
  State<WorkItemView> createState() => _WorkItemViewState();
}

class _WorkItemViewState extends State<WorkItemView> {
  int workersSelected = 0;

  String workersLabel = 'WORKERS';

  String get workerSelected {

    workersSelected = 0;

    for (var currenList in widget.listLists) {
      for (var currentObject in currenList) {
        if (currentObject.isSelected) {
          workersSelected = workersSelected + 1;
        }
      }
    }

    return workersSelected.toString();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.28,
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
                    Image(
                      image: const AssetImage('assets/images/walk.png'),
                      width: MediaQuery.of(context).size.width / 18,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      workersLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    IndexIndicator(
                      total: widget.totalItems,
                      currentIndex: widget.currentIntex,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: workerSelected,
                          style: const TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        const TextSpan(
                          text: ' Workers Selected',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Tick to select multiple, swipe left to remove',
                  style: TextStyle(
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                for (int i = 0; i < widget.listNames.length; i++) ...[
                  makeMemberTitleHeader(widget.listNames[i], context,widget.listLists[i],i),
                  const SizedBox(
                    height: 8,
                  ),
                  for (var currentItem in widget.listLists[i]) ...[
                    UserItem(
                      personId:
                          currentItem.firstName! + ' ' + currentItem.lastName!,
                      personName: currentItem.id!.toString(),
                      initialSelected: currentItem.isSelected,
                      changedStatus: (bool newStatus) {
                        currentItem.isSelected = newStatus;

                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ],
                PElevatedButton(
                  onPressed: () {},
                  text: 'CANCEL SHIFT START',
                ),
                const SizedBox(
                  height: 8,
                ),
                PElevatedButton(
                  onPressed: () async {

                    List<String> workerIds = [];
                    List<String> startTime = [];

                    List<String> executeShiftId = [];
                    List<String> efficiencyCalculation = [];

                    for(var curentItem in widget.listLists) {
                      for(var currentObject in curentItem){
                        if(currentObject.isSelected) {

                          workerIds.add(currentObject.id!.toString());
                          startTime.add('2022-06-05 06:09:04');

                          efficiencyCalculation.add(currentObject.efficiencyCalculation!.toString());


                          //
                        }
                      }
                    }
                    await EasyLoading.show(
                      status: 'loading...',
                      maskType: EasyLoadingMaskType.black,
                    );

                    WorkersService.addWorkers(0, workerIds, startTime, [], efficiencyCalculation);


                    await EasyLoading.dismiss();


                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EndShiftView(),
                      ),
                    );
                  },
                  text: 'NEXT',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row makeMemberTitleHeader(String title, context , List<ShiftWorker>  workers, int index) {
    return Row(
      children: [
        Text(
          '$title:',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kPrimaryColor,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        IconButton(
          onPressed: () async {

            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SelectExistingWorkers(workers: workers,),
            ),);

            setState(() {
              widget.listLists[index] = workers;
            });

            setState(() {
              workersLabel = 'WORKERS';
            });


          },
          icon: const Icon(
            Icons.search,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }
}

class UserItem extends StatefulWidget {
  final String personName;
  final String personId;

  Function(bool) changedStatus;

  bool initialSelected;

  final Color? colorToShow;


  UserItem({
    Key? key,
    required this.personName,
    required this.personId,
    this.colorToShow,
    required this.initialSelected,
    required this.changedStatus,
  }) : super(key: key);

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {

  @override
  void initState() {
   // checkStatus = widget.initialSelected;


    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.initialSelected
            ?  Color.fromRGBO(212, 237, 218, 1)
            :  Color.fromRGBO(150, 150, 150, 0.12),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: widget.initialSelected
                  ?  Color.fromRGBO(212, 237, 218, 1)
                  :  Color.fromRGBO(150, 150, 150, 0.12), //edited
              spreadRadius: 4,
              blurRadius: 1),
        ],
      ),
      child: Padding(
        padding:  EdgeInsets.all(4.0),
        child: Row(
          children: [
            Container(
              padding:  EdgeInsets.all(4), // Border width
              decoration:  BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: ClipOval(
                child: SizedBox.fromSize(
                  size:  Size.fromRadius(24), // Image radius
                  child: Image.network(
                      'https://images.unsplash.com/photo-1537511446984-935f663eb1f4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8b2ZmaWNlJTIwd29ya2VyfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
                      fit: BoxFit.cover),
                ),
              ),
            ),
             SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.personName,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                 SizedBox(
                  height: 4,
                ),
                Text(
                  widget.personId,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Switch(
                value: widget.initialSelected,
                onChanged: (newValue) {
                  setState(() {
                    widget.initialSelected = newValue;
                  });

                  widget.changedStatus(newValue);
                }),
          ],
        ),
      ),
    );
  }
}
