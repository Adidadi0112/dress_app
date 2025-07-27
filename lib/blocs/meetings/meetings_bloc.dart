import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/models/meeting.dart';

// Events
abstract class MeetingsEvent extends Equatable {
  const MeetingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMeetings extends MeetingsEvent {}

class AddMeeting extends MeetingsEvent {
  final Meeting meeting;

  const AddMeeting(this.meeting);

  @override
  List<Object?> get props => [meeting];
}

class UpdateMeeting extends MeetingsEvent {
  final Meeting meeting;

  const UpdateMeeting(this.meeting);

  @override
  List<Object?> get props => [meeting];
}

class DeleteMeeting extends MeetingsEvent {
  final String meetingId;

  const DeleteMeeting(this.meetingId);

  @override
  List<Object?> get props => [meetingId];
}

// States
abstract class MeetingsState extends Equatable {
  const MeetingsState();

  @override
  List<Object?> get props => [];
}

class MeetingsInitial extends MeetingsState {}

class MeetingsLoading extends MeetingsState {}

class MeetingsLoaded extends MeetingsState {
  final List<Meeting> meetings;

  const MeetingsLoaded({required this.meetings});

  @override
  List<Object?> get props => [meetings];
}

class MeetingsError extends MeetingsState {
  final String message;

  const MeetingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class MeetingsBloc extends Bloc<MeetingsEvent, MeetingsState> {
  MeetingsBloc() : super(MeetingsInitial()) {
    on<LoadMeetings>(_onLoadMeetings);
    on<AddMeeting>(_onAddMeeting);
    on<UpdateMeeting>(_onUpdateMeeting);
    on<DeleteMeeting>(_onDeleteMeeting);
  }

  List<Meeting> _meetings = [];

  void _onLoadMeetings(LoadMeetings event, Emitter<MeetingsState> emit) {
    emit(MeetingsLoading());
    try {
      // In a real app, this would fetch from a database or API
      emit(MeetingsLoaded(meetings: List.from(_meetings)));
    } catch (e) {
      emit(MeetingsError(e.toString()));
    }
  }

  void _onAddMeeting(AddMeeting event, Emitter<MeetingsState> emit) {
    try {
      _meetings.add(event.meeting);
      emit(MeetingsLoaded(meetings: List.from(_meetings)));
    } catch (e) {
      emit(MeetingsError(e.toString()));
    }
  }

  void _onUpdateMeeting(UpdateMeeting event, Emitter<MeetingsState> emit) {
    try {
      final index = _meetings.indexWhere((m) => m.id == event.meeting.id);
      if (index != -1) {
        _meetings[index] = event.meeting;
        emit(MeetingsLoaded(meetings: List.from(_meetings)));
      }
    } catch (e) {
      emit(MeetingsError(e.toString()));
    }
  }

  void _onDeleteMeeting(DeleteMeeting event, Emitter<MeetingsState> emit) {
    try {
      _meetings.removeWhere((m) => m.id == event.meetingId);
      emit(MeetingsLoaded(meetings: List.from(_meetings)));
    } catch (e) {
      emit(MeetingsError(e.toString()));
    }
  }
}
