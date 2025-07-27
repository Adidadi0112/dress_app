import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dress_app/models/friend.dart';
import 'package:dress_app/models/friend_request.dart';

class FirebaseFriendsService {
  static final FirebaseFriendsService _instance =
      FirebaseFriendsService._internal();
  factory FirebaseFriendsService() => _instance;
  FirebaseFriendsService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _friendRequestsCollection =>
      _firestore.collection('friendRequests');

  // Get friends collection for current user
  CollectionReference? get _friendsCollection {
    if (_currentUserId == null) return null;
    return _usersCollection.doc(_currentUserId).collection('friends');
  }

  // Search for users by email
  Future<Map<String, dynamic>> searchUserByEmail(String email) async {
    try {
      final querySnapshot = await _usersCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return {
          'type': 'error',
          'message': 'No user found with this email address',
        };
      }

      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data() as Map<String, dynamic>;

      // Don't allow adding yourself as a friend
      if (userDoc.id == _currentUserId) {
        return {
          'type': 'error',
          'message': 'You cannot add yourself as a friend',
        };
      }

      // Check if they're already friends
      final isAlreadyFriend = await _checkIfAlreadyFriends(userDoc.id);
      if (isAlreadyFriend) {
        return {
          'type': 'error',
          'message': 'User is already your friend',
        };
      }

      // Check if there's already a pending request
      final hasPendingRequest = await _checkPendingRequest(userDoc.id);
      if (hasPendingRequest) {
        return {
          'type': 'error',
          'message': 'Friend request already sent',
        };
      }

      return {
        'type': 'success',
        'data': {
          'id': userDoc.id,
          'name': userData['name'] ?? '',
          'email': userData['email'] ?? '',
          'profileImageUrl': userData['profileImageUrl'],
        },
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Error searching for user: $e',
      };
    }
  }

  // Send friend request
  Future<Map<String, dynamic>> sendFriendRequest(String targetUserId) async {
    try {
      if (_currentUserId == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      // Get current user data
      final currentUserDoc = await _usersCollection.doc(_currentUserId).get();
      final currentUserData = currentUserDoc.data() as Map<String, dynamic>;

      // Create friend request
      final friendRequest = FriendRequest(
        id: '', // Will be set by Firestore
        fromUserId: _currentUserId!,
        toUserId: targetUserId,
        fromUserName: currentUserData['name'] ?? '',
        fromUserEmail: currentUserData['email'] ?? '',
        fromUserProfileImageUrl: currentUserData['profileImageUrl'],
        status: FriendRequestStatus.pending,
        createdAt: DateTime.now(),
      );

      await _friendRequestsCollection.add(friendRequest.toFirestore());

      return {
        'type': 'success',
        'message': 'Friend request sent successfully',
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to send friend request: $e',
      };
    }
  }

  // Get pending friend requests (received)
  Stream<List<FriendRequest>> getPendingFriendRequests() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _friendRequestsCollection
        .where('toUserId', isEqualTo: _currentUserId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      List<FriendRequest> requests = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FriendRequest.fromFirestore(data, doc.id);
      }).toList();

      // Sort in memory instead of using orderBy to avoid index requirement
      requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return requests;
    });
  }

  // Get sent friend requests
  Stream<List<FriendRequest>> getSentFriendRequests() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _friendRequestsCollection
        .where('fromUserId', isEqualTo: _currentUserId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      List<FriendRequest> requests = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FriendRequest.fromFirestore(data, doc.id);
      }).toList();

      // Sort in memory instead of using orderBy to avoid index requirement
      requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return requests;
    });
  }

  // Accept friend request
  Future<Map<String, dynamic>> acceptFriendRequest(
      String requestId, String fromUserId) async {
    try {
      if (_currentUserId == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      final batch = _firestore.batch();

      // Update friend request status
      final requestRef = _friendRequestsCollection.doc(requestId);
      batch.update(requestRef, {
        'status': 'accepted',
        'respondedAt': FieldValue.serverTimestamp(),
      });

      // Get both users' data
      final currentUserDoc = await _usersCollection.doc(_currentUserId).get();
      final fromUserDoc = await _usersCollection.doc(fromUserId).get();

      final currentUserData = currentUserDoc.data() as Map<String, dynamic>;
      final fromUserData = fromUserDoc.data() as Map<String, dynamic>;

      // Create friend objects
      final currentUserAsFriend = Friend(
        id: _currentUserId!,
        name: currentUserData['name'] ?? '',
        email: currentUserData['email'] ?? '',
        avatarUrl: currentUserData['profileImageUrl'],
        isConfirmed: true,
      );

      final fromUserAsFriend = Friend(
        id: fromUserId,
        name: fromUserData['name'] ?? '',
        email: fromUserData['email'] ?? '',
        avatarUrl: fromUserData['profileImageUrl'],
        isConfirmed: true,
      );

      // Add to both users' friends collections
      final currentUserFriendsRef = _usersCollection
          .doc(_currentUserId)
          .collection('friends')
          .doc(fromUserId);
      final fromUserFriendsRef = _usersCollection
          .doc(fromUserId)
          .collection('friends')
          .doc(_currentUserId);

      batch.set(currentUserFriendsRef, fromUserAsFriend.toFirestore());
      batch.set(fromUserFriendsRef, currentUserAsFriend.toFirestore());

      await batch.commit();

      return {
        'type': 'success',
        'message': 'Friend request accepted',
        'data': fromUserAsFriend,
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to accept friend request: $e',
      };
    }
  }

  // Reject friend request
  Future<Map<String, dynamic>> rejectFriendRequest(String requestId) async {
    try {
      await _friendRequestsCollection.doc(requestId).update({
        'status': 'rejected',
        'respondedAt': FieldValue.serverTimestamp(),
      });

      return {
        'type': 'success',
        'message': 'Friend request rejected',
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to reject friend request: $e',
      };
    }
  }

  // Get friends list
  Stream<List<Friend>> getFriends() {
    if (_friendsCollection == null) {
      return Stream.value([]);
    }

    return _friendsCollection!.orderBy('name').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Friend.fromFirestore(data, doc.id);
      }).toList();
    });
  }

  // Remove friend
  Future<Map<String, dynamic>> removeFriend(String friendId) async {
    try {
      if (_currentUserId == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      final batch = _firestore.batch();

      // Remove from current user's friends
      final currentUserFriendRef = _usersCollection
          .doc(_currentUserId)
          .collection('friends')
          .doc(friendId);
      batch.delete(currentUserFriendRef);

      // Remove from friend's friends
      final friendUserFriendRef = _usersCollection
          .doc(friendId)
          .collection('friends')
          .doc(_currentUserId);
      batch.delete(friendUserFriendRef);

      await batch.commit();

      return {
        'type': 'success',
        'message': 'Friend removed successfully',
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to remove friend: $e',
      };
    }
  }

  // Helper methods
  Future<bool> _checkIfAlreadyFriends(String userId) async {
    if (_friendsCollection == null) return false;

    final doc = await _friendsCollection!.doc(userId).get();
    return doc.exists;
  }

  Future<bool> _checkPendingRequest(String userId) async {
    if (_currentUserId == null) return false;

    // Check if current user already sent a request to this user
    final sentRequest = await _friendRequestsCollection
        .where('fromUserId', isEqualTo: _currentUserId)
        .where('toUserId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .get();

    // Check if this user already sent a request to current user
    final receivedRequest = await _friendRequestsCollection
        .where('fromUserId', isEqualTo: userId)
        .where('toUserId', isEqualTo: _currentUserId)
        .where('status', isEqualTo: 'pending')
        .get();

    return sentRequest.docs.isNotEmpty || receivedRequest.docs.isNotEmpty;
  }

  // Get all users (for search functionality)
  Future<List<Friend>> getAllUsers() async {
    try {
      if (_currentUserId == null) return [];

      final querySnapshot = await _usersCollection.get();

      return querySnapshot.docs
          .where((doc) => doc.id != _currentUserId) // Exclude current user
          .map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Friend(
          id: doc.id,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          avatarUrl: data['profileImageUrl'],
          isConfirmed: true,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
