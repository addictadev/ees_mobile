import 'package:ees/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../app/images_preview/custom_svg_img.dart';
import '../../../app/utils/app_assets.dart';
import '../../../app/utils/app_colors.dart';
import '../../../app/utils/show_toast.dart';
import '../../../app/widgets/app_text_field.dart';
import '../../../app/widgets/style.dart';
import '../../Auth_screens/widget/custom_auth_appBar.dart';
import '../home_screen/widgets/products_home_grids.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeProvider>(
          builder: (BuildContext context, value, Widget? child) {
        return Column(
          children: [
            customAuthAppBar(title: "نتايج البحث"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextField(
                      width: 75.w,
                      search: true,
                      hintText: 'ابحث عن منتجات أو علامة تجارية',
                      borderColor: AppColors.white,
                      controller: value.searchController,
                      onFieldSubmitted: (p0) =>
                          value.getAllHomeProducts(refresh: true),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: CustomSvgImage(assetName: AppAssets.searchIcon),
                      ),
                      suffixIcon: value.searchController.text.isNotEmpty
                          ? Icons.close
                          : null,
                      suffixIconOnTap: () {
                        value.searchController.clear();
                        value.getAllHomeProducts(refresh: true);
                      }),
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
            Expanded(
                child: Column(
              children: [
                const ProductGrid(),
                if (value.isLoadingProducts && value.productsModel != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Center(
                      child: loadingIndicator,
                    ),
                  ),
              ],
            ))
          ],
        );
      }),
    );
  }
}
