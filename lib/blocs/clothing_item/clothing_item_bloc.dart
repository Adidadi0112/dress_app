import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/blocs/clothing_item/clothing_item_event.dart';
import 'package:dress_app/blocs/clothing_item/clothing_item_state.dart';
import 'package:dress_app/models/clothing_item.dart';
import 'package:dress_app/services/firestore_clothing_service.dart';
import 'package:dress_app/services/firebase_storage_service.dart';
import 'package:flutter/foundation.dart';

class ClothingItemBloc extends Bloc<ClothingItemEvent, ClothingItemState> {
  final FirestoreClothingService _firestoreService = FirestoreClothingService();
  final FirebaseStorageService _storageService = FirebaseStorageService();

  ClothingItemBloc() : super(ClothingItemInitial()) {
    on<LoadClothingItems>(_onLoadClothingItems);
    on<AddClothingItem>(_onAddClothingItem);
    on<UpdateClothingItem>(_onUpdateClothingItem);
    on<DeleteClothingItem>(_onDeleteClothingItem);
    on<LoadClothingItemsByCategory>(_onLoadClothingItemsByCategory);
    on<LoadClothingItemsByOccasion>(_onLoadClothingItemsByOccasion);
  }

  Future<void> _onLoadClothingItems(
    LoadClothingItems event,
    Emitter<ClothingItemState> emit,
  ) async {
    emit(ClothingItemLoading());

    try {
      final result = await _firestoreService.getClothingItems();

      if (result['type'] == 'success') {
        final items = result['data'] as List<ClothingItem>;
        emit(ClothingItemLoaded(items));
        debugPrint('ClothingItemBloc: Loaded ${items.length} items');
      } else {
        emit(ClothingItemError(result['message']));
        debugPrint(
            'ClothingItemBloc: Error loading items: ${result['message']}');
      }
    } catch (e) {
      emit(ClothingItemError('Failed to load clothing items: $e'));
      debugPrint('ClothingItemBloc: Exception loading items: $e');
    }
  }

  Future<void> _onAddClothingItem(
    AddClothingItem event,
    Emitter<ClothingItemState> emit,
  ) async {
    try {
      emit(ClothingItemLoading());

      ClothingItem itemToAdd = event.item;

      // If there's a local image, upload it to Firebase Storage first
      if (event.item.imageUrl != null && event.item.imageUrl!.startsWith('/')) {
        debugPrint('ClothingItemBloc: Uploading image to Firebase Storage');

        final imageFile = File(event.item.imageUrl!);
        final uploadedImageUrl = await _storageService.uploadItemImage(
          imageFile,
          event.item.id,
        );

        if (uploadedImageUrl != null) {
          itemToAdd = event.item.copyWith(imageUrl: uploadedImageUrl);
          debugPrint(
              'ClothingItemBloc: Image uploaded successfully: $uploadedImageUrl');
        } else {
          emit(ClothingItemError('Failed to upload image'));
          return;
        }
      }

      // Add the item to Firestore
      final result = await _firestoreService.createClothingItem(itemToAdd);

      if (result['type'] == 'success') {
        // Get the updated list of items
        final updatedResult = await _firestoreService.getClothingItems();

        if (updatedResult['type'] == 'success') {
          final items = updatedResult['data'] as List<ClothingItem>;
          emit(ClothingItemActionSuccess('Item added successfully!', items));
          debugPrint('ClothingItemBloc: Item added successfully');
        } else {
          emit(ClothingItemError('Item added but failed to refresh list'));
        }
      } else {
        emit(ClothingItemError(result['message']));
        debugPrint('ClothingItemBloc: Error adding item: ${result['message']}');
      }
    } catch (e) {
      emit(ClothingItemError('Failed to add clothing item: $e'));
      debugPrint('ClothingItemBloc: Exception adding item: $e');
    }
  }

  Future<void> _onUpdateClothingItem(
    UpdateClothingItem event,
    Emitter<ClothingItemState> emit,
  ) async {
    try {
      emit(ClothingItemLoading());

      ClothingItem itemToUpdate = event.item;

      // If there's a new local image, upload it to Firebase Storage
      if (event.item.imageUrl != null && event.item.imageUrl!.startsWith('/')) {
        debugPrint('ClothingItemBloc: Uploading new image to Firebase Storage');

        final imageFile = File(event.item.imageUrl!);
        final uploadedImageUrl = await _storageService.uploadItemImage(
          imageFile,
          event.itemId,
        );

        if (uploadedImageUrl != null) {
          itemToUpdate = event.item.copyWith(imageUrl: uploadedImageUrl);
          debugPrint(
              'ClothingItemBloc: New image uploaded successfully: $uploadedImageUrl');
        } else {
          emit(ClothingItemError('Failed to upload new image'));
          return;
        }
      }

      // Update the item in Firestore
      final result = await _firestoreService.updateClothingItem(
          event.itemId, itemToUpdate);

      if (result['type'] == 'success') {
        // Get the updated list of items
        final updatedResult = await _firestoreService.getClothingItems();

        if (updatedResult['type'] == 'success') {
          final items = updatedResult['data'] as List<ClothingItem>;
          emit(ClothingItemActionSuccess('Item updated successfully!', items));
          debugPrint('ClothingItemBloc: Item updated successfully');
        } else {
          emit(ClothingItemError('Item updated but failed to refresh list'));
        }
      } else {
        emit(ClothingItemError(result['message']));
        debugPrint(
            'ClothingItemBloc: Error updating item: ${result['message']}');
      }
    } catch (e) {
      emit(ClothingItemError('Failed to update clothing item: $e'));
      debugPrint('ClothingItemBloc: Exception updating item: $e');
    }
  }

  Future<void> _onDeleteClothingItem(
    DeleteClothingItem event,
    Emitter<ClothingItemState> emit,
  ) async {
    try {
      emit(ClothingItemLoading());

      // First, get the item to retrieve its image URL
      final getResult = await _firestoreService.getClothingItem(event.itemId);

      if (getResult['type'] == 'success') {
        final item = getResult['data'] as ClothingItem;

        // Delete the image from Firebase Storage if it exists
        if (item.imageUrl != null &&
            item.imageUrl!
                .startsWith('https://firebasestorage.googleapis.com')) {
          debugPrint('ClothingItemBloc: Deleting image from Firebase Storage');
          await _storageService.deleteItemImage(item.imageUrl!);
        }
      }

      // Delete the item from Firestore
      final result = await _firestoreService.deleteClothingItem(event.itemId);

      if (result['type'] == 'success') {
        // Get the updated list of items
        final updatedResult = await _firestoreService.getClothingItems();

        if (updatedResult['type'] == 'success') {
          final items = updatedResult['data'] as List<ClothingItem>;
          emit(ClothingItemActionSuccess('Item deleted successfully!', items));
          debugPrint('ClothingItemBloc: Item deleted successfully');
        } else {
          emit(ClothingItemError('Item deleted but failed to refresh list'));
        }
      } else {
        emit(ClothingItemError(result['message']));
        debugPrint(
            'ClothingItemBloc: Error deleting item: ${result['message']}');
      }
    } catch (e) {
      emit(ClothingItemError('Failed to delete clothing item: $e'));
      debugPrint('ClothingItemBloc: Exception deleting item: $e');
    }
  }

  Future<void> _onLoadClothingItemsByCategory(
    LoadClothingItemsByCategory event,
    Emitter<ClothingItemState> emit,
  ) async {
    emit(ClothingItemLoading());

    try {
      final items =
          await _firestoreService.getClothingItemsByCategory(event.category);
      emit(ClothingItemLoaded(items));
      debugPrint(
          'ClothingItemBloc: Loaded ${items.length} items for category: ${event.category}');
    } catch (e) {
      emit(ClothingItemError('Failed to load items by category: $e'));
      debugPrint('ClothingItemBloc: Exception loading items by category: $e');
    }
  }

  Future<void> _onLoadClothingItemsByOccasion(
    LoadClothingItemsByOccasion event,
    Emitter<ClothingItemState> emit,
  ) async {
    emit(ClothingItemLoading());

    try {
      final items =
          await _firestoreService.getClothingItemsByOccasion(event.occasion);
      emit(ClothingItemLoaded(items));
      debugPrint(
          'ClothingItemBloc: Loaded ${items.length} items for occasion: ${event.occasion}');
    } catch (e) {
      emit(ClothingItemError('Failed to load items by occasion: $e'));
      debugPrint('ClothingItemBloc: Exception loading items by occasion: $e');
    }
  }
}
