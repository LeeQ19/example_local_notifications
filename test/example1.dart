// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class _MyHomePageState extends State<MyHomePage> {
//   // Notifications Plugin 생성
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     // 알림 초기화
//     init();
//   }

//   void init() async {
//     // 알림용 ICON 설정
//     const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');

//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     // 알림 초기화
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onSelectNotification: (String? payload) async {
//         //onSelectNotification은 알림을 선택했을때 발생
//         if (payload != null) {
//           debugPrint('notification payload: $payload');
//         }
//       },
//     );
//   }

//   // 알림 더미 타이틀
//   List pushTitleList = ['하하', '메메', '히히', '호호', '아아', '우우'];
//   // 알림 그룹 ID 카운트용, 알림이 올때마다 이 값을 1씩 증가 시킨다., 1부터 시작
//   int groupedNotificationCounter = 1;

//   // 알림 발생 함수!!
//   Future<void> _showGroupedNotifications() async {
//     // 알림 그룹 키
//     const String groupKey = 'com.android.example.WORK_EMAIL';
//     // 알림 채널
//     const String groupChannelId = 'grouped channel id';
//     // 채널 이름
//     const String groupChannelName = 'grouped channel name';
//     // 채널 설명
//     const String groupChannelDescription = 'grouped channel description';

//     // 더미 타이틀 랜덤으로 얻기위함
//     int num = Random().nextInt(pushTitleList.length);

//     const AndroidNotificationDetails notificationAndroidSpecifics = AndroidNotificationDetails(
//       groupChannelId,
//       groupChannelName,
//       groupChannelDescription,
//       importance: Importance.max,
//       priority: Priority.high,
//       autoCancel: true,
//       onlyAlertOnce: false,
//       groupKey: groupKey,
//     );

//     const NotificationDetails notificationPlatformSpecifics =
//         NotificationDetails(android: notificationAndroidSpecifics);

//     await flutterLocalNotificationsPlugin.show(groupedNotificationCounter, pushTitleList[num],
//         '하이제니스!! 이것은 몸체 메시지 입니다.- ${pushTitleList[num]}', notificationPlatformSpecifics);
//     groupedNotificationCounter++;

//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       groupChannelId,
//       groupChannelName,
//       groupChannelDescription,
//       onlyAlertOnce: true,
//       groupKey: groupKey,
//       setAsGroupSummary: true,
//     );
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(0, '', '', platformChannelSpecifics);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notification Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: _showGroupedNotifications,
//               child: Text("showGroupedNotifications"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
