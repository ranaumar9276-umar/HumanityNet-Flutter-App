import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import 'ai_verification_service.dart'; // NEW
//import 'notification_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Current user
  User? get currentUser => _auth.currentUser;
  String? get currentUid => _auth.currentUser?.uid;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── REGISTER ───────────────────────── UPDATED
  Future<UserModel?> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String city,
    String accountType = 'individual',
    XFile? selfieFile,
  }) async {
    try {
      // Firebase Auth mein account banao
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = credential.user!.uid;
      String selfieUrl = '';

      // Selfie upload
      if (selfieFile!= null) {
        try {
          final ref = FirebaseStorage.instance
           .ref()
           .child('selfies/$uid.jpg');
          await ref.putFile(File(selfieFile.path));
          selfieUrl = await ref.getDownloadURL();
        } catch (e) {
          selfieUrl = ''; // Error pe empty rakho, register fail na ho
        }
      }

      final isAdminEmail = email.trim() == AppConstants.adminEmail;

      // User model banao
      final user = UserModel(
        uid: uid,
        fullName: fullName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        city: city.trim(),
        selfieUrl: selfieUrl,
        role: isAdminEmail? 'admin' : 'user',
        accountType: accountType,
        verificationStatus: isAdminEmail? 'approved' : 'pending',
        isVerified: isAdminEmail,
        createdAt: Timestamp.now(),
      );

      // Firestore mein save karo
      await _db.collection('users').doc(uid).set(user.toMap());

      // ── AI VERIFICATION START ── NEW ✅
      // Admin ko skip karo, baaki sab AI se check
      if (!isAdminEmail) {
        final aiService = AiVerificationService();
        await aiService.verifyUser(
          uid: uid,
          fullName: fullName.trim(),
          phone: phone.trim(),
          city: city.trim(),
          accountType: accountType,
          selfieUrl: selfieUrl,
        );
      }
      // ── AI VERIFICATION END ──

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // ── LOGIN ────────────────────────────
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = credential.user!.uid;

      // Firestore se user data lo
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      final user = UserModel.fromMap(doc.data()!);

      // Banned check
      if (user.isBanned) {
        await _auth.signOut();
        throw 'Tumhara account suspend kar diya gaya hai. Admin se rabta karo.';
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // ── LOGOUT ───────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ── GET USER ─────────────────────────
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!);
    } catch (e) {
      return null;
    }
  }

  // User stream — real time
  Stream<UserModel?> getUserStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!);
    });
  }

  // ── UPDATE PROFILE ───────────────────
  Future<void> updateProfile({
    required String uid,
    String? fullName,
    String? phone,
    String? city,
    String? photoUrl,
  }) async {
    final updates = <String, dynamic>{};
    if (fullName!= null) updates['fullName'] = fullName.trim();
    if (phone!= null) updates['phone'] = phone.trim();
    if (city!= null) updates['city'] = city.trim();
    if (photoUrl!= null) updates['photoUrl'] = photoUrl;

    await _db.collection('users').doc(uid).update(updates);
  }

  // ── UPDATE FCM TOKEN ─────────────────
  Future<void> updateFcmToken(String uid, String token) async {
    await _db.collection('users').doc(uid).update({
      'fcmToken': token,
    });
  }

  // ── INCREMENT HELP COUNT ─────────────
  Future<void> incrementHelpCount(String uid) async {
    await _db.collection('users').doc(uid).update({
      'helpCount': FieldValue.increment(1),
    });
  }

  // ── ADD BADGE ────────────────────────
  Future<void> addBadge(String uid, String badge) async {
    await _db.collection('users').doc(uid).update({
      'badges': FieldValue.arrayUnion([badge]),
    });
  }

  // ── CHECK & AWARD BADGE ──────────────
  Future<String?> checkAndAwardBadge(String uid, int helpCount) async {
    final badgeRules = AppConstants.badgeRules;

    if (badgeRules.containsKey(helpCount)) {
      final badge = badgeRules[helpCount]!;
      await addBadge(uid, badge);
      return badge; // Return badge name for celebration
    }
    return null;
  }

  // ── FORGOT PASSWORD ──────────────────
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // ── ERROR HANDLER ────────────────────
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Yeh email registered nahi hai';
      case 'wrong-password':
        return 'Password galat hai';
      case 'email-already-in-use':
        return 'Yeh email pehle se registered hai';
      case 'weak-password':
        return 'Password zyada kamzor hai';
      case 'invalid-email':
        return 'Email format sahi nahi hai';
      case 'too-many-requests':
        return 'Zyada attempts. Thodi der baad try karo';
      case 'network-request-failed':
        return 'Internet connection check karo';
      default:
        return 'Kuch gadbad ho gayi. Dobara try karo';
    }
  }
}