import 'dart:io';
import 'package:dress_app/widgets/modern_text_field.dart';
import 'package:dress_app/widgets/enhanced_card.dart';
import 'package:dress_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dress_app/models/item.dart';
import 'package:dress_app/blocs/item/item_bloc.dart';
import 'package:dress_app/blocs/item/item_event.dart';
import 'package:dress_app/theme/tokens.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  XFile? _selectedImage;

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = picked);
    }
  }

  void _submit() {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty ||
        category.isEmpty ||
        description.isEmpty ||
        _selectedImage == null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and select an image"),
        ),
      );
      return;
    }

    final item = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      categories: [category],
      occasions: [], // Empty occasions list for now
      imageUrl: _selectedImage!.path,
      createdAt: DateTime.now(),
    );

    // 👇 Debug print
    print("🟢 Added item: $item");

    context.read<ItemBloc>().add(AddItem(item));
    navigator.pop(); // powrót po dodaniu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Item',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(SpacingTokens.space16),
        child: ListView(
          children: [
            EnhancedCard(
              child: Padding(
                padding: const EdgeInsets.all(SpacingTokens.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: SpacingTokens.space16),
                    ModernTextField(
                      controller: _nameController,
                      hintText: 'Item Name',
                      prefixIcon: Icon(Icons.label),
                      label: 'Item Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an item name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: SpacingTokens.space16),
                    ModernTextField(
                      controller: _categoryController,
                      hintText: 'Category',
                      prefixIcon: Icon(Icons.category),
                      label: 'Category',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: SpacingTokens.space16),
                    ModernTextField(
                      controller: _descriptionController,
                      hintText: 'Description',
                      prefixIcon: Icon(Icons.description),
                      maxLines: 3,
                      label: '',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SpacingTokens.space16),
            EnhancedCard(
              child: Padding(
                padding: const EdgeInsets.all(SpacingTokens.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Photo',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: SpacingTokens.space16),
                    _selectedImage != null
                        ? Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(RadiusTokens.radiusLg),
                              image: DecorationImage(
                                image: FileImage(File(_selectedImage!.path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius:
                                  BorderRadius.circular(RadiusTokens.radiusLg),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 48,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                                const SizedBox(height: SpacingTokens.space8),
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
            const SizedBox(height: SpacingTokens.space24),
            GradientButton(
              onPressed: _submit,
              text: 'Add Item',
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }
}
