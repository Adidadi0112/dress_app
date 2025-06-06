import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/blocs/item/item_bloc.dart';
import 'package:dress_app/blocs/item/item_state.dart';
import 'package:dress_app/models/item.dart';
import 'package:dress_app/screens/settings.dart';
import 'package:dress_app/widgets/bottom_navigator.dart';
import 'package:dress_app/widgets/warderobe_tile.dart';

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
        title: Text('Home', style: TextTheme().titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: const CircleAvatar(child: Icon(Icons.person)),
                ),
                const Text('Welcome!\nMarta Wilgosz'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Center(child: Text('My Collection')),
          const SizedBox(height: 16),

          // Collection view
          BlocBuilder<ItemBloc, ItemState>(
            builder: (context, state) {
              if (state is ItemLoaded && state.items.isNotEmpty) {
                final items = state.items;
                final item = items[currentIndex];

                return Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => _previousItem(items),
                    ),
                    Expanded(
                      child: WarderobeTile(
                        imagePath: item.imageUrl,
                        title: item.name,
                        subtitle: item.description ?? '',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 50),
                      onPressed: () => _nextItem(items),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                );
              } else if (state is ItemLoaded && state.items.isEmpty) {
                return const Center(child: Text("Your wardrobe is empty"));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomAppBarMobileWidget(),
    );
  }
}
