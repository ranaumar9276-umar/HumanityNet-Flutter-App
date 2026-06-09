import 'package:flutter/material.dart';
import '../models/request_model.dart';
import '../services/request_service.dart';

class RequestProvider extends ChangeNotifier {
  final RequestService _requestService = RequestService();

  List<RequestModel> _requests = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<RequestModel> get requests      => _requests;
  String get selectedCategory          => _selectedCategory;
  String get searchQuery               => _searchQuery;
  bool get isLoading                   => _isLoading;
  String? get errorMessage             => _errorMessage;

  // Filtered requests
  List<RequestModel> get filteredRequests {
    List<RequestModel> result = [..._requests];

    // Category filter
    if (_selectedCategory != 'All') {
      result = result
          .where((r) => r.category == _selectedCategory)
          .toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((r) =>
              r.title.toLowerCase().contains(q) ||
              r.description.toLowerCase().contains(q))
          .toList();
    }

    return result;
  }

  // Urgent requests
  List<RequestModel> get urgentRequests =>
      _requests.where((r) => r.isUrgent && r.isPending).toList();

  // ── SET REQUESTS ─────────────────────
  void setRequests(List<RequestModel> requests) {
    _requests = requests;
    notifyListeners();
  }

  // ── SET CATEGORY ─────────────────────
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // ── SET SEARCH ───────────────────────
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ── CLEAR SEARCH ─────────────────────
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // ── ADD REQUEST ──────────────────────
  Future<RequestModel?> addRequest({
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
    _setLoading(true);
    _errorMessage = null;

    try {
      final request = await _requestService.addRequest(
        title:        title,
        description:  description,
        category:     category,
        postedBy:     postedBy,
        postedByName: postedByName,
        city:         city,
        isUrgent:     isUrgent,
        isAnonymous:  isAnonymous,
        latitude:     latitude,
        longitude:    longitude,
        imageUrl:     imageUrl,
      );
      return request;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // ── UPDATE STATUS ────────────────────
  Future<bool> updateStatus(String requestId, String status) async {
    try {
      await _requestService.updateStatus(requestId, status);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── DELETE REQUEST ───────────────────
  Future<bool> deleteRequest(String requestId) async {
    try {
      await _requestService.deleteRequest(requestId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── FLAG REQUEST ─────────────────────
  Future<void> flagRequest(String requestId) async {
    await _requestService.flagRequest(requestId);
  }

  // ── HELPERS ──────────────────────────
  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}