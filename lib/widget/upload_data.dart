// ignore: avoid_web_libraries_in_flutter
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImage extends StatefulWidget {
  final File file;
  final String store;
  const UploadImage({required this.file, required this.store, super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final FirebaseStorage _firestorage = FirebaseStorage.instance;
  late UploadTask uploadTask;
  double progress = 0.0;
  // ignore: prefer_typing_uninitialized_variables
  var imgURL;

  void UploadStarting() async {
    String path = "${DateTime.now()}.png";
    var reference = _firestorage.ref().child(path);

    setState(() {
      uploadTask = reference.putFile(widget.file);
    });

    await uploadTask.then((p0) {
      setState(() {
        imgURL = p0.ref.getDownloadURL();
      });
      // ignore: avoid_print
      print("Image URL is $imgURL");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Center(
                    // child: Image(image: ,
                    // height: 90.0,
                    // width: 150.0,
                    // ),
                    ),
              ),
              const Text(
                "Upload Image",
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18.0),
              const Divider(),
              Image.file(
                widget.file,
                filterQuality: FilterQuality.high,
                cacheHeight: 250,
                cacheWidth: 250,
              ),
              // ignore: unnecessary_null_comparison
              uploadTask != null
                  ? StreamBuilder(
                      stream: uploadTask.snapshotEvents,
                      builder: (context, snapshot) {
                        uploadTask.snapshotEvents.listen((event) {
                          setState(() {
                            progress = event.bytesTransferred.toDouble() /
                                event.totalBytes.toDouble();
                          });
                        });
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 40, right: 40),
                              child: LinearProgressIndicator(
                                semanticsLabel:
                                    "${(progress * 100).toString()} % uploaded...",
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              "${(progress * 100).toString()} % uploaded...",
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        );
                      })
                  : ElevatedButton.icon(
                      onPressed: () {
                        UploadStarting();
                      },
                      icon: const Icon(
                        Icons.upload_file_rounded,
                        color: Colors.blueGrey,
                      ),
                      label: const Text("Image Uploading")),
            ],
          ),
        ),
      ),
    );
  }
}
