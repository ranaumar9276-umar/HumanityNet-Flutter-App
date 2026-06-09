import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/chat_service.dart';
import '../utils/constants.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final chatService = ChatService();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Column(
        children: [
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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Row(
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
                      'Help Conversations',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: chatService.getMyChatsStream(auth.currentUid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppConstants.primary),
                  );
                }

                final chats = snapshot.data ?? [];

                if (chats.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('💬',
                            style: TextStyle(fontSize: 60)),
                        const SizedBox(height: 16),
                        Text(
                          'No conversations yet',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Help someone to start a conversation',
                          style: GoogleFonts.outfit(
                              color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: chats.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final chat = chats[i];
                    final lastMsg =
                        chat['lastMessage'] ?? '';

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1a237e)
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.support_agent_rounded,
                              color: Color(0xFF1a237e),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Help Request #${i + 1}',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1A2E),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  lastMsg.isEmpty
                                      ? 'Admin will coordinate soon'
                                      : lastMsg,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}