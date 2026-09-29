import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';
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
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: const Icon(Icons.shield_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CYBER COMMAND',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Sentinel v2 • CEP Problem #7',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Simulate Alert',
            icon: const Icon(Icons.notifications_active_outlined, color: AppColors.secondary),
            onPressed: () {
              NotificationService.showRandomScam();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.surface,
                  content: Text(
                    'Simulated scam alert dispatched!',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
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
          // 1. HERO PROGRESS CARD (Circular Ring & Stats)
          SaaSCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 86,
                      height: 86,
                      child: CircularProgressIndicator(
                        value: done.isEmpty ? 0.05 : (done.length / total),
                        strokeWidth: 8,
                        backgroundColor: AppColors.surfaceMuted,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _scorePercentage >= 70 ? AppColors.success : AppColors.secondary,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_scorePercentage.toInt()}%',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'DEFENSE',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CYBER HEALTH INDEX',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
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
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildMiniStat('Solved', '${done.length}/$total', AppColors.secondary),
                          const SizedBox(width: 14),
                          _buildMiniStat('Shielded', '$correct', AppColors.success),
                          const SizedBox(width: 14),
                          _buildMiniStat('Trapped', '$wrong', AppColors.danger),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. 7-DAY DEFENSE ACTIVITY GRAPH (SMOOTH TELEMETRY BARS)
          SaaSCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.insights_rounded, color: AppColors.secondary, size: 18),
                        SizedBox(width: 8),
                        Text(
                          '7-DAY DEFENSE VELOCITY',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    StatusPill(
                      label: '${done.length} ATTEMPTS',
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _build7DayChart(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Mon', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    Text('Tue', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    Text('Wed', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    Text('Thu', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    Text('Fri', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    Text('Sat', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    Text('Today', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. LIVE SCAM RADAR (TRENDING NEWS)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'LIVE SCAM RADAR (INDIA)',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
              StatusPill(label: 'REAL-TIME', color: AppColors.secondary),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildNewsCard(
                  title: 'Digital Arrest Impersonation',
                  category: 'Critical Alert',
                  description: 'Scammers posing as CBI & FedEx on WhatsApp video calls.',
                  color: AppColors.danger,
                ),
                _buildNewsCard(
                  title: 'Fake Bijli Bill APK',
                  category: 'Malware APK',
                  description: 'Urgent power cutoff SMS asking to download unverified APK.',
                  color: AppColors.warning,
                ),
                _buildNewsCard(
                  title: 'Telegram Task Job Scam',
                  category: 'Investment Trap',
                  description: 'Fake hotel & video reviews promising ₹3,500 daily return.',
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. ACTIVE SIMULATION SCENARIOS
          const Text(
            'ACTIVE TRAINING SCENARIOS',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          ...kScenarios.map((s) {
            final isDone = done.contains(s.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SaaSCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SimulationScreen(scenario: s),
                    ),
                  );
                  _load();
                },
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppColors.success.withOpacity(0.12)
                            : AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDone
                              ? AppColors.success.withOpacity(0.3)
                              : AppColors.border,
                        ),
                      ),
                      child: Icon(
                        isDone ? Icons.check_circle_rounded : Icons.shield_outlined,
                        color: isDone ? AppColors.success : AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.category,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            s.sender,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),

          // 5. CEP VERIFIED CERTIFICATION
          SaaSCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.workspace_premium_rounded,
                      color: _allDone ? AppColors.warning : AppColors.textMuted,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'CEP Verified Certificate',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 15.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Apna full name enter karein',
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _allDone ? AppColors.primary : AppColors.surfaceMuted,
                    foregroundColor: _allDone ? Colors.white : AppColors.textMuted,
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
                  icon: const Icon(Icons.download_rounded, size: 19),
                  label: Text(
                    _allDone
                        ? 'Download Verified PDF Certificate'
                        : 'Pehle sabhi $total scenarios attempt karein',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'National Cybercrime Helpline: 1930 • cybercrime.gov.in',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _build7DayChart() {
    // 7 days simulated activity with actual current score for today
    final activityHeights = [0.35, 0.55, 0.40, 0.70, 0.60, 0.85, (done.isEmpty ? 0.2 : (done.length / kScenarios.length)).clamp(0.2, 1.0)];

    return SizedBox(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (i) {
          final isToday = i == 6;
          final heightFactor = activityHeights[i];

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 60 * heightFactor,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: isToday
                            ? [AppColors.secondary, AppColors.primary]
                            : [AppColors.surfaceMuted, AppColors.surfaceMuted.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      border: isToday
                          ? Border.all(color: AppColors.secondary.withOpacity(0.6), width: 1.2)
                          : null,
                      boxShadow: isToday
                          ? [
                              BoxShadow(
                                color: AppColors.secondary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusPill(label: category, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5, height: 1.35),
          ),
        ],
      ),
    );
  }
}
