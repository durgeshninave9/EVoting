import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_voting_system/bindings/authenticate_bind.dart';
import 'package:online_voting_system/bindings/candidate_bind.dart';
import 'package:online_voting_system/handler/auth_handler.dart';
import 'package:online_voting_system/handler/user_handler.dart';
import 'package:online_voting_system/screens/add_newcandidate.dart';
import 'package:online_voting_system/screens/add_votes.dart';
import 'package:online_voting_system/screens/authentication.dart';
import 'package:online_voting_system/screens/cast_vote.dart';
import 'package:online_voting_system/screens/final_result.dart';
import 'package:online_voting_system/screens/home_screen.dart';
import 'package:online_voting_system/screens/login.dart';
import 'package:online_voting_system/screens/new_vote.dart';
import 'package:online_voting_system/screens/setting.dart';
import 'package:online_voting_system/screens/user_data.dart';
import 'package:online_voting_system/screens/vote_display.dart';
import 'package:online_voting_system/widget/offline.dart';
import 'package:online_voting_system/widget/upload_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
var email;
void main() async {
  AddCandidateBinding().dependencies();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs =await SharedPreferences.getInstance();
  email=prefs.getString("email");

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(UserHandler());
    Get.put(AuthenticateHandler());

//     User? firebaseUser = FirebaseAuth.instance.currentUser;
// // Define a widget
//     Widget firstWidget;
//
// // Assign widget based on availability of currentUser
//     if (firebaseUser != null) {
//       firstWidget = const EVoting();
//     } else {
//       firstWidget = const SignIn();
//     }

    return GetMaterialApp(
      defaultTransition: Transition.noTransition,
      debugShowCheckedModeBanner: false,
      initialBinding: AuthenticationBinding(),
      title: 'E-Voting',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: email == null ? const SignIn() : const EVoting(),
      initialRoute: '/',
      routes: {
        'auth': (context) => const Authentication(),
        'settings': (context) => const SignIn(),
        'profile': (context) => const EVoting(),
        'create_vote': (context) => const NewVotes(),
        'sign_out' : (context) => const SignIn(),
      },

    );
  }
}
