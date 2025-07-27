import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  static final FirebaseStorageService _instance =
      FirebaseStorageService._internal();
  factory FirebaseStorageService() => _instance;
  FirebaseStorageService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  /// Upload an image file to Firebase Storage
  /// Returns the download URL on success, null on failure
  Future<String?> uploadItemImage(File imageFile, String itemId) async {
    try {
      if (_currentUserId == null) {
        debugPrint('Firebase Storage: User not authenticated');
        return null;
      }

      // Create a unique path for the image
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_$itemId.jpg';
      final String path = 'users/$_currentUserId/items/$fileName';

      // Create a reference to the file location
      final Reference ref = _storage.ref().child(path);

      // Upload the file
      debugPrint('Firebase Storage: Uploading image to $path');
      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedBy': _currentUserId!,
            'itemId': itemId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      debugPrint('Firebase Storage: Upload successful, URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('Firebase Storage: Upload failed: $e');
      return null;
    }
  }

  /// Delete an image from Firebase Storage
  Future<bool> deleteItemImage(String imageUrl) async {
    try {
      if (_currentUserId == null) {
        debugPrint('Firebase Storage: User not authenticated');
        return false;
      }

      // Extract the path from the URL
      final Reference ref = _storage.refFromURL(imageUrl);

      debugPrint('Firebase Storage: Deleting image at ${ref.fullPath}');
      await ref.delete();

      debugPrint('Firebase Storage: Image deleted successfully');
      return true;
    } catch (e) {
      debugPrint('Firebase Storage: Delete failed: $e');
      return false;
    }
  }

  /// Get metadata for an image
  Future<FullMetadata?> getImageMetadata(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      return await ref.getMetadata();
    } catch (e) {
      debugPrint('Firebase Storage: Failed to get metadata: $e');
      return null;
    }
  }

  /// List all images for the current user
  Future<List<Reference>> getUserImages() async {
    try {
      if (_currentUserId == null) {
        debugPrint('Firebase Storage: User not authenticated');
        return [];
      }

      final Reference userRef =
          _storage.ref().child('users/$_currentUserId/items');
      final ListResult result = await userRef.listAll();

      return result.items;
    } catch (e) {
      debugPrint('Firebase Storage: Failed to list images: $e');
      return [];
    }
  }
}
