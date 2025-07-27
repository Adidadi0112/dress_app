import 'package:equatable/equatable.dart';
import 'package:dress_app/models/meeting.dart';

abstract class MeetingsEvent extends Equatable {
  const MeetingsEvent();

  @override
  List<Object> get props => [];
}

class LoadMeetings extends MeetingsEvent {}

class AddMeeting extends MeetingsEvent {
  final Meeting meeting;

  const AddMeeting(this.meeting);

  @override
  List<Object> get props => [meeting];
}

class UpdateMeeting extends MeetingsEvent {
  final Meeting meeting;

  const UpdateMeeting(this.meeting);

  @override
  List<Object> get props => [meeting];
}

class DeleteMeeting extends MeetingsEvent {
  final String meetingId;

  const DeleteMeeting(this.meetingId);

  @override
  List<Object> get props => [meetingId];
}

class AddFriendToMeeting extends MeetingsEvent {
  final String meetingId;
  final String friendName;

  const AddFriendToMeeting({
    required this.meetingId,
    required this.friendName,
  });

  @override
  List<Object> get props => [meetingId, friendName];
}

class RemoveFriendFromMeeting extends MeetingsEvent {
  final String meetingId;
  final String friendName;

  const RemoveFriendFromMeeting({
    required this.meetingId,
    required this.friendName,
  });

  @override
  List<Object> get props => [meetingId, friendName];
}
