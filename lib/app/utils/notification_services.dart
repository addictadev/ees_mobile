// import 'dart:convert';
// import 'dart:developer';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:dio/dio.dart';

// class NotificationService {
//   factory NotificationService() {
//     return _instance;
//   }

//   NotificationService._internal();
//   static final NotificationService _instance = NotificationService._internal();
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();
//   final Dio _dio = Dio();

//   /// Initializes the notification service
//   Future<void> init() async {
//     await _requestPermissions();
//     await initializePlatformNotifications();
//     _listenToFirebaseMessages();
//   }

//   /// Requests notification permissions
//   Future<void> _requestPermissions() async {
//     final NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     log('User granted permission: ${settings.authorizationStatus}');
//   }

//   /// Initializes local notifications for different platforms
//   Future<void> initializePlatformNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/ic_notification_iconn');

//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//       // onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
//     );

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await _localNotifications.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onSelectNotification,
//     );
//   }

//   /// Listens to foreground and background Firebase messages
//   void _listenToFirebaseMessages() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       log('Message received: ${message.data.toString()}');
//       _handleMessage(message);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       log('Message opened from background: $message');
//       _handleMessageTap(message);
//     });
//   }

//   /// Handles message data for foreground notifications
//   void _handleMessage(RemoteMessage message) {
//     try {
//       if (message.notification != null) {
//         final String title = message.notification!.title ?? "";
//         final String body = message.notification!.body ?? "";
//         final String payload = json.encode(message.data);
//         showLocalNotification(
//             id: 0, title: title, body: body, payload: payload);
//       }
//     } catch (e) {
//       log('Error handling message: $e');
//     }
//   }

//   /// Shows local notifications with optional images
//   Future<void> showLocalNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     final String? imageUrl =
//         payload != null ? jsonDecode(payload)["image"] : null;
//     final platformChannelSpecifics = await _notificationDetails(imageUrl);
//     await _localNotifications.show(id, title, body, platformChannelSpecifics,
//         payload: payload);
//   }

//   /// Configures notification details, including handling images
//   Future<NotificationDetails> _notificationDetails(String? imageUrl) async {
//     final String? base64Image =
//         imageUrl != null ? await _base64encodedImage(imageUrl) : null;

//     final AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       '965',
//       'Public Notification',
//       importance: Importance.max,
//       priority: Priority.high,
//       styleInformation: base64Image != null
//           ? BigPictureStyleInformation(
//               ByteArrayAndroidBitmap.fromBase64String(base64Image),
//               largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Image),
//             )
//           : null,
//     );

//     final DarwinNotificationDetails iosNotificationDetails = imageUrl != null
//         ? DarwinNotificationDetails(
//             attachments: [DarwinNotificationAttachment(imageUrl)])
//         : const DarwinNotificationDetails();

//     return NotificationDetails(
//         android: androidNotificationDetails, iOS: iosNotificationDetails);
//   }

//   /// Handles when a user taps a notification
//   void _onSelectNotification(NotificationResponse? response) {
//     if (response != null) {
//       log("Notification tapped: ${response.payload}");
//       _handleMessageTap(RemoteMessage(data: jsonDecode(response.payload!)));
//     }
//   }

//   void _handleMessageTap(RemoteMessage message) {
//     log("Tapped notification data: ${message.data}");
//     // NavigationManager.navigatTo(const NotificationsScreen());
//   }

//   Future<String> _base64encodedImage(String url) async {
//     try {
//       final Response<List<int>> response = await _dio.get<List<int>>(
//         url,
//         options: Options(responseType: ResponseType.bytes),
//       );
//       return base64Encode(response.data!);
//     } catch (e) {
//       log('Error downloading image: $e');
//       return 'fallback_base64_image';
//     }
//   }

//   void _onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) {
//     log('Received iOS notification: id=$id, title=$title, body=$body, payload=$payload');
//     _handleMessageTap(RemoteMessage(data: jsonDecode(payload!)));
//   }
// }
