import '../models/video_model.dart';
import '../data/video_data.dart';

class VideoService {
  // -----------------------
  // SINGLETON INSTANCE
  // -----------------------
  static final VideoService _instance = VideoService._internal();
  factory VideoService() => _instance;
  VideoService._internal();

  // -----------------------
  // IN-MEMORY WATCHLIST
  // -----------------------
  final List<VideoModel> _watchlist = [];

  // -----------------------
  // VIDEO FETCHING
  // -----------------------
  List<VideoModel> getVideosByCategory(String category) {
    switch (category.toLowerCase()) {
      case "education":
        return VideoData.education;
      case "news":
        return VideoData.news;
      case "health":
        return VideoData.health;
      default:
        return [];
    }
  }

  List<VideoModel> getAllVideos() {
    return [
      ...VideoData.education,
      ...VideoData.news,
      ...VideoData.health,
    ];
  }

  VideoModel? getVideoByTitle(String title) {
    try {
      return getAllVideos().firstWhere(
        (video) => video.title == title,
      );
    } catch (_) {
      return null;
    }
  }

  // -----------------------
  // WATCHLIST FEATURES
  // -----------------------

  /// Add video to watchlist
  void addToWatchlist(VideoModel video) {
    if (!_watchlist.any((v) => v.url == video.url)) {
      video.isInWatchlist = true;
      _watchlist.add(video);
    }
  }

  /// Remove video from watchlist
  void removeFromWatchlist(VideoModel video) {
    video.isInWatchlist = false;
    _watchlist.removeWhere((v) => v.url == video.url);
  }

  /// Toggle watchlist (useful for ❤️ button)
  void toggleWatchlist(VideoModel video) {
    isInWatchlist(video)
        ? removeFromWatchlist(video)
        : addToWatchlist(video);
  }

  /// Get all videos in watchlist
  List<VideoModel> getWatchlist() {
    return List.unmodifiable(_watchlist);
  }

  /// Check if a video is in watchlist
  bool isInWatchlist(VideoModel video) {
    return _watchlist.any((v) => v.url == video.url);
  }
}
