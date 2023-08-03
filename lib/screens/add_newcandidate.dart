import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_voting_system/bindings/vote_bind.dart';
import 'package:online_voting_system/handler/election_handler.dart';
import 'package:online_voting_system/handler/user_handler.dart';
import 'package:online_voting_system/screens/add_votes.dart';
import 'package:online_voting_system/screens/home_screen.dart';
import 'package:online_voting_system/screens/vote_display.dart';
import 'package:online_voting_system/widget/candidate_data.dart';
// import '';

// ignore: unused_element
final FirebaseFirestore fireStore = FirebaseFirestore.instance;

class AddNewCandidate extends StatefulWidget {
  const AddNewCandidate({super.key});

  @override
  State<AddNewCandidate> createState() => _AddNewCandidateState();
}

class _AddNewCandidateState extends State<AddNewCandidate> {
  @override
  Widget build(BuildContext context) {
    Get.put(UserHandler());
    Get.put(ElectionHandler());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
           SliverAppBar(
            automaticallyImplyLeading: false,
            title: const Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Text('ADD VOTE', style: TextStyle(fontSize: 25),),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: InkWell(
                    child: const Icon(
                  Icons.exit_to_app_sharp,
                  color: Colors.white70,
                ),
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const EVoting()));
                  },
                ),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children:  [
                const Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Center(),
                ),
                 Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 10),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                      "VOTE",
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.blueGrey.shade700,

                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                  child: Divider(),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: StreamBuilder(
              key: GlobalKey(debugLabel: "StreamKey"),
              stream: fireStore
                  .collection("users")
                  .doc(Get.find<UserHandler>().user.id)
                  .collection("elections")
                  .doc(Get.arguments[0].id.toString())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.data()!['options'];
                  return data.length == 0
                      ? SliverToBoxAdapter(
                          child: Column(children: const [
                            Icon(
                              Icons.wifi_off,
                              size: 100.0,
                            ),
                            Text('NO CANDIDATE ADDED YET',
                                style: TextStyle(
                                  fontSize: 20.0,
                                )),
                            Text(
                              'Add candidates or options to your vote to finalise the process',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ]),
                        )
                      : SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent:
                                MediaQuery.of(context).size.width * 0.50,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 1.0,
                          ),
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            return CandidateData(
                              // canImgurl: data[index]['img'],
                              canName: data[index]['name'],
                              candDesc: data[index]['desc'],
                              onTap: () {},
                              height: 5,
                            );
                          }, childCount: data.length));
                } else {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 45.0, right: 75.0, top: 40.0, bottom: 20.0),
                child: Container(
                  height: 50.0,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade500,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: FloatingActionButton.large(onPressed: () {
                    Get.to(const VoteDisplay(),
                        arguments: Get.arguments, binding: VoteBinding());
                  }),
                )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 3,
        tooltip: 'Add Candidates',
        backgroundColor: Colors.green,
        onPressed: () {
          Get.to(() => AddVotes(), arguments: Get.arguments);
        },
        child: const Icon(
          Icons.group_add_rounded,
        ),
      ),
    );
  }
}
