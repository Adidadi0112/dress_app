import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/models/meeting.dart';
import 'package:dress_app/services/firestore_meetings_service.dart';
import 'package:dress_app/blocs/meetings/meetings_event.dart';
import 'package:dress_app/blocs/meetings/meetings_state.dart';
// Bloc
class MeetingsBloc extends Bloc<MeetingsEvent, MeetingsState> {
  final FirestoreMeetingsService _firestoreService = FirestoreMeetingsService();
  
  MeetingsBloc() : super(MeetingsInitial()) {
    on<LoadMeetings>(_onLoadMeetings);
    on<AddMeeting>(_onAddMeeting);
    on<UpdateMeeting>(_onUpdateMeeting);
    on<DeleteMeeting>(_onDeleteMeeting);
    on<AddFriendToMeeting>(_onAddFriendToMeeting);
    on<RemoveFriendFromMeeting>(_onRemoveFriendFromMeeting);
  }

  Future<void> _onLoadMeetings(LoadMeetings event, Emitter<MeetingsState> emit) async {
    emit(MeetingsLoading());
    
    try {
      final result = await _firestoreService.getMeetings();
      
      if (result['type'] == 'success') {
        final meetings = result['data'] as List<Meeting>;
        
        // Update isPast status based on current time
        final updatedMeetings = meetings.map((meeting) {
          return meeting.copyWith(isPast: meeting.isActuallyPast);
        }).toList();
        
        emit(MeetingsLoaded(updatedMeetings));
      } else {
        emit(MeetingsError(result['message']));
      }
    } catch (e) {
      emit(MeetingsError('Failed to load meetings: $e'));
    }
  }

  Future<void> _onAddMeeting(AddMeeting event, Emitter<MeetingsState> emit) async {
    try {
      emit(MeetingsLoading());
      
      final result = await _firestoreService.createMeeting(event.meeting);
      
      if (result['type'] == 'success') {
        // Reload meetings to get updated list
        final meetingsResult = await _firestoreService.getMeetings();
        
        if (meetingsResult['type'] == 'success') {
          final meetings = meetingsResult['data'] as List<Meeting>;
          
          // Update isPast status based on current time
          final updatedMeetings = meetings.map((meeting) {
            return meeting.copyWith(isPast: meeting.isActuallyPast);
          }).toList();
          
          emit(MeetingActionSuccess('Meeting created successfully!', updatedMeetings));
        } else {
          emit(MeetingsError('Meeting created but failed to refresh list'));
        }
      } else {
        emit(MeetingsError(result['message']));
      }
    } catch (e) {
      emit(MeetingsError('Failed to create meeting: $e'));
    }
  }

  Future<void> _onUpdateMeeting(UpdateMeeting event, Emitter<MeetingsState> emit) async {
    try {
      emit(MeetingsLoading());
      
      final result = await _firestoreService.updateMeeting(event.meeting.id, event.meeting);
      
      if (result['type'] == 'success') {
        // Reload meetings to get updated list
        final meetingsResult = await _firestoreService.getMeetings();
        
        if (meetingsResult['type'] == 'success') {
          final meetings = meetingsResult['data'] as List<Meeting>;
          
          // Update isPast status based on current time
          final updatedMeetings = meetings.map((meeting) {
            return meeting.copyWith(isPast: meeting.isActuallyPast);
          }).toList();
          
          emit(MeetingActionSuccess('Meeting updated successfully!', updatedMeetings));
        } else {
          emit(MeetingsError('Meeting updated but failed to refresh list'));
        }
      } else {
        emit(MeetingsError(result['message']));
      }
    } catch (e) {
      emit(MeetingsError('Failed to update meeting: $e'));
    }
  }

  Future<void> _onDeleteMeeting(DeleteMeeting event, Emitter<MeetingsState> emit) async {
    try {
      emit(MeetingsLoading());
      
      final result = await _firestoreService.deleteMeeting(event.meetingId);
      
      if (result['type'] == 'success') {
        // Reload meetings to get updated list
        final meetingsResult = await _firestoreService.getMeetings();
        
        if (meetingsResult['type'] == 'success') {
          final meetings = meetingsResult['data'] as List<Meeting>;
          
          // Update isPast status based on current time
          final updatedMeetings = meetings.map((meeting) {
            return meeting.copyWith(isPast: meeting.isActuallyPast);
          }).toList();
          
          emit(MeetingActionSuccess('Meeting deleted successfully!', updatedMeetings));
        } else {
          emit(MeetingsError('Meeting deleted but failed to refresh list'));
        }
      } else {
        emit(MeetingsError(result['message']));
      }
    } catch (e) {
      emit(MeetingsError('Failed to delete meeting: $e'));
    }
  }

  Future<void> _onAddFriendToMeeting(AddFriendToMeeting event, Emitter<MeetingsState> emit) async {
    try {
      final result = await _firestoreService.addFriendToMeeting(
        event.meetingId,
        event.friendName,
      );
      
      if (result['type'] == 'success') {
        // Reload meetings to get updated list
        final meetingsResult = await _firestoreService.getMeetings();
        
        if (meetingsResult['type'] == 'success') {
          final meetings = meetingsResult['data'] as List<Meeting>;
          
          // Update isPast status based on current time
          final updatedMeetings = meetings.map((meeting) {
            return meeting.copyWith(isPast: meeting.isActuallyPast);
          }).toList();
          
          emit(MeetingActionSuccess('Friend added to meeting successfully!', updatedMeetings));
        }
      } else {
        emit(MeetingsError(result['message']));
      }
    } catch (e) {
      emit(MeetingsError('Failed to add friend to meeting: $e'));
    }
  }

  Future<void> _onRemoveFriendFromMeeting(RemoveFriendFromMeeting event, Emitter<MeetingsState> emit) async {
    try {
      final result = await _firestoreService.removeFriendFromMeeting(
        event.meetingId,
        event.friendName,
      );
      
      if (result['type'] == 'success') {
        // Reload meetings to get updated list
        final meetingsResult = await _firestoreService.getMeetings();
        
        if (meetingsResult['type'] == 'success') {
          final meetings = meetingsResult['data'] as List<Meeting>;
          
          // Update isPast status based on current time
          final updatedMeetings = meetings.map((meeting) {
            return meeting.copyWith(isPast: meeting.isActuallyPast);
          }).toList();
          
          emit(MeetingActionSuccess('Friend removed from meeting successfully!', updatedMeetings));
        }
      } else {
        emit(MeetingsError(result['message']));
      }
    } catch (e) {
      emit(MeetingsError('Failed to remove friend from meeting: $e'));
    }
  }
}
