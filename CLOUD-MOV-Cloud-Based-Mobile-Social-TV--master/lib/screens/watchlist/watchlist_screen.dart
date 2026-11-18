import 'package:flutter/material.dart';
import '../../models/video_model.dart';
import '../../services/video_service.dart';
import '../watchparty/watch_party_screen.dart';

class WatchlistScreen extends StatefulWidget {
  final String userId;

  const WatchlistScreen({super.key, required this.userId});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final VideoService _videoService = VideoService();

  @override
  Widget build(BuildContext context) {
    final watchlist = _videoService.getWatchlist();

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        title: const Text("My Watchlist"),
      ),
      body: watchlist.isEmpty
          ? const Center(
              child: Text(
                "Your saved videos will appear here",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: watchlist.length,
              itemBuilder: (context, index) {
                final video = watchlist[index];

                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: video.thumbnail != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              video.thumbnail!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.play_circle_fill,
                            color: Colors.white54, size: 40),
                    title: Text(
                      video.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      video.category,
                      style: const TextStyle(color: Colors.white54),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              _videoService.removeFromWatchlist(video);
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.play_circle_fill,
                              color: Colors.redAccent),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WatchPartyScreen(
                                  selectedVideo: video,
                                  userId: widget.userId,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
