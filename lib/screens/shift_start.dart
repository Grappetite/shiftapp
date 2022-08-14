import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shiftapp/screens/workers_listing.dart';

import '../config/constants.dart';
import '../model/shifts_model.dart';
import '../model/login_model.dart';
import '../services/shift_service.dart';
import '../widgets/elevated_button.dart';
import 'inner_widgets/change_shift_time.dart';

class ShiftStart extends StatefulWidget {
  final Process processSelected;

  final ShiftItem selectedShift;

  const ShiftStart(
      {Key? key, required this.processSelected, required this.selectedShift})
      : super(key: key);

  @override
  State<ShiftStart> createState() => _ShiftStartState();
}

class _ShiftStartState extends State<ShiftStart> {
  bool showingWorkersListing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: lightBlueColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Morning Shift : 2022/12/01',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    "•",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  'Elapsed :  00:00',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(
          height: 16,
        ),
        if (showingWorkersListing) ...[
          Expanded(
            child: WorkersListing(shiftId: 1,),
            flex: 96,
          ),
        ] else ...[
          Expanded(
            flex: 34,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.14,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryColor,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'NEXT SHIFT:',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      //06:00
                      Text(
                        widget.selectedShift.showStartTime +
                            ' to ' +
                            widget.selectedShift.showEndTime,
                        style: const TextStyle(
                            color: kPrimaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w700),
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
                                return const ChangeShiftTime();
                              });

                          if (selected != null) {
                            return;
                          }
                        },
                        child: const Text(
                          'CHANGE SHIFT TIMES',
                          style: TextStyle(fontSize: 20, color: kPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 40,
            child: TextButton(
              onPressed: () async {


                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WorkersListing(shiftId: null,),
                    ),
                  );


                //
              },
              child: Image.asset('assets/images/start_button.png'),
            ),
          ),
          Expanded(
            flex: 20,
            child: Center(
              child: PElevatedButton(
                onPressed: () {},
                text: 'VIEW PREVIOUS SHIFT',
              ),
            ),
          ),
        ],

        const SizedBox(
          height: 16,
        ),

//#5EC1DC40
      ],
    );
  }
}
