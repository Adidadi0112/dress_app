import 'package:dress_app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/meetings/meetings_bloc.dart';
import '../../blocs/friends/friends_bloc.dart';
import '../../blocs/friends/friends_state.dart';
import '../../blocs/meetings/meetings_state.dart'
    hide MeetingsState, MeetingsLoaded;
import '../../models/meeting.dart';
import '../../models/friend.dart';
import '../../widgets/enhanced_card.dart';
import '../../widgets/gradient_button.dart';

class InviteToEventScreen extends StatefulWidget {
  final Meeting? meeting;

  const InviteToEventScreen({Key? key, this.meeting}) : super(key: key);

  @override
  State<InviteToEventScreen> createState() => _InviteToEventScreenState();
}

class _InviteToEventScreenState extends State<InviteToEventScreen> {
  Meeting? _selectedMeeting;
  List<Friend> _selectedFriends = [];

  @override
  void initState() {
    super.initState();
    _selectedMeeting = widget.meeting;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite to Event'),
        actions: [
          TextButton(
            onPressed: _selectedMeeting != null && _selectedFriends.isNotEmpty
                ? () {
                    Navigator.pop(context, {
                      'meeting': _selectedMeeting,
                      'friends': _selectedFriends,
                    });
                  }
                : null,
            child: const Text('Done'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Event Selection
          if (widget.meeting == null) ...[
            Padding(
              padding: const EdgeInsets.all(SpacingTokens.space16),
              child: EnhancedCard(
                child: Padding(
                  padding: const EdgeInsets.all(SpacingTokens.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Event',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: SpacingTokens.space16),
                      BlocBuilder<MeetingsBloc, MeetingsState>(
                        builder: (context, state) {
                          if (state is MeetingsLoaded) {
                            final meetings = (state as MeetingsLoaded)
                                .meetings
                                .where((m) => !m.isPast)
                                .toList();
                            return Column(
                              children: meetings.map((meeting) {
                                return RadioListTile<Meeting>(
                                  value: meeting,
                                  groupValue: _selectedMeeting,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedMeeting = value;
                                    });
                                  },
                                  title: Text(meeting.location),
                                  subtitle: Text(
                                    '${meeting.location} - ${DateFormat('dd.MM.yyyy HH:mm').format(meeting.date)}',
                                  ),
                                );
                              }).toList(),
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          // Friend Selection
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(SpacingTokens.space16),
              child: EnhancedCard(
                child: Padding(
                  padding: const EdgeInsets.all(SpacingTokens.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Friends',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: SpacingTokens.space16),
                      Expanded(
                        child: BlocBuilder<FriendsBloc, FriendsState>(
                          builder: (context, state) {
                            if (state is FriendsLoaded) {
                              if (state.friends.isEmpty) {
                                return const Center(
                                  child: Text('No friends available'),
                                );
                              }

                              return ListView.builder(
                                itemCount: state.friends.length,
                                itemBuilder: (context, index) {
                                  final friend = state.friends[index];
                                  final isSelected =
                                      _selectedFriends.contains(friend);

                                  return CheckboxListTile(
                                    value: isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedFriends.add(friend);
                                        } else {
                                          _selectedFriends.remove(friend);
                                        }
                                      });
                                    },
                                    title: Text(friend.name),
                                    subtitle: Text(friend.email),
                                    secondary: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      child: Text(friend.name[0]),
                                    ),
                                  );
                                },
                              );
                            }

                            if (state is FriendsError) {
                              return Center(
                                  child: Text('Error: ${state.message}'));
                            }

                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
