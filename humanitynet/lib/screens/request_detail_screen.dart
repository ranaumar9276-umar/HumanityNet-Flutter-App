import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart'; // NEW
import '../models/request_model.dart';
import '../models/user_model.dart'; // NEW
import '../providers/auth_provider.dart';
import '../services/request_service.dart';
//import '../services/chat_service.dart';
//import '../services/notification_service.dart';
import '../utils/constants.dart';
import '../widgets/status_badge.dart';
import '../widgets/urgency_tag.dart';
import '../widgets/custom_button.dart';

class RequestDetailScreen extends StatelessWidget {
  final String requestId;

  const RequestDetailScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final reqService = RequestService();
   // final chatService = ChatService();
    //final notifService = NotificationService();

    return Scaffold(
      backgroundColor: AppConstants.background,
      body: StreamBuilder<RequestModel?>(
        stream: reqService.getRequestStream(requestId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstants.primary,
              ),
            );
          }

          final request = snapshot.data;
          if (request == null) {
            return const Center(child: Text('Request nahi mili'));
          }

          final isOwner = request.postedBy == auth.currentUid;
          final catColor =
              AppConstants.categoryColors[request.category]??
                  AppConstants.primary;
          final catIcon =
              AppConstants.categoryIcons[request.category]?? '🌍';

          return CustomScrollView(
            slivers: [
              // App bar with category color
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                backgroundColor: catColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [catColor, catColor.withAlpha(179)],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(catIcon,
                              style: const TextStyle(fontSize: 50)),
                          const SizedBox(height: 8),
                          Text(
                            request.category,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  if (!isOwner)
                    IconButton(
                      icon: const Icon(Icons.flag_outlined,
                          color: Colors.white),
                      onPressed: () async {
                        await reqService.flagRequest(requestId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Report send kar diya gaya')),
                          );
                        }
                      },
                    ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Urgent + Status row
                      FadeInDown(
                        child: Row(
                          children: [
                            if (request.isUrgent)...[
                              const UrgencyTag(),
                              const SizedBox(width: 8),
                            ],
                            StatusBadge(status: request.status),
                            const Spacer(),
                            Text(
                              timeago.format(
                                  request.createdAt.toDate()),
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: AppConstants.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Title
                      FadeInDown(
                        delay: const Duration(milliseconds: 80),
                        child: Text(
                          request.title,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppConstants.textDark,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Description
                      FadeInDown(
                        delay: const Duration(milliseconds: 120),
                        child: Text(
                          request.description,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            color: AppConstants.textMedium,
                            height: 1.7,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Posted by card
                      FadeInUp(
                        delay: const Duration(milliseconds: 150),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border:
                                Border.all(color: AppConstants.border),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor:
                                    AppConstants.primaryLight,
                                child: Text(
                                  request.isAnonymous
                                  ? '?'
                                      : (request.postedByName.isNotEmpty
                                      ? request.postedByName[0]
                                          : '?').toUpperCase(),
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppConstants.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.postedByName,
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w600,
                                      color: AppConstants.textDark,
                                    ),
                                  ),
                                  Text(
                                    '📍 ${request.city}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: AppConstants.textLight,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                '${request.responseCount} responses',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: AppConstants.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Action buttons
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: isOwner
                        ? Column(
                                children: [
                                  if (!request.isCompleted)
                                    CustomButton(
                                      text: '✅ Mark as Completed',
                                      onPressed: () async {
                                        await reqService.updateStatus(
                                          requestId,
                                          'completed',
                                        );
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  if (request.isCompleted)
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppConstants.successLight,
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      child: Text(
                                        '✅ Request Completed!',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w700,
                                          color: AppConstants.success,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            : request.isCompleted
                            ? Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppConstants.successLight,
                                      borderRadius:
                                          BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      '✅ Already Completed',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w700,
                                        color: AppConstants.success,
                                      ),
                                    ),
                                  )
                                : CustomButton(
                                    text: '🤝 I Can Help',
                                    // ── UPDATED ONPRESSED ── ✅
                                    onPressed: () async {
                                      try {
                                        final auth = context.read<AuthProvider>();

                                        // Helper ka data lo
                                        final helperData = await FirebaseFirestore.instance
                                           .collection('users')
                                           .doc(auth.currentUid)
                                           .get();
                                        final helperUser = UserModel.fromMap(helperData.data()!);

                                        // Requester ka data lo
                                        final requesterData = await FirebaseFirestore.instance
                                           .collection('users')
                                           .doc(request.postedBy)
                                           .get();
                                        final requesterUser =
                                            UserModel.fromMap(requesterData.data()!);

                                        // Admin queue mein add karo
                                        await FirebaseFirestore.instance
                                           .collection('help_queue')
                                           .add({
                                          'requestId': requestId,
                                          'requestTitle': request.title,
                                          'category': request.category,
                                          'helperUid': auth.currentUid,
                                          'helperName': helperUser.fullName,
                                          'helperPhone': helperUser.phone,
                                          'helperCity': helperUser.city,
                                          'requesterUid': request.postedBy,
                                          'requesterName': requesterUser.fullName,
                                          'requesterPhone': requesterUser.phone,
                                          'requesterCity': requesterUser.city,
                                          'status': 'pending',
                                          'createdAt': Timestamp.now(),
                                        });

                                        // Request status update
                                        await reqService.updateStatus(requestId, 'in_progress');
                                        await reqService.incrementResponseCount(requestId);

                                        // helpCount
                                        await context
                                           .read<AuthProvider>()
                                           .incrementHelpAndCheckBadge();

                                        if (!context.mounted) return;

                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20)),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text('🎉',
                                                    style: TextStyle(fontSize: 50)),
                                                const SizedBox(height: 12),
                                                Text(
                                                  'Shukriya!',
                                                  style: GoogleFonts.playfairDisplay(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(0xFF1A1A2E),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Tumhari help request admin ko bhej di gayi hai. '
                                                  'Admin jald hi dono parties se rabta karega '
                                                  'aur help coordinate karega.',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 13,
                                                    color: Colors.grey[600],
                                                    height: 1.6,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.symmetric(vertical: 13),
                                                    decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        colors: [
                                                          Color(0xFF1DB954),
                                                          Color(0xFF0F9C3F),
                                                        ],
                                                      ),
                                                      borderRadius: BorderRadius.circular(14),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Theek Hai 👍',
                                                        style: GoogleFonts.outfit(
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error: $e',
                                                  style: GoogleFonts.outfit()),
                                              backgroundColor: const Color(0xFFEF4444),
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12)),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}