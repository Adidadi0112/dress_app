import 'package:dress_app/blocs/friends/friends_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/models/outing.dart';
import 'package:dress_app/models/friend.dart';
import 'package:dress_app/blocs/outings/outings_bloc.dart';
import 'package:dress_app/blocs/friends/friends_bloc.dart';
import 'package:dress_app/screens/friends/invite_to_event_screen.dart';
import 'package:intl/intl.dart';

class FutureOutingsScreen extends StatelessWidget {
  const FutureOutingsScreen({super.key});

  void _showOutingOptions(BuildContext context, Outing outing) {
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
                  _inviteFriendsToEvent(context, outing);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Outing'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement edit outing functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit functionality coming soon'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Outing'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteOuting(context, outing);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _inviteFriendsToEvent(BuildContext context, Outing outing) async {
    // Make sure the FriendsBloc is loaded
    context.read<FriendsBloc>().add(LoadFriends());

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InviteToEventScreen(outing: outing),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final List<Friend> selectedFriends = result['friends'] as List<Friend>;
      final Outing selectedOuting = result['outing'] as Outing;

      if (selectedFriends.isNotEmpty) {
        // In a real app, you would update the outing with the invited friends
        // For now, we'll just show a confirmation message

        // Get the current participants
        final List<String> currentParticipants =
            List<String>.from(selectedOuting.participants);

        // Add the new friend names
        final List<String> friendNames =
            selectedFriends.map((f) => f.name).toList();

        // Create a set to avoid duplicates and convert back to list
        final List<String> updatedParticipants =
            {...currentParticipants, ...friendNames}.toList();

        // Create an updated outing with the new participants
        final updatedOuting = Outing(
          id: selectedOuting.id,
          location: selectedOuting.location,
          date: selectedOuting.date,
          participants: updatedParticipants,
          wornItems: selectedOuting.wornItems,
          foodNotes: selectedOuting.foodNotes,
          isPast: selectedOuting.isPast,
        );

        // Update the outing in the bloc
        context.read<OutingsBloc>().add(UpdateOuting(updatedOuting));

        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Added ${selectedFriends.length} ${selectedFriends.length == 1 ? 'friend' : 'friends'} to ${selectedOuting.location}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _confirmDeleteOuting(BuildContext context, Outing outing) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Outing'),
          content: Text(
              'Are you sure you want to delete the outing to ${outing.location}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<OutingsBloc>().add(DeleteOuting(outing.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Outing to ${outing.location} deleted'),
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
    return BlocBuilder<OutingsBloc, OutingsState>(
      builder: (context, state) {
        if (state is OutingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is OutingsError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is OutingsLoaded) {
          final outings = state.futureOutings;

          if (outings.isEmpty) {
            return const Center(child: Text('No planned outings'));
          }

          return ListView.builder(
            itemCount: outings.length,
            itemBuilder: (context, index) {
              final outing = outings[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Theme.of(context).colorScheme.secondary,
                child: ListTile(
                  title: Text(outing.location),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('dd.MM.yyyy HH:mm').format(outing.date)),
                      Text('Participants: ${outing.participants.join(", ")}'),
                      if (outing.wornItems.isNotEmpty)
                        Text(
                          'Suggested clothes: ${outing.wornItems.map((item) => item.name).join(", ")}',
                        ),
                      if (outing.foodNotes != null)
                        Text('Food suggestions: ${outing.foodNotes}'),
                    ],
                  ),
                  onTap: () {
                    _showOutingOptions(context, outing);
                  },
                ),
              );
            },
          );
        }

        return const Center(child: Text('Unknown state'));
      },
    );
  }
}
