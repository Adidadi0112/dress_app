import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dress_app/models/meeting.dart';

class FirestoreMeetingsService {
  static final FirestoreMeetingsService _instance =
      FirestoreMeetingsService._internal();
  factory FirestoreMeetingsService() => _instance;
  FirestoreMeetingsService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // Meetings collection reference for current user
  CollectionReference? get _meetingsCollection {
    if (_currentUserId == null) return null;
    return _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('meetings');
  }

  /// Create a new meeting
  Future<Map<String, dynamic>> createMeeting(Meeting meeting) async {
    try {
      if (_meetingsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      final now = DateTime.now();
      final meetingData = meeting.toMap();
      meetingData['createdAt'] = now.toIso8601String();
      meetingData['updatedAt'] = now.toIso8601String();

      // Add the meeting to Firestore
      DocumentReference docRef = await _meetingsCollection!.add(meetingData);

      return {
        'type': 'success',
        'message': 'Meeting created successfully',
        'data': {'id': docRef.id},
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to create meeting: $e',
      };
    }
  }

  /// Get all meetings for current user
  Future<Map<String, dynamic>> getMeetings() async {
    try {
      if (_meetingsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      QuerySnapshot querySnapshot = await _meetingsCollection!
          .orderBy('date', descending: false)
          .get();

      List<Meeting> meetings = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Meeting.fromMap(data, doc.id);
      }).toList();

      return {
        'type': 'success',
        'data': meetings,
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to get meetings: $e',
      };
    }
  }

  /// Update a meeting
  Future<Map<String, dynamic>> updateMeeting(
      String meetingId, Meeting meeting) async {
    try {
      if (_meetingsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      final now = DateTime.now();
      final meetingData = meeting.toMap();
      meetingData['updatedAt'] = now.toIso8601String();

      await _meetingsCollection!.doc(meetingId).update(meetingData);

      return {
        'type': 'success',
        'message': 'Meeting updated successfully',
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to update meeting: $e',
      };
    }
  }

  /// Delete a meeting
  Future<Map<String, dynamic>> deleteMeeting(String meetingId) async {
    try {
      if (_meetingsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      await _meetingsCollection!.doc(meetingId).delete();

      return {
        'type': 'success',
        'message': 'Meeting deleted successfully',
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to delete meeting: $e',
      };
    }
  }

  /// Get a specific meeting by ID
  Future<Map<String, dynamic>> getMeeting(String meetingId) async {
    try {
      if (_meetingsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      DocumentSnapshot doc = await _meetingsCollection!.doc(meetingId).get();

      if (!doc.exists) {
        return {
          'type': 'error',
          'message': 'Meeting not found',
        };
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Meeting meeting = Meeting.fromMap(data, doc.id);

      return {
        'type': 'success',
        'data': meeting,
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to get meeting: $e',
      };
    }
  }

  /// Get meetings for a specific date range
  Future<List<Meeting>> getMeetingsInDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      if (_meetingsCollection == null) return [];

      QuerySnapshot querySnapshot = await _meetingsCollection!
          .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('date', descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Meeting.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get upcoming meetings (not past)
  Future<List<Meeting>> getUpcomingMeetings() async {
    try {
      if (_meetingsCollection == null) return [];

      final now = DateTime.now();
      QuerySnapshot querySnapshot = await _meetingsCollection!
          .where('date', isGreaterThan: now.toIso8601String())
          .orderBy('date', descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Meeting.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get past meetings
  Future<List<Meeting>> getPastMeetings() async {
    try {
      if (_meetingsCollection == null) return [];

      final now = DateTime.now();
      QuerySnapshot querySnapshot = await _meetingsCollection!
          .where('date', isLessThan: now.toIso8601String())
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Meeting.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Stream of meetings (real-time updates)
  Stream<List<Meeting>> get meetingsStream {
    if (_meetingsCollection == null) {
      return Stream.value([]);
    }

    return _meetingsCollection!
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Meeting.fromMap(data, doc.id);
      }).toList();
    });
  }

  /// Add a friend to a meeting
  Future<Map<String, dynamic>> addFriendToMeeting(
      String meetingId, String friendName) async {
    try {
      if (_meetingsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      // Get the current meeting
      final meetingResult = await getMeeting(meetingId);
      if (meetingResult['type'] != 'success') {
        return meetingResult;
      }

      Meeting meeting = meetingResult['data'] as Meeting;
      
      // Check if friend is already a participant
      if (meeting.participants.contains(friendName)) {
        return {
          'type': 'error',
          'message': 'Friend is already a participant',
        };
      }

      // Add friend to participants
      List<String> updatedParticipants = List.from(meeting.participants);
      updatedParticipants.add(friendName);

      // Update the meeting
      await _meetingsCollection!.doc(meetingId).update({
        'participants': updatedParticipants,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      return {
        'type': 'success',
        'message': 'Friend added to meeting successfully',
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to add friend to meeting: $e',
      };
    }
  }

  /// Remove a friend from a meeting
  Future<Map<String, dynamic>> removeFriendFromMeeting(
      String meetingId, String friendName) async {
    try {
      if (_meetingsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      // Get the current meeting
      final meetingResult = await getMeeting(meetingId);
      if (meetingResult['type'] != 'success') {
        return meetingResult;
      }

      Meeting meeting = meetingResult['data'] as Meeting;
      
      // Remove friend from participants
      List<String> updatedParticipants = List.from(meeting.participants);
      updatedParticipants.remove(friendName);

      // Update the meeting
      await _meetingsCollection!.doc(meetingId).update({
        'participants': updatedParticipants,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      return {
        'type': 'success',
        'message': 'Friend removed from meeting successfully',
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to remove friend from meeting: $e',
      };
    }
  }
}
