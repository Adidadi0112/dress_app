import 'package:equatable/equatable.dart';
import '../../models/item.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object?> get props => [];
}

class FetchItems extends ItemEvent {}

class AddItem extends ItemEvent {
  final Item item;

  const AddItem(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveItem extends ItemEvent {
  final Item item;

  const RemoveItem(this.item);

  @override
  List<Object?> get props => [item];
}
