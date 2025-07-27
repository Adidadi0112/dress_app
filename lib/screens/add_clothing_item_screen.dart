import 'dart:io';
import 'package:dress_app/widgets/modern_text_field.dart';
import 'package:dress_app/widgets/enhanced_card.dart';
import 'package:dress_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dress_app/models/clothing_item.dart';
import 'package:dress_app/blocs/clothing_item/clothing_item_bloc.dart';
import 'package:dress_app/blocs/clothing_item/clothing_item_event.dart';
import 'package:dress_app/blocs/clothing_item/clothing_item_state.dart';
import 'package:dress_app/screens/clothing_wardrobe_screen.dart';
import 'package:dress_app/theme/tokens.dart';

class AddClothingItemScreen extends StatefulWidget {
  const AddClothingItemScreen({super.key});

  @override
  State<AddClothingItemScreen> createState() => _AddClothingItemScreenState();
}

class _AddClothingItemScreenState extends State<AddClothingItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  XFile? _selectedImage;
  final _picker = ImagePicker();

  List<String> _selectedCategories = [];
  List<String> _selectedOccasions = [];

  // Predefined categories and occasions
  final List<String> _availableCategories = [
    'Tops',
    'Bottoms',
    'Dresses',
    'Outerwear',
    'Shoes',
    'Accessories',
    'Underwear',
    'Sportswear',
    'Formal',
    'Casual',
  ];

  final List<String> _availableOccasions = [
    'Work',
    'Casual',
    'Party',
    'Sport',
    'Formal',
    'Wedding',
    'Beach',
    'Travel',
    'Date',
    'Shopping',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (picked != null) {
        setState(() => _selectedImage = picked);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
        ),
      );
      return;
    }

    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one category'),
        ),
      );
      return;
    }

    final item = ClothingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      imageUrl:
          _selectedImage!.path, // Local path, will be uploaded by the BLoC
      categories: _selectedCategories,
      occasions: _selectedOccasions,
    );

    context.read<ClothingItemBloc>().add(AddClothingItem(item));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Clothing Item',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: BlocListener<ClothingItemBloc, ClothingItemState>(
        listener: (context, state) {
          if (state is ClothingItemActionSuccess) {
            // Navigate to My Wardrobe screen instead of just popping
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ClothingWardrobeScreen(),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          } else if (state is ClothingItemError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: BlocBuilder<ClothingItemBloc, ClothingItemState>(
          builder: (context, state) {
            final isLoading = state is ClothingItemLoading;

            return AbsorbPointer(
              absorbing: isLoading,
              child: Opacity(
                opacity: isLoading ? 0.6 : 1.0,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(SpacingTokens.space16),
                    child: ListView(
                      children: [
                        // Basic Details Card
                        EnhancedCard(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(SpacingTokens.space16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Item Details',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: SpacingTokens.space16),
                                ModernTextField(
                                  controller: _nameController,
                                  hintText: 'Item Name',
                                  prefixIcon: const Icon(Icons.label),
                                  label: 'Item Name',
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter an item name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: SpacingTokens.space16),
                                ModernTextField(
                                  controller: _descriptionController,
                                  hintText: 'Description (optional)',
                                  prefixIcon: const Icon(Icons.description),
                                  maxLines: 3,
                                  label: 'Description',
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: SpacingTokens.space16),

                        // Image Selection Card
                        EnhancedCard(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(SpacingTokens.space16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Item Photo',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: SpacingTokens.space16),
                                _selectedImage != null
                                    ? Container(
                                        height: 200,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              RadiusTokens.radiusLg),
                                          image: DecorationImage(
                                            image: FileImage(
                                                File(_selectedImage!.path)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 150,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceVariant,
                                          borderRadius: BorderRadius.circular(
                                              RadiusTokens.radiusLg),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            width: 2,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .add_photo_alternate_outlined,
                                              size: 48,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                            const SizedBox(
                                                height: SpacingTokens.space8),
                                            Text(
                                              'Tap to select photo',
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
                                const SizedBox(height: SpacingTokens.space16),
                                GradientButton(
                                  onPressed: _pickImage,
                                  text: _selectedImage != null
                                      ? 'Change Photo'
                                      : 'Select Photo',
                                  icon: Icons.photo_camera,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: SpacingTokens.space16),

                        // Categories Card
                        EnhancedCard(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(SpacingTokens.space16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Categories',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: SpacingTokens.space12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      _availableCategories.map((category) {
                                    final isSelected =
                                        _selectedCategories.contains(category);
                                    return FilterChip(
                                      label: Text(category),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() {
                                          if (selected) {
                                            _selectedCategories.add(category);
                                          } else {
                                            _selectedCategories
                                                .remove(category);
                                          }
                                        });
                                      },
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant,
                                      selectedColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      checkmarkColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: SpacingTokens.space16),

                        // Occasions Card
                        EnhancedCard(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(SpacingTokens.space16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Occasions',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: SpacingTokens.space12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _availableOccasions.map((occasion) {
                                    final isSelected =
                                        _selectedOccasions.contains(occasion);
                                    return FilterChip(
                                      label: Text(occasion),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() {
                                          if (selected) {
                                            _selectedOccasions.add(occasion);
                                          } else {
                                            _selectedOccasions.remove(occasion);
                                          }
                                        });
                                      },
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant,
                                      selectedColor: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      checkmarkColor: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: SpacingTokens.space24),

                        // Submit Button
                        if (isLoading)
                          const Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: SpacingTokens.space8),
                                Text('Adding item...'),
                              ],
                            ),
                          )
                        else
                          GradientButton(
                            onPressed: _submit,
                            text: 'Add Item',
                            icon: Icons.add,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
