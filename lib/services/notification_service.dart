import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/scam_scenario.dart';

class NotificationService {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final _plugin = FlutterLocalNotificationsPlugin();
  static void Function(String?)? _onTap;

  static Future<void> init({void Function(String?)? onTap}) async {
    _onTap = onTap;
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) =>
          _onTap?.call(response.payload),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showRandomScam() async {
    final random = Random();
    final scenario = kScenarios[random.nextInt(kScenarios.length)];
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    await _plugin.show(
      scenario.id.hashCode,
      scenario.sender,
      scenario.message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scam_alerts',
          'Scam Alerts',
          channelDescription: 'Simulated fraud messages for training',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: scenario.id,
    );
  }
}
