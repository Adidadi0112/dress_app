import 'package:flutter/material.dart';
import 'package:dress_app/screens/meetings/past_meetings_screen.dart';
import 'package:dress_app/screens/meetings/future_meetings_screen.dart';
import 'package:dress_app/screens/meetings/add_meeting_screen.dart';
import 'package:dress_app/theme/responsive.dart';
import 'package:dress_app/theme/tokens.dart';

class MeetingsScreen extends StatelessWidget {
  const MeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Meetings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          bottom: TabBar(
            labelStyle: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 14.0,
                tablet: 16.0,
                desktop: 18.0,
              ),
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: 'Past Meetings'),
              Tab(text: 'Future Meetings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PastMeetingsScreen(),
            FutureMeetingsScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddMeetingScreen(),
              ),
            );
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
