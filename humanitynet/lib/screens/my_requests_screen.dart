import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/request_model.dart';
import '../providers/auth_provider.dart';
import '../services/request_service.dart';
import '../utils/constants.dart';
import '../widgets/request_card.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final reqService = RequestService();

    return Scaffold(
      backgroundColor: AppConstants.background,
      appBar: AppBar(
        title: Text(
          'My Requests',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
      ),
      body: StreamBuilder<List<RequestModel>>(
        stream: reqService.getMyRequestsStream(auth.currentUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppConstants.primary),
            );
          }

          final requests = snapshot.data ?? [];

          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('📋', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 16),
                  Text(
                    'Koi request nahi',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pehli request post karo!',
                    style: GoogleFonts.outfit(
                        color: AppConstants.textLight),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (_, i) => RequestCard(
              request: requests[i],
              index: i,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.reqDetail,
                arguments: requests[i].requestId,
              ),
            ),
          );
        },
      ),
    );
  }
}