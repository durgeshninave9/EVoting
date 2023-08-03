import 'package:get/get.dart';
import 'package:online_voting_system/database.dart';
import 'package:online_voting_system/handler/election_handler.dart';
import 'package:online_voting_system/handler/user_handler.dart';

class AddCandidateBinding extends Bindings {
  @override
  void dependencies() {
    getData() async {
      var data;
      await Database().candidateData
          (Get.find<UserHandler>().user.id.toString(),
          Get.arguments[0].id.toString())
          .then((election) {
        data = election.data()!['options'];
        Get.find<ElectionHandler>().currentElection.options = data;
      });
    }
  }
}
