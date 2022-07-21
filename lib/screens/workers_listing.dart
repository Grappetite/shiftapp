import 'package:flutter/material.dart';

import 'inner_widgets/worker_item_view.dart';

class WorkersListing extends StatefulWidget {


  WorkersListing({Key? key}) : super(key: key);

  @override
  State<WorkersListing> createState() => _WorkersListingState();
}

class _WorkersListingState extends State<WorkersListing> {
  final PageController controller = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    return  PageView(
      controller: controller,
      children: const [
        WorkItemView(currentIntex: 0,totalItems: 3,),
        WorkItemView(currentIntex: 1,totalItems: 3,),
        WorkItemView(currentIntex: 2,totalItems: 3,),
      ],
    );
  }
}
