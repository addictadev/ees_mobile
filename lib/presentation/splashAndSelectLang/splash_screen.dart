import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/presentation/main_screens/main_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../app/dependency_injection/get_it_injection.dart';
import '../../app/utils/consts.dart';
import '../../app/utils/local/shared_pref_serv.dart';
import 'onboarding_screen.dart'; // Import your OnboardingScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Animation completed, you can add additional logic here if needed
        }
      });

    _controller.forward();
    navigatToNextScreen();
  }

  final sharedPref = getIt<SharedPreferencesService>();

  Future<void> navigatToNextScreen() async {
    if (sharedPref.getBool(ConstsClass.isAuthorized)) {
      Future.delayed(const Duration(seconds: 3), () {
        NavigationManager.navigatToAndFinish(MainScreen());
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        NavigationManager.navigatToAndFinish(OnboardingScreen());
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppAssets.splash), fit: BoxFit.cover),
          ),
          child: FadeTransition(
            opacity: _animation,
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset(
                AppAssets.appLogo,
                width: 80.w,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
