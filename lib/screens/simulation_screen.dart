import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';
import '../models/scam_scenario.dart';
import 'feedback_screen.dart';

class SimulationScreen extends StatefulWidget {
  final ScamScenario scenario;
  const SimulationScreen({super.key, required this.scenario});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  final List<String> _quizOptions = [
    'Personal 10-digit mobile number se message aaya',
    'Paise receive karne ke liye UPI PIN/QR bola',
    'Bank ya Police kabhi WhatsApp/SMS link se warning nahi bhejte',
    'Fake ya shortened link (bit.ly, .apk) use kiya gaya',
  ];

  Future<void> _recordResult(bool wasCorrect) async {
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getStringList('done') ?? [];
    if (!done.contains(widget.scenario.id)) {
      done.add(widget.scenario.id);
      await prefs.setStringList('done', done);
      if (wasCorrect) {
        prefs.setInt('correct', (prefs.getInt('correct') ?? 0) + 1);
      } else {
        prefs.setInt('wrong', (prefs.getInt('wrong') ?? 0) + 1);
      }
    }
  }

  // Right side click: Trap triggered -> Show Red Flag Feedback
  void _onProceedOrLinkTapped() async {
    await _recordResult(false);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => FeedbackScreen(
          scenario: widget.scenario,
          reportedAsScam: false,
          wasCorrect: false,
        ),
      ),
    );
  }

  // Left side click: Close & Report -> Open Micro-Quiz Bottom Sheet
  void _onCloseAndReportTapped() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.verified_rounded, color: AppColors.success, size: 26),
                  SizedBox(width: 10),
                  Text(
                    'Shabash! Aapne Scam Pakda',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Aapne isme kaun sa Red Flag (jhol) notice kiya?',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5),
              ),
              const SizedBox(height: 16),
              ..._quizOptions.map((opt) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(ctx);
                      await _recordResult(true);
                      if (!mounted) return;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => FeedbackScreen(
                            scenario: widget.scenario,
                            reportedAsScam: true,
                            wasCorrect: true,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        opt,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 13.5),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.scenario;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: Text(
          s.category,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Threat Level Pill
            Center(
              child: StatusPill(
                label: 'HIGH THREAT SIMULATION',
                color: AppColors.danger,
                icon: Icons.warning_amber_rounded,
              ),
            ),
            const SizedBox(height: 16),

            // Realistic Mock Message Card
            SaaSCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(
                          s.sender.isNotEmpty ? s.sender[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.sender,
                              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                            const Text('Simulated Sender • Just now', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    s.message,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, height: 1.45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Two-Sided Split Decision Bar
            const Text(
              'Aapka agla kadam kya hoga?',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                // Left Side: Close & Report Fraud
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.danger, width: 1.4),
                      backgroundColor: AppColors.danger.withOpacity(0.08),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _onCloseAndReportTapped,
                    child: const Column(
                      children: [
                        Icon(Icons.close_rounded, color: AppColors.danger),
                        SizedBox(height: 4),
                        Text(
                          'Close & Report',
                          style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Right Side: Proceed / Open Link (The Trap)
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: _onProceedOrLinkTapped,
                    child: const Column(
                      children: [
                        Icon(Icons.link_rounded, color: Colors.white),
                        SizedBox(height: 4),
                        Text(
                          'Proceed / Link',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
