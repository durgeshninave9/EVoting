import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:online_voting_system/database.dart';
import 'package:online_voting_system/handler/user_handler.dart';
import 'package:online_voting_system/model/election_model.dart';

// CODE FOR VOTE ACCESS
const symbols =
    '0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYzyz';
Random rand = Random();

String randomString(int l) => String.fromCharCodes(Iterable.generate(
    l, (_) => symbols.codeUnitAt(rand.nextInt(symbols.length))));

class ElectionHandler extends GetxController {
  final Rx<ElectionModel> _electionModel = ElectionModel().obs;
  ElectionModel currentElection = ElectionModel();

  ElectionModel get election => _electionModel.value;

  set election(ElectionModel value) => _electionModel.value = value;

  bool endElection() {
    _electionModel.value.endDate = DateTime.now().toString();
    return true;
  }


  ElectionModel fromDocumentSnapshot(DocumentSnapshot doc) {
    ElectionModel election = ElectionModel();
    election.id = doc.id;
    election.name = doc['name'];
    election.desc = doc['desc'];
    election.accessId = doc['accessId'];
    election.startDate = doc['startDate'];
    election.endDate = doc['endDate'];
    election.options = doc['options'];
    election.owner = doc['owner'];
    election.voted = doc['voted'];

    return election;
  }

  newElection(name, desc, startDate, endDate) {
    ElectionModel electionModel = ElectionModel(
        accessId: randomString(6),
        name: name,
        desc: desc,
        startDate: startDate,
        endDate: endDate,
        voted: [],
        owner: Get.find<UserHandler>().user.id,);
    Database().addnewElection(electionModel);
  }

  candidate(String id, String eleid) {
    Database().candidateData(id, eleid);
  }

  saveAccessData(String str) {
    Clipboard.setData(ClipboardData(text: str));
    Get.snackbar(
      'ACCESS CODE COPIED',
      'ACCESS CODE COPIED SUCCESSFULLY',
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      overlayBlur: 1.0,
      margin: const EdgeInsets.only(bottom: 50.0),
      barBlur: 0.5,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.green,
      ),
      backgroundGradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.redAccent, Colors.blueAccent]),
    );
  }

  getElectionData(String id, String eleid) {
    Database().getElection(id, eleid).then((value) => Get.find<ElectionHandler>().election=value);
  }
}
