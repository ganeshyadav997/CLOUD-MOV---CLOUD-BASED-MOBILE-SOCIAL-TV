import 'package:flutter/material.dart';
import '../../models/video_model.dart';
import '../../data/video_data.dart';
import '../video/video_player_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String? selectedCategory;

  const CategoryScreen({super.key, this.selectedCategory});

  // Only main categories
  Map<String, List<VideoModel>> get mainCategories => {
        "Education": VideoData.education,
        "Health": VideoData.health,
        "News": VideoData.news,
      };

  @override
  Widget build(BuildContext context) {
    final filteredCategories = selectedCategory != null
        ? {
            selectedCategory!: mainCategories[selectedCategory!] ?? [],
          }
        : mainCategories;

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        title: Text(
          selectedCategory ?? "Categories",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: filteredCategories.entries.map((entry) {
            final categoryTitle = entry.key;
            final videos = entry.value;

            if (videos.isEmpty) return const SizedBox();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category title
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    categoryTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Horizontal scroll videos
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: videos.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      return GestureDetector(
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
                                    errorBuilder: (_, __, ___) =>
                                        _fallback(),
                                  )
                                : _fallback(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // Fallback if thumbnail missing or fails
  Widget _fallback() => Container(
        color: Colors.grey.shade900,
        child: const Center(
          child: Icon(
            Icons.play_circle_fill,
            size: 50,
            color: Colors.white54,
          ),
        ),
      );
}
