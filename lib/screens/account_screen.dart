import 'package:dress_app/screens/wardrobe_screen.dart';
import 'package:dress_app/screens/meetings/meetings_screen.dart';
import 'package:dress_app/screens/friends/friends_screen.dart';
import 'package:dress_app/widgets/bottom_navigator.dart';
import 'package:dress_app/widgets/enhanced_card.dart';
import 'package:dress_app/widgets/responsive_layout.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:dress_app/theme/responsive.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          child: Column(
            children: [
              // Profile Header
              EnhancedCard(
                child: Padding(
                  padding: const EdgeInsets.all(SpacingTokens.space20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(SpacingTokens.space12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 32,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: SpacingTokens.space16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Marta Wilgosz',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Fashion Enthusiast',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: SpacingTokens.space24),

              // Menu Items
              _buildMenuCard(
                context,
                icon: Icons.checkroom,
                title: 'My Wardrobe',
                subtitle: 'Manage your clothing collection',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const WardrobeScreen()),
                  );
                },
              ),

              const SizedBox(height: SpacingTokens.space12),

              _buildMenuCard(
                context,
                icon: Icons.event,
                title: 'My Meetings',
                subtitle: 'Plan and track your events',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const MeetingsScreen()),
                  );
                },
              ),

              const SizedBox(height: SpacingTokens.space12),

              _buildMenuCard(
                context,
                icon: Icons.people,
                title: 'My Friends',
                subtitle: 'Connect with other fashion lovers',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const FriendsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBarMobileWidget(),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return EnhancedCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(SpacingTokens.space16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(SpacingTokens.space12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(RadiusTokens.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: SpacingTokens.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
