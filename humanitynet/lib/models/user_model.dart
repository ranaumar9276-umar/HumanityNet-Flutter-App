import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String city;
  final String photoUrl;
  final String selfieUrl;
  final String role;
  final String accountType;
  final String verificationStatus;
  final String verificationNote;
  final int helpCount;
  final int requestCount;
  final List<String> badges;
  final bool isVerified;
  final bool isBanned;
  final String fcmToken;
  final Timestamp createdAt;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.city,
    this.photoUrl = '',
    this.selfieUrl = '',
    this.role = 'user',
    this.accountType = 'individual',
    this.verificationStatus = 'pending',
    this.verificationNote = '',
    this.helpCount = 0,
    this.requestCount = 0,
    this.badges = const [],
    this.isVerified = false,
    this.isBanned = false,
    this.fcmToken = '',
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid:                map['uid'] ?? '',
      fullName:           map['fullName'] ?? '',
      email:              map['email'] ?? '',
      phone:              map['phone'] ?? '',
      city:               map['city'] ?? '',
      photoUrl:           map['photoUrl'] ?? '',
      selfieUrl:          map['selfieUrl'] ?? '',
      role:               map['role'] ?? 'user',
      accountType:        map['accountType'] ?? 'individual',
      verificationStatus: map['verificationStatus'] ?? 'pending',
      verificationNote:   map['verificationNote'] ?? '',
      helpCount:          map['helpCount'] ?? 0,
      requestCount:       map['requestCount'] ?? 0,
      badges:             List<String>.from(map['badges'] ?? []),
      isVerified:         map['isVerified'] ?? false,
      isBanned:           map['isBanned'] ?? false,
      fcmToken:           map['fcmToken'] ?? '',
      createdAt:          map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid':                uid,
      'fullName':           fullName,
      'email':              email,
      'phone':              phone,
      'city':               city,
      'photoUrl':           photoUrl,
      'selfieUrl':          selfieUrl,
      'role':               role,
      'accountType':        accountType,
      'verificationStatus': verificationStatus,
      'verificationNote':   verificationNote,
      'helpCount':          helpCount,
      'requestCount':       requestCount,
      'badges':             badges,
      'isVerified':         isVerified,
      'isBanned':           isBanned,
      'fcmToken':           fcmToken,
      'createdAt':          createdAt,
    };
  }

  UserModel copyWith({
    String? fullName,
    String? phone,
    String? city,
    String? photoUrl,
    String? selfieUrl,
    String? role,
    String? accountType,
    String? verificationStatus,
    String? verificationNote,
    int? helpCount,
    int? requestCount,
    List<String>? badges,
    bool? isVerified,
    bool? isBanned,
    String? fcmToken,
  }) {
    return UserModel(
      uid:                uid,
      fullName:           fullName ?? this.fullName,
      email:              email,
      phone:              phone ?? this.phone,
      city:               city ?? this.city,
      photoUrl:           photoUrl ?? this.photoUrl,
      selfieUrl:          selfieUrl ?? this.selfieUrl,
      role:               role ?? this.role,
      accountType:        accountType ?? this.accountType,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verificationNote:   verificationNote ?? this.verificationNote,
      helpCount:          helpCount ?? this.helpCount,
      requestCount:       requestCount ?? this.requestCount,
      badges:             badges ?? this.badges,
      isVerified:         isVerified ?? this.isVerified,
      isBanned:           isBanned ?? this.isBanned,
      fcmToken:           fcmToken ?? this.fcmToken,
      createdAt:          createdAt,
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isPending => verificationStatus == 'pending';
  bool get isRejected => verificationStatus == 'rejected';
  bool get isApproved => verificationStatus == 'approved';
}