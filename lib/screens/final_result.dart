// ignore_for_file: unnecessary_null_comparison

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';
import 'package:online_voting_system/screens/home_screen.dart';

import '../model/election_model.dart';

class Vote {
  final String user;
  final int cnt;
  final Color color;

  Vote(this.user, this.cnt, this.color);
}

class FinalResult extends StatefulWidget {
  const FinalResult({super.key});

  @override
  State<FinalResult> createState() => _FinalResultState();
}

class _FinalResultState extends State<FinalResult> {
  ElectionModel election = Get.arguments;

  num totalVoteCount() {
    num totalcount = 0;
    if (election.options != null) {
      totalcount += election.options!.length;
    }
    return totalcount;
  }

  double candidatePercentage(int ttlcnt, int usercnt) {
    return (usercnt / ttlcnt) * 100;
  }

  Color _candidateColor() {
    Random random = Random();
    List<Color> colors = [
      Colors.black,
      Colors.amberAccent,
      Colors.indigo,
      Colors.brown,
      Colors.deepOrangeAccent,
      Colors.lightGreenAccent,
      Colors.tealAccent,
      Colors.pinkAccent,
      Colors.yellowAccent,
      Colors.red,
      Colors.purple,
      Colors.lightBlue,
    ];
    int index = random.nextInt(11);
    return colors[index];
  }

  //Functions that will be in charge to generate charts data
  List<charts.Series<Vote, String>> VoteData() {
    List<Vote> voteData = <Vote>[];
    voteData = election.options!.map((option) {
      return Vote(option['name'], option['count'], _candidateColor());
    }).toList();

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

  @override
  Widget build(BuildContext context) {
    Get.put(ElectionModel());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                icon: const Icon(Icons.dashboard),
                onPressed: () => Get.to(const EVoting())),
            title: const Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                "REAL TIME RESULT",
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SliverToBoxAdapter(
              child: SizedBox(
            height: 20.0,
          )),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 140,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: election.options!.map((options) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: createCandidateResult(
                          // option['avatar'],
                          options['name'],
                          candidatePercentage(
                              totalVoteCount() as int, options['count'])),
                    );
                  }).toList()),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20.0,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
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
          )
        ],
      ),
    );
  }
}

createCandidateResult(String header, double cnt) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    height: 105.0,
    width: 110.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: LinearGradient(
            colors: [Colors.brown.shade400, Colors.grey.shade500])),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            header,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 22.0,
                color: Colors.blueGrey.shade900,
                fontWeight: FontWeight.bold),
          ),
        ),
        // CircleAvatar(
        //   radius: 35.0,
        //   backgroundImage: NetworkImage(img),
        // ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "${cnt.toStringAsFixed(2)} %",
              style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  // )
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}
