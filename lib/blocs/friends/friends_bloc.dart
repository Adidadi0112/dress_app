import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/blocs/friends/friends_event.dart';
import 'package:dress_app/blocs/friends/friends_state.dart';
import 'package:dress_app/models/friend.dart';
import 'package:dress_app/services/user_service.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final UserService _userService = UserService();

  // We'll keep a local cache of friends
  final List<Friend> _friends = [];

  // We'll still use mock data for pending invites since the API doesn't support this
  final List<Friend> _pendingInvites = [
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
    on<InviteFriend>(_onInviteFriend);
  }

  void _onLoadFriends(LoadFriends event, Emitter<FriendsState> emit) async {
    emit(FriendsLoading());
    try {
      // Fetch users from the API
      final users = await _userService.getUsers();

      // Update our local cache
      _friends.clear();
      _friends.addAll(users);

      emit(FriendsLoaded(
        friends: List.from(_friends),
        pendingInvites: List.from(_pendingInvites),
      ));
    } catch (e) {
      emit(FriendsError('Failed to load friends: ${e.toString()}'));
    }
  }

  void _onAddFriend(AddFriend event, Emitter<FriendsState> emit) {
    final currentState = state;
    if (currentState is FriendsLoaded) {
      try {
        // In a real app, you would add the friend to the database
        // For now, we'll just add it to our local cache
        _friends.add(event.friend);

        emit(FriendsLoaded(
          friends: List.from(_friends),
          pendingInvites: currentState.pendingInvites,
        ));
      } catch (e) {
        emit(FriendsError('Failed to add friend: ${e.toString()}'));
      }
    }
  }

  void _onRemoveFriend(RemoveFriend event, Emitter<FriendsState> emit) {
    try {
      _friends.removeWhere((friend) => friend.id == event.friendId);
      emit(FriendsLoaded(
        friends: List.from(_friends),
        pendingInvites: List.from(_pendingInvites),
      ));
    } catch (e) {
      emit(FriendsError(e.toString()));
    }
  }

  void _onUpdateFriend(UpdateFriend event, Emitter<FriendsState> emit) {
    final currentState = state;
    if (currentState is FriendsLoaded) {
      try {
        // In a real app, you would update the friend in the database
        // For now, we'll just update it in our local cache
        final index =
            _friends.indexWhere((friend) => friend.id == event.friend.id);
        if (index != -1) {
          _friends[index] = event.friend;
        }

        emit(FriendsLoaded(
          friends: List.from(_friends),
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
        // For now, we'll just add it to our local pending invites
        final newInvite = Friend(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: event.name,
          email: event.email,
          isConfirmed: false,
        );

        _pendingInvites.add(newInvite);

        emit(FriendsLoaded(
          friends: currentState.friends,
          pendingInvites: List.from(_pendingInvites),
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
        final invite =
            _pendingInvites.firstWhere((invite) => invite.id == event.friendId);

        // Create a confirmed friend from the invite
        final confirmedFriend = invite.copyWith(isConfirmed: true);

        // Remove from pending invites
        _pendingInvites.removeWhere((invite) => invite.id == event.friendId);

        // Add to friends
        _friends.add(confirmedFriend);

        emit(FriendsLoaded(
          friends: List.from(_friends),
          pendingInvites: List.from(_pendingInvites),
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
        _pendingInvites.removeWhere((invite) => invite.id == event.friendId);

        emit(FriendsLoaded(
          friends: currentState.friends,
          pendingInvites: List.from(_pendingInvites),
        ));
        emit(FriendInviteRejected(event.friendId));
      } catch (e) {
        emit(FriendsError('Failed to reject invite: ${e.toString()}'));
      }
    }
  }

  void _onInviteFriend(InviteFriend event, Emitter<FriendsState> emit) {
    try {
      // In a real app, this would send an invitation via API
      // For now, we'll just add to pending invites
      final newInvite = Friend(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        email: event.email,
      );
      _pendingInvites.add(newInvite);
      emit(FriendsLoaded(
        friends: List.from(_friends),
        pendingInvites: List.from(_pendingInvites),
      ));
    } catch (e) {
      emit(FriendsError(e.toString()));
    }
  }
}
