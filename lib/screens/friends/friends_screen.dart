import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/blocs/friends/friends_bloc.dart';
import 'package:dress_app/blocs/friends/friends_event.dart';
import 'package:dress_app/blocs/friends/friends_state.dart';
import 'package:dress_app/blocs/meetings/meetings_bloc.dart';
import 'package:dress_app/models/friend.dart';
import 'package:dress_app/screens/friends/invite_friend_screen.dart';
import 'package:dress_app/screens/friends/invite_to_event_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<FriendsBloc>().add(LoadFriends());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Friends'),
            Tab(text: 'Pending Invites'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InviteFriendScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<FriendsBloc, FriendsState>(
        builder: (context, state) {
          if (state is FriendsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FriendsError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is FriendsLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsList(state.friends),
                _buildPendingInvitesList(state.pendingInvites),
              ],
            );
          }

          return const Center(child: Text('No friends data available'));
        },
      ),
    );
  }

  Widget _buildFriendsList(List<Friend> friends) {
    if (friends.isEmpty) {
      return const Center(
        child: Text('You have no friends yet. Invite some!'),
      );
    }

    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).colorScheme.primary,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: friend.avatarUrl != null
                  ? Image.network(friend.avatarUrl!)
                  : Text(friend.name[0]),
            ),
            title: Text(friend.name),
            subtitle: Text(friend.email),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showFriendOptions(friend);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPendingInvitesList(List<Friend> pendingInvites) {
    if (pendingInvites.isEmpty) {
      return const Center(
        child: Text('No pending invites'),
      );
    }

    return ListView.builder(
      itemCount: pendingInvites.length,
      itemBuilder: (context, index) {
        final invite = pendingInvites[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(invite.name[0]),
            ),
            title: Text(invite.name),
            subtitle: Text(invite.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    context
                        .read<FriendsBloc>()
                        .add(AcceptFriendInvite(invite.id));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    context
                        .read<FriendsBloc>()
                        .add(RejectFriendInvite(invite.id));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFriendOptions(Friend friend) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.event_available),
                title: const Text('Invite to Event'),
                onTap: () {
                  Navigator.pop(context);
                  _inviteToEvent(friend);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Remove Friend'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmRemoveFriend(friend);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _inviteToEvent(Friend friend) async {
    // Load outings to make sure we have the latest data
    context.read<MeetingsBloc>().add(LoadMeetings());

    // Navigate to the invite to event screen with the selected friend
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InviteToEventScreen(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final selectedFriends = result['friends'] as List<Friend>;
      final selectedOuting = result['outing'];

      if (selectedFriends.isNotEmpty && selectedOuting != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Invited ${friend.name} to ${selectedOuting.location}'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }
  }

  void _confirmRemoveFriend(Friend friend) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Friend'),
          content: Text('Are you sure you want to remove ${friend.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<FriendsBloc>().add(RemoveFriend(friend.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${friend.name} removed from friends'),
                  ),
                );
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}
