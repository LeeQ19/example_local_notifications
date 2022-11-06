import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'channel_id',
  'channel name',
  description: 'channel description',
  groupId: "Notification_group",
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationplugin = FlutterLocalNotificationsPlugin();

class NotificationService {
  getNotification({
    required int id,
    required String group,
    required String message,
  }) async {
    // await flutterLocalNotificationplugin
    //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
    //     .createNotificationChannel(channel);
    const intializationSettingsAndroid = AndroidInitializationSettings('ic_notification');
    const initializationSettings = InitializationSettings(
      android: intializationSettingsAndroid,
    );
    flutterLocalNotificationplugin.initialize(initializationSettings);
    AndroidNotificationDetails notificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: channel.groupId,
    );
    NotificationDetails notificationDetailsPlatformSpefics = NotificationDetails(
      android: notificationDetails,
    );
    flutterLocalNotificationplugin.show(
      id,
      'Show Notification: $group',
      message,
      notificationDetailsPlatformSpefics,
    );

    List<ActiveNotification>? activeNotifications = await flutterLocalNotificationplugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();
    if (activeNotifications!.isNotEmpty) {
      List<String> lines = activeNotifications.map((e) => e.title.toString()).toList();
      InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        contentTitle: '${activeNotifications.length - 1} messages',
        summaryText: '${activeNotifications.length - 1} messages',
      );
      AndroidNotificationDetails groupNotificationDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        styleInformation: inboxStyleInformation,
        setAsGroupSummary: true,
        groupKey: channel.groupId,
      );

      NotificationDetails groupNotificationDetailsPlatformSpefics = NotificationDetails(
        android: groupNotificationDetails,
      );
      await flutterLocalNotificationplugin.show(
        0,
        '',
        '',
        groupNotificationDetailsPlatformSpefics,
      );
    }
  }
}
