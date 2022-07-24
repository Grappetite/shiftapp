import 'package:flutter/material.dart';
import 'package:shiftapp/config/constants.dart';

import '../../widgets/elevated_button.dart';
import '../select_exister_workers.dart';
import 'index_indicator.dart';

class WorkItemView extends StatelessWidget {
  final int currentIntex;

  final int totalItems;

  const WorkItemView(
      {Key? key, required this.currentIntex, required this.totalItems})
      : super(key: key);

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
                      total: totalItems,
                      currentIndex: currentIntex,
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
                      children: const <TextSpan>[
                        TextSpan(
                          text: '8',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
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
                makeMemberTitleHeader('TEAM LEADER',context),
                const SizedBox(
                  height: 8,
                ),
                const UserItem(personId: 'Franco Dave', personName: '4778',),
                const SizedBox(height: 16,),
                const UserItem(personId: 'Franco Dave', personName: '4778', colorToShow: Color.fromRGBO(150, 150, 150, 0.12),),
                SizedBox(height: 24,),
                makeMemberTitleHeader('DATA CAPTURER',context),
                const UserItem(personId: 'Franco Dave', personName: '4778',),
                SizedBox(height: 16,),
                const UserItem(personId: 'Franco Dave', personName: '4778', colorToShow: Color.fromRGBO(150, 150, 150, 0.12),),
                SizedBox(height: 24,),
                PElevatedButton(
                  onPressed: () {

                  },
                  text: 'CANCEL SHIFT START',
                ),
                const SizedBox(height: 8,),
                PElevatedButton(
                  onPressed: () {

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

  Row makeMemberTitleHeader(String title,context) {
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
              builder: (context) => SelectExistingWorkers(),
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

class UserItem extends StatelessWidget {
  final String personName;
  final String personId;

  final Color? colorToShow;
  
   const UserItem({
    Key? key, required this.personName, required this.personId, this.colorToShow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorToShow == null ? const Color.fromRGBO(212, 237, 218, 1) : colorToShow!,
        borderRadius: BorderRadius.circular(16),
        boxShadow:  [
          BoxShadow(
              color: colorToShow == null ? const Color.fromRGBO(212, 237, 218, 1) : colorToShow!, //edited
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
              children:  [
                Text(
                  personName,
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
                  personId,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            Switch(value: true, onChanged: (newValue) {}),

          ],
        ),
      ),
    );
  }
}
