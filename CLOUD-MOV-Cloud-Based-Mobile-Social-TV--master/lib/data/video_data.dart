import '../models/video_model.dart';

class VideoData {
  // ============================
  // EDUCATION VIDEOS
  // ============================
  static List<VideoModel> education = [
    VideoModel(
      title: "C Programming Full Course",
      url: "https://d36fm8olcsdb0x.cloudfront.net/education/c_course.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/education/thumb_edu_c_full_course.png",
      category: "education",
    ),
    VideoModel(
      title: "C++ Programming Full Course",
      url: "https://d36fm8olcsdb0x.cloudfront.net/education/cpp_course.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/education/thumb_edu_cpp_full_course.png",
      category: "education",
    ),
    VideoModel(
      title: "Java Programming Full Course",
      url: "https://d36fm8olcsdb0x.cloudfront.net/education/java_course.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/education/thumb_edu_java_full_course.png",
      category: "education",
    ),
    VideoModel(
      title: "Python Programming Full Course",
      url: "https://d36fm8olcsdb0x.cloudfront.net/education/python_course.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/education/thumb_edu_python_full_course.png",
      category: "education",
    ),
  ];

  // ============================
  // HEALTH VIDEOS
  // ============================
  static List<VideoModel> health = [
    VideoModel(
      title: "Healthy Eating Habits for Kids",
      url:
          "https://d36fm8olcsdb0x.cloudfront.net/health/Healthy%20Eating%20Habits%20For%20Kids%20_%20Learn%20Good%20Habits%20%26%20Avoid%20Junk%20Food%20_Tia%20%26%20Tofu%20_%20T-Series%20Kids%20Hut.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/health/thumb_health_kids_eating.png",
      category: "health",
    ),
    VideoModel(
      title: "How Playing Sports Benefits Your Body & Brain",
      url:
          "https://d36fm8olcsdb0x.cloudfront.net/health/How%20playing%20sports%20benefits%20your%20body%20...%20and%20your%20brain%20-%20Leah%20Lagos%20and%20Jaspal%20Ricky%20Singh%20720p.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/health/thumb_health_sports_benefits.png",
      category: "health",
    ),
    VideoModel(
      title: "How Food Affects Your Brain",
      url:
          "https://d36fm8olcsdb0x.cloudfront.net/health/How%20the%20food%20you%20eat%20affects%20your%20brain%20-%20Mia%20Nacamulli%20720p.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/health/thumb_health_food_brain.png",
      category: "health",
    ),
    VideoModel(
      title: "Kickstart a Healthy Lifestyle FAST",
      url:
          "https://d36fm8olcsdb0x.cloudfront.net/health/How%20to%20EASILY%20Kick%20Start%20A%20Healthy%20Lifestyle%20FAST!!%20720p.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/health/thumb_health_lifestyle_kickstart.png",
      category: "health",
    ),
    VideoModel(
      title: "How Your Digestive System Works",
      url:
          "https://d36fm8olcsdb0x.cloudfront.net/health/How%20your%20digestive%20system%20works%20-%20Emma%20Bryce%20720p.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/health/thumb_health_digestive_system.png",
      category: "health",
    ),
  ];

  // ============================
  // NEWS VIDEOS
  // ============================
  static List<VideoModel> news = [
    VideoModel(
      title: "Modi Hugs Putin – India Visit",
      url:
          "https://d36fm8olcsdb0x.cloudfront.net/news/Modi%20Hugs%20Putin%20as%20He%20Arrives%20on%20India%20Visit%20720p.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/news/thumb_news_modi_putin_hug.png",
      category: "news",
    ),
    VideoModel(
      title: "Putin Ends India Visit – Ceremony",
      url:
          "https://d36fm8olcsdb0x.cloudfront.net/news/Putin%20Ends%20India%20Visit%20at%20Ceremonial%20Reception%20720p.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/news/thumb_news_putin_visit_end.png",
      category: "news",
    ),
    VideoModel(
      title: "Putin Visits Modi Residence",
      url:
          "https://d36fm8olcsdb0x.cloudfront.net/news/Putin%20Visits%20Modi%20Residence%20During%20India%20Trip%20720p.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/news/thumb_news_putin_residence_visit.png",
      category: "news",
    ),
    VideoModel(
      title: "Putin’s India Visit in 2 Minutes",
      url:
          "https://d36fm8olcsdb0x.cloudfront.net/news/Putin's%20India%20Visit%20in%202%20Minutes%20720p.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/news/thumb_news_putin_visit_summary.png",
      category: "news",
    ),
    VideoModel(
      title: "Unseen Modi–Putin Meeting Moments",
      url:
          "https://d36fm8olcsdb0x.cloudfront.net/news/Unseen%20moments%20from%20PM%20Modi%E2%80%99s%20meeting%20with%20Russian%20President%20Vladimir%20Putin%20720p.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/news/thumb_news_modi_putin_unseen.png",
      category: "news",
    ),
    VideoModel(
      title: "News Compilation Clip",
      url: "https://d36fm8olcsdb0x.cloudfront.net/news/videoplayback.mp4",
      thumbnail:
          "https://dhak7phdns6f6.cloudfront.net/news/thumb_news_general_compilation.png",
      category: "news",
    ),
  ];

  // ============================
  // FEATURED / TRENDING / LATEST
  // ============================
  static List<VideoModel> featured = [
    education[0],
    health[0],
    news[0],
  ];

  static List<VideoModel> trending = [
    education[1],
    health[1],
    news[1],
  ];

  static List<VideoModel> latest = [
    education[2],
    health[2],
    news[2],
  ];
}
