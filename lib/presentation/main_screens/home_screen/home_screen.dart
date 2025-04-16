import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_asset_img.dart';
import 'package:ees/app/images_preview/custom_svg_img.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/app_text_field.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:ees/controllers/home_controller.dart';
import 'package:ees/presentation/product_details_screen/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'widgets/categoriesTap.dart';
import 'widgets/homeAppBar.dart';
import 'widgets/vendorsTap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HomeProvider>(context, listen: false).getAllCategories();
      Provider.of<HomeProvider>(context, listen: false).getAlVendors();
    });
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
              child: SearchAmdFilterWidget(),
            ),
            2.height,
            Expanded(
              child: value.isLoadingCategories || value.isLoadingVendors
                  ? loadingIndicator
                  : SingleChildScrollView(
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

Widget SearchAmdFilterWidget() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      AppTextField(
        width: 75.w,
        hintText: 'ابحث عن منتجات أو علامة تجارية',
        borderColor: AppColors.white,
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
  );
}

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
class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(bottom: 3.h),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildProductItem();
      },
    );
  }

  Widget _buildProductItem() {
    return InkWell(
      onTap: () => NavigationManager.navigatTo(
          ProductDetailsScreen(productName: 'لمبات ستنزا ليد فلاوظ')),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.w),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 14.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.w),
                color: Colors.white,
              ),
              child: CustomImageAsset(
                assetName: AppAssets.product1,
                width: 30.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              " لمبات ستنزا ليد فلاوظ" * 3,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            CustomText(
                text: " 25.0 ج.م",
                padding: EdgeInsets.symmetric(
                  vertical: 2.w,
                ),
                color: AppColors.primary,
                fontweight: FontWeight.bold,
                isBold: true),
            Text(
              "اقصي حد للطلب 20 قطعة",
              style: TextStyle(
                  fontSize: AppFonts.t5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("X 50 كرتونة"),
                Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: getBoxDecoration(
                      fillColor: AppColors.primary, radus: 1.w),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Category Provider
