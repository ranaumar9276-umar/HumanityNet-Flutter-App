import 'dart:convert';
//import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class AiVerificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── MAIN VERIFY FUNCTION ──────────────
  Future<Map<String, dynamic>> verifyUser({
    required String uid,
    required String fullName,
    required String phone,
    required String city,
    required String accountType,
    String selfieUrl = '',
  }) async {
    try {
      // AI se verification maango
      final result = await _callClaudeAI(
        fullName:    fullName,
        phone:       phone,
        city:        city,
        accountType: accountType,
        selfieUrl:   selfieUrl,
      );

      final score      = result['score'] as int;
      final decision   = result['decision'] as String;
      final reason     = result['reason'] as String;
      final flags      = result['flags'] as List;

      // Score ke hisab se action lo
      String verificationStatus;
      bool isVerified;

      if (score >= 80) {
        verificationStatus = 'approved';
        isVerified = true;
      } else if (score >= 50) {
        verificationStatus = 'pending';
        isVerified = false;
      } else {
        verificationStatus = 'rejected';
        isVerified = false;
      }

      // Firestore mein update karo
      await _db.collection('users').doc(uid).update({
        'verificationStatus': verificationStatus,
        'isVerified':         isVerified,
        'aiScore':            score,
        'aiDecision':         decision,
        'aiReason':           reason,
        'aiFlags':            flags,
        'aiCheckedAt':        Timestamp.now(),
      });

      // Admin ko notification save karo
      await _saveAdminNotification(
        uid:      uid,
        name:     fullName,
        score:    score,
        decision: verificationStatus,
        reason:   reason,
      );

      return {
        'status':  verificationStatus,
        'score':   score,
        'reason':  reason,
        'isVerified': isVerified,
      };
    } catch (e) {
      // AI fail hone pe pending rakhو
      await _db.collection('users').doc(uid).update({
        'verificationStatus': 'pending',
        'isVerified':         false,
        'aiReason':           'AI check failed — manual review needed',
      });

      return {
        'status':     'pending',
        'score':      0,
        'reason':     'Manual review needed',
        'isVerified': false,
      };
    }
  }

  // ── CLAUDE AI CALL ───────────────────
  Future<Map<String, dynamic>> _callClaudeAI({
    required String fullName,
    required String phone,
    required String city,
    required String accountType,
    String selfieUrl = '',
  }) async {
    final prompt = '''
You are a verification agent for HumanityNet — a humanitarian help app in Pakistan.
Your job is to verify if a new user is genuine or fake.

User Information:
- Full Name: $fullName
- Phone: $phone
- City: $city
- Account Type: ${accountType == 'helper' ? 'Wants to Help Others' : 'Needs Help'}
${selfieUrl.isNotEmpty ? '- Selfie: Provided (uploaded)' : '- Selfie: Not provided'}

Analyze this user and respond with ONLY valid JSON:
{
  "score": <number 0-100>,
  "decision": "<approve/review/reject>",
  "reason": "<one sentence explanation>",
  "flags": ["<list of concerns if any>"]
}

Scoring Guide:
- 80-100: Clearly genuine — approve automatically
- 50-79: Borderline — needs admin review  
- 0-49: Clearly fake/bot — reject automatically

Consider:
- Is the name a real Pakistani name?
- Is phone format valid (03xxxxxxxxx)?
- Is city a real Pakistani city?
- Does the account type make sense?
- Any spam/bot patterns?

Respond ONLY with JSON, nothing else.
''';

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'Content-Type':      'application/json',
        'x-api-key':         'YOUR_CLAUDE_API_KEY',
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model':      'claude-sonnet-4-20250514',
        'max_tokens': 500,
        'messages': [
          {
            'role':    'user',
            'content': prompt,
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['content'][0]['text'] as String;

      // JSON parse karo
      final cleanText = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(cleanText);
    }

    // Fallback
    return {
      'score':    60,
      'decision': 'review',
      'reason':   'AI unavailable — manual review',
      'flags':    [],
    };
  }

  // ── ADMIN NOTIFICATION ───────────────
  Future<void> _saveAdminNotification({
    required String uid,
    required String name,
    required int score,
    required String decision,
    required String reason,
  }) async {
    // Admin users ko notification bhejo
    final admins = await _db
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .get();

    for (final admin in admins.docs) {
      String emoji;
      String title;

      if (decision == 'approved') {
        emoji = '✅';
        title = 'AI ne approve kiya';
      } else if (decision == 'pending') {
        emoji = '⚠️';
        title = 'Review zaroor hai';
      } else {
        emoji = '❌';
        title = 'AI ne reject kiya';
      }

      await _db
          .collection('users')
          .doc(admin.id)
          .collection('notifications')
          .add({
        'title':     '$emoji New User: $name',
        'body':      '$title — Score: $score/100 — $reason',
        'type':      'verification',
        'relatedId': uid,
        'isRead':    false,
        'createdAt': Timestamp.now(),
      });
    }
  }

  // ── HELP COMPLETE NOTIFICATION ───────
  Future<void> sendHelpCompleteNotification({
    required String requesterUid,
    required String helperUid,
    required String requestTitle,
  }) async {
    final notif = {
      'title':     '✅ Help Complete!',
      'body':      '"$requestTitle" — Help successfully delivered!',
      'type':      'help_complete',
      'isRead':    false,
      'createdAt': Timestamp.now(),
    };

    // Requester ko
    await _db
        .collection('users')
        .doc(requesterUid)
        .collection('notifications')
        .add(notif);

    // Helper ko
    await _db
        .collection('users')
        .doc(helperUid)
        .collection('notifications')
        .add({
      ...notif,
      'title': '🏅 Shukriya! Help Complete',
      'body':  'Tumne "$requestTitle" mein help di — Badge check karo!',
    });
  }
}