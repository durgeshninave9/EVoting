import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:online_voting_system/database.dart';
import 'package:online_voting_system/handler/user_handler.dart';
import 'package:online_voting_system/model/user_model.dart';
import 'package:online_voting_system/screens/home_screen.dart';
import 'package:online_voting_system/screens/login.dart';

class AuthenticateHandler extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  Rxn<User> firebaseuser = Rxn<User>();
  var controller = Get.put(UserHandler());

  String? get user => firebaseuser.value!.email;

  @override
  void onInit() {
    firebaseuser.bindStream(auth.authStateChanges());
  }

  void addUser(img, name, phno, email, pswd, id) async {
    try {
      var authResult = await auth.createUserWithEmailAndPassword(
          email: email.trim(), password: pswd.trim());
      UserModel user = UserModel(
          img: img,
          id: authResult.user!.uid,
          name: name,
          phone: phno,
          email: email,
          ownedElect: [],
      );
      if (await Database().addnewUser(user)) {
        Get.find<UserHandler>().user = user;
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error 505', e.toString());
    }
  }

  void signInUsers(String email, String pswd) async {
    try {
      var authResult =
          await auth.signInWithEmailAndPassword(email: email, password: pswd);
      FirebaseAuth.instance
          .idTokenChanges()
          .listen((User? user) {
        if (user == null) {
          Get.back();
          print('User is currently signed out!');
        } else {
          print('User is signed in!');
          Get.to(const EVoting());
        }
      });

      Get.find<UserHandler>().user =
          await Database().getUserData(authResult.user!.uid);
      // Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void signOutUser() {
    try {
      auth.signOut();
      Get.find<UserHandler>().clear();
      // Get.to(SignIn());
    } catch (e) {
      Get.snackbar('Error 505', e.toString());
    }
  }
}
