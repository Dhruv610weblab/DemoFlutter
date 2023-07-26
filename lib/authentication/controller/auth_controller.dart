import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:videokit/firebase/firebase_controller.dart';

class LoginController extends GetxController {
  RxBool isLogin = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  @override
  void onInit() {
    checkUserLoggedIn();
    super.onInit();
  }

  Future<void> loginWithGoogle() async {
    try {
      final FirebaseController _firebaseController =
          Get.put(FirebaseController());
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user!;
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      final User currentUser = _auth.currentUser!;
      assert(user.uid == currentUser.uid);
      await _firebaseController.saveUserDataToDatabase();
      isLogin(true);
      return;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<void> logoutGoogle() async {
    await googleSignIn.signOut();
    isLogin(false);
    // navigate to your wanted page after logout.
  }

  Future<void> checkUserLoggedIn() async {
    User? user = _auth.currentUser;
    if (user != null) {
      loginWithGoogle();
    } else {
      isLogin(false);
    }
  }

  // Future<String?> getDeviceId() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) {
  //     // import 'dart:io'
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //   } else if (Platform.isAndroid) {
  //     var androidDeviceInfo = await deviceInfo.androidInfo;
  //     return androidDeviceInfo.androidId; // unique ID on Android
  //   }
  // }
}
