import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  // ── CREATE CHAT ROOM ─────────────────
  Future<String> createChat({
    required String requestId,
    required String uid1,
    required String uid2,
  }) async {
    final chatId = '${requestId}_${uid1}_$uid2';
    final chatDoc = _db.collection('chats').doc(chatId);
    final exists = await chatDoc.get();

    if (!exists.exists) {
      await chatDoc.set({
        'chatId':          chatId,
        'participants':    [uid1, uid2],
        'requestId':       requestId,
        'lastMessage':     '',
        'lastMessageTime': Timestamp.now(),
      });
    }
    return chatId;
  }

  // ── SEND MESSAGE ─────────────────────
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    final trimmedText = text.trim();
    final messageId = _uuid.v4();

    final message = MessageModel(
      messageId:  messageId,
      chatId:     chatId,
      senderId:   senderId,
      senderName: senderName,
      text:       trimmedText,
      timestamp:  Timestamp.now(),
    );

    await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await _db.collection('chats').doc(chatId).update({
      'lastMessage':     trimmedText,
      'lastMessageTime': Timestamp.now(),
    });
  }

  // ── GET MESSAGES (Stream) ────────────
  Stream<List<MessageModel>> getMessagesStream(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => MessageModel.fromMap(d.data()))
            .toList());
  }

  // ── GET MY CHATS (Stream) ────────────
  Stream<List<Map<String, dynamic>>> getMyChatsStream(String uid) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => d.data())
            .toList());
  }

  // ── MARK MESSAGES READ ───────────────
  Future<void> markMessagesRead(String chatId, String uid) async {
    final unread = await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in unread.docs) {
      final data = doc.data();
      if (data['senderId'] != uid) {
        await doc.reference.update({'isRead': true});
      }
    }
  }

  // ── GET UNREAD COUNT ─────────────────
  Stream<int> getUnreadCount(String chatId, String uid) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snap) => snap.docs
            .where((d) => d.data()['senderId'] != uid)
            .length);
  }
}