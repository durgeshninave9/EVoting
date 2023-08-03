import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:online_voting_system/model/candidate_model.dart';

class CandidateHandler extends GetxController {
  CandidateModel fromDocumentSnapshot(DocumentSnapshot doc) {
    CandidateModel candidate = CandidateModel(imgUrl: '');
    candidate.name = doc['name'];
    candidate.desc = doc['desc'];
    return candidate;
  }
}
