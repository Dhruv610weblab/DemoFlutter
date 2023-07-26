import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:videokit/authentication/controller/auth_controller.dart';
import 'package:videokit/authentication/views/login_google.dart';
import 'package:videokit/call/view/call_view.dart';
import 'package:videokit/firebase/firebase_controller.dart';
import 'package:videokit/firebase_options.dart';
import 'package:videokit/views/home.dart';

import 'call/controller/call_controller.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  CallController callController = Get.put(CallController());
  callController.makeFakeCallInComing();
  // var snap = await _firebaseController.getCurrentUser();
  // CallKitParams? params;
  // snap != null
  //     ? params = CallKitParams.fromJson(
  //         jsonDecode(jsonEncode(snap.docs.toList().first["callDetail"])))
  //     : null;
  // showCallkitIncoming(Uuid().v4(), params);
}

// Future<void> showCallkitIncoming(String uuid, param) async {
//   // final params = param;
//   print("DHKDHKHKL LJL FJLF");
//   // CallKitParams(param.toString());
//   print(param.toString());
//   // final params = CallKitParams(
//   //   id: uuid,
//   //   nameCaller: 'Hien Nguyen',
//   //   appName: 'Callkit',
//   //   avatar: 'https://i.pravatar.cc/100',
//   //   handle: '0123456789',
//   //   type: 0,
//   //   duration: 30000,
//   //   textAccept: 'Accept',
//   //   textDecline: 'Decline',
//   //   textMissedCall: 'Missed call',
//   //   textCallback: 'Call back',
//   //   extra: <String, dynamic>{'userId': '1a2b3c4d'},
//   //   headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
//   //   android: AndroidParams(
//   //     isCustomNotification: true,
//   //     isShowLogo: false,
//   //     isShowCallback: true,
//   //     isShowMissedCallNotification: true,
//   //     ringtonePath: 'system_ringtone_default',
//   //     backgroundColor: '#0955fa',
//   //     backgroundUrl: 'assets/test.png',
//   //     actionColor: '#4CAF50',
//   //   ),
//   //   ios: IOSParams(
//   //     iconName: 'CallKitLogo',
//   //     handleType: '',
//   //     supportsVideo: true,
//   //     maximumCallGroups: 2,
//   //     maximumCallsPerCallGroup: 1,
//   //     audioSessionMode: 'default',
//   //     audioSessionActive: true,
//   //     audioSessionPreferredSampleRate: 44100.0,
//   //     audioSessionPreferredIOBufferDuration: 0.005,
//   //     supportsDTMF: true,
//   //     supportsHolding: true,
//   //     supportsGrouping: false,
//   //     supportsUngrouping: false,
//   //     ringtonePath: 'system_ringtone_default',
//   //   ),
//   // );
//   await FlutterCallkitIncoming.showCallkitIncoming(param);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final LoginController _loginController = Get.put(LoginController());
  late final Uuid _uuid;
  String? _currentUuid;
  late final FirebaseMessaging _firebaseMessaging;
  // MethodChannel plateform = MethodChannel('backgroundservices');
  //
  // void startService() async {
  //   dynamic value = plateform.invokeMethod('startServices');
  //   print(value);
  // }

  @override
  void initState() {
    // startService();
    _uuid = Uuid();
    initFirebase();
    WidgetsBinding.instance.addObserver(this);
    //Check call when open app from terminated
    // checkAndNavigationCallingPage();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    await _loginController.checkUserLoggedIn();
    super.didChangeDependencies();
  }

  getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        _currentUuid = calls[0]['id'];
        return calls[0];
      } else {
        _currentUuid = "";
        return null;
      }
    }
  }

  // checkAndNavigationCallingPage() async {
  //   var currentCall = await getCurrentCall();
  //   if (currentCall != null) {
  //     Get.to(() => CallingScreen());
  //   }
  // }

  final CallController callController = Get.put(CallController());
  final FirebaseController firebaseController = Get.put(FirebaseController());
  initFirebase() async {
    await Firebase.initializeApp();
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
      // _currentUuid = _uuid.v4();
      callController.makeFakeCallInComing();
      // var snap = await firebaseController.getCurrentUser();
      // print("SNAPP  ${snap.docs}");
      // print(snap.docs.toList().first);
      // CallKitParams? params;
      // snap != null
      //     ? params = CallKitParams.fromJson(
      //         jsonDecode(jsonEncode(snap.docs.toList().first["callDetail"])))
      //     : null;
      // print(params);
      // showCallkitIncoming(_currentUuid!, params);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print(
          'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
      callController.makeFakeCallInComing();
      // _currentUuid = _uuid.v4();
      // var snap = await _firebaseController.getCurrentUser();
      // CallKitParams? params;
      // snap != null
      //     ? params = CallKitParams.fromJson(
      //         jsonDecode(jsonEncode(snap.docs.toList().first["callDetail"])))
      //     : null;
      // showCallkitIncoming(_currentUuid!, params);
    });
    _firebaseMessaging.getToken().then((token) {
      print('Device Token FCM: $token');
      firebaseController.fcmToken(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Obx(
          () => _loginController.isLogin.value ? HomePage() : GoogleLogin()),
    );
  }

  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
        await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
  }
}
