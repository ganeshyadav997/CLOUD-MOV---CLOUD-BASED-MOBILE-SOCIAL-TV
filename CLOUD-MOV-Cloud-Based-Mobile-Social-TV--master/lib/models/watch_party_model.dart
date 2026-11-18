import 'package:cloud_firestore/cloud_firestore.dart';
import 'video_model.dart';
import 'chat_model.dart';

class WatchParty {
  final String partyId;
  final String hostId;
  final VideoModel currentVideo;
  final bool isPlaying;
  final int playbackPosition; // in seconds
  final Map<String, String> participants; // userId -> nickname
  final List<ChatMessage> chat;
  final DateTime createdAt;
  final DateTime updatedAt;

  WatchParty({
    required this.partyId,
    required this.hostId,
    required this.currentVideo,
    this.isPlaying = false,
    this.playbackPosition = 0,
    Map<String, String>? participants,
    List<ChatMessage>? chat,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : participants = participants ?? {},
        chat = chat ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// CopyWith helper for easy updates
  WatchParty copyWith({
    VideoModel? currentVideo,
    bool? isPlaying,
    int? playbackPosition,
    Map<String, String>? participants,
    List<ChatMessage>? chat,
    DateTime? updatedAt,
  }) {
    return WatchParty(
      partyId: partyId,
      hostId: hostId,
      currentVideo: currentVideo ?? this.currentVideo,
      isPlaying: isPlaying ?? this.isPlaying,
      playbackPosition: playbackPosition ?? this.playbackPosition,
      participants: participants ?? this.participants,
      chat: chat ?? this.chat,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Add participant safely
  WatchParty addParticipant(String userId, String nickname) {
    final updated = Map<String, String>.from(participants);
    updated[userId] = nickname.isNotEmpty ? nickname : "Guest";
    return copyWith(participants: updated);
  }

  /// Add chat message safely
  WatchParty addMessage(ChatMessage message) {
    final updated = List<ChatMessage>.from(chat)..add(message);
    return copyWith(chat: updated);
  }

  bool isHost(String userId) => hostId == userId;
  bool isParticipant(String userId) => participants.containsKey(userId);

  /// Convert to Firestore map
  Map<String, dynamic> toMap() => {
        'partyId': partyId,
        'hostId': hostId,
        'currentVideo': currentVideo.toMap(),
        'isPlaying': isPlaying,
        'playbackPosition': playbackPosition,
        'participants': participants,
        'chat': chat.map((c) => c.toMap()).toList(),
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };

  /// Construct from Firestore
  factory WatchParty.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return WatchParty(
      partyId: data['partyId'] ?? doc.id,
      hostId: data['hostId'] ?? '',
      currentVideo: data['currentVideo'] != null
          ? VideoModel.fromMap(Map<String, dynamic>.from(data['currentVideo']))
          : VideoModel(title: "Unknown", url: "", category: ""),
      isPlaying: data['isPlaying'] ?? false,
      playbackPosition: data['playbackPosition'] ?? 0,
      participants: data['participants'] != null
          ? Map<String, String>.from(data['participants'])
          : {},
      chat: data['chat'] != null
          ? (data['chat'] as List)
              .map((c) => ChatMessage.fromMap(Map<String, dynamic>.from(c)))
              .toList()
          : [],
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['updatedAt'])
          : DateTime.now(),
    );
  }
}
