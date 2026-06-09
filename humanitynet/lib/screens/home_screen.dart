import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/request_model.dart';
//import '../providers/auth_provider.dart';
import '../providers/request_provider.dart';
import '../services/request_service.dart';
import '../utils/constants.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final RequestService _requestService = RequestService();
  final _searchCtrl = TextEditingController();
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final auth = context.watch<AuthProvider>();
    final reqProvider = context.watch<RequestProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Column(
        children: [
          // ── BEAUTIFUL HEADER ──
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
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
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    children: [
                      // Top row
                      Row(
                        children: [
                          // HumanityNet beautiful box
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1DB954),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'HumanityNet',
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      Text(
                                        'Connecting Hearts',
                                        style: GoogleFonts.outfit(
                                          fontSize: 11,
                                          color:
                                              Colors.white.withOpacity(0.7),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Notification bell
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.notifications),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Search bar
                      Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: reqProvider.setSearchQuery,
                          decoration: InputDecoration(
                            hintText: 'Search help requests...',
                            hintStyle: GoogleFonts.outfit(
                              fontSize: 13,
                              color: Colors.grey[400],
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[400],
                              size: 20,
                            ),
                            suffixIcon:
                                reqProvider.searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear,
                                            size: 18),
                                        onPressed: () {
                                          _searchCtrl.clear();
                                          reqProvider.clearSearch();
                                        },
                                      )
                                    : null,
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 13),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Category filter tabs
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: AppConstants.categories.map((cat) {
                            final isSelected =
                                reqProvider.selectedCategory == cat;
                            final color = cat == 'All'
                                ? const Color(0xFF1DB954)
                                : AppConstants.categoryColors[cat] ??
                                    AppConstants.primary;
                            final icon =
                                AppConstants.categoryIcons[cat] ?? '🌍';

                            return GestureDetector(
                              onTap: () => reqProvider.setCategory(cat),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: isSelected
                                        ? color
                                        : Colors.white.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Colors.black
                                                .withOpacity(0.1),
                                            blurRadius: 8,
                                          )
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(icon,
                                        style:
                                            const TextStyle(fontSize: 14)),
                                    const SizedBox(width: 5),
                                    Text(
                                      cat,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? color
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Status tabs
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          controller: _tabController,
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
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          tabs: const [
                            Tab(text: '🟡 Pending'),
                            Tab(text: '🔵 Active'),
                            Tab(text: '✅ Done'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── REQUESTS ──
          Expanded(
            child: StreamBuilder<List<RequestModel>>(
              stream: _requestService.getRequestsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmer();
                }

                final allRequests = snapshot.data ?? [];
                reqProvider.setRequests(allRequests);

                return TabBarView(
                  controller: _tabController,
                  children: [
                    // Pending
                    _buildRequestList(
                      reqProvider.filteredRequests
                          .where((r) => r.isPending)
                          .toList(),
                      'pending',
                    ),
                    // In Progress
                    _buildRequestList(
                      reqProvider.filteredRequests
                          .where((r) => r.isInProgress)
                          .toList(),
                      'in_progress',
                    ),
                    // Completed - all including completed
                    _buildCompletedList(),
                  ],
                );
              },
            ),
          ),
        ],
      ),

      // ── BOTTOM NAV ──
      bottomNavigationBar: _buildBottomNav(context),

      // ── FAB ──
      floatingActionButton: FadeInUp(
        delay: const Duration(milliseconds: 400),
        child: FloatingActionButton.extended(
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.postRequest),
          backgroundColor: const Color(0xFF1DB954),
          elevation: 8,
          icon: const Icon(Icons.add_circle_outline,
              color: Colors.white),
          label: Text(
            'Post Request',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestList(List<RequestModel> requests, String status) {
    if (requests.isEmpty) {
      return Center(
        child: FadeIn(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                status == 'pending'
                    ? '🟡'
                    : status == 'in_progress'
                        ? '🔵'
                        : '✅',
                style: const TextStyle(fontSize: 50),
              ),
              const SizedBox(height: 12),
              Text(
                status == 'pending'
                    ? 'Koi pending request nahi'
                    : status == 'in_progress'
                        ? 'Koi active request nahi'
                        : 'Koi completed request nahi',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppConstants.primary,
      onRefresh: () async => setState(() {}),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: requests.length,
        itemBuilder: (_, i) => _buildBeautifulCard(requests[i], i),
      ),
    );
  }

  Widget _buildCompletedList() {
    return StreamBuilder<List<RequestModel>>(
      stream: _requestService.getAllRequestsAdmin(),
      builder: (context, snapshot) {
        final completed = (snapshot.data ?? [])
            .where((r) => r.isCompleted)
            .toList();

        if (completed.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('✅', style: TextStyle(fontSize: 50)),
                const SizedBox(height: 12),
                Text(
                  'Koi completed request nahi',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: completed.length,
          itemBuilder: (_, i) =>
              _buildBeautifulCard(completed[i], i),
        );
      },
    );
  }

  Widget _buildBeautifulCard(RequestModel request, int index) {
    final catColor =
        AppConstants.categoryColors[request.category] ??
            AppConstants.primary;
    final catIcon =
        AppConstants.categoryIcons[request.category] ?? '🌍';

    Color statusColor;
    String statusText;
    Color statusBg;

    switch (request.status) {
      case 'pending':
        statusColor = const Color(0xFFF59E0B);
        statusBg = const Color(0xFFFFFBEB);
        statusText = '🟡 Pending';
        break;
      case 'in_progress':
        statusColor = const Color(0xFF3B82F6);
        statusBg = const Color(0xFFEFF6FF);
        statusText = '🔵 Active';
        break;
      default:
        statusColor = const Color(0xFF16A34A);
        statusBg = const Color(0xFFF0FDF4);
        statusText = '✅ Done';
    }

    return FadeInUp(
      delay: Duration(milliseconds: index * 80),
      duration: const Duration(milliseconds: 400),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.reqDetail,
          arguments: request.requestId,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: catColor.withOpacity(0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Colored top bar
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color:
                      request.isUrgent ? const Color(0xFFEF4444) : catColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: category + urgent
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: catColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: catColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(catIcon,
                                  style:
                                      const TextStyle(fontSize: 12)),
                              const SizedBox(width: 4),
                              Text(
                                request.category,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: catColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (request.isUrgent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: const Color(0xFFFECACA)),
                            ),
                            child: Text(
                              '🚨 URGENT',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFEF4444),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Title
                    Text(
                      request.title,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 5),

                    // Description
                    Text(
                      request.description,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Footer
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: catColor.withOpacity(0.15),
                          child: Text(
                            request.isAnonymous
                                ? '?'
                                : (request.postedByName.isNotEmpty
                                    ? request.postedByName[0]
                                        .toUpperCase()
                                    : 'U'),
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: catColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${request.postedByName} • 📍${request.city}',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: statusColor.withOpacity(0.3)),
                          ),
                          child: Text(
                            statusText,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
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
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: _currentIndex == 0,
                color: const Color(0xFF1DB954),
                onTap: () => setState(() => _currentIndex = 0),
              ),
              _navItem(
                icon: Icons.volunteer_activism_rounded,
                label: 'Requests',
                isActive: _currentIndex == 1,
                color: const Color(0xFF3B82F6),
                onTap: () {
                  setState(() => _currentIndex = 1);
                  Navigator.pushNamed(context, AppRoutes.myRequests);
                },
              ),
              // Center button
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.postRequest),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1DB954), Color(0xFF0F9C3F)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color(0xFF1DB954).withOpacity(0.45),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: Colors.white, size: 28),
                ),
              ),
              _navItem(
                icon: Icons.admin_panel_settings_rounded,
                label: 'Admin',
                isActive: _currentIndex == 3,
                color: const Color(0xFFEF4444),
                onTap: () {
                  setState(() => _currentIndex = 3);
                  Navigator.pushNamed(context, AppRoutes.admin);
                },
              ),
              _navItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isActive: _currentIndex == 4,
                color: const Color(0xFF6B7FD4),
                onTap: () {
                  setState(() => _currentIndex = 4);
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? color : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? color : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        height: 140,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}