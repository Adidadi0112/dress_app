import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/item/item_bloc.dart';
import '../blocs/item/item_state.dart';
import '../screens/add_item_screen.dart';
import '../screens/category_items_screen.dart';
import '../models/item.dart';
import '../theme/tokens.dart';

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
                return _buildCategoryCard(context, category, items);
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

  Widget _buildCategoryCard(
      BuildContext context, String category, List<Item> items) {
    // Use theme colors instead of hard-coded colors
    final colorScheme = Theme.of(context).colorScheme;

    // Create a list of color pairs using theme colors
    final List<Map<String, Color>> colorSchemes = [
      {
        'background': colorScheme.primaryContainer,
        'text': colorScheme.onPrimaryContainer,
      },
      {
        'background': colorScheme.secondaryContainer,
        'text': colorScheme.onSecondaryContainer,
      },
      {
        'background': colorScheme.tertiaryContainer,
        'text': colorScheme.onTertiaryContainer,
      },
      {
        'background': colorScheme.surfaceVariant,
        'text': colorScheme.onSurfaceVariant,
      },
    ];

    // Use a consistent color based on the category name
    final colorIndex = category.length % colorSchemes.length;
    final colors = colorSchemes[colorIndex];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CategoryItemsScreen(
                category: category,
                items: items,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                colors['background']!.withOpacity(0.3),
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Category image
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusTokens.radiusMd),
                    border: Border.all(
                      color: colors['background']!,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors['text']!.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(RadiusTokens.radiusSm),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: items.first.imageUrl != null
                          ? _buildImageWidget(items.first.imageUrl!, 80, 80)
                          : Container(
                              color: colors['background']!.withOpacity(0.3),
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: colors['text'],
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Category details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors['text'],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: SpacingTokens.space8,
                            vertical: SpacingTokens.space4),
                        decoration: BoxDecoration(
                          color: colors['background'],
                          borderRadius:
                              BorderRadius.circular(RadiusTokens.radiusMd),
                        ),
                        child: Text(
                          '${items.length} ${items.length == 1 ? 'item' : 'items'}',
                          style: TextStyle(
                            color: colors['text'],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors['background'],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: colors['text'],
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath, double width, double height) {
    // Check if the path is a local file path
    if (imagePath.startsWith('/')) {
      return Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading local image: $error');
          return const Icon(Icons.image_not_supported);
        },
      );
    } else {
      // Assume it's a network URL
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading network image: $error');
          return const Icon(Icons.image_not_supported);
        },
      );
    }
  }
}
