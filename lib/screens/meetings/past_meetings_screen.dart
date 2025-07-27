import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/meetings/meetings_bloc.dart';
import '../../blocs/meetings/meetings_state.dart';
import '../../widgets/enhanced_card.dart';
import '../../theme/responsive.dart';

class PastMeetingsScreen extends StatelessWidget {
  const PastMeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingsBloc, MeetingsState>(
      builder: (context, state) {
        if (state is MeetingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MeetingsError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is MeetingsLoaded) {
          final meetings = state.meetings.where((m) => m.isPast).toList();

          if (meetings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No past meetings',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: ResponsiveHelper.getResponsivePadding(context),
            itemCount: meetings.length,
            itemBuilder: (context, index) {
              final meeting = meetings[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: EnhancedCard(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      meeting.location,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('dd.MM.yyyy HH:mm').format(meeting.date),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Participants: ${meeting.participants.join(", ")}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        if (meeting.wornItems.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Worn items: ${meeting.wornItems.map((item) => item.name).join(", ")}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ],
                        if (meeting.foodNotes != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Food notes: ${meeting.foodNotes}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ],
                    ),
                    onTap: () {
                      // TODO: Implement meeting details view
                    },
                  ),
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
