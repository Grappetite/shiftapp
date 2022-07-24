import 'package:flutter/material.dart';

import '../config/constants.dart';

class SelectExistingWorkers extends StatefulWidget {
  const SelectExistingWorkers({Key? key}) : super(key: key);

  @override
  State<SelectExistingWorkers> createState() => _SelectExistingWorkersState();
}

class _SelectExistingWorkersState extends State<SelectExistingWorkers> {
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
            /*
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 4,
            blurRadius: 10, //edited
          )
        ],*/
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(height: 8,),
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
                      onTap: (){

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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
