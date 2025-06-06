import 'package:equatable/equatable.dart';
import 'package:dress_app/models/friend.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props => [];
}

class FriendsInitial extends FriendsState {}

class FriendsLoading extends FriendsState {}

class FriendsLoaded extends FriendsState {
  final List<Friend> friends;
  final List<Friend> pendingInvites;

  const FriendsLoaded({
    required this.friends,
    required this.pendingInvites,
  });

  @override
  List<Object> get props => [friends, pendingInvites];
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
