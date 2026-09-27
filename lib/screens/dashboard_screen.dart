import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/scam_scenario.dart';
import '../services/certificate_service.dart';
import '../services/notification_service.dart';
import 'simulation_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final nameController = TextEditingController();
  List<String> done = [];
  int correct = 0, wrong = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      done = prefs.getStringList('done') ?? [];
      correct = prefs.getInt('correct') ?? 0;
      wrong = prefs.getInt('wrong') ?? 0;
      nameController.text = prefs.getString('name') ?? '';
    });
  }

  bool get _allDone => done.length >= kScenarios.length;

  @override
  Widget build(BuildContext context) {
    final total = kScenarios.length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A2342),
        foregroundColor: Colors.white,
        title: const Text('Cyber Fraud Simulator'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFF0A2342),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progress: ${done.length}/$total scenarios',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: done.length / total,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 12),
                  Text('✅ Correct: $correct    ❌ Wrong: $wrong',
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: () => NotificationService.showRandomScam(),
            icon: const Icon(Icons.notifications_active),
            label: const Text('Demo Scam Notification bhejo'),
          ),
          const Divider(height: 28),
          ...kScenarios.map((s) => Card(
                child: ListTile(
                  leading: Icon(
                    done.contains(s.id)
                        ? Icons.check_circle
                        : Icons.help_outline,
                    color: done.contains(s.id) ? Colors.green : Colors.grey,
                  ),
                  title: Text(s.category,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(s.sender),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(
                      builder: (_) => SimulationScreen(scenario: s),
                    ));
                    _load();
                  },
                ),
              )),
          const Divider(height: 28),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Certificate ke liye apna naam likho',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor:
                  _allDone ? const Color(0xFFD4AF37) : Colors.grey,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: _allDone
                ? () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('name', nameController.text);
                    await CertificateService.generateAndShare(
                      name: nameController.text.trim().isEmpty
                          ? 'Participant'
                          : nameController.text.trim(),
                      correct: correct,
                      total: kScenarios.length,
                    );
                  }
                : null,
            icon: const Icon(Icons.workspace_premium),
            label: Text(_allDone
                ? '🏆 Certificate Download karo'
                : 'Certificate: pehle sabhi $total scenarios complete karo'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Emergency: Fraud hone par 1930 par call karo ya cybercrime.gov.in par report karo.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
