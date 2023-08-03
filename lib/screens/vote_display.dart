import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:online_voting_system/handler/election_handler.dart';
import 'package:online_voting_system/handler/user_handler.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:online_voting_system/screens/home_screen.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

// ignore: non_constant_identifier_names
Widget _StatsBox(IconData icon, String title, String count) {
  return Container(
    padding: const EdgeInsets.all(2.0),
    height: 100.0,
    width: 100.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient:  LinearGradient(colors: [Colors.blue.shade300, Colors.indigo.shade500])),
    child: Column(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.w700),
        ),
        Icon(
          icon,
          size: 40.0,
          color: Colors.white60,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            count,
            style: const TextStyle(
                fontSize: 22.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    ),
  );
}

class Vote {
  final String user;
  final int cnt;
  final Color color;

  Vote(this.user, this.cnt, this.color);
}

class VoteDisplay extends StatefulWidget {
  const VoteDisplay({super.key});

  @override
  State<VoteDisplay> createState() => _VoteDisplayState();
}

class _VoteDisplayState extends State<VoteDisplay> {
  @override
  Widget build(BuildContext context) {
    Color canColor() {
      Random random = Random();
      List<Color> colors = [
        Colors.black,
        Colors.amberAccent,
        Colors.indigo,
        Colors.deepOrangeAccent,
        Colors.lightGreenAccent,
        Colors.brown,
        Colors.tealAccent,
        Colors.pinkAccent,
        Colors.yellowAccent,
        Colors.red,
        Colors.purple,
        Colors.lightBlue,
      ];
      int idx = random.nextInt(11);
      return colors[idx];
    }

    return Scaffold(
      body: StreamBuilder(
          stream: firestore
              .collection("users")
              .doc(Get.find<UserHandler>().user.id)
              .collection("elections")
              .doc(Get.arguments[0].id.toString())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var election = snapshot.data!.data();
              var candidates = election!['options'];

              //Functions that will be in charge to generate charts data
              List<charts.Series<Vote, String>> VoteData() {
                List<Vote> voteData = <Vote>[];
                if (candidates != null) {
                  for (var candidate in candidates) {
                    if (candidate != null &&
                        candidate['name'] != null &&
                        candidate['count'] != null) {
                      Vote vote =
                          Vote(candidate['name'], candidate['count'], canColor());
                      voteData.add(vote);
                    }
                  }
                }
                return [
                  charts.Series<Vote, String>(
                      id: 'Best Framework',
                      labelAccessorFn: (Vote votes, _) => votes.user,
                      colorFn: (Vote votes, _) =>
                          charts.ColorUtil.fromDartColor(votes.color),
                      domainFn: (Vote votes, _) => votes.user,
                      measureFn: (Vote votes, _) => votes.cnt,
                      data: voteData)
                ];
              }

              //End of chart data functions

              //Clling the function to initiate data
              List<charts.Series> seriesList = VoteData();

              //function to get the total votes count
              num totalVoteCount() {
                num totalcount = 0;
                for (var candidate in candidates) {
                  totalcount += candidate['count'];
                }
                return totalcount;
              }

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: IconButton(
                        icon: const Icon(Icons.dashboard),
                        onPressed: () => Get.to(const EVoting())),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        children: [
                          Text(
                            election['name'] != null
                                ? election['name'].toUpperCase()
                                : "Election Name...",
                          ),
                          Text(
                            election["desc"],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      IconButton(
                          tooltip: 'Copy election access code',
                          icon: const Icon(
                            Icons.content_copy,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Get.find<ElectionHandler>()
                                .saveAccessData(election["accessId"]);
                          })
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Colors.white,
                                  ),
                                  label: const Text('Copy Access Code')),
                              ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: Colors.green,
                                  ),
                                  label: const Text('Regenerate the Code')),
                            ],
                          ),
                          _StatsBox(Icons.people_alt, 'CANDIDATES',
                              election["options"].length.toString()),
                          _StatsBox(Icons.how_to_vote, 'TOTAL VOTES',
                              totalVoteCount().toString())
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.40,
                          width: MediaQuery.of(context).size.width,
                          //color: Colors.black12,
                          child: charts.BarChart(
                            VoteData(),
                            animate: true,
                            behaviors: [
                              charts.DatumLegend(
                                outsideJustification:
                                    charts.OutsideJustification.middleDrawArea,
                                horizontalFirst: false,
                                desiredMaxRows: 2,
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.30,
                              width: MediaQuery.of(context).size.width * 0.60,
                              // color: Colors.pinkAccent.withOpacity(.5),
                              // child: Expanded(
                              //   child: charts.PieChart(
                              //     seriesList,
                              //     animate: true,
                              //     defaultRenderer: charts.ArcRendererConfig(arcwid),
                              //   ),
                              // ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.30,
                                width: MediaQuery.of(context).size.width * 0.40,
                                //color: Colors.teal.shade200,
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: ListView(
                                      children: [
                                         Center(
                                          child: Text(
                                            'OWNER ACTIONS',
                                            style: TextStyle(
                                                color: Colors.brown.shade900,
                                                fontSize: 18.0,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.stop_rounded,
                                              color: Colors.red,
                                            ),
                                            label: const Text('Stop Election')),

                                        ElevatedButton.icon(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.bar_chart,
                                              semanticLabel: 'Chart',
                                            ),
                                            label: const Text(
                                                'Get Election\'s stats'))
                                      ],
                                    )))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
