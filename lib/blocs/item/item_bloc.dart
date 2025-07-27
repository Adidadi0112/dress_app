import 'package:flutter_bloc/flutter_bloc.dart';
import 'item_event.dart';
import 'item_state.dart';
import '../../services/firestore_service.dart';
import '../../models/item.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(ItemInitial()) {
    on<FetchItems>(_onFetchItems);
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
  }

  Future<void> _onFetchItems(FetchItems event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    try {
      final response = await FirestoreService().getItems();
      if (response['type'] == 'success') {
        final List<Item> items = response['data'] as List<Item>;
        emit(ItemLoaded(items));
      } else {
        emit(ItemError(response['message'] ?? 'Failed to load items'));
      }
    } catch (e) {
      emit(ItemError('Failed to load items: $e'));
    }
  }

  void _onAddItem(AddItem event, Emitter<ItemState> emit) {
    final currentState = state;
    if (currentState is ItemLoaded) {
      final updatedItems = List<Item>.from(currentState.items)..add(event.item);
      emit(ItemLoaded(updatedItems));
    } else {
      emit(ItemLoaded([event.item]));
    }
  }

  void _onRemoveItem(RemoveItem event, Emitter<ItemState> emit) {
    final currentState = state;
    if (currentState is ItemLoaded) {
      final updatedItems =
          currentState.items.where((item) => item.id != event.item.id).toList();
      emit(ItemLoaded(updatedItems));
    }
  }
}
