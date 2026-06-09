import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../providers/auth_provider.dart';
import '../services/chat_service.dart';
import '../utils/constants.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendMessage(String uid, String name) async {
    if (_msgCtrl.text.trim().isEmpty) return;

    await _chatService.sendMessage(
      chatId:     widget.chatId,
      senderId:   uid,
      senderName: name,
      text:       _msgCtrl.text,
    );

    _msgCtrl.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppConstants.background,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppConstants.primaryLight,
              child: const Text('💬'),
            ),
            const SizedBox(width: 10),
            Text(
              'Chat',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _chatService.getMessagesStream(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppConstants.primary),
                  );
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'Say hello! 👋',
                      style: GoogleFonts.outfit(
                          color: AppConstants.textLight),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final msg = messages[i];
                    final isMe = msg.isMine(auth.currentUid);
                    return _buildBubble(msg, isMe);
                  },
                );
              },
            ),
          ),

          // Input
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppConstants.surfaceGrey,
                        borderRadius: BorderRadius.circular(24),
                        border:
                            Border.all(color: AppConstants.border),
                      ),
                      child: TextField(
                        controller: _msgCtrl,
                        decoration: InputDecoration(
                          hintText: 'Message likho...',
                          hintStyle: GoogleFonts.outfit(
                            color: AppConstants.textHint,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _sendMessage(
                      auth.currentUid,
                      auth.user?.fullName ?? '',
                    ),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppConstants.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(MessageModel msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppConstants.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 6,
            )
          ],
        ),
        child: Text(
          msg.text,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: isMe ? Colors.white : AppConstants.textDark,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}