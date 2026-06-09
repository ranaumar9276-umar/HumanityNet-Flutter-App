import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/request_model.dart';
import '../providers/auth_provider.dart';
import '../services/request_service.dart';
import '../utils/constants.dart';
import '../widgets/status_badge.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final RequestService _reqService = RequestService();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: RefreshIndicator(
        color: AppConstants.primary,
        onRefresh: () => auth.refreshUser(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header
              FadeInDown(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1a237e), Color(0xFF283593)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20, 12, 20, 30),
                      child: Column(
                        children: [
                          // Back + Edit
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withOpacity(0.2),
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    _showEditDialog(context, auth),
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withOpacity(0.2),
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.edit_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Avatar
                          Container(
                            width: 86,
                            height: 86,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withOpacity(0.2),
                                  blurRadius: 16,
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                user?.fullName.isNotEmpty == true
                                    ? user!.fullName
                                        .substring(0, 2)
                                        .toUpperCase()
                                    : 'U',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1a237e),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            user?.fullName ?? 'Loading...',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.email_outlined,
                                  color: Colors.white70, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                user?.email ?? '',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  color: Colors.white70, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                user?.city ?? '',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.phone_outlined,
                                  color: Colors.white70, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                user?.phone ?? '',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Stats
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          children: [
                            _statItem(
                              icon: Icons.list_alt_rounded,
                              color: const Color(0xFF6B7FD4),
                              value:
                                  '${user?.requestCount ?? 0}',
                              label: 'Requests',
                            ),
                            _dividerV(),
                            _statItem(
                              icon: Icons.favorite_rounded,
                              color: const Color(0xFF1DB954),
                              value: '${user?.helpCount ?? 0}',
                              label: 'Helped',
                            ),
                            _dividerV(),
                            _statItem(
                              icon: Icons.star_rounded,
                              color: const Color(0xFFF59E0B),
                              value:
                                  '${user?.badges.length ?? 0}',
                              label: 'Badges',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // My Recent Requests
                    FadeInUp(
                      delay: const Duration(milliseconds: 150),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'My Requests',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      Navigator.pushNamed(context,
                                          AppRoutes.myRequests),
                                  child: Text(
                                    'See All →',
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      color: const Color(0xFF6B7FD4),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            StreamBuilder<List<RequestModel>>(
                              stream: _reqService
                                  .getMyRequestsStream(
                                      user?.uid ?? ''),
                              builder: (context, snap) {
                                final reqs = snap.data ?? [];
                                if (reqs.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Center(
                                      child: Text(
                                        'Koi request nahi — pehli request post karo!',
                                        style: GoogleFonts.outfit(
                                          color: Colors.grey[500],
                                          fontSize: 13,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                                return Column(
                                  children: reqs
                                      .take(3)
                                      .map((r) => Container(
                                            margin: const EdgeInsets
                                                .only(bottom: 8),
                                            padding:
                                                const EdgeInsets.all(
                                                    12),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                  0xFFF8FAFC),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12),
                                              border: Border.all(
                                                color: Colors.grey[200]!,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  AppConstants
                                                          .categoryIcons[
                                                      r.category] ??
                                                      '🌍',
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        r.title,
                                                        style:
                                                            GoogleFonts
                                                                .outfit(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                          color: const Color(
                                                              0xFF1A1A2E),
                                                        ),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                      Text(
                                                        r.category,
                                                        style:
                                                            GoogleFonts
                                                                .outfit(
                                                          fontSize: 11,
                                                          color: Colors
                                                              .grey[500],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                StatusBadge(
                                                    status: r.status),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Badges
                    if (user?.badges.isNotEmpty == true)
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withOpacity(0.06),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🏅 Badges Earned',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1A1A2E),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: user!.badges
                                    .map(
                                      (b) => Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFFF9E6),
                                              Color(0xFFFFF3CC),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(
                                                  100),
                                          border: Border.all(
                                            color: const Color(
                                                0xFFFBBF24),
                                          ),
                                        ),
                                        child: Text(
                                          b,
                                          style: GoogleFonts.outfit(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                const Color(0xFF92400E),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 14),

                    // Menu
                    FadeInUp(
                      delay: const Duration(milliseconds: 250),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            _menuItem(
                              icon: Icons.list_alt_rounded,
                              color: const Color(0xFF6B7FD4),
                              title: 'My Requests',
                              subtitle: 'All your posted requests',
                              onTap: () => Navigator.pushNamed(
                                  context, AppRoutes.myRequests),
                            ),
                            _menuDivider(),
                            _menuItem(
                              icon: Icons.notifications_outlined,
                              color: const Color(0xFFF59E0B),
                              title: 'Notifications',
                              subtitle: 'View all alerts',
                              onTap: () => Navigator.pushNamed(
                                  context, AppRoutes.notifications),
                            ),
                            _menuDivider(),
                            _menuItem(
                              icon: Icons.shield_outlined,
                              color: const Color(0xFF3B82F6),
                              title: 'Privacy Policy',
                              subtitle: 'Review our terms',
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Privacy Policy — Coming Soon!',
                                        style: GoogleFonts.outfit()),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                );
                              },
                            ),
                            _menuDivider(),
                            _menuItem(
                              icon: Icons.help_outline_rounded,
                              color: const Color(0xFF1DB954),
                              title: 'Help & Support',
                              subtitle: 'Contact us anytime',
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Help: humanitynet@support.com',
                                        style: GoogleFonts.outfit()),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Sign Out
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: GestureDetector(
                        onTap: () async {
                          await auth.logout();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.login);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFEF4444)
                                  .withOpacity(0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout_rounded,
                                  color: Color(0xFFEF4444), size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Sign Out',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFEF4444),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, AuthProvider auth) {
    final nameCtrl =
        TextEditingController(text: auth.user?.fullName ?? '');
    final cityCtrl =
        TextEditingController(text: auth.user?.city ?? '');
    final phoneCtrl =
        TextEditingController(text: auth.user?.phone ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: GoogleFonts.outfit(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cityCtrl,
              decoration: InputDecoration(
                labelText: 'City',
                labelStyle: GoogleFonts.outfit(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              decoration: InputDecoration(
                labelText: 'Phone',
                labelStyle: GoogleFonts.outfit(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.outfit(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              await auth.updateProfile(
                fullName: nameCtrl.text,
                city: cityCtrl.text,
                phone: phoneCtrl.text,
              );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profile updated! ✅',
                        style: GoogleFonts.outfit()),
                    backgroundColor: AppConstants.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Save',
                style: GoogleFonts.outfit(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _dividerV() {
    return Container(
        width: 1, height: 60, color: const Color(0xFFF1F5F9));
  }

  Widget _menuItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A2E),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.outfit(
            fontSize: 12, color: Colors.grey[500]),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded,
          size: 14, color: Colors.grey[400]),
    );
  }

  Widget _menuDivider() {
    return Divider(height: 1, indent: 72, color: Colors.grey[100]);
  }
}