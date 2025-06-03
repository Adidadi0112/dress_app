import 'dart:io';
import 'package:dress_app/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dress_app/models/item.dart';
import 'package:dress_app/blocs/item/item_bloc.dart';
import 'package:dress_app/blocs/item/item_event.dart';
import 'package:dress_app/blocs/item/item_state.dart';

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
      imageUrl: _selectedImage!.path,
    );

    // 👇 Debug print
    print("🟢 Added item: $item");

    context.read<ItemBloc>().add(AddItem(item));
    navigator.pop(); // powrót po dodaniu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dodaj ciuch")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nazwa'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Kategoria'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Opis'),
            ),
            const SizedBox(height: 12),
            _selectedImage != null
                ? Image.file(File(_selectedImage!.path), height: 150)
                : TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo),
                    label: const Text("Wybierz zdjęcie"),
                  ),
            const SizedBox(height: 16),
            MyButton(title: "Dodaj", onTap: _submit),
          ],
        ),
      ),
    );
  }
}
