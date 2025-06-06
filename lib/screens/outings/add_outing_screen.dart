import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/models/outing.dart';
import 'package:dress_app/models/clothing_item.dart';
import 'package:dress_app/blocs/outings/outings_bloc.dart';
import 'package:dress_app/screens/outings/select_clothes_screen.dart';
import 'package:intl/intl.dart';

class AddOutingScreen extends StatefulWidget {
  const AddOutingScreen({super.key});

  @override
  State<AddOutingScreen> createState() => _AddOutingScreenState();
}

class _AddOutingScreenState extends State<AddOutingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _participantsController = TextEditingController();
  final _foodNotesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<ClothingItem> _selectedClothes = [];

  @override
  void dispose() {
    _locationController.dispose();
    _participantsController.dispose();
    _foodNotesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _selectClothes(BuildContext context) async {
    final selectedClothes = await Navigator.push<List<ClothingItem>>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectClothesScreen(
          initiallySelected: _selectedClothes,
        ),
      ),
    );

    if (selectedClothes != null) {
      setState(() {
        _selectedClothes = selectedClothes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Outing')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                'Date: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text('Time: ${_selectedTime.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _participantsController,
              decoration: const InputDecoration(
                labelText: 'Participants (separated by commas)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _foodNotesController,
              decoration: const InputDecoration(
                labelText: 'Food Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _selectClothes(context),
              child: Text(
                _selectedClothes.isEmpty
                    ? 'Select Clothes'
                    : 'Selected Clothes: ${_selectedClothes.length}',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final outing = Outing(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    location: _locationController.text,
                    date: _selectedDate,
                    participants: _participantsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList(),
                    wornItems: _selectedClothes,
                    foodNotes: _foodNotesController.text.isEmpty
                        ? null
                        : _foodNotesController.text,
                    isPast: false,
                  );

                  context.read<OutingsBloc>().add(AddOuting(outing));
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Outing'),
            ),
          ],
        ),
      ),
    );
  }
}
