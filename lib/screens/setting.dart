import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text(
              "SETTINGS",
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 25.0,
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 25.0,
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return ListTile(
              title: const Text("Light Mode"),
              subtitle: const Text("Dark Mode"),
              leading: const Icon(Icons.lightbulb_outline_rounded),
              trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    value == true
                        ? Get.changeTheme(ThemeData.dark())
                        : Get.changeTheme(ThemeData.light());
                  }),
            );
          }, childCount: 1))
        ],
      ),
    );
  }
}
