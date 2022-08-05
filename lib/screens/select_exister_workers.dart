import 'package:flutter/material.dart';

import '../config/constants.dart';
import '../widgets/elevated_button.dart';
import 'inner_widgets/add_temp_worker.dart';
import 'inner_widgets/worker_item_view.dart';

class SelectExistingWorkers extends StatefulWidget {
  const SelectExistingWorkers({Key? key}) : super(key: key);

  @override
  State<SelectExistingWorkers> createState() => _SelectExistingWorkersState();
}

class _SelectExistingWorkersState extends State<SelectExistingWorkers> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                              onChanged: (v) {}),
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
                 UserItem(personName: 'personName', personId: 'personId', initialSelected: false, changedStatus: (bool ) {  },),
                const SizedBox(
                  height: 12,
                ),
                 UserItem(personName: 'personName', personId: 'personId', initialSelected: false, changedStatus: (bool ) {  },),
                const SizedBox(
                  height: 12,
                ),
                 UserItem(personName: 'personName', personId: 'personId', initialSelected: false, changedStatus: (bool ) {  },),
                const SizedBox(
                  height: 20,
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
    );
  }
}
