import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_voting_system/handler/election_handler.dart';
import 'package:online_voting_system/handler/user_handler.dart';
import 'package:online_voting_system/screens/cast_vote.dart';
import 'package:online_voting_system/screens/final_result.dart';
import 'package:online_voting_system/screens/new_vote.dart';
import 'package:online_voting_system/screens/user_data.dart';
import 'package:online_voting_system/widget/action_data.dart';
import 'package:online_voting_system/widget/design.dart';

import '../model/election_model.dart';
import '../model/user_model.dart';

class EVoting extends StatefulWidget {
  const EVoting({super.key});

  @override
  State<EVoting> createState() => _EVotingState();
}

class _EVotingState extends State<EVoting> {
  final GlobalKey _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      key: _globalKey,
      appBar: AppBar(

        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.brown.shade400, Colors.grey.shade500]),
        )),
        elevation: 0.0,
        title: RichText(
            text: const TextSpan(children: [
          TextSpan(
              text: 'E-Voting',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold))
        ])),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.how_to_vote_rounded),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: IconButton(
                onPressed: () {
                  showAboutDialog(
                      context: context,
                      applicationVersion: '^1.0.0',
                      applicationIcon: const CircleAvatar(
                        radius: 15,
                        // backgroundImage: ,
                      ),
                      applicationName: 'E-voting');
                },
                icon: const Icon(Icons.info_outline_rounded)),
          )
        ],
      ),
      body: const HomeScreen(),
      floatingActionButton: FloatingActionButton(
        heroTag: 1,
        onPressed: () => Get.to(const NewVotes()),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: IconButton(
              icon: const Icon(Icons.how_to_vote_rounded),
              // ignore: avoid_print
              onPressed: () => print('How to vote')),
        ),
      ),
      drawer: const CustomerDesign(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "ENTER A VOTE CODE",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 60.0,
                      margin: const EdgeInsets.only(top: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Form(
                        key: GlobalKey<FormState>(),
                        child: TextFormField(
                          controller: textEditingController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            fontSize: 24.0,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white60,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28.0)),
                            hintText: "Enter the Election Code",
                            hintStyle: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w500),
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                            ),
                          ),
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0, left: 5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.redAccent, Colors.blueGrey])),
                    child: FloatingActionButton.extended(
                      heroTag: 2,
                        // height: 40.0,
                        onPressed: () async {
                          FirebaseFirestore firestore =
                              FirebaseFirestore.instance;
                          List<UserModel> allUsers = <UserModel>[];
                          List<ElectionModel> allElections = <ElectionModel>[];
                          var usersQuerySnap =
                              firestore.collection("users").get();
                          usersQuerySnap.then((usersQuery) {
                            var allUsers = usersQuery.docs
                                .map((user) => Get.find<UserHandler>()
                                    .fromDocumentSnapshot(user))
                                .toList();

                            for (var user in allUsers) {
                              // ignore: avoid_print
                              print(user.email);
                              firestore
                                  .collection("users")
                                  .doc(user.id)
                                  .collection("elections")
                                  .get()
                                  .then((userElectionsSnap) {
                                var userElections = userElectionsSnap.docs
                                    .map((election) =>
                                        Get.find<ElectionHandler>()
                                            .fromDocumentSnapshot(election))
                                    .toList();
                                for (var element in userElections) {
                                  allElections.add(element);
                                }
                                for (int i = 0; i < allElections.length; i++) {
                                  var election = allElections[i];
                                  if (election.accessId ==
                                      textEditingController.text) {
                                    // ignore: avoid_print
                                    print(
                                        "Election found ${election.accessId}");
                                    Get.to(CastVote(), arguments: election);
                                  }
                                }
                                // textEditingController.clear();
                              });
                            }
                            //print("All elections $allElections");
                          });
                        },
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.white54,
                        ),
                        label: const Text(
                          "Validate",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        )),
                  )
                ],
              ),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        Get.to(const NewVotes());
                      },
                      child: const ActionData(
                          img: Icons.how_to_vote_rounded,
                          action: "Create New Election",
                          desc: "Create New Vote")),
                  const ActionData(
                      img: Icons.poll_rounded,
                      action: "Poll",
                      desc: "Create New Poll")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        Get.to(UserData());
                      },
                      child: const ActionData(
                          img: Icons.ballot_rounded,
                          action: "My election",
                          desc: "create a new vote")),
                  const ActionData(
                      img: Icons.description_rounded,
                      action: "FAQs",
                      desc: "create new poll")
                ],
              ),
            ],
          )),
    );
  }
}
