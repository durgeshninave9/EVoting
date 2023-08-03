import 'package:flutter/material.dart';

class ActionData extends StatelessWidget {
  final IconData img;
  final String action;
  final String desc;
  const ActionData(
      {required this.img, required this.action, required this.desc, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 160,
      height: 160,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient:  LinearGradient(
              colors: [Colors.blueGrey.shade400, Colors.brown.shade500],
              end: Alignment.bottomRight,
              tileMode: TileMode.clamp)),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Icon(
          img,
          size: 50.0,
          color: Colors.white60,
        ),
        const SizedBox(height: 5,),
        Text(
          action,
          style: const TextStyle(
              fontSize: 24.0, color: Colors.white60, fontWeight: FontWeight.bold,),
        ),
        const Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
              onPressed: null,
              icon: Icon(
                Icons.arrow_right_alt_rounded,
                color: Colors.white70,
              )),
        )
      ]),
    );
  }
}
