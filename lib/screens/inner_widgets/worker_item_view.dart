import 'package:flutter/material.dart';
import 'package:shiftapp/config/constants.dart';

import '../../model/workers_model.dart';
import '../../services/workers_service.dart';
import '../../widgets/elevated_button.dart';
import '../end_shift.dart';
import '../select_exister_workers.dart';
import 'index_indicator.dart';

class WorkItemView extends StatefulWidget {
  final int currentIntex;

  final int shiftId;

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

  String get workerSelected {
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
    // TODO: implement initState
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
                    const Text(
                      'WORKERS',
                      style: TextStyle(
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
                  makeMemberTitleHeader(widget.listNames[i], context),
                  const SizedBox(
                    height: 8,
                  ),
                  for (var currentItem in widget.listLists[i]) ...[
                    UserItem(
                      personId:
                          currentItem.firstName! + ' ' + currentItem.lastName!,
                      personName: currentItem.id!.toString(),
                      colorToShow: !currentItem.isSelected
                          ? const Color.fromRGBO(150, 150, 150, 0.12)
                          : null,
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
                  onPressed: () {

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
                    WorkersService.addWorkers(widget.shiftId, workerIds, startTime, [], efficiencyCalculation);

                    return;

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

  Row makeMemberTitleHeader(String title, context) {
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
          onPressed: () {
            //
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SelectExistingWorkers(),
            ));
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

  final bool initialSelected;

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
  bool checkStatus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkStatus = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: checkStatus
            ? const Color.fromRGBO(212, 237, 218, 1)
            : const Color.fromRGBO(150, 150, 150, 0.12),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: checkStatus
                  ? const Color.fromRGBO(212, 237, 218, 1)
                  : const Color.fromRGBO(150, 150, 150, 0.12), //edited
              spreadRadius: 4,
              blurRadius: 1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4), // Border width
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(24), // Image radius
                  child: Image.network(
                      'https://images.unsplash.com/photo-1537511446984-935f663eb1f4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8b2ZmaWNlJTIwd29ya2VyfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
                      fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(
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
                const SizedBox(
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
                value: checkStatus,
                onChanged: (newValue) {
                  setState(() {
                    checkStatus = newValue;
                  });

                  widget.changedStatus(newValue);
                }),
          ],
        ),
      ),
    );
  }
}
