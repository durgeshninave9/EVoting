import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CandidateData extends StatefulWidget {
  // final String canImgurl;
  final String canName;
  final String candDesc;
  final Function onTap;
  final double height;
  const CandidateData(
      {required this.canName,
      // required this.canImgurl,
      required this.candDesc,
      required this.onTap,
      required this.height,
      super.key});

  @override
  State<CandidateData> createState() => _CandidateDateStata();
}

class _CandidateDateStata extends State<CandidateData> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onTap,
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.only(top: 5, bottom: 7, left: 7, right: 7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),

            gradient:  LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.brown.shade400, Colors.blueGrey.shade400])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Center(
              //   child: CircleAvatar(
              //     radius: 45.0,
              //     backgroundImage: NetworkImage(widget.canImgurl),
              //   ),
              // ),
              Center(
                child: Text(
                  widget.canName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.candDesc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
