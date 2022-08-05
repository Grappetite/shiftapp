import 'package:flutter/material.dart';
import 'package:shiftapp/model/shifts_model.dart';
import 'package:shiftapp/model/login_model.dart';

import 'home.dart';

class ShiftsListing extends StatefulWidget {
  ShiftsResponse shiftResponse;
  Process processSelected;

  ShiftsListing(
      {Key? key, required this.shiftResponse, required this.processSelected})
      : super(key: key);

  @override
  State<ShiftsListing> createState() => _ShiftsListingState();
}

class _ShiftsListingState extends State<ShiftsListing> {
  List<String> shiftsStrings = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Shift'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text('Please select the shift you can to log for.'),
            Expanded(
              child: ListView.separated(
                itemCount: widget.shiftResponse.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      var shiftSelected =
                          widget.shiftResponse.data![index];

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => HomeView(
                            selectedShift: shiftSelected,
                            processSelected: widget.processSelected,
                          ),
                        ),
                      );

                    },
                    title: Text(widget.shiftResponse.data![index].name!),
                    subtitle: Text(widget.shiftResponse.data![index].startTime! + ' to ' + widget.shiftResponse.data![index].endTime!),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.blueAccent,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
