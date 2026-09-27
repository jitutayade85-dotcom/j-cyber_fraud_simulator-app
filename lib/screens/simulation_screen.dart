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
  bool _inspecting = false;

  Future<void> _decide(bool reportedAsScam) async {
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getStringList('done') ?? [];
    final firstTime = !done.contains(widget.scenario.id);
    if (firstTime) done.add(widget.scenario.id);
    await prefs.setStringList('done', done);

    final wasCorrect = reportedAsScam == widget.scenario.isScam;
    if (firstTime) {
      if (wasCorrect) {
        prefs.setInt('correct', (prefs.getInt('correct') ?? 0) + 1);
      } else {
        prefs.setInt('wrong', (prefs.getInt('wrong') ?? 0) + 1);
      }
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => FeedbackScreen(
        scenario: widget.scenario,
        reportedAsScam: reportedAsScam,
        wasCorrect: wasCorrect,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.scenario;
    return Scaffold(
      appBar: AppBar(title: Text(s.category)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const CircleAvatar(child: Icon(Icons.person)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(s.sender,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ]),
                  const SizedBox(height: 14),
                  Text(s.message, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => setState(() => _inspecting = !_inspecting),
              child: const Text('🔍 Sender/Link Inspect karo'),
            ),
            if (_inspecting)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Sender: ${s.sender}\n\nDhyan se dekho - number/link kis website se aaya hai? Bank kabhi .info/.xyz link nahi bhejta, aur paise lene ke liye PIN kabhi nahi maangta.',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.red, padding: const EdgeInsets.all(16)),
              onPressed: () => _decide(true),
              icon: const Icon(Icons.report),
              label: const Text('Ye SCAM hai - Report karo'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
              onPressed: () => _decide(false),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Ye Safe hai - Aage badho'),
            ),
          ],
        ),
      ),
    );
  }
}
