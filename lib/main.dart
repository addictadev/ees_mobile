import 'dart:io';
import 'package:ees/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'app/dependency_injection/get_it_injection.dart';
import 'app.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'app/utils/network/dio_helper.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   log("Handling a background message: ${message.data}");

//   NotificationService().showLocalNotification(
//     id: 1,
//     title: message.notification?.title ?? "No Title",
//     body: message.notification?.body ?? "No Body",
//     payload: json.encode(message.data),
//   );
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  HttpOverrides.global = MyHttpOverrides();

  await initDependencyInjection();
  //   await NotificationService().init();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await translator.init(
    localeType: LocalizationDefaultType.device,
    language: 'ar',
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/translation/',
  );
  await DioHelper.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(Phoenix(child: MyApp()));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.orange
    ..backgroundColor = AppColors.white
    ..indicatorColor = AppColors.orange
    ..userInteractions = true
    ..dismissOnTap = false;
}
