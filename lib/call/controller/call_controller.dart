import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:videokit/call/view/call_view.dart';
import 'package:videokit/firebase/firebase_controller.dart';
import 'package:videokit/utils/keys.dart';
import 'package:videokit/utils/urls.dart';

import '../model/fire_fcm.dart';

FirebaseController _firebaseController = Get.put(FirebaseController());

class CallController extends GetxController {
  late final Uuid _uuid;
  String? _currentUuid;
  CallKitParams? params;

  @override
  void onInit() async {
    print("call onInit"); // this line not printing
    _uuid = Uuid();
    _currentUuid = "";
    initCurrentCall();
    super.onInit();
  }

  initCurrentCall() async {
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

  Future<void> makeFakeCallInComing() async {
    await Future.delayed(const Duration(seconds: 1), () async {
      var snap = await _firebaseController.getCurrentUser();
      print("MISSED CALL");
      print(snap.docs.toList().first.data());
      try {
        snap != null
            ? params = CallKitParams.fromJson(
                jsonDecode(jsonEncode(snap.docs.toList().first["callDetail"])))
            : null;
      } catch (e) {
        print(e);
      }
      print(params);
      _currentUuid = _uuid.v4();

      // params = CallKitParams(
      //   id: _currentUuid,
      //   nameCaller: 'Hien Nguyen',
      //   appName: 'Callkit',
      //   avatar: 'https://i.pravatar.cc/100',
      //   handle: '0123456789',
      //   type: 0,
      //   duration: 30000,
      //   textAccept: 'Accept',
      //   textDecline: 'Decline',
      //   textMissedCall: 'Missed call',
      //   textCallback: 'Call back',
      //   extra: <String, dynamic>{'userId': '1a2b3c4d'},
      //   headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      //   android: AndroidParams(
      //     isCustomNotification: true,
      //     isShowLogo: false,
      //     isShowCallback: true,
      //     isShowMissedCallNotification: true,
      //     ringtonePath: 'system_ringtone_default',
      //     backgroundColor: '#0955fa',
      //     backgroundUrl: 'assets/test.png',
      //     actionColor: '#4CAF50',
      //     incomingCallNotificationChannelName: 'Incoming Call',
      //     missedCallNotificationChannelName: 'Missed Call',
      //   ),
      //   ios: IOSParams(
      //     iconName: 'CallKitLogo',
      //     handleType: '',
      //     supportsVideo: true,
      //     maximumCallGroups: 2,
      //     maximumCallsPerCallGroup: 1,
      //     audioSessionMode: 'default',
      //     audioSessionActive: true,
      //     audioSessionPreferredSampleRate: 44100.0,
      //     audioSessionPreferredIOBufferDuration: 0.005,
      //     supportsDTMF: true,
      //     supportsHolding: true,
      //     supportsGrouping: false,
      //     supportsUngrouping: false,
      //     ringtonePath: 'system_ringtone_default',
      //   ),
      // );
      // await _firebaseController.getIncomingCall();
      await FlutterCallkitIncoming.showCallkitIncoming(params!);
    });
  }

  Future<void> endCurrentCall() async {
    initCurrentCall();
    await FlutterCallkitIncoming.endCall(_currentUuid!);
  }

  Future<void> startOutGoingCall({required Map<String, dynamic> data}) async {
    _currentUuid = _uuid.v4();
    User user = FirebaseAuth.instance.currentUser!;

    print("KKKELIOFMF $data");
    params = CallKitParams(
      id: data['deviceId'],
      appName: 'Callkit',
      nameCaller: data['displayName'],
      handle: data['email'],
      avatar: data['photoUrl'],
      type: 1,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      textMissedCall: 'Missed call',
      textCallback: 'Call back',
      extra: <String, dynamic>{'userId': data['uid']},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        isShowCallback: true,
        isShowMissedCallNotification: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
        incomingCallNotificationChannelName: 'Incoming Call',
        missedCallNotificationChannelName: 'Missed Call',
      ),
      ios: IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    CallKitParams paramsUser = CallKitParams(
      id: _currentUuid,
      appName: 'Callkit',
      nameCaller: user.displayName,
      handle: user.email,
      avatar: user.photoURL,
      type: 1,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      textMissedCall: 'Missed call',
      textCallback: 'Call back',
      extra: <String, dynamic>{'userId': user.uid},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        isShowCallback: true,
        isShowMissedCallNotification: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
        incomingCallNotificationChannelName: 'Incoming Call',
        missedCallNotificationChannelName: 'Missed Call',
      ),
      ios: IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    //Firebase Set Data in user
    print("::::");
    await _firebaseController.setCallData(params: paramsUser, uid: data['uid']);
    await FlutterCallkitIncoming.startCall(params!);
    await sendFirebaseNotification(ftoken: data['fcmToken']);
  }

  Future<void> activeCalls() async {
    var calls = await FlutterCallkitIncoming.activeCalls();
    print(calls);
  }

  Future<void> endAllCalls() async {
    await FlutterCallkitIncoming.endAllCalls();
  }

  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
        await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
  }

  Future<void> listenerEvent(Function? callback) async {
    try {
      FlutterCallkitIncoming.onEvent.listen((event) async {
        print('HOME: $event');
        switch (event!.event) {
          case Event.ACTION_CALL_INCOMING:
            // TODO: received an incoming call
            // makeFakeCallInComing();
            break;
          case Event.ACTION_CALL_START:
            Get.to(
              () => CallingScreen(
                params: params,
                isOutGoing: true,
              ),
            );
            break;
          case Event.ACTION_CALL_ACCEPT:
            // TODO: accepted an incoming call
            // TODO: show screen calling in Flutter
            Get.to(() => CallingScreen(
                  params: params,
                  isOutGoing: false,
                ));
            // NavigationService.instance
            //     .pushNamedIfNotCurrent(AppRoute.callingPage, args: event.body);
            break;
          case Event.ACTION_CALL_DECLINE:
            // TODO: declined an incoming call
            await requestHttp("ACTION_CALL_DECLINE_FROM_DART");
            break;
          case Event.ACTION_CALL_ENDED:
            // TODO: ended an incoming/outgoing call
            await requestHttp("ACTION_CALL_Ended");
            break;
          case Event.ACTION_CALL_TIMEOUT:
            // TODO: missed an incoming call
            await requestHttp("ACTION_CALL_TIMEOUT");
            break;
          case Event.ACTION_CALL_CALLBACK:
            // TODO: only Android - click action `Call back` from missed call notification
            await requestHttp("ACTION_CALL_CALLBACK");
            break;
          case Event.ACTION_CALL_TOGGLE_HOLD:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_MUTE:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_DMTF:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_GROUP:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
            // TODO: only iOS
            break;
          case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
            // TODO: only iOS
            break;
        }
        if (callback != null) {
          callback(event.toString());
        }
      });
    } on Exception {}
  }

  //check with https://webhook.site/#!/2748bc41-8599-4093-b8ad-93fd328f1cd2
  Future<void> requestHttp(content) async {
    http.get(Uri.parse(
        'https://webhook.site/086fa0b0-d722-417b-be40-7df9d20992d1?data=$content'));
  }

  Future<FirebaseNotificationResponce> sendFirebaseNotification({
    ftoken,
  }) async {
    final body = jsonEncode({
      "to": ftoken,
      "notification": {
        "body": 'msg',
        "title": 'title',
      },
    });
    // dJQuJinQQDSAwjPOfak9an:APA91bEgLMN3S-ENoRT-wVcXFGvzxVpzwFjj0hVGbD8PiLZUqX83anobmrN0W4xj0sE5FsdEmMexIlAP4xtwHlYhUE6exQ2fucPJYm9iUpwLv2CFVm2EMr7tIopmz9lVpkx4JSYOLj95
    try {
      FirebaseNotificationResponce sub;
      print('Post Start');
      final response = await http.post(Uri.parse(AppUrl.fcmSendNotification),
          headers: {
            "Authorization": AppKeys.firebaseMessaging,
            "Content-Type": "application/json"
          },
          body: body);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> uToken = jsonDecode(response.body);
        sub = FirebaseNotificationResponce.fromJson(uToken);
        return sub;
      }
      return FirebaseNotificationResponce();
    } catch (e) {
      rethrow;
    }
  }
}
