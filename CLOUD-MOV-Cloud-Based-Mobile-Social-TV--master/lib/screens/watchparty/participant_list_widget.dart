import 'package:flutter/material.dart';
import '../../services/watch_party_service.dart';

class ParticipantListWidget extends StatelessWidget {
  final String partyId;
  final WatchPartyService partyService;

  const ParticipantListWidget({
    super.key,
    required this.partyId,
    required this.partyService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: partyService.getPartyStream(partyId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(); // Placeholder while loading
        }

        final participants = snapshot.data!.participants;

        if (participants.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "No participants",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        // Sort participants alphabetically by nickname
        final sortedParticipants = participants.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value));

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black87.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: const BoxConstraints(
            maxWidth: 220, // Prevent horizontal overflow
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Participants",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: Scrollbar(
                  radius: const Radius.circular(4),
                  thickness: 4,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: sortedParticipants.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final entry = sortedParticipants[index];
                      return Row(
                        children: [
                          const Icon(Icons.person, color: Colors.white54, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}