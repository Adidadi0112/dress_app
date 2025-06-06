import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/blocs/friends/friends_event.dart';
import 'package:dress_app/blocs/friends/friends_state.dart';
import 'package:dress_app/models/friend.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  // Mock data for demonstration purposes
  final List<Friend> _mockFriends = [
    Friend(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      avatarUrl: null,
    ),
    Friend(
      id: '2',
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
      avatarUrl: null,
    ),
    Friend(
      id: '3',
      name: 'Mike Johnson',
      email: 'mike.johnson@example.com',
      avatarUrl: null,
    ),
  ];

  final List<Friend> _mockPendingInvites = [
    Friend(
      id: '4',
      name: 'Sarah Williams',
      email: 'sarah.williams@example.com',
      avatarUrl: null,
      isConfirmed: false,
    ),
  ];

  FriendsBloc() : super(FriendsInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<AddFriend>(_onAddFriend);
    on<RemoveFriend>(_onRemoveFriend);
    on<UpdateFriend>(_onUpdateFriend);
    on<SendFriendInvite>(_onSendFriendInvite);
    on<AcceptFriendInvite>(_onAcceptFriendInvite);
    on<RejectFriendInvite>(_onRejectFriendInvite);
  }

  void _onLoadFriends(LoadFriends event, Emitter<FriendsState> emit) {
    emit(FriendsLoading());
    try {
      // In a real app, you would fetch friends from an API or database
      emit(FriendsLoaded(
        friends: List.from(_mockFriends),
        pendingInvites: List.from(_mockPendingInvites),
      ));
    } catch (e) {
      emit(FriendsError('Failed to load friends: ${e.toString()}'));
    }
  }

  void _onAddFriend(AddFriend event, Emitter<FriendsState> emit) {
    final currentState = state;
    if (currentState is FriendsLoaded) {
      try {
        final updatedFriends = List<Friend>.from(currentState.friends)
          ..add(event.friend);
        emit(FriendsLoaded(
          friends: updatedFriends,
          pendingInvites: currentState.pendingInvites,
        ));
      } catch (e) {
        emit(FriendsError('Failed to add friend: ${e.toString()}'));
      }
    }
  }

  void _onRemoveFriend(RemoveFriend event, Emitter<FriendsState> emit) {
    final currentState = state;
    if (currentState is FriendsLoaded) {
      try {
        final updatedFriends = currentState.friends
            .where((friend) => friend.id != event.friendId)
            .toList();
        emit(FriendsLoaded(
          friends: updatedFriends,
          pendingInvites: currentState.pendingInvites,
        ));
      } catch (e) {
        emit(FriendsError('Failed to remove friend: ${e.toString()}'));
      }
    }
  }

  void _onUpdateFriend(UpdateFriend event, Emitter<FriendsState> emit) {
    final currentState = state;
    if (currentState is FriendsLoaded) {
      try {
        final updatedFriends = currentState.friends.map((friend) {
          return friend.id == event.friend.id ? event.friend : friend;
        }).toList();
        emit(FriendsLoaded(
          friends: updatedFriends,
          pendingInvites: currentState.pendingInvites,
        ));
      } catch (e) {
        emit(FriendsError('Failed to update friend: ${e.toString()}'));
      }
    }
  }

  void _onSendFriendInvite(SendFriendInvite event, Emitter<FriendsState> emit) {
    final currentState = state;
    if (currentState is FriendsLoaded) {
      try {
        // In a real app, you would send an invite through an API
        final newInvite = Friend(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: event.name,
          email: event.email,
          isConfirmed: false,
        );

        final updatedPendingInvites =
            List<Friend>.from(currentState.pendingInvites)..add(newInvite);

        emit(FriendsLoaded(
          friends: currentState.friends,
          pendingInvites: updatedPendingInvites,
        ));
        emit(FriendInviteSent(event.email));
      } catch (e) {
        emit(FriendsError('Failed to send invite: ${e.toString()}'));
      }
    }
  }

  void _onAcceptFriendInvite(
      AcceptFriendInvite event, Emitter<FriendsState> emit) {
    final currentState = state;
    if (currentState is FriendsLoaded) {
      try {
        // Find the invite
        final invite = currentState.pendingInvites
            .firstWhere((invite) => invite.id == event.friendId);

        // Create a confirmed friend from the invite
        final confirmedFriend = invite.copyWith(isConfirmed: true);

        // Remove from pending invites
        final updatedPendingInvites = currentState.pendingInvites
            .where((invite) => invite.id != event.friendId)
            .toList();

        // Add to friends
        final updatedFriends = List<Friend>.from(currentState.friends)
          ..add(confirmedFriend);

        emit(FriendsLoaded(
          friends: updatedFriends,
          pendingInvites: updatedPendingInvites,
        ));
        emit(FriendInviteAccepted(confirmedFriend));
      } catch (e) {
        emit(FriendsError('Failed to accept invite: ${e.toString()}'));
      }
    }
  }

  void _onRejectFriendInvite(
      RejectFriendInvite event, Emitter<FriendsState> emit) {
    final currentState = state;
    if (currentState is FriendsLoaded) {
      try {
        // Remove from pending invites
        final updatedPendingInvites = currentState.pendingInvites
            .where((invite) => invite.id != event.friendId)
            .toList();

        emit(FriendsLoaded(
          friends: currentState.friends,
          pendingInvites: updatedPendingInvites,
        ));
        emit(FriendInviteRejected(event.friendId));
      } catch (e) {
        emit(FriendsError('Failed to reject invite: ${e.toString()}'));
      }
    }
  }
}
