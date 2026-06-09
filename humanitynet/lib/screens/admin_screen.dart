import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/request_model.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../services/request_service.dart';
import '../utils/constants.dart';
import '../widgets/status_badge.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final RequestService _reqService = RequestService();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isAdmin) {
      return Scaffold(
        backgroundColor: const Color(0xFFF0F4FF),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🚫', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              Text(
                'Admin Access Only',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sirf admin yeh panel dekh sakta hai',
                style: GoogleFonts.outfit(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1a237e), Color(0xFF283593)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 38, height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white, size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Admin Panel',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1DB954)
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '🛡️ Admin',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TabBar(
                      controller: _tabCtrl,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelColor: const Color(0xFF1a237e),
                      unselectedLabelColor: Colors.white,
                      labelStyle: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      unselectedLabelStyle: GoogleFonts.outfit(
                        fontSize: 12,
                      ),
                      tabs: const [
                        Tab(text: '⏳ Verify Users'),
                        Tab(text: '🤝 Help Queue'),
                        Tab(text: '📋 All Requests'),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _buildVerifyUsers(),
                _buildHelpQueue(),
                _buildAllRequests(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB 1: Verify Users ──
  Widget _buildVerifyUsers() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db
          .collection('users')
          .where('verificationStatus', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
                color: AppConstants.primary),
          );
        }

        final users = (snapshot.data?.docs ?? [])
            .map((d) => UserModel.fromMap(
                d.data() as Map<String, dynamic>))
            .toList();

        if (users.isEmpty) {
          return _emptyState(
            '✅', 'Koi pending user nahi',
            'Sab users reviewed hain',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (_, i) => _userVerifyCard(users[i]),
        );
      },
    );
  }

  Widget _userVerifyCard(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Selfie
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: user.selfieUrl.isNotEmpty
                          ? Image.network(
                              user.selfieUrl,
                              width: 70, height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _avatarFallback(user),
                            )
                          : _avatarFallback(user),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            user.email,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              _infoChip(
                                  Icons.phone_outlined,
                                  user.phone,
                                  const Color(0xFF1DB954)),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              _infoChip(
                                  Icons.location_on_outlined,
                                  user.city,
                                  const Color(0xFF6B7FD4)),
                              const SizedBox(width: 8),
                              _infoChip(
                                  Icons.person_outline,
                                  user.accountType == 'helper'
                                      ? 'Helper'
                                      : 'Needs Help',
                                  const Color(0xFFF59E0B)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _rejectUser(user),
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFECACA),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.close_rounded,
                                  color: Color(0xFFEF4444), size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'Reject',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFEF4444),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _approveUser(user),
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1DB954),
                                Color(0xFF0F9C3F),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1DB954)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'Approve ✅',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB 2: Help Queue ──
  Widget _buildHelpQueue() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db
          .collection('help_queue')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
                color: AppConstants.primary),
          );
        }

        final items = snapshot.data?.docs ?? [];

        if (items.isEmpty) {
          return _emptyState(
            '🤝', 'Koi help queue nahi',
            'Jab koi "I Can Help" dabayega — yahan aayega',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final data = items[i].data() as Map<String, dynamic>;
            final docId = items[i].id;
            return _helpQueueCard(data, docId);
          },
        );
      },
    );
  }

  Widget _helpQueueCard(Map<String, dynamic> data, String docId) {
    final status = data['status'] ?? 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status == 'completed'
              ? const Color(0xFF1DB954).withOpacity(0.3)
              : const Color(0xFFF59E0B).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == 'completed'
                        ? const Color(0xFFF0FDF4)
                        : const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: status == 'completed'
                          ? const Color(0xFF1DB954)
                          : const Color(0xFFF59E0B),
                    ),
                  ),
                  child: Text(
                    status == 'completed'
                        ? '✅ Completed'
                        : '⏳ Pending Action',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: status == 'completed'
                          ? const Color(0xFF1DB954)
                          : const Color(0xFFF59E0B),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  data['requestTitle'] ?? 'Request',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Requester info
            _contactCard(
              label: '👤 Jo Help Chahta/Chahti Hai:',
              name: data['requesterName'] ?? 'Unknown',
              phone: data['requesterPhone'] ?? 'N/A',
              city: data['requesterCity'] ?? 'N/A',
              color: const Color(0xFF6B7FD4),
            ),

            const SizedBox(height: 10),

            // Helper info
            _contactCard(
              label: '🤝 Jo Help Dena Chahta/Chahti Hai:',
              name: data['helperName'] ?? 'Unknown',
              phone: data['helperPhone'] ?? 'N/A',
              city: data['helperCity'] ?? 'N/A',
              color: const Color(0xFF1DB954),
            ),

            const SizedBox(height: 14),

            // Category + Request detail
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Text(
                    AppConstants.categoryIcons[
                            data['category'] ?? 'Food'] ??
                        '🌍',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data['requestTitle'] ?? 'Help Request',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (status != 'completed') ...[
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => _markHelpComplete(docId, data),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1DB954),
                        Color(0xFF0F9C3F),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1DB954).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Help Complete — Mark as Done',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _contactCard({
    required String label,
    required String name,
    required String phone,
    required String city,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_rounded, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                name,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.phone_rounded, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                phone,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_rounded, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                city,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── TAB 3: All Requests ──
  Widget _buildAllRequests() {
    return StreamBuilder<List<RequestModel>>(
      stream: _reqService.getAllRequestsAdmin(),
      builder: (context, snapshot) {
        final requests = snapshot.data ?? [];

        if (requests.isEmpty) {
          return _emptyState(
              '📋', 'Koi request nahi', 'App mein abhi koi request nahi');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (_, i) => _requestAdminCard(requests[i]),
        );
      },
    );
  }

  Widget _requestAdminCard(RequestModel r) {
    final catColor =
        AppConstants.categoryColors[r.category] ?? AppConstants.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: r.isFlagged
              ? const Color(0xFFEF4444).withOpacity(0.3)
              : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: catColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                AppConstants.categoryIcons[r.category] ?? '🌍',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    StatusBadge(status: r.status),
                    if (r.isFlagged) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '🚩 Flagged',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: Color(0xFFEF4444)),
            onPressed: () => _deleteRequest(r),
          ),
        ],
      ),
    );
  }

  // ── ACTIONS ──
  Future<void> _approveUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).update({
      'verificationStatus': 'approved',
      'isVerified': true,
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ${user.fullName} approved!',
              style: GoogleFonts.outfit()),
          backgroundColor: const Color(0xFF1DB954),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _rejectUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).update({
      'verificationStatus': 'rejected',
      'isVerified': false,
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ ${user.fullName} rejected',
              style: GoogleFonts.outfit()),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _markHelpComplete(
      String docId, Map<String, dynamic> data) async {
    await _db.collection('help_queue').doc(docId).update({
      'status': 'completed',
      'completedAt': Timestamp.now(),
    });

    // Request bhi complete mark karo
    final requestId = data['requestId'] ?? '';
    if (requestId.isNotEmpty) {
      await _reqService.updateStatus(requestId, 'completed');
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Help complete mark kar diya!',
              style: GoogleFonts.outfit()),
          backgroundColor: const Color(0xFF1DB954),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _deleteRequest(RequestModel r) async {
    await _reqService.deleteRequest(r.requestId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request delete ho gayi',
              style: GoogleFonts.outfit()),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Widget _emptyState(String emoji, String title, String sub) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 54)),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            sub,
            style: GoogleFonts.outfit(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback(UserModel user) {
    return Container(
      width: 70, height: 70,
      color: const Color(0xFF6B7FD4).withOpacity(0.15),
      child: Center(
        child: Text(
          user.fullName.isNotEmpty
              ? user.fullName[0].toUpperCase()
              : 'U',
          style: GoogleFonts.outfit(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF6B7FD4),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}