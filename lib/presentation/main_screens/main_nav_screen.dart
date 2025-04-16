import 'package:ees/presentation/main_screens/my_orders_screen/orders_screen.dart';
import 'package:ees/presentation/main_screens/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import '../../app/images_preview/custom_svg_img.dart';
import '../../app/dependency_injection/get_it_injection.dart';
import '../../app/utils/local/shared_pref_serv.dart';
import '../../app/utils/app_assets.dart';
import '../../app/utils/app_colors.dart';
import '../../app/utils/exit_popup.dart';
import 'cart_screen/cart_screen.dart';
import 'home_screen/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.currentIndex});
  final int? currentIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;
  List<Widget> _pages = [];
  final shedPref = getIt<SharedPreferencesService>();

  void updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? 0;
    _pages = [
      HomeScreen(),
      CartScreen(),
      OrdersScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (_) => const ExitPopUp(),
          );
          return shouldPop!;
        },
        child: Scaffold(
          key: _scaffoldKey,
          drawer: CustomDrawer(),
          backgroundColor: AppColors.white,
          body: Container(
            alignment: Alignment.topCenter,
            child: _pages[_currentIndex],
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.w),
              topRight: Radius.circular(4.w),
            ),
            child: BottomNavigationBar(
              backgroundColor: AppColors.white,
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              elevation: 5,
              selectedFontSize: 15.sp,
              selectedLabelStyle: GoogleFonts.cairo(),
              unselectedLabelStyle: GoogleFonts.cairo(),
              unselectedFontSize: 15.sp,
              selectedItemColor: AppColors.btnColor,
              selectedIconTheme: const IconThemeData(color: AppColors.btnColor),
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 2.w),
                    child: CustomSvgImage(
                      assetName: AppAssets.homeIcon,
                      color:
                          _currentIndex == 0 ? AppColors.btnColor : Colors.grey,
                    ),
                  ),
                  label: 'الرئيسية'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 2.w),
                    child: CustomSvgImage(
                      assetName: AppAssets.cartIcon,
                      color:
                          _currentIndex == 1 ? AppColors.btnColor : Colors.grey,
                    ),
                  ),
                  label: 'العربة'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 2.w),
                    child: CustomSvgImage(
                      assetName: AppAssets.billIcon,
                      color:
                          _currentIndex == 2 ? AppColors.btnColor : Colors.grey,
                    ),
                  ),
                  label: 'فواتيري'.tr(),
                ),
                // BottomNavigationBarItem(
                //   icon: Padding(
                //     padding: EdgeInsets.only(top: 2.w),
                //     child: CustomSvgImage(
                //       assetName: AppAssets.walletIcon,
                //       color:
                //           _currentIndex == 3 ? AppColors.btnColor : Colors.grey,
                //     ),
                //   ),
                //   label: 'المحفظة'.tr(),
                // ),
                BottomNavigationBarItem(
                  icon: CustomSvgImage(
                    assetName: AppAssets.moreIcon,
                    color:
                        _currentIndex == 3 ? AppColors.btnColor : Colors.grey,
                  ),
                  label: '',
                ),
              ],
              onTap: (index) {
                if (index == 3) {
                  _scaffoldKey.currentState?.openDrawer();
                } else {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
            ),
          ),
        ));
  }
}
