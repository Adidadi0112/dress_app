import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/blocs/item/item_bloc.dart';
import 'package:dress_app/blocs/item/item_state.dart';
import 'package:dress_app/models/item.dart';
import 'package:dress_app/screens/settings.dart';
import 'package:dress_app/widgets/bottom_navigator.dart';
import 'package:dress_app/widgets/warderobe_tile.dart';
import 'package:dress_app/theme/tokens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void _previousItem(List<Item> items) {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void _nextItem(List<Item> items) {
    if (currentIndex < items.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Home',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // User profile
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.space16,
                vertical: SpacingTokens.space12),
            padding: const EdgeInsets.all(SpacingTokens.space16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.3),
              borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
              border: Border.all(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: SpacingTokens.space12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome!',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    Text(
                      'Marta Wilgosz',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Collection header
          Container(
            margin: const EdgeInsets.symmetric(vertical: SpacingTokens.space16),
            child: Column(
              children: [
                Text(
                  'My Collection',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: SpacingTokens.space4),
                Container(
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(RadiusTokens.radiusXs),
                  ),
                ),
              ],
            ),
          ),

          // Collection view
          BlocBuilder<ItemBloc, ItemState>(
            builder: (context, state) {
              if (state is ItemLoaded && state.items.isNotEmpty) {
                final items = state.items;
                final item = items[currentIndex];

                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: SpacingTokens.space16),
                  child: Column(
                    children: [
                      // Item counter
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: SpacingTokens.space8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: SpacingTokens.space12,
                                  vertical: SpacingTokens.space4),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                borderRadius: BorderRadius.circular(
                                    RadiusTokens.radiusCircular),
                              ),
                              child: Text(
                                '${currentIndex + 1} of ${items.length}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Item display with navigation
                      Row(
                        children: [
                          // Previous button
                          Container(
                            decoration: BoxDecoration(
                              color: currentIndex > 0
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                size: 30,
                                color: currentIndex > 0
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withOpacity(0.5),
                              ),
                              onPressed: currentIndex > 0
                                  ? () => _previousItem(items)
                                  : null,
                            ),
                          ),

                          // Item card
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: SpacingTokens.space8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    RadiusTokens.radiusLg),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .shadow
                                        .withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: WarderobeTile(
                                imagePath: item.imageUrl,
                                title: item.name,
                                subtitle: item.description ?? '',
                              ),
                            ),
                          ),

                          // Next button
                          Container(
                            decoration: BoxDecoration(
                              color: currentIndex < items.length - 1
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.chevron_right,
                                size: 30,
                                color: currentIndex < items.length - 1
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withOpacity(0.5),
                              ),
                              onPressed: currentIndex < items.length - 1
                                  ? () => _nextItem(items)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (state is ItemLoaded && state.items.isEmpty) {
                return Container(
                  margin: const EdgeInsets.all(SpacingTokens.space24),
                  padding: const EdgeInsets.all(SpacingTokens.space24),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceVariant
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: SpacingTokens.space16),
                      Text(
                        "Your wardrobe is empty",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                      ),
                      const SizedBox(height: SpacingTokens.space8),
                      Text(
                        "Add some items to get started",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withOpacity(0.8),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  margin: const EdgeInsets.all(SpacingTokens.space24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: SpacingTokens.space16),
                      Text(
                        "Loading your collection...",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomAppBarMobileWidget(),
    );
  }
}
