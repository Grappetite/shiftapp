import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shiftapp/model/login_model.dart';

import '../services/login_service.dart';
import '../widgets/drop_down.dart';
import '../widgets/elevated_button.dart';
import 'home.dart';

class DropDownPage extends StatefulWidget {
  List<Process> process;
  DropDownPage({Key? key, required this.process}) : super(key: key);

  @override
  State<DropDownPage> createState() => _DropDownPageState();
}

class _DropDownPageState extends State<DropDownPage> {
  String selectedString = "";
  int processIndexSelected = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage('assets/images/logo-colored.png'),
            width: MediaQuery.of(context).size.width / 1.35,
          ),
          const SizedBox(
            height: 24,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.21,
            child: const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Please select Process',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.21,
            child: DropDown(
              labelText: 'Title',
              currentList: widget.process.map((e) => e.name!.trim()).toList(),
              showError: false,
              onChange: (newString) {
                setState(() {
                  selectedString = newString;
                });

                processIndexSelected = widget.process
                    .map((e) => e.name!.trim())
                    .toList()
                    .indexOf(newString);

                //final List<String> cityNames = cities.map((city) => city.name).toList();
              },
              placeHolderText: 'Process',
              preSelected: selectedString,
            ),
          ),
          Center(
            child: PElevatedButton(
              onPressed: () async {
                if (processIndexSelected == -1) {
                  EasyLoading.showError('Please select a process');

                  return;
                }
                await EasyLoading.show(
                  
                  status: 'loading...',
                  maskType: EasyLoadingMaskType.black,
                );
                var processSelected = widget.process[processIndexSelected];

                var shifts = await LoginService.getShifts(processSelected.id!);

                await EasyLoading.dismiss();

                //shifts!.data!.first.displayScreen = 3;

                if (shifts == null) {
                  EasyLoading.showError('Could not load shifts');
                } else {
                  if (shifts.data!.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomeView(
                          selectedShift: shifts.data!.first,
                          processSelected: processSelected,
                        ),
                      ),
                    );
                  }
                }
                print("object");

                //getShifts
                return;
              },
              text: 'NEXT',
            ),
          )
        ],
      ),
    );
  }
}
