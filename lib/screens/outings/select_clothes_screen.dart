import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/blocs/item/item_bloc.dart';
import 'package:dress_app/blocs/item/item_state.dart';
import 'package:dress_app/models/clothing_item.dart';
import 'package:dress_app/models/item.dart';

class SelectClothesScreen extends StatefulWidget {
  final List<ClothingItem> initiallySelected;

  const SelectClothesScreen({
    super.key,
    this.initiallySelected = const [],
  });

  @override
  State<SelectClothesScreen> createState() => _SelectClothesScreenState();
}

class _SelectClothesScreenState extends State<SelectClothesScreen> {
  late List<ClothingItem> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.initiallySelected);
  }

  ClothingItem _convertItemToClothingItem(Item item) {
    return ClothingItem(
      id: item.id,
      name: item.name,
      description: item.description,
      imageUrl: item.imageUrl,
      categories: item.categories ?? [],
      occasions: item.occasions ?? [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wybierz ubrania'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedItems);
            },
            child: const Text('Zatwierdź'),
          ),
        ],
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ItemError) {
            return Center(child: Text('Błąd: ${state.message}'));
          }

          if (state is ItemLoaded) {
            final items = state.items;

            if (items.isEmpty) {
              return const Center(
                child: Text('Brak ubrań w garderobie'),
              );
            }

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final clothingItem = _convertItemToClothingItem(item);
                final isSelected = _selectedItems.any((i) => i.id == item.id);

                return ListTile(
                  leading: item.imageUrl != null
                      ? Image.network(
                          item.imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(item.name),
                  subtitle: Text((item.categories ?? []).join(', ')),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedItems.add(clothingItem);
                        } else {
                          _selectedItems.removeWhere((i) => i.id == item.id);
                        }
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedItems.removeWhere((i) => i.id == item.id);
                      } else {
                        _selectedItems.add(clothingItem);
                      }
                    });
                  },
                );
              },
            );
          }

          return const Center(child: Text('Nieznany stan'));
        },
      ),
    );
  }
}
