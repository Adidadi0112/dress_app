import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/models/outing.dart';
import 'package:dress_app/blocs/outings/outings_bloc.dart';
import 'package:intl/intl.dart';

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
          return Center(child: Text('Błąd: ${state.message}'));
        }

        if (state is OutingsLoaded) {
          final outings = state.pastOutings;

          if (outings.isEmpty) {
            return const Center(child: Text('Brak poprzednich wyjść'));
          }

          return ListView.builder(
            itemCount: outings.length,
            itemBuilder: (context, index) {
              final outing = outings[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(outing.location),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('dd.MM.yyyy HH:mm').format(outing.date)),
                      Text('Uczestnicy: ${outing.participants.join(", ")}'),
                      if (outing.wornItems.isNotEmpty)
                        Text(
                          'Ubrane rzeczy: ${outing.wornItems.map((item) => item.name).join(", ")}',
                        ),
                      if (outing.foodNotes != null)
                        Text('Notatki o jedzeniu: ${outing.foodNotes}'),
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

        return const Center(child: Text('Nieznany stan'));
      },
    );
  }
}
