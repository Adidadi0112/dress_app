import 'package:equatable/equatable.dart';
import 'package:dress_app/models/clothing_item.dart';

abstract class ClothingItemState extends Equatable {
  const ClothingItemState();

  @override
  List<Object?> get props => [];
}

class ClothingItemInitial extends ClothingItemState {}

class ClothingItemLoading extends ClothingItemState {}

class ClothingItemLoaded extends ClothingItemState {
  final List<ClothingItem> items;

  const ClothingItemLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class ClothingItemError extends ClothingItemState {
  final String message;

  const ClothingItemError(this.message);

  @override
  List<Object?> get props => [message];
}

class ClothingItemActionSuccess extends ClothingItemState {
  final String message;
  final List<ClothingItem> items;

  const ClothingItemActionSuccess(this.message, this.items);

  @override
  List<Object?> get props => [message, items];
}
