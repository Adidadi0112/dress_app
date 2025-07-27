import 'package:equatable/equatable.dart';
import 'package:dress_app/models/friend.dart';
import 'package:dress_app/models/friend_request.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props => [];
}

class FriendsInitial extends FriendsState {}

class FriendsLoading extends FriendsState {}

class FriendsLoaded extends FriendsState {
  final List<Friend> friends;
  final List<Friend> pendingInvites; // Keep for backward compatibility
  final List<FriendRequest> receivedRequests;
  final List<FriendRequest> sentRequests;

  const FriendsLoaded({
    required this.friends,
    this.pendingInvites = const [],
    this.receivedRequests = const [],
    this.sentRequests = const [],
  });

  @override
  List<Object> get props =>
      [friends, pendingInvites, receivedRequests, sentRequests];

  FriendsLoaded copyWith({
    List<Friend>? friends,
    List<Friend>? pendingInvites,
    List<FriendRequest>? receivedRequests,
    List<FriendRequest>? sentRequests,
  }) {
    return FriendsLoaded(
      friends: friends ?? this.friends,
      pendingInvites: pendingInvites ?? this.pendingInvites,
      receivedRequests: receivedRequests ?? this.receivedRequests,
      sentRequests: sentRequests ?? this.sentRequests,
    );
  }
}

class FriendsError extends FriendsState {
  final String message;

  const FriendsError(this.message);

  @override
  List<Object> get props => [message];
}

class FriendInviteSent extends FriendsState {
  final String email;

  const FriendInviteSent(this.email);

  @override
  List<Object> get props => [email];
}

class FriendInviteAccepted extends FriendsState {
  final Friend friend;

  const FriendInviteAccepted(this.friend);

  @override
  List<Object> get props => [friend];
}

class FriendInviteRejected extends FriendsState {
  final String friendId;

  const FriendInviteRejected(this.friendId);

  @override
  List<Object> get props => [friendId];
}

// New Firebase-specific states
class UserSearchResult extends FriendsState {
  final Map<String, dynamic> userData;

  const UserSearchResult(this.userData);

  @override
  List<Object> get props => [userData];
}

class FriendRequestSent extends FriendsState {
  final String message;

  const FriendRequestSent(this.message);

  @override
  List<Object> get props => [message];
}

class FriendRequestAccepted extends FriendsState {
  final Friend friend;

  const FriendRequestAccepted(this.friend);

  @override
  List<Object> get props => [friend];
}

class FriendRequestRejected extends FriendsState {
  final String message;

  const FriendRequestRejected(this.message);

  @override
  List<Object> get props => [message];
}
