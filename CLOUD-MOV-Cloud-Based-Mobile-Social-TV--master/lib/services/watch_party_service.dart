import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/watch_party_model.dart';
import '../models/chat_model.dart';
import '../models/video_model.dart';

class WatchPartyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "watch_parties";

  /// Create a new watch party
  Future<String> createParty(String hostId, VideoModel initialVideo) async {
    final partyId = const Uuid().v4();
    final party = WatchParty(
      partyId: partyId,
      hostId: hostId,
      currentVideo: initialVideo,
      participants: {hostId: "Host"},
      chat: [],
      isPlaying: false,
      playbackPosition: 0,
    );

    await _firestore.collection(collectionPath).doc(partyId).set(party.toMap());
    return partyId;
  }

  /// Join an existing party
  Future<void> joinParty(String partyId, String userId, {String? nickname}) async {
    final docRef = _firestore.collection(collectionPath).doc(partyId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final party = WatchParty.fromDoc(snapshot);
      if (!party.isParticipant(userId)) {
        final updatedParty = party.addParticipant(userId, nickname ?? "Guest");
        transaction.update(docRef, updatedParty.toMap());
      }
    });
  }

  /// Leave a party
  Future<void> leaveParty(String partyId, String userId) async {
    final docRef = _firestore.collection(collectionPath).doc(partyId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final party = WatchParty.fromDoc(snapshot);
      if (!party.isParticipant(userId)) return;

      final updatedParticipants = Map<String, String>.from(party.participants);
      updatedParticipants.remove(userId);

      transaction.update(docRef, {'participants': updatedParticipants});
    });
  }

  /// Fetch party state once (useful for joining)
  Future<WatchParty?> getPartyOnce(String partyId) async {
    final doc = await _firestore.collection(collectionPath).doc(partyId).get();
    if (!doc.exists) return null;
    return WatchParty.fromDoc(doc);
  }

  /// Stream party updates
  Stream<WatchParty> getPartyStream(String partyId) {
    return _firestore
        .collection(collectionPath)
        .doc(partyId)
        .snapshots()
        .map((doc) => WatchParty.fromDoc(doc));
  }

  /// Host playback controls: play/pause/seek
  /// If `position` is null, keep current; otherwise apply relative seek
  Future<void> updatePlayback(String partyId, bool isPlaying, int? position) async {
    final docRef = _firestore.collection(collectionPath).doc(partyId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final party = WatchParty.fromDoc(snapshot);
      final newPosition = position != null
          ? party.playbackPosition + position // relative seek
          : party.playbackPosition;

      final updatedParty = party.copyWith(
        isPlaying: isPlaying,
        playbackPosition: newPosition,
      );

      transaction.update(docRef, updatedParty.toMap());
    });
  }

  /// Host changes the current video
  Future<void> changeVideo(String partyId, VideoModel video) async {
    final docRef = _firestore.collection(collectionPath).doc(partyId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final party = WatchParty.fromDoc(snapshot);
      final updatedParty = party.copyWith(
        currentVideo: video,
        isPlaying: false,
        playbackPosition: 0,
      );
      transaction.update(docRef, updatedParty.toMap());
    });
  }

  /// Send chat message
  Future<void> sendMessage(String partyId, String userId, String text) async {
    final docRef = _firestore.collection(collectionPath).doc(partyId);

    final message = ChatMessage(
      id: const Uuid().v4(),
      userId: userId,
      text: text,
      timestamp: DateTime.now(),
    );

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final party = WatchParty.fromDoc(snapshot);
      final updatedParty = party.addMessage(message);
      transaction.update(docRef, updatedParty.toMap());
    });
  }

  /// Optional: Kick participant (host only)
  Future<void> removeParticipant(String partyId, String userId) async {
    final docRef = _firestore.collection(collectionPath).doc(partyId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final party = WatchParty.fromDoc(snapshot);
      if (!party.isParticipant(userId)) return;

      final updatedParticipants = Map<String, String>.from(party.participants);
      updatedParticipants.remove(userId);
      transaction.update(docRef, {'participants': updatedParticipants});
    });
  }
}
