import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/notification_service.dart';
import '../utils/constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final notifService = NotificationService();

    return Scaffold(
      backgroundColor: AppConstants.background,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: notifService.getNotificationsStream(auth.currentUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppConstants.primary),
            );
          }

          final notifs = snapshot.data ?? [];

          if (notifs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔔', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 16),
                  Text(
                    'Koi notification nahi',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.textDark,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifs.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final n = notifs[i];
              final isRead = n['isRead'] ?? true;

              return GestureDetector(
                onTap: () => notifService.markNotificationRead(
                  auth.currentUid,
                  n['notifId'],
                ),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isRead
                        ? Colors.white
                        : AppConstants.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isRead
                          ? AppConstants.border
                          : AppConstants.primary.withAlpha(77),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppConstants.primary.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('🔔',
                              style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              n['title'] ?? '',
                              style: GoogleFonts.outfit(
                                fontWeight: isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                color: AppConstants.textDark,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              n['body'] ?? '',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: AppConstants.textLight,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppConstants.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}