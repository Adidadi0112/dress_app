import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/blocs/item/item_bloc.dart';
import 'package:dress_app/blocs/item/item_event.dart';
import 'package:dress_app/blocs/item/item_state.dart';
import 'package:dress_app/models/item.dart';
import 'package:dress_app/screens/add_item_screen.dart';
import 'package:dress_app/screens/clothing_category_items_screen.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:dress_app/theme/responsive.dart';
import 'package:dress_app/widgets/enhanced_card.dart';

class ClothingWardrobeScreen extends StatefulWidget {
  const ClothingWardrobeScreen({super.key});

  @override
  State<ClothingWardrobeScreen> createState() => _ClothingWardrobeScreenState();
}

class _ClothingWardrobeScreenState extends State<ClothingWardrobeScreen> {
  @override
  void initState() {
    super.initState();
    // Load clothing items when screen initializes
    context.read<ItemBloc>().add(FetchItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wardrobe"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ItemBloc>().add(FetchItems());
        },
        child: BlocBuilder<ItemBloc, ItemState>(
          builder: (context, state) {
            if (state is ItemLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: SpacingTokens.space16),
                    Text('Loading your wardrobe...'),
                  ],
                ),
              );
            }

            if (state is ItemError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: SpacingTokens.space16),
                    Text(
                      'Error loading wardrobe',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: SpacingTokens.space8),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: SpacingTokens.space16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ItemBloc>().add(FetchItems());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ItemLoaded) {
              List<Item> items;

              items = state.items;
              items = state.items;

              if (items.isEmpty) {
                return _buildEmptyState();
              }

              final grouped = _groupItemsByCategory(items);
              return ListView(
                padding: ResponsiveHelper.getResponsivePadding(context),
                children: [
                  // Stats Card
                  _buildStatsCard(items),
                  const SizedBox(height: SpacingTokens.space16),

                  // Categories
                  ...grouped.entries.map((entry) {
                    final category = entry.key;
                    final items = entry.value;
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: SpacingTokens.space16),
                      child: _buildCategoryCard(context, category, items),
                    );
                  }).toList(),
                ],
              );
            }

            return _buildEmptyState();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ItemBloc>(),
                child: const AddItemScreen(),
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(SpacingTokens.space24),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.checkroom_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: SpacingTokens.space24),
            Text(
              "Your wardrobe is empty",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingTokens.space12),
            Text(
              "Start building your digital wardrobe by adding your first clothing item",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingTokens.space32),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<ItemBloc>(),
                      child: const AddItemScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Item'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.space24,
                  vertical: SpacingTokens.space16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(List<Item> items) {
    final categories = _groupItemsByCategory(items);

    return EnhancedCard(
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wardrobe Overview',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: SpacingTokens.space16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Total Items',
                    items.length.toString(),
                    Icons.checkroom,
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Categories',
                    categories.length.toString(),
                    Icons.category,
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.space12),
      margin: const EdgeInsets.symmetric(horizontal: SpacingTokens.space4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(RadiusTokens.radiusMd),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: SpacingTokens.space8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Map<String, List<Item>> _groupItemsByCategory(List<Item> items) {
    final Map<String, List<Item>> grouped = {};
    for (final item in items) {
      for (final category in item.categories) {
        grouped.putIfAbsent(category, () => []).add(item);
      }
    }
    return grouped;
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String category,
    List<Item> items,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final colorIndex = category.length % 4;

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

    return EnhancedCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ClothingCategoryItemsScreen(
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
            padding: const EdgeInsets.all(SpacingTokens.space16),
            child: Row(
              children: [
                // Category preview image
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusTokens.radiusMd),
                    border: Border.all(
                      color: colors['background']!,
                      width: 3,
                    ),
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
                const SizedBox(width: SpacingTokens.space16),

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
                      const SizedBox(height: SpacingTokens.space8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SpacingTokens.space8,
                          vertical: SpacingTokens.space4,
                        ),
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

  Widget _buildImageWidget(String imageUrl, double width, double height) {
    // Check if it's a Firebase Storage URL or local path
    if (imageUrl.startsWith('https://firebasestorage.googleapis.com')) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Icon(
              Icons.broken_image,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        },
      );
    } else {
      // Fallback for local files or other cases
      return Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Icon(
          Icons.image_not_supported,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
  }
}
