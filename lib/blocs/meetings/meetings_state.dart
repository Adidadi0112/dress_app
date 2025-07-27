import 'package:equatable/equatable.dart';
import 'package:dress_app/models/meeting.dart';

abstract class MeetingsState extends Equatable {
  const MeetingsState();

  @override
  List<Object> get props => [];
}

class MeetingsInitial extends MeetingsState {}

class MeetingsLoading extends MeetingsState {}

class MeetingsLoaded extends MeetingsState {
  final List<Meeting> meetings;

  const MeetingsLoaded(this.meetings);

  List<Meeting> get pastMeetings => meetings.where((m) => m.isPast).toList();
  List<Meeting> get futureMeetings => meetings.where((m) => !m.isPast).toList();

  @override
  List<Object> get props => [meetings];
}

class MeetingsError extends MeetingsState {
  final String message;

  const MeetingsError(this.message);

  @override
  List<Object> get props => [message];
}

class MeetingActionSuccess extends MeetingsState {
  final String message;
  final List<Meeting> meetings;

  const MeetingActionSuccess(this.message, this.meetings);

  @override
  List<Object> get props => [message, meetings];
}
