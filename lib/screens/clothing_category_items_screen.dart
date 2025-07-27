import 'package:flutter/material.dart';
import 'package:dress_app/models/item.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:dress_app/theme/responsive.dart';
import 'package:dress_app/widgets/enhanced_card.dart';

class ClothingCategoryItemsScreen extends StatelessWidget {
  final String category;
  final List<Item> items;

  const ClothingCategoryItemsScreen({
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: items.isEmpty
          ? _buildEmptyState(context)
          : GridView.builder(
              padding: ResponsiveHelper.getResponsivePadding(context),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    ResponsiveHelper.getResponsiveGridCrossAxisCount(context),
                crossAxisSpacing: SpacingTokens.space16,
                mainAxisSpacing: SpacingTokens.space16,
                childAspectRatio: 0.75,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildItemCard(context, item);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: SpacingTokens.space16),
            Text(
              'No items in $category',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingTokens.space8),
            Text(
              'Add some items to this category to see them here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, Item item) {
    return EnhancedCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
        onTap: () => _showItemDetails(context, item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(RadiusTokens.radiusLg),
                  ),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(RadiusTokens.radiusLg),
                  ),
                  child: item.imageUrl != null
                      ? _buildImageWidget(context, item.imageUrl!)
                      : Container(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
            ),

            // Details section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(SpacingTokens.space12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: SpacingTokens.space4),
                    if (item.description != null &&
                        item.description!.isNotEmpty)
                      Expanded(
                        child: Text(
                          item.description!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: SpacingTokens.space4),

                    // Occasions chips
                    if (item.occasions.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        children: item.occasions.take(2).map((occasion) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SpacingTokens.space6,
                              vertical: SpacingTokens.space2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius:
                                  BorderRadius.circular(RadiusTokens.radiusXs),
                            ),
                            child: Text(
                              occasion,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(BuildContext context, String imageUrl) {
    // Check if it's a Firebase Storage URL
    if (imageUrl.startsWith('https://firebasestorage.googleapis.com')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.broken_image,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        },
      );
    } else {
      // Fallback for other cases
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_not_supported,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
  }

  void _showItemDetails(BuildContext context, Item item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ItemDetailsBottomSheet(item: item),
    );
  }
}

class _ItemDetailsBottomSheet extends StatelessWidget {
  final Item item;

  const _ItemDetailsBottomSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(RadiusTokens.radiusXl),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: SpacingTokens.space12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(SpacingTokens.space24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      if (item.imageUrl != null)
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(RadiusTokens.radiusLg),
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(RadiusTokens.radiusLg),
                            child: _buildImageWidget(context, item.imageUrl!),
                          ),
                        ),

                      const SizedBox(height: SpacingTokens.space24),

                      // Title
                      Text(
                        item.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: SpacingTokens.space12),

                      // Description
                      if (item.description != null &&
                          item.description!.isNotEmpty) ...[
                        Text(
                          'Description',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: SpacingTokens.space8),
                        Text(
                          item.description!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: SpacingTokens.space16),
                      ],

                      // Categories
                      if (item.categories.isNotEmpty) ...[
                        Text(
                          'Categories',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: SpacingTokens.space8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: item.categories.map((category) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SpacingTokens.space12,
                                vertical: SpacingTokens.space6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(
                                    RadiusTokens.radiusMd),
                              ),
                              child: Text(
                                category,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: SpacingTokens.space16),
                      ],

                      // Occasions
                      if (item.occasions.isNotEmpty) ...[
                        Text(
                          'Occasions',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: SpacingTokens.space8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: item.occasions.map((occasion) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SpacingTokens.space12,
                                vertical: SpacingTokens.space6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                borderRadius: BorderRadius.circular(
                                    RadiusTokens.radiusMd),
                              ),
                              child: Text(
                                occasion,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: SpacingTokens.space16),
                      ],

                      // Timestamps
                      if (item.createdAt != null) ...[
                        Text(
                          'Added on',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: SpacingTokens.space4),
                        Text(
                          _formatDate(item.createdAt!),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageWidget(BuildContext context, String imageUrl) {
    if (imageUrl.startsWith('https://firebasestorage.googleapis.com')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.broken_image,
              size: 50,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        },
      );
    } else {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_not_supported,
          size: 50,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
