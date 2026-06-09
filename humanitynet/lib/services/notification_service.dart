import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _db  = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // ── INITIALIZE ───────────────────────
  Future<void> initialize() async {
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(initSettings);

    FirebaseMessaging.onMessage.listen((message) {
      showLocalNotification(
        title: message.notification?.title ?? 'HumanityNet',
        body:  message.notification?.body  ?? '',
      );
    });
  }

  // ── GET FCM TOKEN ────────────────────
  Future<String?> getToken() async {
    return await _fcm.getToken();
  }

  // ── SHOW LOCAL NOTIFICATION ──────────
  Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'humanitynet_channel',
      'HumanityNet',
      channelDescription: 'HumanityNet notifications',
      importance: Importance.high,
      priority:   Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(0, title, body, details);
  }

  // ── SAVE NOTIFICATION TO FIRESTORE ───
  Future<void> saveNotification({
    required String uid,
    required String title,
    required String body,
    String  type      = 'general',
    String? relatedId,
  }) async {
    final notifId = _uuid.v4();
    await _db
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .doc(notifId)
        .set({
      'notifId':   notifId,
      'title':     title,
      'body':      body,
      'type':      type,
      'relatedId': relatedId,
      'isRead':    false,
      'createdAt': Timestamp.now(),
    });
  }

  // ── GET NOTIFICATIONS (Stream) ───────
  Stream<List<Map<String, dynamic>>> getNotificationsStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => d.data())
            .toList());
  }

  // ── MARK NOTIFICATION READ ───────────
  Future<void> markNotificationRead(String uid, String notifId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .doc(notifId)
        .update({'isRead': true});
  }

  // ── GET UNREAD COUNT ─────────────────
  Stream<int> getUnreadNotifCount(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snap) => snap.docs.length);
  }
}