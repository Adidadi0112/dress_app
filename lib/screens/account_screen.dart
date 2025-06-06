import 'package:dress_app/screens/wardrobe_screen.dart';
import 'package:dress_app/screens/outings/outings_screen.dart';
import 'package:dress_app/widgets/bottom_navigator.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Account'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const WardrobeScreen()),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(25),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(child: Icon(Icons.star)),
                  const SizedBox(width: 40),
                  Text("My Wardrobe"),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const OutingsScreen()),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(25),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(child: Icon(Icons.event)),
                  const SizedBox(width: 40),
                  Text("My Outings"),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBarMobileWidget(),
    );
  }
}
