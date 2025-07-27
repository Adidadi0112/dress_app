import 'dart:io';
import 'package:dress_app/models/clothing_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/item/item_bloc.dart';
import '../../blocs/item/item_state.dart';
import '../../models/item.dart';
import '../../models/meeting.dart';
import '../../widgets/enhanced_card.dart';
import '../../widgets/gradient_button.dart';
import '../../theme/responsive.dart';

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
        title: Text(
          'Select Clothes',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedItems);
            },
            child: const Text('Done'),
          ),
        ],
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ItemError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is ItemLoaded) {
            return Column(
              children: [
                // Selected items summary
                if (_selectedItems.isNotEmpty)
                  Container(
                    padding: ResponsiveHelper.getResponsivePadding(context),
                    child: EnhancedCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Items (${_selectedItems.length})',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _selectedItems.map((item) {
                              return Chip(
                                label: Text(item.name),
                                onDeleted: () {
                                  setState(() {
                                    _selectedItems.remove(item);
                                  });
                                },
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                deleteIconColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Available items grid
                Expanded(
                  child: GridView.builder(
                    padding: ResponsiveHelper.getResponsivePadding(context),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          ResponsiveHelper.getResponsiveGridCrossAxisCount(
                              context),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      final clothingItem = _convertItemToClothingItem(item);
                      final isSelected = _selectedItems
                          .any((selected) => selected.id == item.id);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedItems.removeWhere(
                                  (selected) => selected.id == item.id);
                            } else {
                              _selectedItems.add(clothingItem);
                            }
                          });
                        },
                        child: EnhancedCard(
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: _buildImageWidget(item.imageUrl),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          if (item.description != null)
                                            Text(
                                              item.description!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No items available'));
        },
      ),
    );
  }

  Widget _buildImageWidget(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Icon(
          Icons.image_not_supported,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    // Check if the path is a local file path
    if (imagePath.startsWith('/')) {
      return Image.file(
        File(imagePath),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Icon(
              Icons.image_not_supported,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        },
      );
    } else {
      // Assume it's a network URL
      return Image.network(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Icon(
              Icons.image_not_supported,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        },
      );
    }
  }
}
