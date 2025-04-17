import 'dart:developer';

import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_svg_img.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/app_text_field.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:ees/controllers/home_controller.dart';
import 'package:ees/presentation/main_screens/home_screen/widgets/products_home_grids.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../search_screen/search_screen.dart';
import 'widgets/categoriesTap.dart';
import 'widgets/homeAppBar.dart';
import 'widgets/vendorsTap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() {
      Provider.of<HomeProvider>(context, listen: false)
          .searchController
          .clear();
      Provider.of<HomeProvider>(context, listen: false).selectedVendor = null;
      Provider.of<HomeProvider>(context, listen: false).selectedCategory = null;
      Provider.of<HomeProvider>(context, listen: false).getAllCategories();
      Provider.of<HomeProvider>(context, listen: false).getAlVendors();
      Provider.of<HomeProvider>(context, listen: false)
          .getAllHomeProducts(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<HomeProvider>(context, listen: false);
      if (provider.hasMorePages && !provider.isLoadingProducts) {
        log("Loading more products...");
        provider.getAllHomeProducts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      body: Consumer<HomeProvider>(
          builder: (BuildContext context, value, Widget? child) {
        return Column(
          children: [
            HomeAppBar(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextField(
                    width: 75.w,
                    search: true,
                    hintText: 'ابحث عن منتجات أو علامة تجارية',
                    borderColor: AppColors.white,
                    controller: value.searchController,
                    onTap: () => NavigationManager.navigatTo(SearchScreen()),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(2.w),
                      child: CustomSvgImage(assetName: AppAssets.searchIcon),
                    ),
                  ),
                  Container(
                    height: 7.h,
                    width: 7.h,
                    margin: EdgeInsets.only(top: 3.w),
                    decoration: getBoxDecoration(),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: CustomSvgImage(
                        assetName: AppAssets.filterIcon,
                        height: 2.w,
                      ),
                    ),
                  )
                ],
              ),
            ),
            2.height,
            Expanded(
              child: value.isLoadingCategories || value.isLoadingVendors
                  ? loadingIndicator
                  : SingleChildScrollView(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 3.w,
                          right: 3.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SliderWidget(),
                            const CategoryTabs(),
                            VendorList(),
                            const ProductGrid(),
                            if (value.isLoadingProducts &&
                                value.productsModel != null)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                child: Center(
                                  child: loadingIndicator,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}

// Widget SearchAmdFilterWidget(context) {
//   return

// }

// Home Screen
// Slider Widget
class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 17.h,
      width: 100.w,
      child: PageView(
        children: [
          _buildSliderItem(),
          _buildSliderItem(),
          _buildSliderItem(),
        ],
      ),
    );
  }

  Widget _buildSliderItem() {
    return Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.w),
        color: Colors.blue.shade100,
      ),
      child: Stack(
        children: [
          Positioned(
            right: 3.w,
            top: 1.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "خصومات",
                  style: TextStyle(
                      fontSize: AppFonts.h2, fontWeight: FontWeight.bold),
                ),
                Text(
                  "تصل إلى %50",
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1.5.h),
                AppButton(
                  'اطلب الآن',
                  borderNum: 3.w,
                  hieght: 4.5.h,
                  fontSize: 14.sp,
                  bgColor: AppColors.primary,
                  width: 22.w,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Category Tabs

// Product Grid

// Category Provider
