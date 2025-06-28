import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/blocs/friends/friends_bloc.dart';
import 'package:dress_app/blocs/friends/friends_state.dart';
import 'package:dress_app/blocs/outings/outings_bloc.dart';
import 'package:dress_app/models/friend.dart';
import 'package:dress_app/models/outing.dart';
import 'package:intl/intl.dart';

class InviteToEventScreen extends StatefulWidget {
  final Outing? outing;

  const InviteToEventScreen({
    Key? key,
    this.outing,
  }) : super(key: key);

  @override
  State<InviteToEventScreen> createState() => _InviteToEventScreenState();
}

class _InviteToEventScreenState extends State<InviteToEventScreen> {
  Outing? _selectedOuting;
  final List<Friend> _selectedFriends = [];

  @override
  void initState() {
    super.initState();
    _selectedOuting = widget.outing;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Friends to Event'),
      ),
      body: Column(
        children: [
          if (_selectedOuting == null) _buildEventSelector(),
          Expanded(
            child: _buildFriendsList(),
          ),
          if (_selectedFriends.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _inviteFriends,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  'Invite ${_selectedFriends.length} ${_selectedFriends.length == 1 ? 'Friend' : 'Friends'}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEventSelector() {
    return BlocBuilder<OutingsBloc, OutingsState>(
      builder: (context, state) {
        if (state is OutingsLoaded) {
          final futureOutings = state.futureOutings;

          if (futureOutings.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No future events available to invite friends to'),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select an event:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<Outing>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  hint: const Text('Select an event'),
                  value: _selectedOuting,
                  items: futureOutings.map((outing) {
                    return DropdownMenuItem<Outing>(
                      value: outing,
                      child: Text(
                        '${outing.location} - ${DateFormat('dd.MM.yyyy HH:mm').format(outing.date)}',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedOuting = value;
                    });
                  },
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildFriendsList() {
    return BlocBuilder<FriendsBloc, FriendsState>(
      builder: (context, state) {
        if (state is FriendsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FriendsError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is FriendsLoaded) {
          final friends = state.friends;

          if (friends.isEmpty) {
            return const Center(
              child: Text('You have no friends to invite'),
            );
          }

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              final isSelected = _selectedFriends.contains(friend);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                    : Theme.of(context).colorScheme.surface,
                child: CheckboxListTile(
                  value: isSelected,
                  onChanged: (bool? value) {
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: friend.avatarUrl != null
                        ? Image.network(friend.avatarUrl!)
                        : Text(friend.name[0]),
                  ),
                ),
              );
            },
          );
        }

        return const Center(child: Text('No friends data available'));
      },
    );
  }

  void _inviteFriends() {
    if (_selectedOuting == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an event'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedFriends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one friend'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // In a real app, you would send invitations through an API
    // For now, we'll just show a success message and return the data
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Invited ${_selectedFriends.length} ${_selectedFriends.length == 1 ? 'friend' : 'friends'} to ${_selectedOuting!.location}',
        ),
        backgroundColor: Colors.green,
      ),
    );

    // Return both the selected friends and the outing
    Navigator.pop(context, {
      'friends': _selectedFriends,
      'outing': _selectedOuting,
    });
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/blocs/friends/friends_bloc.dart';
import 'package:dress_app/blocs/friends/friends_state.dart';
import 'package:dress_app/blocs/outings/outings_bloc.dart';
import 'package:dress_app/blocs/outings/outings_state.dart';
import 'package:dress_app/models/friend.dart';
import 'package:dress_app/models/outing.dart';
import 'package:dress_app/widgets/enhanced_card.dart';
import 'package:dress_app/widgets/gradient_button.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:intl/intl.dart';

class InviteToEventScreen extends StatefulWidget {
  final Outing? outing;

  const InviteToEventScreen({Key? key, this.outing}) : super(key: key);

  @override
  State<InviteToEventScreen> createState() => _InviteToEventScreenState();
}

class _InviteToEventScreenState extends State<InviteToEventScreen> {
  Outing? _selectedOuting;
  List<Friend> _selectedFriends = [];

  @override
  void initState() {
    super.initState();
    _selectedOuting = widget.outing;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite to Event'),
        actions: [
          TextButton(
            onPressed: _selectedOuting != null && _selectedFriends.isNotEmpty
                ? () {
                    Navigator.pop(context, {
                      'outing': _selectedOuting,
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
          if (widget.outing == null) ...[
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: SpacingTokens.space16),
                      BlocBuilder<OutingsBloc, OutingsState>(
                        builder: (context, state) {
                          if (state is OutingsLoaded) {
                            return Column(
                              children: state.futureOutings.map((outing) {
                                return RadioListTile<Outing>(
                                  value: outing,
                                  groupValue: _selectedOuting,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOuting = value;
                                    });
                                  },
                                  title: Text(outing.location),
                                  subtitle: Text(
                                    '${outing.location} - ${DateFormat('dd.MM.yyyy HH:mm').format(outing.date)}',
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                                  final isSelected = _selectedFriends.contains(friend);

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
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      child: Text(friend.name[0]),
                                    ),
                                  );
                                },
                              );
                            }

                            if (state is FriendsError) {
                              return Center(child: Text('Error: ${state.message}'));
                            }

                            return const Center(child: CircularProgressIndicator());
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
