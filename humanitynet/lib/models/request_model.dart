import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String requestId;
  final String title;
  final String description;
  final String category;
  final String status;
  final bool isUrgent;
  final bool isAnonymous;
  final String postedBy;
  final String postedByName;
  final String city;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final int responseCount;
  final bool isFlagged;
  final Timestamp createdAt;
  final Timestamp? completedAt;

  RequestModel({
    required this.requestId,
    required this.title,
    required this.description,
    required this.category,
    this.status = 'pending',
    this.isUrgent = false,
    this.isAnonymous = false,
    required this.postedBy,
    required this.postedByName,
    required this.city,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.imageUrl = '',
    this.responseCount = 0,
    this.isFlagged = false,
    required this.createdAt,
    this.completedAt,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      requestId:     map['requestId'] ?? '',
      title:         map['title'] ?? '',
      description:   map['description'] ?? '',
      category:      map['category'] ?? '',
      status:        map['status'] ?? 'pending',
      isUrgent:      map['isUrgent'] ?? false,
      isAnonymous:   map['isAnonymous'] ?? false,
      postedBy:      map['postedBy'] ?? '',
      postedByName:  map['postedByName'] ?? '',
      city:          map['city'] ?? '',
      latitude:      (map['latitude'] ?? 0.0).toDouble(),
      longitude:     (map['longitude'] ?? 0.0).toDouble(),
      imageUrl:      map['imageUrl'] ?? '',
      responseCount: map['responseCount'] ?? 0,
      isFlagged:     map['isFlagged'] ?? false,
      createdAt:     map['createdAt'] ?? Timestamp.now(),
      completedAt:   map['completedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId':     requestId,
      'title':         title,
      'description':   description,
      'category':      category,
      'status':        status,
      'isUrgent':      isUrgent,
      'isAnonymous':   isAnonymous,
      'postedBy':      postedBy,
      'postedByName':  postedByName,
      'city':          city,
      'latitude':      latitude,
      'longitude':     longitude,
      'imageUrl':      imageUrl,
      'responseCount': responseCount,
      'isFlagged':     isFlagged,
      'createdAt':     createdAt,
      'completedAt':   completedAt,
    };
  }

  RequestModel copyWith({
    String? status,
    int? responseCount,
    bool? isFlagged,
    Timestamp? completedAt,
    String? imageUrl,
  }) {
    return RequestModel(
      requestId:     requestId,
      title:         title,
      description:   description,
      category:      category,
      status:        status ?? this.status,
      isUrgent:      isUrgent,
      isAnonymous:   isAnonymous,
      postedBy:      postedBy,
      postedByName:  postedByName,
      city:          city,
      latitude:      latitude,
      longitude:     longitude,
      imageUrl:      imageUrl ?? this.imageUrl,
      responseCount: responseCount ?? this.responseCount,
      isFlagged:     isFlagged ?? this.isFlagged,
      createdAt:     createdAt,
      completedAt:   completedAt ?? this.completedAt,
    );
  }

  // Helper getters
  bool get isPending     => status == 'pending';
  bool get isInProgress  => status == 'in_progress';
  bool get isCompleted   => status == 'completed';
}