import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_voting_system/model/user_model.dart';
import 'package:online_voting_system/screens/home_screen.dart';
import 'package:online_voting_system/screens/login.dart';

class UserHandler extends GetxController {
  Rx<UserModel> usermodel = UserModel(ownedElect: []).obs;
  UserModel get user => usermodel.value;
  set user(UserModel value) => usermodel.value = value;
  void clear() {
    usermodel.value = UserModel(ownedElect: []);
  }

  UserModel fromDocumentSnapshot(DocumentSnapshot doc) {
    UserModel user = UserModel(ownedElect: doc['ownedElect']);
    user.id = doc.id;
    user.email = doc['email'];
    user.name = doc['name'];
    user.phone = doc['phone'];
    user.ownedElect = doc['ownedElect'];
    user.img = doc["img"];

    return user;
  }
}
