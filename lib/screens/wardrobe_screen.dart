import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/item/item_bloc.dart';
import '../blocs/item/item_state.dart';
import '../screens/add_item_screen.dart';
import '../models/item.dart';

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wardrobe"), centerTitle: true),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoaded) {
            final grouped = _groupItemsByCategory(state.items);
            if (grouped.isEmpty) {
              return const Center(child: Text("No items yet."));
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: grouped.entries.map((entry) {
                final category = entry.key;
                final items = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: items.first.imageUrl != null
                        ? Image.network(
                            items.first.imageUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported);
                            },
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(category),
                    subtitle: Text('${items.length} items'),
                  ),
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text("Add your first item!"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7D6CDA),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddItemScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Map<String, List<Item>> _groupItemsByCategory(List<Item> items) {
    final Map<String, List<Item>> grouped = {};
    for (final item in items) {
      final category = item.categories?.firstOrNull ?? 'Uncategorized';
      grouped.putIfAbsent(category, () => []).add(item);
    }
    return grouped;
  }
}
