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
  final String id;

  const DeleteMeeting(this.id);

  @override
  List<Object> get props => [id];
}
