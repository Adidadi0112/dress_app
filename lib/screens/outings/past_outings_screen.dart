import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/models/outing.dart';
import 'package:dress_app/blocs/outings/outings_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:dress_app/widgets/enhanced_card.dart';

class PastOutingsScreen extends StatelessWidget {
  const PastOutingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OutingsBloc, OutingsState>(
      builder: (context, state) {
        if (state is OutingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is OutingsError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is OutingsLoaded) {
          final outings = state.pastOutings;

          if (outings.isEmpty) {
            return const Center(child: Text('No past outings'));
          }

          return ListView.builder(
            itemCount: outings.length,
            itemBuilder: (context, index) {
              final outing = outings[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Theme.of(context).colorScheme.secondary,
                child: ListTile(
                  title: Text(outing.location),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('dd.MM.yyyy HH:mm').format(outing.date)),
                      Text('Participants: ${outing.participants.join(", ")}'),
                      if (outing.wornItems.isNotEmpty)
                        Text(
                          'Worn items: ${outing.wornItems.map((item) => item.name).join(", ")}',
                        ),
                      if (outing.foodNotes != null)
                        Text('Food notes: ${outing.foodNotes}'),
                    ],
                  ),
                  onTap: () {
                    // TODO: Implement outing details view
                  },
                ),
              );
            },
          );
        }

        return const Center(child: Text('Unknown state'));
      },
    );
  }
}
