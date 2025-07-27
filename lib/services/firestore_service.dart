import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dress_app/models/item.dart';
import 'package:dress_app/models/user_model.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // User collection reference
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Items collection reference for current user
  CollectionReference? get _itemsCollection {
    if (_currentUserId == null) return null;
    return _usersCollection.doc(_currentUserId).collection('items');
  }

  // CRUD operations for Items

  // Create a new item
  Future<Map<String, dynamic>> createItem(Item item) async {
    try {
      if (_itemsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      // Add the item to Firestore
      DocumentReference docRef = await _itemsCollection!.add(item.toJson());

      return {
        'type': 'success',
        'message': 'Item created successfully',
        'data': {'id': docRef.id},
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to create item: $e',
      };
    }
  }

  // Get all items for current user
  Future<Map<String, dynamic>> getItems() async {
    try {
      if (_itemsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      QuerySnapshot querySnapshot = await _itemsCollection!.get();

      List<Item> items = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add the document ID
        return Item.fromJson(data);
      }).toList();

      return {
        'type': 'success',
        'data': items,
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to fetch items: $e',
      };
    }
  }

  // Get items stream for real-time updates
  Stream<List<Item>>? getItemsStream() {
    if (_itemsCollection == null) return null;

    return _itemsCollection!.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Item.fromJson(data);
      }).toList();
    });
  }

  // Update an item
  Future<Map<String, dynamic>> updateItem(String itemId, Item item) async {
    try {
      if (_itemsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      await _itemsCollection!.doc(itemId).update(item.toJson());

      return {
        'type': 'success',
        'message': 'Item updated successfully',
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to update item: $e',
      };
    }
  }

  // Delete an item
  Future<Map<String, dynamic>> deleteItem(String itemId) async {
    try {
      if (_itemsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      await _itemsCollection!.doc(itemId).delete();

      return {
        'type': 'success',
        'message': 'Item deleted successfully',
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to delete item: $e',
      };
    }
  }

  // Get a single item by ID
  Future<Map<String, dynamic>> getItem(String itemId) async {
    try {
      if (_itemsCollection == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      DocumentSnapshot doc = await _itemsCollection!.doc(itemId).get();

      if (!doc.exists) {
        return {
          'type': 'error',
          'message': 'Item not found',
        };
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      Item item = Item.fromJson(data);

      return {
        'type': 'success',
        'data': item,
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to fetch item: $e',
      };
    }
  }

  // User profile operations

  // Create or update user profile
  Future<Map<String, dynamic>> saveUserProfile(UserModel user) async {
    try {
      if (_currentUserId == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      await _usersCollection.doc(_currentUserId).set(user.toFirestore());

      return {
        'type': 'success',
        'message': 'User profile saved successfully',
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to save user profile: $e',
      };
    }
  }

  // Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      if (_currentUserId == null) {
        return {
          'type': 'error',
          'message': 'User not authenticated',
        };
      }

      DocumentSnapshot doc = await _usersCollection.doc(_currentUserId).get();

      if (!doc.exists) {
        return {
          'type': 'error',
          'message': 'User profile not found',
        };
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      UserModel user = UserModel.fromFirestore(data, doc.id);

      return {
        'type': 'success',
        'data': user,
      };
    } catch (e) {
      return {
        'type': 'error',
        'message': 'Failed to fetch user profile: $e',
      };
    }
  }

  // Get user profile stream for real-time updates
  Stream<UserModel?>? getUserProfileStream() {
    if (_currentUserId == null) return null;

    return _usersCollection.doc(_currentUserId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return UserModel.fromFirestore(data, snapshot.id);
    });
  }
}
