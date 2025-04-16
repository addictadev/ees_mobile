import 'package:ees/multi_providers.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'presentation/splashAndSelectLang/splash_screen.dart';
import 'app/navigation_services/navigation_manager.dart';
import 'app/utils/app_colors.dart';

class MyApp extends StatefulWidget {
  factory MyApp() => _instance;
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal();
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: MultiProviders.providers(),
          child: LocalizedApp(
            child: MaterialApp(
              theme: ThemeData(
                  scaffoldBackgroundColor: AppColors.white,
                  primaryColor: AppColors.primary,
                  textTheme:
                      GoogleFonts.cairoTextTheme(Theme.of(context).textTheme)),
              navigatorKey: NavigationManager.navigatorKey,
              localizationsDelegates: translator.delegates,
              locale: Locale('ar'),
              supportedLocales: translator.locals(),
              builder: (BuildContext context, Widget? child) {
                child = EasyLoading.init()(context, child);
                child = MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child,
                );
                return child;
              },
              title: 'EES',
              debugShowCheckedModeBanner: false,
              onGenerateRoute: (settings) {
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FadeTransition(
                      opacity: animation,
                      child: const SplashScreen(),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
