import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Result & Feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              wasCorrect ? Icons.verified : Icons.warning_amber_rounded,
              color: wasCorrect ? Colors.green : Colors.red,
              size: 72,
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                wasCorrect ? 'Shabash! Sahi pakda!' : 'Galat jawab - dhyan do!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Text('🚩 Red Flags:',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ...scenario.redFlags.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(children: [
                    const Text('• '),
                    Expanded(child: Text(f)),
                  ]),
                )),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('✅ Sahi action: ${scenario.safeAction}',
                  style: const TextStyle(fontSize: 15)),
            ),
            const SizedBox(height: 28),
            FilledButton(
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                (route) => false,
              ),
              child: const Text('Dashboard par wapas jao'),
            ),
          ],
        ),
      ),
    );
  }
}
