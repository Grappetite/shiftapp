import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shiftapp/config/constants.dart';

import '../../model/shifts_model.dart';
import '../../model/workers_model.dart';
import '../../services/workers_service.dart';
import '../../widgets/elevated_button.dart';
import '../select_exister_workers.dart';
import '../start_shift_page.dart';
import 'index_indicator.dart';
import '../../model/login_model.dart';

class WorkItemView extends StatefulWidget {
  final bool isEditing;

  final VoidCallback reloadData;

  final int currentIntex;

  final int processId;
  final ShiftItem selectedShift;

  final int? shiftId;
  final Process process;

  final int totalItems;
  List<String> listNames;
  List<List<ShiftWorker>> listLists;

  WorkItemView(
      {Key? key,
      required this.currentIntex,
      required this.totalItems,
      required this.listNames,
      required this.listLists,
      required this.shiftId,
      required this.processId,
      required this.selectedShift,
      this.isEditing = false,
      required this.process,
      required this.reloadData})
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
    if (widget.isEditing) {}
  }

  List<String> workerIds = [];

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
                if (!widget.isEditing) ...[
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
                ],
                const SizedBox(
                  height: 8,
                ),
                for (int i = 0; i < widget.listNames.length; i++) ...[
                  makeMemberTitleHeader(
                      widget.listNames[i], context, widget.listLists[i], i),
                  const SizedBox(
                    height: 8,
                  ),
                  for (var currentItem in widget.listLists[i]) ...[
                    UserItem(
                      keyNo: currentItem.key != null ? currentItem.key! : '',
                      personName:
                          currentItem.firstName! + ' ' + currentItem.lastName!,
                      initialSelected: currentItem.isSelected,
                      picUrl: currentItem.picture,
                      changedStatus: (bool newStatus) async {
                        currentItem.isSelected = newStatus;

                        String dateString = DateFormat("yyyy-MM-dd hh:mm:ss")
                            .format(DateTime.now());

                        if (widget.isEditing && newStatus) {
                          await EasyLoading.show(
                            status: 'Adding...',
                            maskType: EasyLoadingMaskType.black,
                          );

                          var response = await WorkersService.addWorkers(
                              widget.shiftId!,
                              [currentItem.id!.toString()],
                              [dateString],
                              [],
                              [currentItem.efficiencyCalculation.toString()]);

                          await EasyLoading.dismiss();

                          if (response) {
                          } else {
                            EasyLoading.showError('Error');
                          }
                        } else if (widget.isEditing && !newStatus) {
                          await EasyLoading.show(
                            status: 'Removing...',
                            maskType: EasyLoadingMaskType.black,
                          );

                          var response = await WorkersService.removeWorkers(
                              widget.shiftId!,
                              [currentItem.id!.toString()],
                              [dateString],
                              [],
                              [currentItem.efficiencyCalculation.toString()]);
                          await EasyLoading.dismiss();

                          if (response) {
                          } else {
                            EasyLoading.showError('Error');
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ],
                PElevatedButton(
                  onPressed: () async {
                    if (this.widget.isEditing) {
                      Navigator.pop(context);

                      return;
                    }
                    workerIds = [];

                    List<String> startTime = [];

                    List<String> efficiencyCalculation = [];
                    String dateString = DateFormat("yyyy-MM-dd hh:mm:ss")
                        .format(DateTime.now());

                    setState(() {
                      for (var curentItem in widget.listLists) {
                        for (var currentObject in curentItem) {
                          if (currentObject.isSelected) {
                            workerIds.add(currentObject.id!.toString());
                            startTime.add(dateString);
                            efficiencyCalculation.add(currentObject
                                .efficiencyCalculation!
                                .toString());
                          }
                        }
                      }
                    });

                    int totalCountTemp = 0;
                    for (var currentItem in widget.listLists) {
                      totalCountTemp = totalCountTemp + currentItem.length;
                    }

                    if (workerIds.isEmpty) {
                      return;
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StartShiftView(
                          shiftId: widget.selectedShift.id!,
                          endTime: widget.selectedShift.endTime!,
                          processId: widget.processId,
                          startTime: widget.selectedShift.startTime!,
                          efficiencyCalculation: efficiencyCalculation,
                          userId: workerIds,
                          totalUsersCount: totalCountTemp,
                          selectedShift: widget.selectedShift,
                          process: this.widget.process,
                        ),
                      ),
                    );
                  },
                  text: this.widget.isEditing ? 'RETURN TO SHIFT' : 'NEXT',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row makeMemberTitleHeader(
      String title, context, List<ShiftWorker> workers, int index) {
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
            var response = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SelectExistingWorkers(
                  workers: workers,
                  isEditing: widget.isEditing,
                  shiftId: widget.selectedShift.id!,
                  tempWorkerAdded: (AddTempResponse tmp) {
                    this.widget.reloadData();

                    var index =
                        this.widget.listNames.indexOf(tmp.data!.workerType!);

                    var resulf = this
                        .widget
                        .listNames
                        .contains(tmp.data!.workerType!)
                        .toString();

                    setState(() {
                      this.widget.listLists[index].add(tmp.data!);
                    });

                    print('object');
                  }, processId: widget.processId.toString(),
                ),
              ),
            );

            if (response == null) {
              return;
            }

            ///  this.widget.reloadData();

            if (widget.isEditing) {
              var newlyAdded =
                  workers.where((e) => e.newAdded == true).toList();

              List<String> workerIds = [];
              List<String> startTime = [];

              List<String> efficiencyCalculation = [];

              String dateString = DateFormat("yyyy-MM-dd hh:mm:ss").format(
                DateTime.now(),
              );

              for (var currentObject in newlyAdded) {
                if (currentObject.isSelected) {
                  workerIds.add(currentObject.id!.toString());
                  startTime.add(dateString);
                  efficiencyCalculation
                      .add(currentObject.efficiencyCalculation!.toString());
                }
              }

              setState(() {
                widget.listLists[index] = workers;
              });

              setState(() {
                workersLabel = 'WORKERS';
              });

              await EasyLoading.show(
                status: 'Adding...',
                maskType: EasyLoadingMaskType.black,
              );

              if (workerIds.isEmpty) {
                await EasyLoading.dismiss();

                return;
              }
              var response = await WorkersService.addWorkers(widget.shiftId!,
                  workerIds, startTime, [], efficiencyCalculation);

              await EasyLoading.dismiss();

              if (response) {
              } else {
                EasyLoading.showError('Error');
              }
              print('');
            } else {
              setState(() {
                widget.listLists[index] = workers;
              });

              setState(() {
                workersLabel = 'WORKERS';
              });
            }
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

  final String keyNo;

  final bool disableRatio;

  Function(bool) changedStatus;

  bool initialSelected;

  final Color? colorToShow;
  final String picUrl;

  UserItem({
    Key? key,
    required this.personName,
    required this.keyNo,
    this.colorToShow,
    required this.initialSelected,
    required this.changedStatus,
    this.disableRatio = false,
    required this.picUrl,
  }) : super(key: key);

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.initialSelected
            ? lightGreenColor
            : const Color.fromRGBO(150, 150, 150, 0.12),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: widget.initialSelected
                  ? lightGreenColor
                  : const Color.fromRGBO(150, 150, 150, 0.12), //edited
              spreadRadius: 4,
              blurRadius: 1),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4), // Border width
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(24), // Image radius
                  child: Image.network(widget.picUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
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
                    'Key : ' + widget.keyNo,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Switch(
                value: widget.initialSelected,
                onChanged: (newValue) {
                  if (widget.disableRatio) {
                    return;
                  }
                  setState(() {
                    widget.initialSelected = newValue;
                  });
                  widget.changedStatus(newValue);
                }),
            const SizedBox(
              width: 9,
            ),
          ],
        ),
      ),
    );
  }
}
