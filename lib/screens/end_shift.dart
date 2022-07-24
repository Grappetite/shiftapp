import 'package:flutter/material.dart';
import 'package:shiftapp/config/constants.dart';

class EndShiftView extends StatefulWidget {
  const EndShiftView({Key? key}) : super(key: key);

  @override
  State<EndShiftView> createState() => _EndShiftViewState();
}

class _EndShiftViewState extends State<EndShiftView> {
  @override
  void initState() {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryColor,
                      width: 3,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        24,
                      ),
                    ),
                  ),
                  width: double.infinity,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'TIME REMAINING: 01 :05 :30',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const ExplainerWidget(
                iconName: 'construct',
                title: 'SOP REQUIRED',
                text1: '4 Workers requir SOP Training',
                text2: 'Tap to train now or swipe to ignore',
                showWarning: true,
              ),
              const SizedBox(
                height: 16,
              ),
              const ExplainerWidget(
                iconName: 'filled-walk',
                title: 'MANAGE WORKERS',
                text1: '15/18 Workers',
                text2: 'Tap to train now or swipe to ignore',
                showWarning: true,
              ),
              const SizedBox(
                height: 16,
              ),
              const ExplainerWidget(
                iconName: 'exclamation',
                title: 'INCIDENTS',
                text1: '5',
                text2: 'Tap to train now or swipe to ignore',
                showWarning: false,
                text1_2: '01:50:00',
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 26,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 52,
                    child: TextButton(
                      onPressed: () {},
                      child: Image.asset('assets/images/start_button.png'),
                    ),
                  ),
                  Expanded(
                    flex: 26,
                    child: Container(),
                  ),

                ],
              ),
              const SizedBox(height: 26,)
            ],
          ),
        ),
      ),
    );
  }
}

class ExplainerWidget extends StatelessWidget {
  final String iconName;
  final String title;
  final String text1;
  final String text1_2;
  final String text2;

  final bool showWarning;

  const ExplainerWidget({
    Key? key,
    required this.iconName,
    required this.title,
    required this.text1,
    required this.text2,
    this.showWarning = false,
    this.text1_2 = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: kPrimaryColor,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              24,
            ),
          ),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/images/$iconName.png'),
                  width: MediaQuery.of(context).size.width / 12,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      if (text1_2.isNotEmpty) ...[
                        Row(
                          children: [
                            const Text(
                              'Incidents Recorded:',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              text1,
                              style: const TextStyle(
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Downtime Recorded:',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              text1_2,
                              style: const TextStyle(
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Text(
                          text1,
                          style: const TextStyle(
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        text2,
                        style: const TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                if (showWarning) ...[
                  Image(
                    image: const AssetImage('assets/images/warning.png'),
                    width: MediaQuery.of(context).size.width / 12,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
