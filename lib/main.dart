import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'models/scam_scenario.dart';
import 'screens/dashboard_screen.dart';
import 'screens/simulation_screen.dart';
import 'services/notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await NotificationService.showRandomScam();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher);
  await NotificationService.init(onTap: (payload) {
    final context = NotificationService.navigatorKey.currentContext;
    if (context == null || payload == null) return;
    final scenario = kScenarios.firstWhere(
      (s) => s.id == payload,
      orElse: () => kScenarios.first,
    );
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => SimulationScreen(scenario: scenario)),
    );
  });
  await Workmanager().registerPeriodicTask(
    'cep_scam_alerts',
    'scamAlert',
    frequency: const Duration(minutes: 15),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
  );
  runApp(const CyberSafeApp());
}

class CyberSafeApp extends StatelessWidget {
  const CyberSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Fraud Simulator',
      debugShowCheckedModeBanner: false,
      navigatorKey: NotificationService.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A2342)),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
