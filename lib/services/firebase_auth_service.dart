import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dress_app/models/user_model.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(name);

      // Create user document in Firestore
      await _createUserDocument(userCredential.user!, name);

      return {
        'type': 'success',
        'data': {
          'user': userCredential.user,
          'message': 'Account created successfully',
        }
      };
    } on FirebaseAuthException catch (e) {
      return {
        'type': 'error',
        'data': {
          'message': _getAuthErrorMessage(e.code),
        }
      };
    } catch (e) {
      return {
        'type': 'error',
        'data': {
          'message': 'An unexpected error occurred. Please try again.',
        }
      };
    }
  }

  // Sign in with email and password
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return {
        'type': 'success',
        'data': {
          'user': userCredential.user,
          'message': 'Signed in successfully',
        }
      };
    } on FirebaseAuthException catch (e) {
      return {
        'type': 'error',
        'data': {
          'message': _getAuthErrorMessage(e.code),
        }
      };
    } catch (e) {
      return {
        'type': 'error',
        'data': {
          'message': 'An unexpected error occurred. Please try again.',
        }
      };
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'type': 'success',
        'data': {
          'message': 'Password reset email sent. Check your inbox.',
        }
      };
    } on FirebaseAuthException catch (e) {
      return {
        'type': 'error',
        'data': {
          'message': _getAuthErrorMessage(e.code),
        }
      };
    } catch (e) {
      return {
        'type': 'error',
        'data': {
          'message': 'An unexpected error occurred. Please try again.',
        }
      };
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(User user, String name) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    final userData = UserModel(
      id: user.uid,
      name: name,
      email: user.email!,
      createdAt: DateTime.now(),
      profileImageUrl: null,
    );

    await userDoc.set(userData.toFirestore());
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateUserProfile({
    required String name,
    String? profileImageUrl,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        return {
          'type': 'error',
          'data': {'message': 'No user logged in'}
        };
      }

      // Update Firebase Auth profile
      await user.updateDisplayName(name);

      // Update Firestore document
      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return {
        'type': 'success',
        'data': {'message': 'Profile updated successfully'}
      };
    } catch (e) {
      return {
        'type': 'error',
        'data': {'message': 'Failed to update profile: $e'}
      };
    }
  }

  // Helper method to get user-friendly error messages
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
