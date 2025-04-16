import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/presentation/Auth_screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../app/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(AppAssets.bg1),
          Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: [
                    OnboardingPage(
                      image: AppAssets.onboardingOne,
                      title: "أفضل المنتجات",
                      description:
                          "اكتشف منتجات مميزة واطلب فاتورة من\n المورد للقرب لك",
                    ),
                    OnboardingPage(
                      image: AppAssets.onboardingTwo,
                      title: "طلبيتك في ميعادها!",
                      description:
                          "تقدم نتائج حالة الطلبة و هتوصلك\n في ميعادها",
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 2,
                      effect: WormEffect(),
                    ),
                    AppButton(
                      'دخول',
                      width: 45.w,
                      onTap: () =>
                          NavigationManager.navigatToAndFinish(LoginScreen()),
                    )
                  ],
                ),
              ),
              4.height
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingPage(
      {super.key,
      required this.title,
      required this.image,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          20.height,
          Image.asset(
            image,
            // width: 65.w,
            height: 35.h,
            fit: BoxFit.contain,
          ),
          4.height,
          CustomText(
            text: title,
            fontSize: AppFonts.t1,
            fontweight: FontWeight.bold,
          ),
          2.height,
          CustomText(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            text: description,
            fontSize: AppFonts.t2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
