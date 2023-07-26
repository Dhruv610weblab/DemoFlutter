import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class FirebaseController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final fcmToken = ''.obs;
  Future<void> saveUserDataToDatabase() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // var ff;
      // try {
      //   ff = _firestore.collection('users').doc(user.uid).get();
      // } catch (e) {
      //   print(e);
      // } finally {
      //   ff == null
      //       ?
      await _firestore.collection('users').doc(user.uid).set({
        'deviceId': Uuid().v4(),
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoURL,
        'updatedAt': DateTime.now(),
        'fcmToken': fcmToken.value
      })
          // : await _firestore.collection('users').doc(user.uid).update({
          //     'deviceId': Uuid().v4(),
          //     'uid': user.uid,
          //     'email': user.email,
          //     'displayName': user.displayName,
          //     'photoUrl': user.photoURL,
          //     'updatedAt': DateTime.now()
          //   })
          ;
      // }
    }
  }

  Future<void> setCallData({CallKitParams? params, required uid}) async {
    // User? user = _auth.currentUser;
    print(":::SET DAATa");
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'callDetail': jsonDecode(jsonEncode(params))});
  }

  Future<QuerySnapshot> getCurrentUser() async {
    User? user = _auth.currentUser;
    print("FIRS");
    var subscription = await _firestore
        .collection('users')
        .where('uid', isEqualTo: user!.uid)
        .get();
    return subscription;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFirebaseUser() {
    User? user = _auth.currentUser;
    var subscription = _firestore
        .collection('users')
        .where('uid', isNotEqualTo: user!.uid)
        .snapshots();
    print(subscription);
    return subscription;
  }
}
