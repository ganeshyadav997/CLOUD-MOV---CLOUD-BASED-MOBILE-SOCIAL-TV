import 'package:flutter/material.dart';
import '../../services/watch_party_service.dart';
import '../../models/video_model.dart';
import '../../data/video_data.dart';

class PartyControlsWidget extends StatelessWidget {
  final String partyId;
  final WatchPartyService partyService;
  final Future<void> Function(int seconds)? onSeek; // callback for +30s

  const PartyControlsWidget({
    super.key,
    required this.partyId,
    required this.partyService,
    this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    final categories = {
      "Education": VideoData.education,
      "Health": VideoData.health,
      "News": VideoData.news,
    };

    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Host Controls",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Playback buttons
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text("Play"),
                onPressed: () async {
                  await partyService.updatePlayback(partyId, true, null);
                },
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.pause),
                label: const Text("Pause"),
                onPressed: () async {
                  await partyService.updatePlayback(partyId, false, null);
                },
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.forward_30),
                label: const Text("Seek +30s"),
                onPressed: () async {
                  if (onSeek != null) {
                    await onSeek!(30); // use VideoPlayerController position
                  } else {
                    // fallback: read from Firestore
                    final currentParty = await partyService.getPartyStream(partyId).first;
                    final currentPos = currentParty.playbackPosition;
                    final newPos = currentPos + 30;
                    await partyService.updatePlayback(partyId, true, newPos);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Video selection from AWS S3 (VideoData should contain S3 URLs)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.entries.expand((entry) {
                return entry.value.map((video) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () async {
                        await partyService.changeVideo(partyId, video);
                      },
                      child: Text(
                        video.title.length > 12
                            ? '${video.title.substring(0, 12)}...'
                            : video.title,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                });
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
