import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:online_voting_system/handler/election_handler.dart';
import 'package:online_voting_system/handler/user_handler.dart';
import 'package:online_voting_system/screens/final_result.dart';
import 'package:online_voting_system/bindings/vote_bind.dart';

import '../model/election_model.dart';

class CastVote extends StatefulWidget {
  const CastVote({super.key});

  @override
  State<CastVote> createState() => _CastVoteState();
}

class _CastVoteState extends State<CastVote> {
  // ignore: prefer_typing_uninitialized_variables
  var target;
  @override
  Widget build(BuildContext context) {
    Get.put(ElectionHandler());
    List? option = Get.arguments.options;

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text(
            "CAST YOUR VOTE",
            style: TextStyle(
                fontSize: 25.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.info_rounded),
                // ignore: avoid_print
                onPressed: () => print("Display something")),
          ],
        ),
        // const SliverToBoxAdapter(
        //   child: Padding(
        //     padding: EdgeInsets.only(top: 10.0),
        //     child: Center(
        //       child: Image(
        //         image: AssetImage('assets/icons/logo.png'),
        //         height: 80.0,
        //         width: 300.0,
        //       ),
        //     ),
        //   ),
        // ),
        const SliverToBoxAdapter(
          child: Divider(),
        ),
        SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
                child: Center(
              child: Text(
                Get.arguments.name.toString(),
                style:  TextStyle(
                    fontSize: 30.0,
                    color: Colors.brown.shade800,
                    fontWeight: FontWeight.bold),
              ),
            ))),
        SliverToBoxAdapter(
            child: Center(
          child: Text(
            Get.arguments.desc.toString(),
            style:  TextStyle(
                fontSize: 22.0,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold),
          ),
        )),
        const SliverToBoxAdapter(
          child: SizedBox(height: 40.0),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                      height: 70.0,
                      margin: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          gradient:  LinearGradient(
                            end: Alignment.bottomRight,
                            colors: [Colors.blueGrey.shade700, Colors.deepPurple.shade200],
                          )),
                      child: ListTile(
                        // leading:  CircleAvatar(
                        //     radius: 30.0,
                        //     backgroundColor: Colors.deepPurple.shade50,
                        //     // backgroundImage:
                        //     //     NetworkImage(option![index]["img"])
                        // ),

                        trailing: Text(
                          "${option![index]["count"].toString()} Votes",
                          style:  TextStyle(
                              color: Colors.brown.shade700,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                              option[index]["name"].toString().toUpperCase(),style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w800, fontSize: 18),),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(option[index]["desc"], style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w300, fontSize: 14),),
                        ),
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              title: const ListTile(
                                leading: Icon(
                                  Icons.warning_rounded,
                                  size: 36.0,
                                  color: Colors.amberAccent,
                                ),
                                title: Text("CONFIRM YOUR CHOICE PLEASE"),
                                subtitle: Text(
                                    "after confirm you cann't change your choice."),
                              ),
                              content: Container(
                                height: 200.0,
                                // width: 250.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    gradient:  LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Colors.blueGrey.shade700, Colors.deepPurple.shade200])),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Center(
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.only(
                                      //       top: 10.0,
                                      //     ),
                                      //     child: CircleAvatar(
                                      //         radius: 60.0,
                                      //         backgroundImage: NetworkImage(
                                      //             option![index]["img"])),
                                      //   ),
                                      // ),
                                      const SizedBox(height: 15.0),
                                      Text(option[index]["name"],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        option[index]["desc"],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        "${option[index]["count"].toString()} VOTES COUNT",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:  TextStyle(
                                            color: Colors.brown.shade700,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10.0),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text("No"),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                ElevatedButton.icon(

                                    onPressed: () {
                                      FirebaseFirestore firebaseFirestore =
                                          FirebaseFirestore.instance;
                                      List<ElectionModel> allele =
                                          <ElectionModel>[];
                                      var usersQuerySnap = firebaseFirestore
                                          .collection("users")
                                          .get();
                                      usersQuerySnap.then((usersQuery) {
                                        var allUsers = usersQuery.docs
                                            .map((user) =>
                                                Get.find<UserHandler>()
                                                    .fromDocumentSnapshot(user))
                                            .toList();

                                        for (var user in allUsers) {
                                          firebaseFirestore
                                              .collection("users")
                                              .doc(user.id)
                                              .collection("elections")
                                              .get()
                                              .then((usersEle) {
                                            var userElections = usersEle.docs
                                                .map((ele) =>
                                                    Get.find<ElectionHandler>()
                                                        .fromDocumentSnapshot(
                                                            ele))
                                                .toList();
                                            for (var ele in userElections) {
                                              if (ele.accessId ==
                                                  Get.arguments.accessId) {
                                                setState(() {
                                                  target = ele;
                                                });
                                                firebaseFirestore
                                                    .collection("users")
                                                    .doc(ele.owner)
                                                    .collection("elections")
                                                    .doc(ele.id)
                                                    .update({
                                                  "options":
                                                      FieldValue.arrayRemove([
                                                    {

                                                      "name": ele.options![index]
                                                          ['name'],
                                                      "desc":
                                                          ele.options![index]
                                                              ['desc'],
                                                      "count": ele
                                                          .options![index]['count']
                                                    }
                                                  ])
                                                });
                                                ele.options![index]['count']++;
                                                var updatedOption =
                                                    ele.options![index];

                                                firebaseFirestore
                                                    .collection("users")
                                                    .doc(ele.owner)
                                                    .collection("elections")
                                                    .doc(ele.id)
                                                    .update({
                                                  "options":
                                                      FieldValue.arrayUnion([
                                                    {

                                                      "name":
                                                          updatedOption['name'],
                                                      "desc":
                                                          updatedOption['desc'],
                                                      "count":
                                                          updatedOption['count']
                                                    }
                                                  ])
                                                }).then((value) {
                                                  Get.to(const FinalResult(),
                                                      arguments: target);
                                                });
                                              }
                                            }
                                          });
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.how_to_vote),
                                    label: const Text("Confirm"))
                              ],
                            ),
                            barrierDismissible: false,
                            arguments: Get.arguments,
                          );
                        },
                      )));
            },
            childCount: option?.length,
          ),
        ),
      ],
    ));
  }
}
