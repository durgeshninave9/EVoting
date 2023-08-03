 // ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_voting_system/handler/election_handler.dart';
import 'package:online_voting_system/handler/user_handler.dart';
import 'package:get/get.dart';
import 'package:online_voting_system/model/election_model.dart';
import 'package:online_voting_system/model/user_model.dart';
import 'package:online_voting_system/screens/add_newcandidate.dart';

class Database {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final uid = Get.find<UserHandler>().user.id;
  List<UserModel> users = <UserModel>[];
  List<ElectionModel> elections = <ElectionModel>[];
  ElectionModel electionModel = ElectionModel();
  ElectionHandler electionHandler = Get.put(ElectionHandler());
  late DocumentReference reference;

  Future<bool> addnewUser(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.id).set({
        "name": user.name,
        "phone": user.phone,
        "email": user.email,
        "img": user.img,
        "ownedElect": [],
        "id":user.id,
      });
      return true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return false;
    }
  }

  Future<UserModel> getUserData(String userid) async {
    try {
      DocumentSnapshot data =
          await firestore.collection('users').doc(userid).get();
      return Get.find<UserHandler>().fromDocumentSnapshot(data) ;

    } catch (e) {
      // ignore: avoid_print
      print(e);
      rethrow;
    }
  }

  Future<DocumentReference?> addnewElection(ElectionModel ele) async {
    try {
      await firestore.collection('users').doc(uid).collection('elections').add({
        'options': [],
        'name': ele.name,
        'desc': ele.desc,
        'startDate': ele.startDate,
        'endDate': ele.endDate,
        'accessId': ele.accessId,
        'voted': [],
        'owner': ele.owner
      }).then((value) {
        firestore.collection('users').doc(uid).update({
          "ownedElect": FieldValue.arrayUnion([value.id])
        });

        Get.to(const AddNewCandidate(), arguments: [value, ele]);
      });

      return reference;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }

  Future<bool> addnewCandidate(eleId, img, name, desc) async {
    try {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('elections')
          .doc(eleId)
          .update({
        "options": FieldValue.arrayUnion([
          {
            // 'img': img,
            'name': name,
            'desc': desc,
            'count': 1,
          }
        ])
      });
      return true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      Get.snackbar('ERROR 505', "unexpected error occurs");
      return false;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> candidateData(
      String userid, String eleid) async {
    var data = await firestore
        .collection('users')
        .doc(uid)
        .collection('elections')
        .doc(eleid)
        .get();
    return data;
  }

  Future<ElectionModel> getElection(String userid, String eleid) async {
    var data = await firestore
        .collection('users')
        .doc(userid)
        .collection('elections')
        .doc(eleid)
        .get();
    return Get.find<ElectionHandler>().fromDocumentSnapshot(data);
  }

  Stream<ElectionModel> getElections(userID) {
    var snaps;
    firestore.collection("users").doc(userID).snapshots().map((user) {
      snaps = user.data()!['ownedElect'].map((electionOwned) {
        return firestore
            .collection("users")
            .doc(userID)
            .collection("elections")
            .doc(electionOwned)
            .snapshots();
      });
      print(snaps);
    });
    print("Snaaaaaaaaaps oooooooh $snaps");
    return snaps;
  }
}
