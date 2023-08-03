import 'package:flutter/material.dart';

class FloatingButton extends StatefulWidget {
  const FloatingButton({super.key});

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 5,
      // ignore: avoid_print
      onPressed: () => print("floating button pressed."),
      child: Container(
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.indigo, Colors.blue])),
        child: IconButton(
            // ignore: avoid_print
            onPressed: () => print("How to Vote"),
            icon: const Icon(Icons.how_to_vote_rounded)),
      ),
    );
  }
}
