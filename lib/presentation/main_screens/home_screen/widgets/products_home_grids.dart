import 'package:ees/app/images_preview/custom_cashed_network_image.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:ees/controllers/home_controller.dart';
import 'package:ees/models/products_home_data_model.dart';
import 'package:ees/presentation/product_details_screen/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() {
      Provider.of<HomeProvider>(context, listen: false).getAllHomeProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      Provider.of<HomeProvider>(context, listen: false).getAllHomeProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingProducts && provider.productsModel == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = provider.productsModel?.data ?? [];

        return GridView.builder(
          controller: _scrollController,
          padding: EdgeInsets.only(bottom: 3.h),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: products.length + (provider.hasMorePages ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == products.length) {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppColors.primary,
              ));
            }

            final product = products[index];
            return _buildProductItem(product);
          },
        );
      },
    );
  }

  Widget _buildProductItem(ProductData product) {
    return InkWell(
      onTap: () => NavigationManager.navigatTo(ProductDetailsScreen(
          productName: product.name ?? '', product: product)),
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
              child: CustomCachedImage(
                imageUrl: product.image ?? '',
                width: 30.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              product.name ?? '',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (product.variants?.isNotEmpty == true)
              CustomText(
                text: "${product.variants!.first.price} ج.م",
                padding: EdgeInsets.symmetric(
                  vertical: 2.w,
                ),
                color: AppColors.primary,
                fontweight: FontWeight.bold,
                isBold: true,
              ),
            if (product.variants?.isNotEmpty == true)
              Text(
                "اقصي حد للطلب ${product.variants!.first.maxQuantity} قطعة",
                style: TextStyle(
                  fontSize: AppFonts.t5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                ),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(product.package ?? ''),
                Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: getBoxDecoration(
                    fillColor: AppColors.primary,
                    radus: 1.w,
                  ),
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
