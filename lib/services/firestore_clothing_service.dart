import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dress_app/models/clothing_item.dart';

class FirestoreClothingService {
  static final FirestoreClothingService _instance =
      FirestoreClothingService._internal();
  factory FirestoreClothingService() => _instance;
  FirestoreClothingService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // Clothing items collection reference for current user
  CollectionReference? get _clothingItemsCollection {
    if (_currentUserId == null) return null;
    return _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('clothingItems');
  }

  /// Create a new clothing item
  Future<Map<String, dynamic>> createClothingItem(ClothingItem item) async {
    try {
      if (_clothingItemsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      final now = DateTime.now();
      final itemData = item
          .copyWith(
            createdAt: now,
            updatedAt: now,
          )
          .toMap();

      // Add the item to Firestore
      DocumentReference docRef = await _clothingItemsCollection!.add(itemData);

      return {
        'type': 'success',
        'message': 'Clothing item created successfully',
        'data': {'id': docRef.id},
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to create clothing item: $e',
      };
    }
  }

  /// Get all clothing items for current user
  Future<Map<String, dynamic>> getClothingItems() async {
    try {
      if (_clothingItemsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      QuerySnapshot querySnapshot = await _clothingItemsCollection!
          .orderBy('createdAt', descending: true)
          .get();

      List<ClothingItem> items = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ClothingItem.fromMap(data, doc.id);
      }).toList();

      return {
        'type': 'success',
        'data': items,
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to fetch clothing items: $e',
      };
    }
  }

  /// Get clothing items stream for real-time updates
  Stream<List<ClothingItem>>? getClothingItemsStream() {
    if (_clothingItemsCollection == null) return null;

    return _clothingItemsCollection!
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ClothingItem.fromMap(data, doc.id);
      }).toList();
    });
  }

  /// Update a clothing item
  Future<Map<String, dynamic>> updateClothingItem(
      String itemId, ClothingItem item) async {
    try {
      if (_clothingItemsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      final itemData = item
          .copyWith(
            updatedAt: DateTime.now(),
          )
          .toMap();

      await _clothingItemsCollection!.doc(itemId).update(itemData);

      return {
        'type': 'success',
        'message': 'Clothing item updated successfully',
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to update clothing item: $e',
      };
    }
  }

  /// Delete a clothing item
  Future<Map<String, dynamic>> deleteClothingItem(String itemId) async {
    try {
      if (_clothingItemsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      await _clothingItemsCollection!.doc(itemId).delete();

      return {
        'type': 'success',
        'message': 'Clothing item deleted successfully',
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to delete clothing item: $e',
      };
    }
  }

  /// Get a single clothing item by ID
  Future<Map<String, dynamic>> getClothingItem(String itemId) async {
    try {
      if (_clothingItemsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      DocumentSnapshot doc = await _clothingItemsCollection!.doc(itemId).get();

      if (!doc.exists) {
        return {
          'type': 'error',
          'message': 'Clothing item not found',
        };
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      ClothingItem item = ClothingItem.fromMap(data, doc.id);

      return {
        'type': 'success',
        'data': item,
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to get clothing item: $e',
      };
    }
  }

  /// Get clothing items by category
  Future<List<ClothingItem>> getClothingItemsByCategory(String category) async {
    try {
      if (_clothingItemsCollection == null) return [];

      QuerySnapshot querySnapshot = await _clothingItemsCollection!
          .where('categories', arrayContains: category)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ClothingItem.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get clothing items by occasion
  Future<List<ClothingItem>> getClothingItemsByOccasion(String occasion) async {
    try {
      if (_clothingItemsCollection == null) return [];

      QuerySnapshot querySnapshot = await _clothingItemsCollection!
          .where('occasions', arrayContains: occasion)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ClothingItem.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
