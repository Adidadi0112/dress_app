import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:dress_app/themes/theme_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ThemeAndStickersScreen extends StatefulWidget {
  const ThemeAndStickersScreen({Key? key}) : super(key: key);

  @override
  State<ThemeAndStickersScreen> createState() => _ThemeAndStickersScreenState();
}

class _ThemeAndStickersScreenState extends State<ThemeAndStickersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Color selection
  Color _selectedPrimaryColor = ColorTokens.rosePetal;
  Color _selectedSecondaryColor = ColorTokens.lavenderMist;
  Color _selectedAccentColor = ColorTokens.mintFoam;

  // Sticker selection
  final List<String> _availableStickers = [
    'heart',
    'star',
    'polaroid-frame',
    'flower',
    'butterfly',
    'ribbon',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize with current theme colors
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _selectedPrimaryColor = themeProvider.primaryColor;
    _selectedSecondaryColor = themeProvider.secondaryColor;
    _selectedAccentColor = themeProvider.accentColor;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Personalize Your Journal'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Theme Colors', icon: Icon(Icons.color_lens)),
            Tab(text: 'Stickers', icon: Icon(Icons.emoji_emotions)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Theme Colors Tab
          _buildThemeColorTab(themeProvider),

          // Stickers Tab
          _buildStickersTab(),
        ],
      ),
    );
  }

  Widget _buildThemeColorTab(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(SpacingTokens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Theme Mode Selection
          Text(
            'Choose Theme Mode',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: SpacingTokens.space16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildThemeModeCard(
                title: 'Light Pastel',
                icon: Icons.light_mode,
                isSelected: themeProvider.themeType == ThemeType.light,
                onTap: () => themeProvider.setLightTheme(),
              ),
              _buildThemeModeCard(
                title: 'Dark Pastel',
                icon: Icons.dark_mode,
                isSelected: themeProvider.themeType == ThemeType.dark,
                onTap: () => themeProvider.setDarkTheme(),
              ),
              _buildThemeModeCard(
                title: 'Custom Pastel',
                icon: Icons.palette,
                isSelected: themeProvider.themeType == ThemeType.customPastel,
                onTap: () => themeProvider.setCustomPastelTheme(
                  primaryColor: _selectedPrimaryColor,
                  secondaryColor: _selectedSecondaryColor,
                  accentColor: _selectedAccentColor,
                ),
              ),
            ],
          ),

          SizedBox(height: SpacingTokens.space32),

          // Custom Color Selection
          Text(
            'Customize Your Pastel Colors',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: SpacingTokens.space16),

          // Primary Color
          _buildColorPickerSection(
            title: 'Primary Color',
            description: 'Used for buttons and highlights',
            currentColor: _selectedPrimaryColor,
            onColorChanged: (color) {
              setState(() {
                _selectedPrimaryColor = color;
              });

              if (themeProvider.themeType == ThemeType.customPastel) {
                themeProvider.setCustomPastelTheme(
                  primaryColor: _selectedPrimaryColor,
                  secondaryColor: _selectedSecondaryColor,
                  accentColor: _selectedAccentColor,
                );
              }
            },
          ),

          SizedBox(height: SpacingTokens.space24),

          // Secondary Color
          _buildColorPickerSection(
            title: 'Secondary Color',
            description: 'Used for cards and backgrounds',
            currentColor: _selectedSecondaryColor,
            onColorChanged: (color) {
              setState(() {
                _selectedSecondaryColor = color;
              });

              if (themeProvider.themeType == ThemeType.customPastel) {
                themeProvider.setCustomPastelTheme(
                  primaryColor: _selectedPrimaryColor,
                  secondaryColor: _selectedSecondaryColor,
                  accentColor: _selectedAccentColor,
                );
              }
            },
          ),

          SizedBox(height: SpacingTokens.space24),

          // Accent Color
          _buildColorPickerSection(
            title: 'Accent Color',
            description: 'Used for special elements',
            currentColor: _selectedAccentColor,
            onColorChanged: (color) {
              setState(() {
                _selectedAccentColor = color;
              });

              if (themeProvider.themeType == ThemeType.customPastel) {
                themeProvider.setCustomPastelTheme(
                  primaryColor: _selectedPrimaryColor,
                  secondaryColor: _selectedSecondaryColor,
                  accentColor: _selectedAccentColor,
                );
              }
            },
          ),

          SizedBox(height: SpacingTokens.space32),

          // Apply Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                themeProvider.setCustomPastelTheme(
                  primaryColor: _selectedPrimaryColor,
                  secondaryColor: _selectedSecondaryColor,
                  accentColor: _selectedAccentColor,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Custom theme applied!'),
                    backgroundColor: _selectedPrimaryColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text('Apply Custom Theme'),
            ).animate().fadeIn(duration: 300.ms).scale(delay: 150.ms),
          ),

          SizedBox(height: SpacingTokens.space16),
        ],
      ),
    );
  }

  Widget _buildThemeModeCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(SpacingTokens.space16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: 1,
          ),
          boxShadow: isSelected ? ElevationTokens.low : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            SizedBox(height: SpacingTokens.space8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).slideY(
          begin: 0.2, end: 0, duration: 300.ms, curve: Curves.easeOutQuad),
    );
  }

  Widget _buildColorPickerSection({
    required String title,
    required String description,
    required Color currentColor,
    required ValueChanged<Color> onColorChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: currentColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
            SizedBox(width: SpacingTokens.space8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: SpacingTokens.space4),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: SpacingTokens.space12),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusTokens.radiusMd),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(RadiusTokens.radiusMd),
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
              pickerAreaHeightPercent: 1.0,
              enableAlpha: false,
              displayThumbColor: true,
              paletteType: PaletteType.hsl,
              pickerAreaBorderRadius:
                  BorderRadius.circular(RadiusTokens.radiusMd),
              labelTypes: const [],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStickersTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(SpacingTokens.space16),
          child: Text(
            'Drag stickers onto your photos',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),

        // Sticker palette
        Container(
          height: 100,
          margin: EdgeInsets.symmetric(horizontal: SpacingTokens.space16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(RadiusTokens.radiusMd),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(SpacingTokens.space8),
            itemCount: _availableStickers.length,
            itemBuilder: (context, index) {
              return _buildDraggableSticker(_availableStickers[index]);
            },
          ),
        ),

        SizedBox(height: SpacingTokens.space16),

        // Preview area
        Expanded(
          child: Container(
            margin: EdgeInsets.all(SpacingTokens.space16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Placeholder for photo
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(height: SpacingTokens.space8),
                      Text(
                        'Drop stickers here',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: SpacingTokens.space16),
                      Text(
                        'Stickers will be available when viewing your outfits',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Drop target area
                DragTarget<String>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      color: Colors.transparent,
                    );
                  },
                  onAccept: (data) {
                    // Show a preview of the sticker
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Sticker "$data" will be available in your collection!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDraggableSticker(String stickerName) {
    return Draggable<String>(
      data: stickerName,
      feedback: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _getStickerIcon(stickerName),
        ),
      ),
      childWhenDragging: Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.all(SpacingTokens.space8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.all(SpacingTokens.space8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
        ),
        child: Center(
          child: _getStickerIcon(stickerName),
        ),
      ),
    )
        .animate()
        .fadeIn(
            duration: 300.ms,
            delay: 100.ms * _availableStickers.indexOf(stickerName))
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0));
  }

  Widget _getStickerIcon(String stickerName) {
    switch (stickerName) {
      case 'heart':
        return Icon(Icons.favorite,
            color: Theme.of(context).colorScheme.primary);
      case 'star':
        return Icon(Icons.star, color: Theme.of(context).colorScheme.secondary);
      case 'polaroid-frame':
        return Icon(Icons.crop_square,
            color: Theme.of(context).colorScheme.tertiary);
      case 'flower':
        return Icon(Icons.local_florist,
            color: Theme.of(context).colorScheme.primary);
      case 'butterfly':
        return Icon(Icons.air, color: Theme.of(context).colorScheme.secondary);
      case 'ribbon':
        return Icon(Icons.bookmark,
            color: Theme.of(context).colorScheme.tertiary);
      default:
        return Icon(Icons.emoji_emotions,
            color: Theme.of(context).colorScheme.primary);
    }
  }
}
