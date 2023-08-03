import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:online_voting_system/database.dart';
import 'package:online_voting_system/handler/auth_handler.dart';
import 'package:online_voting_system/handler/user_handler.dart';
import 'package:online_voting_system/model/election_model.dart';
import 'package:online_voting_system/screens/login.dart';
import 'package:online_voting_system/screens/setting.dart';
import 'package:online_voting_system/screens/user_data.dart';

late ElectionModel ele;
void GetElection(uid, eleid) async {
  ele = await Database().getElection(uid, eleid);
}

Widget leadingIcon(IconData icon) {
  return CircleAvatar(
    backgroundColor: Colors.blueGrey,
    child: Icon(
      icon,
      color: Colors.white60,
    ),
  );
}

class CustomerDesign extends StatefulWidget {
  const CustomerDesign({super.key});

  @override
  State<CustomerDesign> createState() => _CustomerDesignState();
}

class _CustomerDesignState extends State<CustomerDesign> {
  @override
  Widget build(BuildContext context) {
    Get.put(UserHandler());
    return  Drawer(
            child: Container(
              color: Colors.grey,
              child: ListView(
                padding: const EdgeInsets.all(10.0),
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Obx(
                      () => Text(
                        Get.find<UserHandler>().user.name.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    accountEmail: Obx(
                      () => Text(Get.find<UserHandler>().user.email.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                    // currentAccountPicture: CircleAvatar(
                    //   radius: 50,
                    //   backgroundImage:
                    //       NetworkImage(Get.find<UserHandler>().user.img.toString()),
                    // ),
                    otherAccountsPictures: const <Widget>[
                      Icon(
                        Icons.notification_important_rounded,
                        color: Colors.white,
                      )
                    ],
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.brown.shade400, Colors.grey.shade500
                        ])),
                  ),
                  ListTile(
                    title: const Text('Home'),
                    subtitle: const Text('Go to homepage'),
                    leading: leadingIcon(Icons.home),
                    onLongPress: () {},
                  ),
                  ListTile(
                    title: const Text('Owned Elections'),
                    subtitle: const Text('My elections'),
                    leading: leadingIcon(Icons.how_to_vote),
                    onLongPress: () {},
                    onTap: () => Get.to(UserData()),
                  ),
                  ListTile(
                    title: const Text('Change Theme'),
                    subtitle: const Text('Modify settings'),
                    leading: leadingIcon(Icons.settings),
                    onLongPress: () {},
                    onTap: () => Get.to(const Setting()),
                  ),
                  ListTile(
                    title: const Text('About'),
                    subtitle: const Text('About E-Voting'),
                    leading: leadingIcon(Icons.info_outline_rounded),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationVersion: '^1.0.0',
                        applicationIcon: const CircleAvatar(
                          radius: 35.0,
                          backgroundColor: Colors.transparent,
                          // backgroundImage: AssetImage('assets/icons/icon.png'),
                        ),
                        applicationName: 'E-Voting',
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Sign Out'),
                    subtitle: const Text('Sign out'),
                    leading: leadingIcon(Icons.logout),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Get.find<AuthenticateHandler>().signOutUser();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                               SignIn()),
                              (route) => false);
                    },
                  ),
                  const Spacer(),
                  // const Image(
                  //   // color: Color,
                  //   height: 70.0,
                  //   image: AssetImage('assets/icons/logo.png'),
                  //   filterQuality: FilterQuality.high,
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 25.0, left: 10.0),
                    child: Text(
                      'Developped by Durgesh Ninave',
                      style: TextStyle(color: Colors.grey.shade300, fontSize: 14.0),
                    ),
                  )
                ],
              ),
            ),

    );
  }
}
