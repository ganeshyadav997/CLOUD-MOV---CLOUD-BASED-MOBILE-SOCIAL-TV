import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/watch_party_service.dart';
import '../../models/video_model.dart';
import '../../data/video_data.dart';
import '../watchparty/watch_party_screen.dart';

class PartyVideoSelector extends StatefulWidget {
  final String userId;

  const PartyVideoSelector({super.key, required this.userId});

  @override
  State<PartyVideoSelector> createState() => _PartyVideoSelectorState();
}

class _PartyVideoSelectorState extends State<PartyVideoSelector> {
  final TextEditingController _roomController = TextEditingController();
  final WatchPartyService _partyService = WatchPartyService();
  String? _createdRoomId;

  @override
  void dispose() {
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = {
      "Education": VideoData.education,
      "Health": VideoData.health,
      "News": VideoData.news,
    };

    return Scaffold(
      appBar: AppBar(title: const Text("Watch Party")),
      backgroundColor: const Color(0xFF141414),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Join Room
            const Text("Join a Room",
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _roomController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Enter Room ID",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _joinRoom, child: const Text("Join")),
              ],
            ),
            const SizedBox(height: 16),

            // Create Room
            const Text("Create a Room",
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            if (_createdRoomId != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Room ID: $_createdRoomId",
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.white),
                      onPressed: _createdRoomId == null
                          ? null
                          : () {
                              Clipboard.setData(
                                  ClipboardData(text: _createdRoomId!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Room ID copied")),
                              );
                            },
                    )
                  ],
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.keys.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories.keys.elementAt(index);
                  return ActionChip(
                    backgroundColor: Colors.grey.shade800,
                    label: Text(category,
                        style: const TextStyle(color: Colors.white)),
                    onPressed: () => _showCategoryVideos(
                        context, category, categories[category]!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _joinRoom() async {
    final roomId = _roomController.text.trim();
    if (roomId.isEmpty) return;

    try {
      await _partyService.joinParty(roomId, widget.userId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WatchPartyScreen(
            userId: widget.userId,
            partyId: roomId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Room not found or failed to join")),
      );
    }
  }

  void _showCategoryVideos(
      BuildContext context, String category, List<VideoModel> videos) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(category)),
          backgroundColor: const Color(0xFF141414),
          body: ListView.separated(
            itemCount: videos.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            separatorBuilder: (_, __) =>
                const Divider(color: Colors.white24, height: 1),
            itemBuilder: (context, index) {
              final video = videos[index];
              return ListTile(
                title:
                    Text(video.title, style: const TextStyle(color: Colors.white)),
                trailing:
                    const Icon(Icons.play_circle_fill, color: Colors.redAccent),
                onTap: () async {
                  final partyId =
                      await _partyService.createParty(widget.userId, video);
                  setState(() => _createdRoomId = partyId);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WatchPartyScreen(
                        selectedVideo: video,
                        userId: widget.userId,
                        partyId: partyId,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
