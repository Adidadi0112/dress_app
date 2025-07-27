import 'package:equatable/equatable.dart';
import 'package:dress_app/models/item.dart';

abstract class ClothingItemEvent extends Equatable {
  const ClothingItemEvent();

  @override
  List<Object?> get props => [];
}

class LoadClothingItems extends ClothingItemEvent {}

class AddClothingItem extends ClothingItemEvent {
  final Item item;

  const AddClothingItem(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateClothingItem extends ClothingItemEvent {
  final String itemId;
  final Item item;

  const UpdateClothingItem(this.itemId, this.item);

  @override
  List<Object?> get props => [itemId, item];
}

class DeleteClothingItem extends ClothingItemEvent {
  final String itemId;

  const DeleteClothingItem(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class LoadClothingItemsByCategory extends ClothingItemEvent {
  final String category;

  const LoadClothingItemsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class LoadClothingItemsByOccasion extends ClothingItemEvent {
  final String occasion;

  const LoadClothingItemsByOccasion(this.occasion);

  @override
  List<Object?> get props => [occasion];
}
