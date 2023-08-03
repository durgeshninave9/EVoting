import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_voting_system/database.dart';
import 'package:online_voting_system/handler/election_handler.dart';

import '../widget/input_data.dart';

class AddVotes extends StatefulWidget {
  const AddVotes({super.key});

  @override
  State<AddVotes> createState() => _AddVotesState();
}

class _AddVotesState extends State<AddVotes> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  var arguments = Get.arguments;
  late File img;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  late UploadTask uploadTask;
  double progress = 0.0;
  // ignore: prefer_typing_uninitialized_variables
  var imgURL, futimgURL;

  @override
  void initState() {
    super.initState();
    arguments = arguments ?? Get.arguments;
  }

  void startUpload() async {
    String filePath = "election_pics/${DateTime.now()}.png";
    var reference = firebaseStorage.ref().child(filePath);

    setState(() {
      uploadTask = reference.putFile(img);
      uploadTask.then((snapshot) {
        setState(() {
          snapshot.ref.getDownloadURL().then((imgURL) => imgURL = imgURL);
          futimgURL = Future.value(snapshot.ref.getDownloadURL());
          Get.back(canPop: false);
        });
      });
    });
  }

  Future<void> pickImage(ImageSource source) async {
    PickedFile selectedImage = (await ImagePicker().pickImage(
        source: source,
        maxHeight: 300.0,
        maxWidth: 300.0,
        imageQuality: 100)) as PickedFile;
    setState(() {
      // ignore: unnecessary_null_comparison
      if (selectedImage != null) {
        img = File(selectedImage.path);
        Get.dialog(
            AlertDialog(
              title: const Text("Candidate Image Upload"),
              content: SizedBox(
                height: 320.0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.file(
                      //   img,
                      //   filterQuality: FilterQuality.high,
                      //   height: 250,
                      //   width: 250,
                      // ),
                      const SizedBox(height: 20.0),
                      // ignore: unnecessary_null_comparison
                      uploadTask != null
                          ? StreamBuilder(
                              stream: uploadTask.snapshotEvents,
                              builder: (context, snapshot) {
                                uploadTask.snapshotEvents
                                    .listen((TaskSnapshot snapshot) {
                                  setState(() {
                                    progress =
                                        snapshot.bytesTransferred.toDouble() /
                                            snapshot.totalBytes.toDouble();
                                  });
                                });

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, left: 45.0, right: 45.0),
                                      child: LinearProgressIndicator(
                                          semanticsLabel:
                                              "${(progress * 100).toString()} % uploaded...",
                                          minHeight: 10.0,
                                          value: progress * 100),
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Text(
                                      "${(progress * 100).toString()} % uploaded...",
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                );
                              })
                          : ElevatedButton.icon(
                              onPressed: () {
                                startUpload();
                              },
                              icon: const Icon(Icons.upload_file),
                              label: const Text("Upload Image")),
                    ],
                  ),
                ),
              ),
            ),
            arguments: Get.arguments);
      } else {
        Get.snackbar("ERROR", "No Image selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ElectionHandler());

    return Scaffold(
      backgroundColor: Colors.indigo[100],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Center(
                  // child: Image(
                  //   image: AssetImage('assets/icons/logo.png'),
                  //   height: 80.0,
                  //   width: 300.0,
                  // ),
                  ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "ADD CANDIDATE",
              style: TextStyle(
                  fontSize: 28.0,
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold),
            ),
            const Divider(),
            // InkWell(
            //   onTap: () {
            //     Get.bottomSheet(
            //         Container(
            //           color: Colors.white,
            //           height: 70.0,
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceAround,
            //             children: [
            //               ElevatedButton.icon(
            //                   onPressed: () {
            //                     ImageSource src = ImageSource.gallery;
            //                     pickImage(src);
            //                   },
            //                   icon: const Icon(
            //                     Icons.image_outlined,
            //                     color: Colors.red,
            //                   ),
            //                   label: const Text("Pick from Gallery")),
            //               ElevatedButton.icon(
            //                   onPressed: () {
            //                     ImageSource src = ImageSource.camera;
            //                     pickImage(src);
            //                   },
            //                   icon: const Icon(
            //                     Icons.camera_enhance,
            //                     color: Colors.green,
            //                   ),
            //                   label: Text("Take picture with Camera")),
            //             ],
            //           ),
            //         ),
            //         settings: RouteSettings(arguments: Get.arguments));
            //     // setState(() {
            //     //   img = null;
            //     // });
            //   },
            //   child: FutureBuilder(
            //       future: Future.value(futimgURL),
            //       builder: (context, state) {
            //         if (state.hasData) {
            //           // backgroundImage: NetworkImage(state.data),
            //           return const CircleAvatar(
            //             radius: 80.0,
            //           );
            //           // radius: 80.0,
            //         }
            //         return CircleAvatar(
            //           radius: 80.0,
            //           child: Center(
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: const [
            //                 Center(
            //                   child: Icon(
            //                     Icons.account_circle,
            //                     size: 84.0,
            //                   ),
            //                 ),
            //                 Center(
            //                   child: Text("Add Image"),
            //                 )
            //               ],
            //             ),
            //           ),
            //         );
            //       }),
            // ),
            const SizedBox(
              height: 40.0,
            ),
            InputData(
              icon: Icons.person,
              hint: 'Candidate\'s names',
              controller: nameController,
              obscure: false,
              label: '',
              type: TextInputType.name,
                valid: (value){
                  if(value.isEmpty){
                    return "Name is required";
                  }
                  else {
                    return null;
                  }
                }
            ),
            InputData(
              icon: Icons.edit,
              hint: 'Candidates\'s description',
              controller: descController,
              obscure: false,
              label: '',
              type: TextInputType.text,
                valid: (value){
                  if(value.isEmpty){
                    return "Description is required";
                  }
                  else {
                    return null;
                  }
                }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 4,
        backgroundColor: Colors.indigo,
        onPressed: () async {
          var result;

          if(nameController.text.isNotEmpty && descController.text.isNotEmpty) {
            result = await Database().addnewCandidate(
              arguments[0].id.toString(),
              imgURL,
              nameController.text,
              descController.text);
          }
          else{
            Get.snackbar("", "Field must be not Empty");
          }
          if (result) {
            Get.back();
          }
        },
        child: const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
      ),
    );
  }
}
