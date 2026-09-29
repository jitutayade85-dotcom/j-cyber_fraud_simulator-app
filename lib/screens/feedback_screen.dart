import 'package:flutter/material.dart';

import '../app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    final accentColor = wasCorrect ? AppColors.success : AppColors.danger;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'THREAT DEBRIEF',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 15,
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
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: accentColor.withOpacity(0.4), width: 1),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withOpacity(0.12),
                    ),
                    child: Icon(
                      wasCorrect ? Icons.shield_rounded : Icons.warning_amber_rounded,
                      color: accentColor,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    wasCorrect ? 'THREAT NEUTRALIZED!' : 'COMPROMISED (TRAP TRIGGERED)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    wasCorrect
                        ? 'Shabash! Aapne scam ke red flags ko bilkul sahi pehchana.'
                        : 'Aap is fraud trap me fas sakte the! Asli zindagi me dhyan dein.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  StatusPill(
                    label: wasCorrect ? '+25 DEFENSE XP' : '-15 XP (TRAP CLICKED)',
                    color: accentColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Red Flags Breakdown Card
            SaaSCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.flag_rounded, color: AppColors.warning, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'CRITICAL RED FLAGS:',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
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
                                  color: AppColors.textSecondary,
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

            // Golden Defense Rule
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.success.withOpacity(0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'GOLDEN DEFENSE RULE:',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    scenario.safeAction,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Emergency Helpline Info Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withOpacity(0.35)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.phone_in_talk_rounded, color: AppColors.warning, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Asli fraud hone par turant 1930 Cyber Helpline par call karein ya cybercrime.gov.in par report karein.',
                      style: TextStyle(color: AppColors.warning, fontSize: 12, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Back to Dashboard
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                (route) => false,
              ),
              child: const Text(
                'CONTINUE TO COMMAND HQ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
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
