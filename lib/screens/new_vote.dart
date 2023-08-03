// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:online_voting_system/handler/election_handler.dart';
import 'package:online_voting_system/handler/user_handler.dart';
import 'package:online_voting_system/widget/date_picker.dart';
import 'package:online_voting_system/widget/input_data.dart';

late ElectionHandler electionHandler;
TextEditingController namecontroller = TextEditingController();
TextEditingController desccontroller = TextEditingController();
TextEditingController startcontroller = TextEditingController();
TextEditingController endcontroller = TextEditingController();
final author = Get.find<UserHandler>().user;

void clear() {
  namecontroller.clear();
  desccontroller.clear();
  startcontroller.clear();
  endcontroller.clear();
}

class NewVotes extends StatefulWidget {
  const NewVotes({super.key});

  @override
  State<NewVotes> createState() => _NewVotesState();
}

class _NewVotesState extends State<NewVotes> {
  // late DateTime startTime, endTime;
  Future<DateTime?> pickDate() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2999),
    );
  }

  @override
  Widget build(BuildContext context) {
    electionHandler = Get.put(ElectionHandler());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero(tag: '1', child: Center())
          const SliverPadding(
            padding: EdgeInsets.only(top: 100.0, bottom: 0.0),
            sliver: SliverToBoxAdapter(
                // child: Image(
                //   image: AssetImage('assets/icons/logo.png'),
                // ),
                ),
          ),
          const SliverToBoxAdapter(
            child: Center(
              child: Text(
                'ADD ELECTION',
                style: TextStyle(
                    fontSize: 38.0,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15),
              child: Center(
                child: Column(
                  children: [
                    InputData(
                        controller: namecontroller,
                        hint: 'Enter the election\'s name',
                        icon: Icons.person,
                        obscure: false,
                        label: '',
                        type: TextInputType.name,
                        valid: (value) {
                          if (value.isEmpty) {
                            return "Name is required";
                          } else {
                            return null;
                          }
                        }),
                    InputData(
                        controller: desccontroller,
                        hint: 'Enter the election\'s description',
                        icon: Icons.edit,
                        obscure: false,
                        label: '',
                        type: TextInputType.text,
                        valid: (value) {
                          if (value.isEmpty) {
                            return "Description is required";
                          } else {
                            return null;
                          }
                        }),
                    DatePicker(
                      controller: startcontroller,
                      title: 'START DATE',
                      hint: 'Start date of the election',
                      icon: Icons.date_range_rounded,
                    ),
                    DatePicker(
                      controller: endcontroller,
                      title: 'END DATE',
                      hint: 'End date of the election',
                      icon: Icons.date_range_rounded,
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin:
                  const EdgeInsets.only(left: 55.0, bottom: 20.0, right: 55.0),
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(18.0)),
              child: ElevatedButton(
                onPressed: () async {
                  if (namecontroller.text.isNotEmpty &&
                      desccontroller.text.isNotEmpty &&
                      startcontroller.text.isNotEmpty &&
                      endcontroller.text.isNotEmpty) {
                    await electionHandler.newElection(
                      namecontroller.text,
                      desccontroller.text,
                      startcontroller.text,
                      endcontroller.text,
                    );
                    Navigator.of(context).pop();
                    clear();
                  } else {
                    Get.snackbar("Field Empty", "Field must be not empty");
                  }
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
