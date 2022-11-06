import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_local_notifications_example/notification_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadger.removeBadge();
    }
  }

  Future<void> _init() async {
    await _configureLocalTimeZone();
    await _initializeNotification();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> _initializeNotification() async {
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _registerMessage({
    required int id,
    required String group,
    required String message,
  }) async {
    const String groupKey = 'com.android.example.WORK_EMAIL';
    const String groupChannelId = 'grouped channel id';
    const String groupChannelName = 'grouped channel name';
    const String groupChannelDescription = 'grouped channel description';

    const AndroidNotificationDetails notificationAndroidSpecifics = AndroidNotificationDetails(
      groupChannelId,
      groupChannelName,
      channelDescription: groupChannelDescription,
      icon: 'ic_notification',
      importance: Importance.max,
      priority: Priority.high,
      groupKey: groupKey,
      autoCancel: true,
      onlyAlertOnce: false,
    );
    const DarwinNotificationDetails notificationIOSSpecifics = DarwinNotificationDetails(
      badgeNumber: 1,
    );
    const NotificationDetails notificationPlatformSpecifics = NotificationDetails(
      android: notificationAndroidSpecifics,
      iOS: notificationIOSSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      'Show Notification: $group',
      message,
      notificationPlatformSpecifics,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      groupChannelId,
      groupChannelName,
      channelDescription: groupChannelDescription,
      groupKey: groupKey,
      setAsGroupSummary: true,
      onlyAlertOnce: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: notificationIOSSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      '',
      '',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    // NotificationService notification = NotificationService();
    // _cancelNotification();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Notifications'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () async {
              await _requestPermissions();
              await _registerMessage(
                id: tz.TZDateTime.now(tz.local).hashCode,
                group: 'first',
                message: 'This notification occured by #1',
              );
            },
            child: const Text('Show Notification #1'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _requestPermissions();
              await _registerMessage(
                id: tz.TZDateTime.now(tz.local).hashCode,
                group: 'second',
                message: 'This notification occured by #2',
              );
            },
            child: const Text('Show Notification #2'),
          ),
        ],
      ),
    );
  }
}
