import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "global_chat"; // Firestore collection

  // Send a message
  Future<void> sendMessage(String userId, String text) async {
    final message = ChatMessage(
      id: const Uuid().v4(),
      userId: userId,
      text: text,
      timestamp: DateTime.now(),
    );

    await _firestore
        .collection(collectionPath)
        .doc(message.id)
        .set(message.toMap());
  }

  // Stream to listen to messages in real-time
  Stream<List<ChatMessage>> getMessagesStream() {
    return _firestore
        .collection(collectionPath)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }
}
