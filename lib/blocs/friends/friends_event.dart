import 'package:equatable/equatable.dart';
import 'package:dress_app/models/friend.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

class LoadFriends extends FriendsEvent {}

class AddFriend extends FriendsEvent {
  final Friend friend;

  const AddFriend(this.friend);

  @override
  List<Object> get props => [friend];
}

class RemoveFriend extends FriendsEvent {
  final String friendId;

  const RemoveFriend(this.friendId);

  @override
  List<Object> get props => [friendId];
}

class InviteFriend extends FriendsEvent {
  final String email;
  final String name;

  const InviteFriend({required this.email, required this.name});

  @override
  List<Object> get props => [email, name];
}

class UpdateFriend extends FriendsEvent {
  final Friend friend;

  const UpdateFriend(this.friend);

  @override
  List<Object> get props => [friend];
}

class SendFriendInvite extends FriendsEvent {
  final String email;
  final String name;

  const SendFriendInvite({required this.email, required this.name});

  @override
  List<Object> get props => [email, name];
}

class AcceptFriendInvite extends FriendsEvent {
  final String friendId;

  const AcceptFriendInvite(this.friendId);

  @override
  List<Object> get props => [friendId];
}

class RejectFriendInvite extends FriendsEvent {
  final String friendId;

  const RejectFriendInvite(this.friendId);

  @override
  List<Object> get props => [friendId];
}

// New Firebase-specific events
class SearchUserByEmail extends FriendsEvent {
  final String email;

  const SearchUserByEmail(this.email);

  @override
  List<Object> get props => [email];
}

class SendFriendRequest extends FriendsEvent {
  final String targetUserId;

  const SendFriendRequest(this.targetUserId);

  @override
  List<Object> get props => [targetUserId];
}

class AcceptFriendRequest extends FriendsEvent {
  final String requestId;
  final String fromUserId;

  const AcceptFriendRequest(this.requestId, this.fromUserId);

  @override
  List<Object> get props => [requestId, fromUserId];
}

class RejectFriendRequest extends FriendsEvent {
  final String requestId;

  const RejectFriendRequest(this.requestId);

  @override
  List<Object> get props => [requestId];
}

class LoadPendingRequests extends FriendsEvent {}

class LoadSentRequests extends FriendsEvent {}
