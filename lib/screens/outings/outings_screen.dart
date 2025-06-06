import 'package:flutter/material.dart';
import 'package:dress_app/screens/outings/past_outings_screen.dart';
import 'package:dress_app/screens/outings/future_outings_screen.dart';
import 'package:dress_app/screens/outings/add_outing_screen.dart';

class OutingsScreen extends StatelessWidget {
  const OutingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Outings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Past Outings'),
              Tab(text: 'Future Outings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PastOutingsScreen(),
            FutureOutingsScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddOutingScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
