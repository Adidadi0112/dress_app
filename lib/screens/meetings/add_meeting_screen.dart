import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/meetings/meetings_bloc.dart';
import '../../blocs/meetings/meetings_event.dart';
import '../../blocs/meetings/meetings_state.dart';
import '../../blocs/friends/friends_bloc.dart';
import '../../blocs/friends/friends_event.dart';
import '../../models/meeting.dart';
import '../../widgets/enhanced_card.dart';
import '../../widgets/modern_text_field.dart';
import 'package:dress_app/models/clothing_item.dart';
import 'package:dress_app/models/friend.dart';
import 'package:dress_app/screens/meetings/select_clothes_screen.dart';
import 'package:dress_app/screens/friends/invite_to_event_screen.dart';
import 'package:dress_app/theme/responsive.dart';

class AddMeetingScreen extends StatefulWidget {
  const AddMeetingScreen({super.key});

  @override
  State<AddMeetingScreen> createState() => _AddMeetingScreenState();
}

class _AddMeetingScreenState extends State<AddMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _participantsController = TextEditingController();
  final _foodNotesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<ClothingItem> _selectedClothes = [];
  List<Friend> _invitedFriends = [];

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

  Future<void> _inviteFriends(BuildContext context) async {
    // Make sure the FriendsBloc is loaded
    context.read<FriendsBloc>().add(LoadFriends());

    // Create a temporary meeting object for the invite screen
    // This is needed because we're inviting to an event that doesn't exist yet
    final tempMeeting = Meeting(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      location: _locationController.text.isEmpty
          ? 'New Event'
          : _locationController.text,
      date: _selectedDate,
      participants: _participantsController.text.isEmpty
          ? []
          : _participantsController.text
              .split(',')
              .map((e) => e.trim())
              .toList(),
      wornItems: _selectedClothes,
      foodNotes:
          _foodNotesController.text.isEmpty ? null : _foodNotesController.text,
      isPast: false,
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InviteToEventScreen(meeting: tempMeeting),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final List<Friend> selectedFriends = result['friends'] as List<Friend>;
      setState(() {
        _invitedFriends = selectedFriends;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MeetingsBloc, MeetingsState>(
      listener: (context, state) {
        if (state is MeetingActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is MeetingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Meeting',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: ResponsiveHelper.getResponsivePadding(context),
          children: [
            ModernTextField(
              controller: _locationController,
              label: 'Location',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            EnhancedCard(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Date: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                  ListTile(
                    title: Text(
                      'Time: ${_selectedTime.format(context)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () => _selectTime(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ModernTextField(
              controller: _participantsController,
              labelText: 'Participants (separated by commas)',
              label: 'Participants',
              validator: (value) => null,
            ),
            const SizedBox(height: 16),
            ModernTextField(
              controller: _foodNotesController,
              labelText: 'Food Notes',
              label: 'Food Notes',
              validator: (value) => null,
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _inviteFriends(context),
              child: Text(
                _invitedFriends.isEmpty
                    ? 'Invite Friends'
                    : 'Invited Friends: ${_invitedFriends.length}',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final meeting = Meeting(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    location: _locationController.text,
                    date: _selectedDate,
                    participants: [
                      // Combine manual participants with selected friends
                      ..._participantsController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty),
                      ..._invitedFriends.map((friend) => friend.name),
                    ].toSet().toList(), // Remove duplicates
                    wornItems: _selectedClothes,
                    foodNotes: _foodNotesController.text.isEmpty
                        ? null
                        : _foodNotesController.text,
                    isPast: false,
                  );

                  context.read<MeetingsBloc>().add(AddMeeting(meeting));
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Meeting'),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
