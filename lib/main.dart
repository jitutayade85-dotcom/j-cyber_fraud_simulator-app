import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'app_theme.dart';
import 'models/scam_scenario.dart';
import 'screens/dashboard_screen.dart';
import 'screens/simulation_screen.dart';
import 'services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await NotificationService.showRandomScam();
    } catch (_) {}
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CyberFraudApp());

  // Background initialization after UI renders safely
  Future.microtask(() async {
    try {
      await NotificationService.init(
        onTap: (scenarioId) {
          final scenario = kScenarios.firstWhere(
            (s) => s.id == scenarioId,
            orElse: () => kScenarios.first,
          );
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => SimulationScreen(scenario: scenario),
            ),
          );
        },
      );

      await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
      await Workmanager().registerPeriodicTask(
        'cyber_fraud_periodic_alert',
        'triggerSimulatedScam',
        frequency: const Duration(hours: 4),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
        initialDelay: const Duration(minutes: 30),
      );
    } catch (e) {
      debugPrint('Background init error: $e');
    }
  });
}

class CyberFraudApp extends StatelessWidget {
  const CyberFraudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Command Simulator',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const DashboardScreen(),
    );
  }
}
