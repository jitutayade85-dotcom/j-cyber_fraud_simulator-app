import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      backgroundColor: const Color(0xFF0F172A),
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
                  Icon(Icons.shield_outlined, color: Color(0xFF10B981), size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Shabash! Aapne Scam Pakda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Aapne isme kaun sa Red Flag (jhol) notice kiya?',
                style: TextStyle(color: Colors.white70, fontSize: 14),
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
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Text(
                        opt,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
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
      backgroundColor: const Color(0xFF0A0F1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Text(
          s.category,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Threat Level Pill
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'HIGH THREAT SIMULATION',
                        style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Realistic Mock Message Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF131C2E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1E293B)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF2563EB),
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
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const Text('Simulated Sender • Just now', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    s.message,
                    style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 16, height: 1.45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Two-Sided Split Decision Bar
            const Text(
              'Aapka agla kadam kya hoga?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                // Left Side: Close & Report Fraud
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                      backgroundColor: const Color(0xFF1F1218),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _onCloseAndReportTapped,
                    child: const Column(
                      children: [
                        Icon(Icons.close, color: Color(0xFFEF4444)),
                        SizedBox(height: 4),
                        Text(
                          'Close & Report',
                          style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 13),
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
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 4,
                    ),
                    onPressed: _onProceedOrLinkTapped,
                    child: const Column(
                      children: [
                        Icon(Icons.link, color: Colors.white),
                        SizedBox(height: 4),
                        Text(
                          'Proceed / Link',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
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
