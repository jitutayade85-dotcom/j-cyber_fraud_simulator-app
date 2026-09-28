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
  double get _scorePercentage =>
      done.isEmpty ? 0 : ((correct / done.length) * 100).clamp(0, 100);

  @override
  Widget build(BuildContext context) {
    final total = kScenarios.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shield, color: Color(0xFF38BDF8), size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CYBER DEFENDER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'CEP Problem #7 • Active Sentinel',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Simulate Notification',
            icon: const Icon(Icons.notifications_active_outlined, color: Color(0xFF38BDF8)),
            onPressed: () {
              NotificationService.showRandomScam();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Simulated Scam notification bhej di gayi hai!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. HERO PROGRESS CARD (SaaS Defense Ring & Stats)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF334155)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Circular Defense Ring
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: done.isEmpty ? 0.05 : (done.length / total),
                        strokeWidth: 9,
                        backgroundColor: const Color(0xFF334155),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _scorePercentage >= 70
                              ? const Color(0xFF10B981)
                              : const Color(0xFF38BDF8),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_scorePercentage.toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'DEFENSE',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                // Stats Summary
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cyber Health Index',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _scorePercentage >= 80
                            ? '🛡️ Gold Sentinel'
                            : (_scorePercentage >= 50
                                ? '⚡ Silver Vigilant'
                                : '⚠️ Vulnerable State'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildMiniStat('Solved', '${done.length}/$total', const Color(0xFF38BDF8)),
                          const SizedBox(width: 14),
                          _buildMiniStat('Shielded', '$correct', const Color(0xFF10B981)),
                          const SizedBox(width: 14),
                          _buildMiniStat('Trapped', '$wrong', const Color(0xFFEF4444)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. LIVE SCAM RADAR (TRENDING NEWS)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'LIVE SCAM RADAR (INDIA)',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                'UPDATED TODAY',
                style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 125,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildNewsCard(
                  title: 'Digital Arrest Gang Seized',
                  category: 'High Alert',
                  description: 'Fraudsters pretending as CBI & FedEx on WhatsApp video calls.',
                  color: const Color(0xFFDC2626),
                ),
                _buildNewsCard(
                  title: 'Fake Bijli Bill APK Alert',
                  category: 'Malware',
                  description: 'Disconnection SMS asking to download unverified .apk file.',
                  color: const Color(0xFFF59E0B),
                ),
                _buildNewsCard(
                  title: 'Telegram Rating Scam',
                  category: 'Job Trap',
                  description: 'Fake hotel reviews promising ₹3,500 daily profit.',
                  color: const Color(0xFF8B5CF6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. FRAUD DEFENSE BLOG & PROTOCOL
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131C2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.lightbulb_outline, color: Color(0xFFFACC15), size: 20),
                    SizedBox(width: 8),
                    Text(
                      '30-Second Defense Tip: UPI Golden Rule',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'UPI PIN sirf paise BHEJNE ke liye hota hai. Agar koi bole ki "Cashback lene ke liye PIN enter karo ya QR scan karo", toh wo 100% scam hai.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. ACTIVE SIMULATION SCENARIOS
          const Text(
            'ACTIVE SCENARIOS (TRAIN NOW)',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          ...kScenarios.map((s) {
            final isDone = done.contains(s.id);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF131C2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDone ? const Color(0xFF10B981).withOpacity(0.4) : const Color(0xFF1E293B),
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isDone
                      ? const Color(0xFF10B981).withOpacity(0.2)
                      : const Color(0xFF334155),
                  child: Icon(
                    isDone ? Icons.check_circle : Icons.shield_outlined,
                    color: isDone ? const Color(0xFF10B981) : Colors.white70,
                    size: 20,
                  ),
                ),
                title: Text(
                  s.category,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                ),
                subtitle: Text(
                  s.sender,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 14),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SimulationScreen(scenario: s),
                    ),
                  );
                  _load();
                },
              ),
            );
          }),
          const SizedBox(height: 20),

          // 5. CEP VERIFIED CERTIFICATION
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF111827)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _allDone ? const Color(0xFFF59E0B) : const Color(0xFF334155),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      color: _allDone ? const Color(0xFFF59E0B) : Colors.grey,
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'CEP Verified Certificate',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Certificate ke liye apna full name enter karein',
                    hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF0A0F1D),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF334155)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF334155)),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _allDone ? const Color(0xFFF59E0B) : const Color(0xFF334155),
                    foregroundColor: _allDone ? Colors.black : Colors.white54,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                            total: total,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.download),
                  label: Text(
                    _allDone
                        ? 'Download Verified PDF Certificate'
                        : 'Pehle sabhi $total scenarios attempt karein',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'National Cybercrime Helpline: 1930 | cybercrime.gov.in',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String category,
    required String description,
    required Color color,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF131C2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category.toUpperCase(),
                  style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white54, fontSize: 11, height: 1.3),
          ),
        ],
      ),
    );
  }
}
