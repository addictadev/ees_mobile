import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../home_screen/widgets/homeAppBar.dart';
import 'widgets/current_invoice.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HomeAppBar(text: 'فواتيري', isHome: false),
          Container(
            margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            decoration:
                getBoxDecoration(fillColor: AppColors.grey, withShadwos: false),
            child: TabBar(
              controller: _tabController,
              // tabAlignment: TabAlignment.center,
              indicatorSize: TabBarIndicatorSize.tab,

              indicator: BoxDecoration(
                color: Colors.white, // Selected tab background color
                borderRadius: BorderRadius.circular(1.w),

                // border: Border.all(
                //     color: Colors.grey,
                //     width: 1.5), // Gray border for selected tab
              ),
              labelStyle: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.cairo().fontFamily,
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: 2.w),
              labelColor: AppColors.black,
              unselectedLabelColor: AppColors.black,
              unselectedLabelStyle: TextStyle(
                fontSize: 13.sp,
                fontFamily: GoogleFonts.cairo().fontFamily,
              ),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: "فواتيري الحالية"),
                Tab(text: "فواتير تم تأكيدها"),
                Tab(text: "فواتير سابقة"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              controller: _tabController,
              children: [
                InvoiceTab(type: 'current'),
                InvoiceTab(type: 'confirmed'),
                InvoiceTab(type: 'previous'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
