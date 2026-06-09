import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageId;
  final String chatId;
  final String senderId;
  final String senderName;
  final String text;
  final Timestamp timestamp;
  final bool isRead;

  MessageModel({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId:  map['messageId'] as String? ?? '',
      chatId:     map['chatId'] as String? ?? '',
      senderId:   map['senderId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? '',
      text:       map['text'] as String? ?? '',
      timestamp:  map['timestamp'] as Timestamp? ?? Timestamp.now(),
      isRead:     map['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId':  messageId,
      'chatId':     chatId,
      'senderId':   senderId,
      'senderName': senderName,
      'text':       text,
      'timestamp':  timestamp,
      'isRead':     isRead,
    };
  }

  // Mera message hai?
  bool isMine(String currentUserId) => senderId == currentUserId;
}