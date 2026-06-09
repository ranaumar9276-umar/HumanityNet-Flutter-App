import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/request_model.dart';
import '../utils/constants.dart';
import 'status_badge.dart';
import 'urgency_tag.dart';

class RequestCard extends StatelessWidget {
  final RequestModel request;
  final VoidCallback onTap;
  final int index;

  const RequestCard({
    super.key,
    required this.request,
    required this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final catColor =
        AppConstants.categoryColors[request.category]?? AppConstants.primary;
    final catIcon =
        AppConstants.categoryIcons[request.category]?? '🌍';
    final timeStr = timeago.format(request.createdAt.toDate());

    return FadeInUp(
      delay: Duration(milliseconds: index * 80),
      duration: const Duration(milliseconds: 400),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppConstants.cardSpacing),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            border: Border.all(color: AppConstants.borderLight),
            boxShadow: [
              BoxShadow(
                color: request.isUrgent
                   ? AppConstants.urgent.withAlpha(26)
                    : Colors.black.withAlpha(13),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top color border
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: request.isUrgent? AppConstants.urgent : catColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.cardRadius),
                    topRight: Radius.circular(AppConstants.cardRadius),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(AppConstants.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category + Urgent row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.categoryLightColors[
                                    request.category]??
                                AppConstants.surfaceGrey,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: catColor.withAlpha(51),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(catIcon,
                                  style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 4),
                              Text(
                                request.category,
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: catColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (request.isUrgent) const UrgencyTag(),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Title
                    Text(
                      request.title,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppConstants.textDark,
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
                        color: AppConstants.textMedium,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Footer
                    Row(
                      children: [
                        // Avatar + name
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppConstants.primary,
                          child: Text(
                            request.isAnonymous
                               ? '?'
                                : (request.postedByName.isNotEmpty 
                                   ? request.postedByName[0] 
                                    : '?').toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${request.postedByName} · $timeStr',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: AppConstants.textLight,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        StatusBadge(status: request.status),
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
}