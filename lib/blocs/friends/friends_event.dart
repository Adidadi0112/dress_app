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
