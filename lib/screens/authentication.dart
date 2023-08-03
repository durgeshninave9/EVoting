import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_voting_system/handler/auth_handler.dart';
import 'package:online_voting_system/screens/login.dart';
import 'package:online_voting_system/widget/input_data.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pnController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pswdController = TextEditingController();
  final TextEditingController repswdController = TextEditingController();

  var arguments = Get.arguments;
  late File img;
  // File avatar = File("assets/icons/avatar.png");
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  late UploadTask uploadTask;
  double progress = 0.0;
  // ignore: prefer_typing_uninitialized_variables
  var imgURL, futImgURL;

  @override
  void initState() {
    super.initState();
    arguments = arguments ?? Get.arguments;
  }

  void startUpload() async {
    String filePath = "users_pics/${DateTime.now()}";
    var reference = firebaseStorage.ref().child(filePath);

    setState(() {
      uploadTask = reference.putFile(img);
      uploadTask.then((snapshot) {
        setState(() {
          snapshot.ref.getDownloadURL().then((imgURL) => imgURL = imgURL);
          futImgURL = Future.value(snapshot.ref.getDownloadURL());
          Get.back(canPop: true);
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
        Navigator.pop(context);
        Get.dialog(
            AlertDialog(
              // contentPadding: const EdgeInsets.only(top: 200.0, bottom: 200.0),
              title: const Text("Candidate Image Upload"),
              content: SizedBox(
                height: 320.0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.file(
                        img,
                        filterQuality: FilterQuality.high,
                        height: 250,
                        width: 250,
                      ),
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
        Get.snackbar("505", "No Image selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AuthenticateHandler());
    return Scaffold(
        // backgroundColor: Colors.grey,
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Center(
                // child: Image(
                //   height: 80.0,
                //   image: AssetImage('assets/icons/logo.png'),
                // ),
                ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 70.0),
            child: Text('SIGN UP',
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            height: 10.0,
          ),
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
          //                   label: const Text("Take picture with Camera"))
          //             ],
          //           ),
          //         ),
          //         settings: RouteSettings(arguments: Get.arguments));
          //     setState(() {
          //       // ignore: cast_from_null_always_fails
          //       img = File as File;
          //     });
          //   },
          //   child: FutureBuilder(
          //       future: Future.value(futImgURL),
          //       builder: (context, state) {
          //         if (state.hasData) {
          //           return const CircleAvatar(
          //             // backgroundImage: NetworkImage(state!.data!),
          //             radius: 80.0,
          //           );
          //         }
          //
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
            height: 15.0,
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                InputData(
                    controller: nameController,
                    hint: 'Enter your name',
                    icon: Icons.account_circle,
                    type: TextInputType.name,
                    obscure: false,
                    label: '',
                    valid: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      } else {
                        return null;
                      }
                    }),
                InputData(
                    controller: pnController,
                    hint: 'Enter your phone number',
                    icon: Icons.phone,
                    type: TextInputType.phone,
                    obscure: false,
                    label: '',
                    valid: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone no is required";
                      } else if (value.length != 10) {
                        return "Phone no must be of 10 digit";
                      } else {
                        return null;
                      }
                    }),
                InputData(
                    controller: emailController,
                    hint: 'Enter your email',
                    icon: Icons.email,
                    type: TextInputType.emailAddress,
                    obscure: false,
                    label: '',
                    valid: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      } else if (!value.contains('@')) {
                        return "Enter Valid Email ID";
                      } else {
                        return null;
                      }
                    }),
                InputData(
                  controller: pswdController,
                  hint: 'Enter your password',
                  icon: Icons.lock,
                  type: TextInputType.visiblePassword,
                  obscure: true,
                  label: '',
                  valid: (value) {
                    RegExp regex = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#_\$&*~]).{8,}$');
                    var nvalue = value ?? "";
                    if (nvalue.isEmpty) {
                      return ("Password is required");
                    } else if (nvalue.length <= 6) {
                      return ("Password Must be more than 6 characters");
                    } else if (!regex.hasMatch(nvalue)) {
                      return ("Password should contain upper,lower,digit and Special character ");
                    }
                    return null;
                  },
                ),
                InputData(
                    controller: repswdController,
                    hint: 'Confirm password',
                    icon: Icons.lock,
                    type: TextInputType.visiblePassword,
                    obscure: true,
                    label: '',
                    valid: (value) {
                      if (value.isEmpty) {
                        return "Confirm password is required";
                      } else if (pswdController.text.toString() !=
                          repswdController.text.toString()) {
                        return "Password does not match";
                      } else {
                        return null;
                      }
                    }),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (pswdController.text.toString() !=
                            repswdController.text.toString()) {
                          Get.snackbar(
                              "password : ", "password does not match");
                        } else {
                          Get.find<AuthenticateHandler>().addUser(
                              imgURL,
                              nameController.text.toString(),
                              pnController.text.toString(),
                              emailController.text.toString().trim(),
                              pswdController.text.toString().trim(),
                              "1");
                        }
                      },
                      label: const Text('SIGN UP'),
                      icon: const Icon(Icons.verified_user),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have account ?",
                      style: TextStyle(fontSize: 16),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                        child: const Text(
                          " Sign In",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
