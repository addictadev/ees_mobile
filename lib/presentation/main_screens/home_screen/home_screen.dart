import 'dart:developer';

import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_svg_img.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/consts.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/app/widgets/app_text_field.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:ees/controllers/home_controller.dart';
import 'package:ees/presentation/main_screens/home_screen/widgets/products_home_grids.dart';
import 'package:ees/presentation/product_details_screen/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

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
      Provider.of<HomeProvider>(context, listen: false).getAllHomeSlider();
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
                    search: false,
                    readOnly: true,
                    controller: value.searchHome,
                    hintText: 'ابحث عن منتجات أو علامة تجارية',
                    borderColor: AppColors.white,
                    onTap: () => NavigationManager.navigatTo(SearchScreen()),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(2.w),
                      child: CustomSvgImage(assetName: AppAssets.searchIcon),
                    ),
                  ),
                  GestureDetector(
                      onTap: () => NavigationManager.navigatTo(SearchScreen()),
                      child: Container(
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
                      ))
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

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _autoScroll();
  }

  void _autoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      int nextPage = (_currentIndex + 1) %
          Provider.of<HomeProvider>(context, listen: false)
              .sliderModel!
              .data!
              .length;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() => _currentIndex = nextPage);
      _autoScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.h,
      width: 100.w,
      child: Consumer<HomeProvider>(
          builder: (BuildContext context, value, Widget? child) {
        return Column(
          children: [
            SizedBox(
              height: 17.h,
              child: PageView.builder(
                controller: _controller,
                itemCount: value.sliderModel!.data!.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (value.sliderModel!.data![index].link == null) {
                        NavigationManager.navigatTo(ProductDetailsScreen(
                            product: value.sliderModel!.data![index].product!,
                            productName:
                                value.sliderModel!.data![index].product!.name ??
                                    ""));
                      } else {
                        openLink(value.sliderModel!.data![index].link!);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.w),
                        image: DecorationImage(
                          image: NetworkImage(
                              value.sliderModel!.data![index].image ?? ""),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 1.h),
            SmoothPageIndicator(
              controller: _controller,
              count: value.sliderModel!.data!.length,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.blue,
                dotHeight: 1.h,
                dotWidth: 2.w,
              ),
            ),
          ],
        );
      }),
    );
  }
}
