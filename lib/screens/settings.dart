import 'package:dress_app/screens/theme_and_stickers.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:dress_app/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dress_app/services/firebase_auth_service.dart';
import 'package:dress_app/widgets/bottom_navigator.dart';
import 'package:dress_app/widgets/enhanced_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(SpacingTokens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Appearance Section
              _buildSectionHeader(context, 'Appearance'),

              _buildSettingCard(
                context,
                title: 'Personalize Your Journal',
                subtitle: 'Customize colors and add stickers to your wardrobe',
                icon: Icons.palette,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThemeAndStickersScreen(),
                    ),
                  );
                },
              ),

              _buildSettingCard(
                context,
                title: 'Dark Mode',
                subtitle: 'Switch between light and dark themes',
                icon: themeProvider.isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode,
                trailing: CupertinoSwitch(
                  value: themeProvider.isDarkMode,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) => themeProvider.toggleTheme(),
                ),
              ),

              _buildSettingCard(
                context,
                title: 'Accessibility',
                subtitle: 'High contrast mode for better readability',
                icon: Icons.accessibility_new,
                trailing: CupertinoSwitch(
                  value:
                      false, // This would be connected to a real accessibility setting
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) {
                    // Apply high contrast if needed
                    themeProvider.applyHighContrastIfNeeded(value);
                  },
                ),
              ),

              SizedBox(height: SpacingTokens.space24),

              // Account Section
              _buildSectionHeader(context, 'Account'),

              _buildSettingCard(
                context,
                title: 'Profile Information',
                subtitle: 'Update your personal details',
                icon: Icons.person,
                onTap: () {
                  // Navigate to profile screen
                },
              ),

              _buildSettingCard(
                context,
                title: 'Notifications',
                subtitle: 'Manage your notification preferences',
                icon: Icons.notifications,
                onTap: () {
                  // Navigate to notifications screen
                },
              ),

              _buildSettingCard(
                context,
                title: 'Privacy',
                subtitle: 'Control your data and privacy settings',
                icon: Icons.privacy_tip,
                onTap: () {
                  // Navigate to privacy screen
                },
              ),

              SizedBox(height: SpacingTokens.space24),

              // Logout Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final optionModel = Provider.of<BottomAppBarOptionProvider>(
                      context,
                      listen: false,
                    );

                    try {
                      final authService = Provider.of<FirebaseAuthService>(
                          context,
                          listen: false);
                      await authService.signOut();

                      optionModel.selectOption(0);
                      // Navigation will be handled automatically by the StreamBuilder in main.dart
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logout failed: $e')),
                      );
                    }
                  },
                  icon: Icon(Icons.logout),
                  label: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: SpacingTokens.space24,
                      vertical: SpacingTokens.space16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: SpacingTokens.space32),

              // App Info
              Center(
                child: Text(
                  'Wardrobe Journal v1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),

              SizedBox(height: SpacingTokens.space8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: SpacingTokens.space8,
        bottom: SpacingTokens.space12,
        top: SpacingTokens.space8,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontFamily: TypographyTokens.displayFontFamily,
            ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return EnhancedCard(
      child: ListTile(
        contentPadding: EdgeInsets.all(SpacingTokens.space16),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: SpacingTokens.space4),
          child: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
