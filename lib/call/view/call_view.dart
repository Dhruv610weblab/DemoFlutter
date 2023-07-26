import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:videokit/call/controller/call_controller.dart';
import 'package:http/http.dart';

class CallingScreen extends StatefulWidget {
  CallKitParams? params;
  bool? isOutGoing;
  CallingScreen({Key? key, this.params, this.isOutGoing = false})
      : super(key: key);

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  CallKitParams? calling;
  bool callCut = false;
  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  loadData() async {
    widget.isOutGoing == true && callCut == false
        ? Future.delayed(Duration(seconds: 30), () => Get.back())
        : null;
  }

  @override
  Widget build(BuildContext context) {
    calling = CallKitParams.fromJson(jsonDecode(jsonEncode(widget.params)));
    return GetBuilder<CallController>(
        init: CallController(),
        builder: (__) {
          return Scaffold(
            backgroundColor: Color(0xFF0A55FA),
            body: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AvatarGlow(
                              glowColor: Colors.white,
                              endRadius: 90.0,
                              duration: Duration(milliseconds: 2000),
                              repeat: true,
                              showTwoGlows: true,
                              repeatPauseDuration: Duration(milliseconds: 500),
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[100],
                                  foregroundImage: NetworkImage(
                                    calling!.avatar.toString(),
                                    scale: 1,
                                  ),
                                  radius: Get.width / 6,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              calling!.nameCaller.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 26),
                            ),
                          ),
                          Text(
                            widget.isOutGoing == true
                                ? "Ringing..."
                                : calling!.handle.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  color: Colors.grey,
                                  child: IconButton(
                                    onPressed: widget.isOutGoing == true
                                        ? null
                                        : () {},
                                    color: Colors.white,
                                    icon: Icon(Icons.mic),
                                  ))),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                  padding: EdgeInsets.all(
                                      widget.isOutGoing == true ? 10 : 5),
                                  color: Colors.red,
                                  child: IconButton(
                                    onPressed: () async {
                                      if (calling != null) {
                                        FlutterCallkitIncoming.endCall(
                                            calling!.id!);
                                        calling = null;
                                      }
                                      Get.back();
                                      await __.requestHttp('END_CALL');
                                    },
                                    color: Colors.white,
                                    icon: Icon(
                                      Icons.call_end,
                                      size: widget.isOutGoing == true ? 35 : 25,
                                    ),
                                  ))),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  color: Colors.grey,
                                  child: IconButton(
                                    onPressed: widget.isOutGoing == true
                                        ? null
                                        : () {
                                            setState(() => callCut = true);
                                          },
                                    // => requestHttp('ACTION_CALL_Ended'),
                                    color: Colors.white,
                                    icon: Icon(Icons.volume_up),
                                  ))),
                        ]),
                  )
                ],
              ),
            ),
          );
        });
  }

  // check with https://webhook.site/#!/2748bc41-8599-4093-b8ad-93fd328f1cd2
  // Future<void> requestHttp(content) async {
  //   var res = await get(
  //       Uri.parse('https://webhook.site/086fa0b0-d722-417b-be40-7df9d20992d1'));
  //   print(res.body);
  // }

  @override
  void dispose() {
    super.dispose();
    if (calling != null) FlutterCallkitIncoming.endCall(calling!.id!);
  }
}
