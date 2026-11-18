class VideoModel {
  final String title;
  final String url;
  final String category;
  final String? thumbnail;

  bool isInWatchlist; // ⭐ added

  VideoModel({
    required this.title,
    required this.url,
    required this.category,
    this.thumbnail,
    this.isInWatchlist = false, // default safe
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "url": url,
      "category": category,
      "thumbnail": thumbnail,
      "isInWatchlist": isInWatchlist,
    };
  }

  static VideoModel fromMap(Map<String, dynamic> map) {
    return VideoModel(
      title: map["title"],
      url: map["url"],
      category: map["category"],
      thumbnail: map["thumbnail"],
      isInWatchlist: map["isInWatchlist"] ?? false,
    );
  }
}
