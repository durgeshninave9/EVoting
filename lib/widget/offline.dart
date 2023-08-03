import 'package:flutter/material.dart';

class Offline extends StatelessWidget {
  const Offline({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: const [
            Icon(
              Icons.wifi_2_bar_rounded,
              color: Colors.black54,
              size: 110,
            ),
            Text(
              "NOT INTERNET CONNECTION",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "PLEASE CHECK YOUR INTERNET CONNECTION.",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.redAccent),
            )
          ],
        ),
      ),
    );
  }
}
