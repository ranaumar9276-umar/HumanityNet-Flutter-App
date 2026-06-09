import 'package:cloud_firestore/cloud_firestore.dart';

class ResponseModel {
  final String responseId;
  final String requestId;
  final String helperId;
  final String helperName;
  final String helperPhoto;
  final String message;
  final String chatId;
  final Timestamp createdAt;

  ResponseModel({
    required this.responseId,
    required this.requestId,
    required this.helperId,
    required this.helperName,
    this.helperPhoto = '',
    this.message = '',
    required this.chatId,
    required this.createdAt,
  });

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      responseId:  map['responseId'] ?? '',
      requestId:   map['requestId'] ?? '',
      helperId:    map['helperId'] ?? '',
      helperName:  map['helperName'] ?? '',
      helperPhoto: map['helperPhoto'] ?? '',
      message:     map['message'] ?? '',
      chatId:      map['chatId'] ?? '',
      createdAt:   map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'responseId':  responseId,
      'requestId':   requestId,
      'helperId':    helperId,
      'helperName':  helperName,
      'helperPhoto': helperPhoto,
      'message':     message,
      'chatId':      chatId,
      'createdAt':   createdAt,
    };
  }
}