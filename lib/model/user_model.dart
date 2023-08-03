import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? img;
  String? id;
  String? phone;
  String? name;
  String? email;
  List<dynamic>? ownedElect;

  UserModel(
      { this.img,
       this.id,
       this.name,
       this.phone,
       this.email,
        required this.ownedElect});
  // UserModel fromDocumentSnapshot(DocumentSnapshot doc) {
  //   UserModel user = UserModel(ownedElect: doc['ownedElect']);
  //   user.id = doc.id;
  //   user.email = doc['email'];
  //   user.name = doc['name'];
  //   user.phone = doc['phone'];
  //   user.ownedElect = doc['ownedElect'];
  //   user.img = doc['img'];
  //   return user;
  // }
}
