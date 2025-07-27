import 'dart:io';
import 'package:flutter/material.dart';
import '../models/item.dart';
import '../theme/tokens.dart';
import '../theme/responsive.dart';

class CategoryItemsScreen extends StatelessWidget {
  final String category;
  final List<Item> items;

  const CategoryItemsScreen({
    super.key,
    required this.category,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: ResponsiveHelper.getResponsivePadding(context),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          // Alternate card colors for visual interest
          final cardColorIndex = index % 4;
          return Padding(
            padding: const EdgeInsets.only(bottom: SpacingTokens.space16),
            child: _buildItemCard(context, item, cardColorIndex),
          );
        },
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, Item item, int colorIndex) {
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

    final colors = colorSchemes[colorIndex];

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
        onTap: () {
          _showItemDetails(context, item);
        },
        child: Container(
          height: 200, // Fixed height for all cards
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              ClipRRect(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(RadiusTokens.radiusLg)),
                child: Container(
                  width: 150,
                  height: double.infinity,
                  color: colors['background']!.withOpacity(0.3),
                  child: item.imageUrl != null
                      ? _buildImageWidget(item.imageUrl!)
                      : Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: colors['text'],
                          ),
                        ),
                ),
              ),

              // Item details section
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(SpacingTokens.space16),
                  decoration: BoxDecoration(
                    color: colors['background']!.withOpacity(0.2),
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(RadiusTokens.radiusLg)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: colors['text'],
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      if (item.description != null &&
                          item.description!.isNotEmpty)
                        Expanded(
                          child: Text(
                            item.description!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: colors['text']!.withOpacity(0.8),
                                ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      // Category tag
                      if (item.categories != null &&
                          item.categories!.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors['background'],
                            borderRadius:
                                BorderRadius.circular(RadiusTokens.radiusMd),
                          ),
                          child: Text(
                            item.categories!.first,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: colors['text'],
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showItemDetails(BuildContext context, Item item) {
    // Get a color scheme based on the item's name (for consistency)
    final colorIndex = item.name.length % 4;
    final colorScheme = Theme.of(context).colorScheme;

    // Create a list of color pairs using theme colors
    final List<Map<String, Color>> colorSchemes = [
      {
        'background': colorScheme.primaryContainer,
        'text': colorScheme.onPrimaryContainer,
        'accent': colorScheme.primary,
      },
      {
        'background': colorScheme.secondaryContainer,
        'text': colorScheme.onSecondaryContainer,
        'accent': colorScheme.secondary,
      },
      {
        'background': colorScheme.tertiaryContainer,
        'text': colorScheme.onTertiaryContainer,
        'accent': colorScheme.tertiary,
      },
      {
        'background': colorScheme.surfaceVariant,
        'text': colorScheme.onSurfaceVariant,
        'accent': colorScheme.primary,
      },
    ];

    final colors = colorSchemes[colorIndex];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(RadiusTokens.radiusXl)),
          ),
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: colors['background'],
                  borderRadius: BorderRadius.circular(RadiusTokens.radiusSm),
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(SpacingTokens.space20, 0,
                      SpacingTokens.space20, SpacingTokens.space20),
                  children: [
                    // Image with colored border
                    if (item.imageUrl != null)
                      Container(
                        height: 300,
                        margin: const EdgeInsets.only(
                            bottom: SpacingTokens.space20),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(RadiusTokens.radiusLg),
                          border: Border.all(
                            color: colors['background']!,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors['text']!.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(RadiusTokens.radiusMd),
                          child: _buildImageWidget(item.imageUrl!),
                        ),
                      ),

                    // Title with colored background
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: SpacingTokens.space16,
                          vertical: SpacingTokens.space8),
                      decoration: BoxDecoration(
                        color: colors['background']!.withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(RadiusTokens.radiusMd),
                      ),
                      child: Text(
                        item.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: colors['text'],
                            ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description
                    if (item.description != null &&
                        item.description!.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(Icons.description, color: colors['accent']),
                          const SizedBox(width: 8),
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors['text'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors['background']!.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(RadiusTokens.radiusSm),
                          border: Border.all(
                            color: colors['background']!,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          item.description!,
                          style: TextStyle(
                            fontSize: 16,
                            color: colors['text']!.withOpacity(0.8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Categories
                    if (item.categories != null &&
                        item.categories!.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(Icons.category, color: colors['accent']),
                          const SizedBox(width: 8),
                          Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors['text'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: item.categories!.map((category) {
                          return Chip(
                            label: Text(category),
                            backgroundColor: colors['background'],
                            labelStyle: TextStyle(
                              color: colors['text'],
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Occasions
                    if (item.occasions != null &&
                        item.occasions!.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(Icons.event, color: colors['accent']),
                          const SizedBox(width: 8),
                          Text(
                            'Occasions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors['text'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: item.occasions!.map((occasion) {
                          return Chip(
                            label: Text(occasion),
                            backgroundColor: colors['accent']!.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: colors['accent'],
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    // Check if the path is a local file path
    if (imagePath.startsWith('/')) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading local image: $error');
          return const Center(child: Icon(Icons.image_not_supported, size: 50));
        },
      );
    } else {
      // Assume it's a network URL
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading network image: $error');
          return const Center(child: Icon(Icons.image_not_supported, size: 50));
        },
      );
    }
  }
}
