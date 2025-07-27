import 'package:dress_app/models/friend.dart';
import 'package:dress_app/screens/friends/invite_to_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/meetings/meetings_bloc.dart';
import '../../blocs/meetings/meetings_state.dart';
import '../../blocs/meetings/meetings_event.dart';
import '../../blocs/friends/friends_bloc.dart';
import '../../blocs/friends/friends_event.dart';
import '../../models/meeting.dart';
import '../../widgets/enhanced_card.dart';
import '../../theme/responsive.dart';

class FutureMeetingsScreen extends StatelessWidget {
  const FutureMeetingsScreen({super.key});

  void _showMeetingOptions(BuildContext context, Meeting meeting) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Invite Friends'),
                onTap: () {
                  Navigator.pop(context);
                  _inviteFriendsToEvent(context, meeting);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Meeting'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement edit meeting functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit functionality coming soon'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Meeting'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteMeeting(context, meeting);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _inviteFriendsToEvent(BuildContext context, Meeting meeting) async {
    // Make sure the FriendsBloc is loaded
    context.read<FriendsBloc>().add(LoadFriends());

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InviteToEventScreen(meeting: meeting),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final List<Friend> selectedFriends = result['friends'] as List<Friend>;
      final Meeting selectedMeeting = result['meeting'] as Meeting;

      if (selectedFriends.isNotEmpty) {
        // In a real app, you would update the meeting with the invited friends
        // For now, we'll just show a confirmation message

        // Get the current participants
        final List<String> currentParticipants =
            List<String>.from(selectedMeeting.participants);

        // Add the new friend names
        final List<String> friendNames =
            selectedFriends.map((f) => f.name).toList();

        // Create a set to avoid duplicates and convert back to list
        final List<String> updatedParticipants =
            {...currentParticipants, ...friendNames}.toList();

        // Create an updated meeting with the new participants
        final updatedMeeting = Meeting(
          id: selectedMeeting.id,
          location: selectedMeeting.location,
          date: selectedMeeting.date,
          participants: updatedParticipants,
          wornItems: selectedMeeting.wornItems,
          foodNotes: selectedMeeting.foodNotes,
          isPast: selectedMeeting.isPast,
        );

        // Update the meeting in the bloc
        context.read<MeetingsBloc>().add(UpdateMeeting(updatedMeeting));

        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Added ${selectedFriends.length} ${selectedFriends.length == 1 ? 'friend' : 'friends'} to ${selectedMeeting.location}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _confirmDeleteMeeting(BuildContext context, Meeting meeting) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Meeting'),
          content: Text(
              'Are you sure you want to delete the meeting to ${meeting.location}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<MeetingsBloc>().add(DeleteMeeting(meeting.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Meeting to ${meeting.location} deleted'),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MeetingsBloc, MeetingsState>(
      listener: (context, state) {
        if (state is MeetingActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: BlocBuilder<MeetingsBloc, MeetingsState>(
        builder: (context, state) {
          if (state is MeetingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MeetingsError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          // Handle both MeetingsLoaded and MeetingActionSuccess states
          List<Meeting> meetings = [];
          if (state is MeetingsLoaded) {
            meetings = state.meetings.where((m) => !m.isPast).toList();
          } else if (state is MeetingActionSuccess) {
            meetings = state.meetings.where((m) => !m.isPast).toList();
          }

          if (meetings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No planned meetings',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: ResponsiveHelper.getResponsivePadding(context),
            itemCount: meetings.length,
            itemBuilder: (context, index) {
              final meeting = meetings[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: EnhancedCard(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      meeting.location,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('dd.MM.yyyy HH:mm').format(meeting.date),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Participants: ${meeting.participants.join(", ")}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        if (meeting.wornItems.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Suggested clothes: ${meeting.wornItems.map((item) => item.name).join(", ")}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ],
                        if (meeting.foodNotes != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Food suggestions: ${meeting.foodNotes}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ],
                    ),
                    onTap: () {
                      _showMeetingOptions(context, meeting);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
