import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'models/scam_scenario.dart';
import 'screens/dashboard_screen.dart';
import 'screens/simulation_screen.dart';
import 'services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final notif = NotificationService();
      await notif.initialize();
      await notif.showRandomScamAlert();
    } catch (_) {
      // Background task fail-safe
    }
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CyberFraudApp());

  // Background initialization after UI is rendered (prevents startup crash)
  Future.microtask(() async {
    try {
      final notif = NotificationService();
      await notif.initialize(onSelectNotification: (scenarioId) {
        final scenario = kScenarios.firstWhere(
          (s) => s.id == scenarioId,
          orElse: () => kScenarios.first,
        );
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => SimulationScreen(scenario: scenario),
          ),
        );
      });

      // Register periodic simulation task
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
    const bgDark = Color(0xFF0B0F19);
    const cardDark = Color(0xFF161F30);
    const accentBlue = Color(0xFF2563EB);

    return MaterialApp(
      title: 'Cyber Command Simulator',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bgDark,
        primaryColor: accentBlue,
        cardColor: cardDark,
        colorScheme: const ColorScheme.dark(
          primary: accentBlue,
          secondary: Color(0xFF10B981),
          surface: cardDark,
          background: bgDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: cardDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(),
    );
  }
}
