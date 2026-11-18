import 'package:flutter/material.dart';

class PartyParticipantWidget extends StatelessWidget {
  final Map<String, String> participants; // userId -> nickname

  const PartyParticipantWidget({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "No participants yet",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      );
    }

    final sortedParticipants = participants.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return SizedBox(
      height: 70, // Slightly taller for nicknames
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: sortedParticipants.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final entry = sortedParticipants[index];
          final nickname = entry.value.isNotEmpty ? entry.value : "Guest";

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey.shade800,
                child: Text(
                  nickname[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60, // Slightly wider to accommodate longer names
                child: Text(
                  nickname,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
