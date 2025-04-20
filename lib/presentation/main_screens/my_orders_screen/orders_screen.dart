import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/app/widgets/loginFrist.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:ees/controllers/orders_controller.dart';
import 'package:ees/presentation/main_screens/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
    Future.microtask(() {
      if (IsLogin()) {
        Provider.of<OrdersController>(context, listen: false)
            .getAllOrders("pending");
      }
    });
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        return; // avoid calling twice during animation
      }

      String status;
      switch (_tabController.index) {
        case 0:
          status = "pending";
          break;
        case 1:
          status = "accepted";
          break;
        case 2:
          status = "finished";
          break;
        default:
          status = "pending";
      }

      if (IsLogin()) {
        Provider.of<OrdersController>(context, listen: false)
            .getAllOrders(status);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OrdersController>(
          builder: (BuildContext context, value, Widget? child) {
        return Column(
          children: [
            HomeAppBar(text: 'فواتيري', isHome: false),
            Container(
              margin: EdgeInsets.only(top: 1.h, bottom: 1.h),
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: getBoxDecoration(
                  fillColor: AppColors.grey, withShadwos: false),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1.w),
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
                child: IsLogin()
                    ? value.isLoadingAllOrders
                        ? Center(
                            child: loadingIndicator,
                          )
                        : TabBarView(
                            physics: BouncingScrollPhysics(),
                            controller: _tabController,
                            children: [
                              InvoiceTab(
                                type: 'current',
                                status: "pending",
                                orderList: value.ordersModel?.orderList ?? [],
                              ),
                              InvoiceTab(
                                type: 'confirmed',
                                status: "accepted",
                                orderList: value.ordersModel?.orderList ?? [],
                              ),
                              InvoiceTab(
                                type: 'previous',
                                status: "finished",
                                orderList: value.ordersModel?.orderList ?? [],
                              ),
                            ],
                          )
                    : LoginFristWidget())
          ],
        );
      }),
    );
  }
}
