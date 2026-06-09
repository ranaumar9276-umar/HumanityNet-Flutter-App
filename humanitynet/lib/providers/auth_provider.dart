import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // NEW - XFile ke liye
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final NotificationService _notifService = NotificationService();

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get user        => _user;
  bool get isLoading         => _isLoading;
  String? get errorMessage   => _errorMessage;
  bool get isLoggedIn        => _user != null;
  bool get isAdmin           => _user?.isAdmin ?? false;
  
  String get currentUid {
    final uid = _user?.uid ?? 
        FirebaseAuth.instance.currentUser?.uid ?? '';
    return uid;
  }

  // ── INIT ─────────────────────────────
  Future<void> init() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      _user = await _authService.getUser(firebaseUser.uid);

      // FCM token update
      final token = await _notifService.getToken();
      if (token != null && _user != null) {
        await _authService.updateFcmToken(_user!.uid, token);
      }

      notifyListeners();
    }
  }

  // ── REGISTER ───────────────────────── UPDATED
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String city,
    String accountType = 'individual', // NEW
    XFile? selfieFile, // NEW - XFile use kiya dynamic ki jagah
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _authService.register(
        fullName:    fullName,
        email:       email,
        password:    password,
        phone:       phone,
        city:        city,
        accountType: accountType, // NEW
        selfieFile:  selfieFile,  // NEW
      );

      final token = await _notifService.getToken();
      if (token != null && _user != null) {
        await _authService.updateFcmToken(_user!.uid, token);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── LOGIN ────────────────────────────
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _authService.login(
        email:    email,
        password: password,
      );

      // FCM token save
      final token = await _notifService.getToken();
      if (token != null && _user != null) {
        await _authService.updateFcmToken(_user!.uid, token);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── LOGOUT ───────────────────────────
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  // ── UPDATE PROFILE ───────────────────
  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? city,
    String? photoUrl,
  }) async {
    if (_user == null) return false;
    _setLoading(true);

    try {
      await _authService.updateProfile(
        uid:      _user!.uid,
        fullName: fullName,
        phone:    phone,
        city:     city,
        photoUrl: photoUrl,
      );

      // Local user update
      _user = _user!.copyWith(
        fullName: fullName,
        phone:    phone,
        city:     city,
        photoUrl: photoUrl,
      );

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── INCREMENT HELP + BADGE CHECK ─────
  Future<String?> incrementHelpAndCheckBadge() async {
    if (_user == null) return null;

    await _authService.incrementHelpCount(_user!.uid);
    final newCount = _user!.helpCount + 1;

    // Local update
    _user = _user!.copyWith(helpCount: newCount);
    notifyListeners();

    // Badge check
    final badge = await _authService.checkAndAwardBadge(
      _user!.uid,
      newCount,
    );

    if (badge != null) {
      final updatedBadges = [..._user!.badges, badge];
      _user = _user!.copyWith(badges: updatedBadges);
      notifyListeners();
    }

    return badge;
  }

  // ── REFRESH USER ─────────────────────
  Future<void> refreshUser() async {
    if (_user == null) return;
    _user = await _authService.getUser(_user!.uid);
    notifyListeners();
  }

  // ── HELPERS ──────────────────────────
  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}