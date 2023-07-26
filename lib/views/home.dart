import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:videokit/authentication/controller/auth_controller.dart';
import 'package:videokit/call/controller/call_controller.dart';
import 'package:videokit/firebase/firebase_controller.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final FirebaseController _firebaseController = Get.put(FirebaseController());
  final CallController _callController = Get.put(CallController());
  String textEvents = "";

  @override
  void initState() {
    textEvents = "";
    _callController.listenerEvent(onEvent);
    super.initState();
  }

  onEvent(event) {
    if (!mounted) return;
    setState(() {
      textEvents += "${event.toString()}\n";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: LoginController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  FirebaseAuth.instance.currentUser!.displayName.toString()),
              actions: [
                IconButton(
                    onPressed: () => _.logoutGoogle(), icon: Icon(Icons.logout))
              ],
            ),
            body: SafeArea(
                child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseController.getFirebaseUser(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return Text('Loading...');
                }
                return ListView.builder(
                  padding: EdgeInsets.only(top: 8),
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    var name = data['displayName'];
                    var profileImg = data['photoUrl'];
                    var email = data['email'];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        style: ListTileStyle.list,
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(profileImg)),
                        title: Text(name),
                        subtitle: Text(email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () =>
                                    _callController.makeFakeCallInComing(),
                                icon: Icon(
                                  Icons.video_call,
                                  color: Colors.blue,
                                )),
                            IconButton(
                                onPressed: () => _callController
                                    .startOutGoingCall(data: data),
                                icon: Icon(
                                  Icons.call,
                                  color: Colors.green,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )),
          );
        });
  }
}
