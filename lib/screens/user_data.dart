import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:online_voting_system/handler/election_handler.dart';
import 'package:online_voting_system/handler/user_handler.dart';
import 'package:online_voting_system/screens/vote_display.dart';

final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class UserData extends StatelessWidget {
  const UserData({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserHandler());
    return Scaffold(
      body: StreamBuilder(
          stream: firebaseFirestore
              .collection('users')
              .doc(Get.find<UserHandler>().user.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var ele = snapshot.data!.data()!['ownedElect'];
              if (ele.length < 1) {
                return const Center(
                  child: ListTile(
                      leading: Icon(
                      Icons.warning_rounded,
                      color: Colors.blueGrey,
                    ),
                    title: Text("you haven't any elections"),
                    subtitle: Text("your elections is this."),
                  ),
                );
              }
              return CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    title: Text(
                      "OWNED ELECTIONS",
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Center(
                        // child: Image(
                        //   image: AssetImage('assets/icons/logo.png'),
                        //   height: 80.0,
                        //   width: 300.0,
                        // ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 30.0,
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return StreamBuilder(
                      stream: firebaseFirestore
                          .collection("users")
                          .doc(Get.find<UserHandler>().user.id)
                          .collection("elections")
                          .doc(ele[index])
                          .snapshots(),
                      // ignore: missing_return
                      builder: (context, snap) {
                        if (snap.hasData) {
                          return GestureDetector(
                            onTap: () {
                              // ignore: avoid_print
                              print("working.......");
                              Get.to(const VoteDisplay(),
                                  arguments: [snap.data!.data()]);
                            },
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Container(
                                    height: 70.0,
                                    margin: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        gradient:  LinearGradient(
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.blueGrey.shade600, Colors.deepPurple.shade200
                                          ],
                                        )),
                                    child: ListTile(
                                      trailing:  Icon(Icons.chevron_right, color: Colors.brown.shade700,),
                                      title: Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Text(
                                            snap.data!.data()!['name'] ?? "Name", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Text(
                                            snap.data!.data()!['description']??"Description", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                                      ),
                                      onTap: () {
                                        // ignore: avoid_print
                                        print("working.......");
                                        Get.to(const VoteDisplay(), arguments: [
                                          Get.find<ElectionHandler>()
                                              .fromDocumentSnapshot(snap.data
                                                  as DocumentSnapshot<Object?>)
                                        ]);
                                      },
                                    ))),
                          );
                        } else {
                          return const Center(child: Text("Loading..."));
                        }
                      },
                    );
                  }, childCount: ele.length))
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("LLooaaddiinng...."));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
