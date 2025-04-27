import 'dart:developer';

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
import '../../../../controllers/cart_controller.dart';
import '../../cart_screen/widgets/cart_popup.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final isLoading = provider.isLoadingProducts;
        final products = provider.productsModel?.data ?? [];

        if (isLoading && products.isNotEmpty) {
          return GridView.builder(
            padding: EdgeInsets.only(bottom: 3.h),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return _buildLoadingCard();
            },
          );
        }

        if (!isLoading && products.isEmpty) {
          return SizedBox(
            height: 20.h,
            child: Center(
              child: Text(
                "لا توجد منتجات متاحة",
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.only(bottom: 3.h),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductItem(context, product);
          },
        );
      },
    );
  }

  Widget _buildProductItem(BuildContext context, ProductData product) {
    return InkWell(
      onTap: () => NavigationManager.navigatTo(
        ProductDetailsScreen(productName: product.name ?? '', product: product),
      ),
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
              height: 12.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.w),
                color: Colors.white,
              ),
              child: CustomCachedImage(
                imageUrl: product.image ?? '',
                width: 100.w,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: .5.h),
            Text(
              product.name ?? '',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (product.variants?.isNotEmpty == true)
              CustomText(
                text: "${product.variants!.first.price} ج.م",
                padding: EdgeInsets.symmetric(vertical: 2.w),
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
                ),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${product.variants!.first.minQuantity} ${product.package!}",
                ),
                InkWell(
                  onTap: () => context
                      .read<CartProvider>()
                      .addToCart(
                        product.id,
                        product.variants!.first.id,
                        product.properties!.first.id,
                      )
                      .then((val) {
                    log('value >>>>>> $val');
                    if (val != null &&
                        val.toString().contains(
                            ' السلة تحتوي على منتجات من بائع مختلف، هل تريد مسح السلة الحالية وإضافة المنتج الجديد؟')) {
                      log("mmmmmmmmm?????$val");
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CartPopup(
                              productId: product.id.toString(),
                              variantId: product.variants!.first.id.toString(),
                              propertyId:
                                  product.properties!.first.id.toString(),
                            );
                          });
                    }
                  }),
                  child: Container(
                    padding: EdgeInsets.all(.7.w),
                    decoration: getBoxDecoration(
                      fillColor: AppColors.primary,
                      radus: 1.w,
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
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
            height: 13.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.w),
              color: Colors.grey.shade300,
            ),
          ),
          SizedBox(height: .5.h),
          Container(
            height: 2.h,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 1.h),
          Container(
            height: 2.h,
            width: 20.w,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 1.h),
          Container(
            height: 2.h,
            width: 25.w,
            color: Colors.grey.shade300,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 2.h,
                width: 15.w,
                color: Colors.grey.shade300,
              ),
              Container(
                height: 4.h,
                width: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
