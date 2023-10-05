import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shiftapp/screens/splash.dart';
import 'package:timezone/data/latest_all.dart';

import 'config/BaseConfig.dart';
import 'config/FirebaseConfig.dart';
import 'config/constants.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);

  //print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
  );

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  flutterLocalNotificationsPlugin.show(
    1,
    message.data["title"],
    message.data["body"],
    NotificationDetails(
      android: AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        channelDescription: 'your other channel description',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(''),
      ),
      iOS: DarwinNotificationDetails(),
    ),
  );
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
const _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kIsWeb)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb)
    FlutterError.onError = (errorDetails) {
      // If you wish to record a "non-fatal" exception, please use `FirebaseCrashlytics.instance.recordFlutterError` instead
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
  if (!kIsWeb)
    PlatformDispatcher.instance.onError = (error, stack) {
      // If you wish to record a "non-fatal" exception, please remove the "fatal" parameter
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  const String? environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.dev,
  );
  Environment().initConfig(environment);
  configLoading();
  if (!kIsWeb)
    FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  initializeTimeZones();
  bool? result = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
          ) async {});

  if (!kIsWeb) {
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }
  runApp(MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _initializeFlutterFireFuture;

  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      //print(list[100]);
    });
  }

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    if (_kShouldTestAsyncErrorOnInit) {
      await _testAsyncErrorOnInit();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!kIsWeb) _initializeFlutterFireFuture = _initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF0E577F, primaryMap),
      ),
      builder: EasyLoading.init(builder: (context, child) {
        child = MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        );
        return child;
      }),
      home: FutureBuilder(
          future: !kIsWeb ? _initializeFlutterFireFuture : Future.value(true),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return SplashScreen();
              // return Center(
              //   child: Column(
              //     children: <Widget>[
              //       ElevatedButton(
              //         onPressed: () {
              //           FirebaseCrashlytics.instance
              //               .setCustomKey('example', 'flutterfire');
              //           ScaffoldMessenger.of(context)
              //               .showSnackBar(const SnackBar(
              //             content: Text(
              //                 'Custom Key "example: flutterfire" has been set \n'
              //                 'Key will appear in Firebase Console once an error has been reported.'),
              //             duration: Duration(seconds: 5),
              //           ));
              //         },
              //         child: const Text('Key'),
              //       ),
              //       ElevatedButton(
              //         onPressed: () {
              //           FirebaseCrashlytics.instance
              //               .log('This is a log example');
              //           ScaffoldMessenger.of(context)
              //               .showSnackBar(const SnackBar(
              //             content: Text(
              //                 'The message "This is a log example" has been logged \n'
              //                 'Message will appear in Firebase Console once an error has been reported.'),
              //             duration: Duration(seconds: 5),
              //           ));
              //         },
              //         child: const Text('Log'),
              //       ),
              //       ElevatedButton(
              //         onPressed: () async {
              //           ScaffoldMessenger.of(context)
              //               .showSnackBar(const SnackBar(
              //             content: Text('App will crash is 5 seconds \n'
              //                 'Please reopen to send data to Crashlytics'),
              //             duration: Duration(seconds: 5),
              //           ));
              //
              //           // Delay crash for 5 seconds
              //           sleep(const Duration(seconds: 5));
              //
              //           // Use FirebaseCrashlytics to throw an error. Use this for
              //           // confirmation that errors are being correctly reported.
              //           FirebaseCrashlytics.instance.crash();
              //         },
              //         child: const Text('Crash'),
              //       ),
              //       ElevatedButton(
              //         onPressed: () {
              //           ScaffoldMessenger.of(context)
              //               .showSnackBar(const SnackBar(
              //             content: Text(
              //                 'Thrown error has been caught and sent to Crashlytics.'),
              //             duration: Duration(seconds: 5),
              //           ));
              //
              //           // Example of thrown error, it will be caught and sent to
              //           // Crashlytics.
              //           throw StateError('Uncaught error thrown by app');
              //         },
              //         child: const Text('Throw Error'),
              //       ),
              //       ElevatedButton(
              //         onPressed: () {
              //           ScaffoldMessenger.of(context)
              //               .showSnackBar(const SnackBar(
              //             content: Text(
              //                 'Uncaught Exception that is handled by second parameter of runZonedGuarded.'),
              //             duration: Duration(seconds: 5),
              //           ));
              //
              //           // Example of an exception that does not get caught
              //           // by `FlutterError.onError` but is caught by
              //           // `runZonedGuarded`.
              //           runZonedGuarded(() {
              //             Future<void>.delayed(const Duration(seconds: 2), () {
              //               final List<int> list = <int>[];
              //               //print(list[100]);
              //             });
              //           }, FirebaseCrashlytics.instance.recordError);
              //         },
              //         child: const Text('Async out of bounds'),
              //       ),
              //       ElevatedButton(
              //         onPressed: () async {
              //           try {
              //             ScaffoldMessenger.of(context)
              //                 .showSnackBar(const SnackBar(
              //               content: Text('Recorded Error'),
              //               duration: Duration(seconds: 5),
              //             ));
              //             throw Error();
              //           } catch (e, s) {
              //             // "reason" will append the word "thrown" in the
              //             // Crashlytics console.
              //             await FirebaseCrashlytics.instance.recordError(e, s,
              //                 reason: 'as an example of fatal error',
              //                 fatal: true);
              //           }
              //         },
              //         child: const Text('Record Fatal Error'),
              //       ),
              //       ElevatedButton(
              //         onPressed: () async {
              //           try {
              //             ScaffoldMessenger.of(context)
              //                 .showSnackBar(const SnackBar(
              //               content: Text('Recorded Error'),
              //               duration: Duration(seconds: 5),
              //             ));
              //             throw Error();
              //           } catch (e, s) {
              //             // "reason" will append the word "thrown" in the
              //             // Crashlytics console.
              //             await FirebaseCrashlytics.instance.recordError(e, s,
              //                 reason: 'as an example of non-fatal error');
              //           }
              //         },
              //         child: const Text('Record Non-Fatal Error'),
              //       ),
              //     ],
              //   ),
              // );
              default:
                return SplashScreen();
            }
          }),
    );
  }
}
