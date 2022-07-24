import 'package:flutter/material.dart';

import 'inner_widgets/worker_item_view.dart';

class WorkersListing extends StatefulWidget {


  WorkersListing({Key? key}) : super(key: key);

  @override
  State<WorkersListing> createState() => _WorkersListingState();
}

class _WorkersListingState extends State<WorkersListing> {
  final PageController controller = PageController(viewportFraction: 0.94);

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
        padding: const EdgeInsets.only(top: 8,bottom: 16),
        child: PageView(
          controller: controller,
          children: const [
            WorkItemView(currentIntex: 0,totalItems: 3,),

          ],
        ),
      ),
    );
  }
}
