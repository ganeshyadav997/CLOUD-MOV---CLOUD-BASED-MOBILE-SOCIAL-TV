import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/video_service.dart';
import '../auth/login_screen.dart';
import '../categories/category_screen.dart';
import '../video/video_player_screen.dart';
import '../chat/global_chat_screen.dart';
import '../watchparty/party_video_selector.dart';
import '../../data/video_data.dart';
import '../../models/video_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VideoService _videoService = VideoService();

  @override
  Widget build(BuildContext context) {
    final userId = DateTime.now().millisecondsSinceEpoch.toString();

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text(
          "CloudMoV",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        backgroundColor: const Color(0xFF141414),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GlobalChatScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.group, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PartyVideoSelector(userId: userId),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await AuthService().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= FEATURED =================
            SizedBox(
              height: 220,
              child: PageView.builder(
                itemCount: VideoData.featured.length,
                controller: PageController(viewportFraction: 0.9),
                itemBuilder: (context, index) {
                  final video = VideoData.featured[index];
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  VideoPlayerScreen(url: video.url),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.grey.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: video.thumbnail != null
                                ? Image.network(
                                    video.thumbnail!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (_, __, ___) =>
                                        _fallbackBig(),
                                  )
                                : _fallbackBig(),
                          ),
                        ),
                      ),

                      // ❤️ WATCHLIST BUTTON
                      Positioned(
                        top: 12,
                        right: 12,
                        child: IconButton(
                          icon: Icon(
                            video.isInWatchlist
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              _videoService.toggleWatchlist(video);
                            });
                          },
                        ),
                      ),

                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("Play"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    VideoPlayerScreen(url: video.url),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE50914),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // ================= ROWS =================
            HorizontalVideoRow(
              title: "Education",
              videos: VideoData.education,
              videoService: _videoService,
            ),
            HorizontalVideoRow(
              title: "Health",
              videos: VideoData.health,
              videoService: _videoService,
            ),
            HorizontalVideoRow(
              title: "News",
              videos: VideoData.news,
              videoService: _videoService,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _fallbackBig() => Container(
        color: Colors.grey.shade800,
        child: const Center(
          child: Icon(Icons.play_circle_fill,
              size: 80, color: Colors.white54),
        ),
      );
}

// =====================================================
// HORIZONTAL VIDEO ROW
// =====================================================
class HorizontalVideoRow extends StatelessWidget {
  final String title;
  final List<VideoModel> videos;
  final VideoService videoService;

  const HorizontalVideoRow({
    super.key,
    required this.title,
    required this.videos,
    required this.videoService,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CategoryScreen(selectedCategory: title),
                    ),
                  );
                },
                child: const Text(
                  "See All",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: videos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final video = videos[index];
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              VideoPlayerScreen(url: video.url),
                        ),
                      );
                    },
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: video.thumbnail != null
                            ? Image.network(
                                video.thumbnail!,
                                fit: BoxFit.cover,
                              )
                            : _fallbackSmall(),
                      ),
                    ),
                  ),

                  // ❤️ WATCHLIST BUTTON
                  Positioned(
                    top: 6,
                    right: 6,
                    child: IconButton(
                      iconSize: 20,
                      icon: Icon(
                        video.isInWatchlist
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        videoService.toggleWatchlist(video);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  static Widget _fallbackSmall() => Container(
        color: Colors.grey.shade900,
        child: const Center(
          child: Icon(Icons.play_circle_fill,
              size: 50, color: Colors.white54),
        ),
      );
}
