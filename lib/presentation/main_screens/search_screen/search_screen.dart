import 'dart:developer';

import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/widgets/custom_app_bar.dart';
import 'package:ees/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../app/images_preview/custom_svg_img.dart';
import '../../../app/navigation_services/navigation_manager.dart';
import '../../../app/utils/app_assets.dart';
import '../../../app/utils/app_colors.dart';
import '../../../app/utils/show_toast.dart';
import '../../../app/widgets/app_text_field.dart';
import '../../../app/widgets/style.dart';
import '../home_screen/widgets/products_home_grids.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    super.initState();
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
      body: Consumer<HomeProvider>(
          builder: (BuildContext context, value, Widget? child) {
        return WillPopScope(
          onWillPop: () async {
            value.searchController.clear();
            value.getAllHomeProducts(refresh: true);
            return true;
          },
          child: Column(
            children: [
              CustomeAppBar(
                  text: "البحث",
                  onTap: () {
                    NavigationManager.pop();
                    value.searchController.clear();
                    value.getAllHomeProducts(refresh: true);
                  }),
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
                          child:
                              CustomSvgImage(assetName: AppAssets.searchIcon),
                        ),
                        suffixIcon: value.searchController.text.isNotEmpty
                            ? Icons.close
                            : null,
                        suffixIconOnTap: () {
                          value.searchController.clear();
                          value.getAllHomeProducts(refresh: true);
                        }),
                    Container(
                      height: 6.5.h,
                      width: 6.5.h,
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
                  child: value.productsModel == null ||
                          value.productsModel!.data!.isEmpty
                      ? Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppAssets.noItems,
                                width: 45.w,
                              ),
                              1.height,
                              Center(
                                child: Text(
                                  "لا توجد عمليات بحث",
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                              ),
                              9.height
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Center(child: const ProductGrid()),
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
                        ))
            ],
          ),
        );
      }),
    );
  }
}
