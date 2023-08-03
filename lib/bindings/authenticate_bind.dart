import 'package:get/get.dart';
import 'package:online_voting_system/handler/auth_handler.dart';

class AuthenticationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthenticateHandler>(() => AuthenticateHandler());
  }
}
