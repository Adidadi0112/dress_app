import 'package:flutter_bloc/flutter_bloc.dart';
import 'item_event.dart';
import 'item_state.dart';
import '../../service/api.dart';
import '../../models/item.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(ItemInitial()) {
    on<FetchItems>(_onFetchItems);
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
  }

  Future<void> _onFetchItems(FetchItems event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    final response = await Api().getItems();
    if (response['type'] == 'success') {
      final List<Item> items =
          (response['data'] as List)
              .map((json) => Item.fromJson(json))
              .toList();
      emit(ItemLoaded(items));
    } else {
      emit(ItemError(response['data']['message']));
    }
  }

  void _onAddItem(AddItem event, Emitter<ItemState> emit) {
    final currentState = state;
    if (currentState is ItemLoaded) {
      final updatedItems = List<Item>.from(currentState.items)..add(event.item);
      emit(ItemLoaded(updatedItems));
      print('✅ [Bloc] Added item: ${event.item}');
      print('📦 [Bloc] Updated list (${updatedItems.length} items):');
      for (var i in updatedItems) {
        print('  • $i');
      }
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
