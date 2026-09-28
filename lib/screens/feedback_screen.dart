import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/scam_scenario.dart';
import 'dashboard_screen.dart';

class FeedbackScreen extends StatelessWidget {
  final ScamScenario scenario;
  final bool reportedAsScam;
  final bool wasCorrect;

  const FeedbackScreen({
    super.key,
    required this.scenario,
    required this.reportedAsScam,
    required this.wasCorrect,
  });

  Future<void> _dialHelpline() async {
    final uri = Uri.parse('tel:1930');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF0B0F19);
    const cardBg = Color(0xFF161F30);
    const borderColor = Color(0xFF23314E);
    final accentColor = wasCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'THREAT DEBRIEF',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Banner Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: accentColor.withOpacity(0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.15),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withOpacity(0.15),
                    ),
                    child: Icon(
                      wasCorrect ? Icons.shield_rounded : Icons.warning_amber_rounded,
                      color: accentColor,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    wasCorrect ? 'THREAT NEUTRALIZED!' : 'COMPROMISED (TRAP TRIGGERED)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    wasCorrect
                        ? 'Shabash! Aapne scam ke red flags ko bilkul sahi pehchana.'
                        : 'Aap is fraud trap me fas sakte the! Asli zindagi me dhyan dein.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  // XP Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: wasCorrect ? const Color(0xFF064E3B) : const Color(0xFF7F1D1D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      wasCorrect ? '+25 DEFENSE XP' : '-15 XP (TRAP CLICKED)',
                      style: TextStyle(
                        color: wasCorrect ? const Color(0xFF6EE7B7) : const Color(0xFFFCA5A5),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Red Flags Deep Dive Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.flag_rounded, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'CRITICAL RED FLAGS (Khatre Ke Nishan):',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...scenario.redFlags.map((flag) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('⚠️ ', style: TextStyle(fontSize: 14)),
                            Expanded(
                              child: Text(
                                flag,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Golden Rule / Safe Action
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF062826),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF059669)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: Color(0xFF34D399), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'GOLDEN DEFENSE RULE:',
                        style: TextStyle(
                          color: Color(0xFF34D399),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    scenario.safeAction,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Emergency Helpline Action
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.amber,
                side: const BorderSide(color: Colors.amber),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _dialHelpline,
              icon: const Icon(Icons.phone_in_talk, size: 20),
              label: const Text(
                'Report Real Scam: Call 1930 Cyber Helpline',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            // Back to HQ / Dashboard
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                (route) => false,
              ),
              child: const Text(
                'CONTINUE TO COMMAND HQ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
