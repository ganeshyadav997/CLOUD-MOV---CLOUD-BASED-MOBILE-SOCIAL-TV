class ChatMessage {
  final String id;          // Unique message ID
  final String userId;      // Anonymous user ID
  final String text;        // Message text
  final DateTime timestamp; // Time of sending

  ChatMessage({
    required this.id,
    required this.userId,
    required this.text,
    required this.timestamp,
  });

  // Convert ChatMessage to Map for Firestore or JSON storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create ChatMessage from Map
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      text: map['text'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
