import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/request_model.dart';
import '../utils/constants.dart';

class RequestService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  // ── ADD REQUEST ──────────────────────
  Future<RequestModel> addRequest({
    required String title,
    required String description,
    required String category,
    required String postedBy,
    required String postedByName,
    required String city,
    bool isUrgent = false,
    bool isAnonymous = false,
    double latitude = 0.0,
    double longitude = 0.0,
    String imageUrl = '',
  }) async {
    final activeCount = await getActiveRequestCount(postedBy);
    if (activeCount >= AppConstants.maxActiveRequests) {
      throw 'Aap zyada se zyada ${AppConstants.maxActiveRequests} active requests rakh sakte ho';
    }

    final requestId = _uuid.v4();
    final request = RequestModel(
      requestId:    requestId,
      title:        title.trim(),
      description:  description.trim(),
      category:     category,
      status:       'pending',
      isUrgent:     isUrgent,
      isAnonymous:  isAnonymous,
      postedBy:     postedBy,
      postedByName: isAnonymous ? 'Anonymous' : postedByName,
      city:         city,
      latitude:     latitude,
      longitude:    longitude,
      imageUrl:     imageUrl,
      createdAt:    Timestamp.now(),
    );

    await _db.collection('requests').doc(requestId).set(request.toMap());

    await _db.collection('users').doc(postedBy).update({
      'requestCount': FieldValue.increment(1),
    });

    return request;
  }

  // ── GET ALL REQUESTS (Stream) ──────── FIXED
  Stream<List<RequestModel>> getRequestsStream() {
    return _db
        .collection('requests')
        .where('status', whereIn: ['pending', 'in_progress']) // INDEX USE KIYA
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      List<RequestModel> requests = snapshot.docs
          .map((doc) => RequestModel.fromMap(doc.data()))
          .toList();

      // Urgent top pe sort karo
      requests.sort((a, b) {
        if (a.isUrgent && !b.isUrgent) return -1;
        if (!a.isUrgent && b.isUrgent) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });

      return requests;
    });
  }

  // ── GET MY REQUESTS (Stream) ─────────
  Stream<List<RequestModel>> getMyRequestsStream(String uid) {
    return _db
        .collection('requests')
        .where('postedBy', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => RequestModel.fromMap(d.data()))
            .toList());
  }

  // ── GET SINGLE REQUEST ───────────────
  Future<RequestModel?> getRequest(String requestId) async {
    final doc = await _db.collection('requests').doc(requestId).get();
    if (!doc.exists) return null;
    return RequestModel.fromMap(doc.data()!);
  }

  Stream<RequestModel?> getRequestStream(String requestId) {
    return _db
        .collection('requests')
        .doc(requestId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return RequestModel.fromMap(doc.data()!);
    });
  }

  // ── UPDATE STATUS ────────────────────
  Future<void> updateStatus(String requestId, String status) async {
    final updates = <String, dynamic>{'status': status};
    if (status == 'completed') {
      updates['completedAt'] = Timestamp.now();
    }
    await _db.collection('requests').doc(requestId).update(updates);
  }

  // ── INCREMENT RESPONSE COUNT ─────────
  Future<void> incrementResponseCount(String requestId) async {
    await _db.collection('requests').doc(requestId).update({
      'responseCount': FieldValue.increment(1),
    });
  }

  // ── DELETE REQUEST ───────────────────
  Future<void> deleteRequest(String requestId) async {
    await _db.collection('requests').doc(requestId).delete();
  }

  // ── FLAG REQUEST ─────────────────────
  Future<void> flagRequest(String requestId) async {
    await _db.collection('requests').doc(requestId).update({
      'isFlagged': true,
    });
  }

  // ── GET ACTIVE COUNT ─────────────────
  Future<int> getActiveRequestCount(String uid) async {
    final snap = await _db
        .collection('requests')
        .where('postedBy', isEqualTo: uid)
        .where('status', whereIn: ['pending', 'in_progress'])
        .get();
    return snap.docs.length;
  }

  // ── ADMIN — ALL REQUESTS ─────────────
  Stream<List<RequestModel>> getAllRequestsAdmin() {
    return _db
        .collection('requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => RequestModel.fromMap(d.data()))
            .toList());
  }

  // ── ADMIN — FLAGGED REQUESTS ─────────
  Stream<List<RequestModel>> getFlaggedRequests() {
    return _db
        .collection('requests')
        .where('isFlagged', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => RequestModel.fromMap(d.data()))
            .toList());
  }
}