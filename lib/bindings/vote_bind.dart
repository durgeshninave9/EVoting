import 'package:get/get.dart';
import 'package:online_voting_system/handler/election_handler.dart';

class VoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ElectionHandler>(() => ElectionHandler());
  }
}
