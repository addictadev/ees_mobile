import 'dart:developer';

import 'package:cherry_toast/resources/constants.dart';
import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_cashed_network_image.dart';
import 'package:ees/app/images_preview/photo_view.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/controllers/cart_controller.dart';
import 'package:ees/models/products_home_data_model.dart';
import 'package:ees/presentation/main_screens/cart_screen/widgets/cart_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ProductCard extends StatelessWidget {
  final ProductData product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductHeader(
            product: product,
          ),
          Divider(color: Colors.grey[300], thickness: 1),
          SizedBox(height: 1.h),
          ProductAttributes(
            product: product,
          ),
        ],
      ),
    );
  }
}

class ProductHeader extends StatelessWidget {
  final ProductData product;

  const ProductHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final variant =
        product.variants?.isNotEmpty == true ? product.variants!.first : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => NavigationManager.navigatTo(
              PhotoViewPage(imageUrl: product.image ?? "")),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(2.w),
              child: CustomCachedImage(
                imageUrl: product.image ?? '',
                width: 20.w,
                height: 20.w,
                fit: BoxFit.contain,
              )),
        ),
        2.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: GoogleFonts.cairo(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.variants!.first.minQuantity.toString() +
                        ' ' +
                        product.package.toString(),
                    style: GoogleFonts.cairo(
                      fontSize: 15.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    variant != null ? "${variant.price} ج.م" : "",
                    style: GoogleFonts.cairo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProductAttributes extends StatelessWidget {
  final ProductData product;

  const ProductAttributes({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final variant =
        product.variants?.isNotEmpty == true ? product.variants!.first : null;

    List<Widget> attributes = [];

    final shapeProperty = product.properties?.firstWhere(
      (prop) =>
          prop.name?.toLowerCase().contains('شكل') == true ||
          prop.name?.toLowerCase().contains('shape') == true,
      orElse: () => Categories(),
    );

    if (shapeProperty?.name != null) {
      attributes.add(_AttributeItem(
          icon: Icons.category, label: "الشكل", value: shapeProperty!.name!));
    }

    if (variant?.maxQuantity != null) {
      attributes.add(_AttributeItem(
          icon: Icons.inventory,
          label: "أقصى كمية",
          value: "${variant!.maxQuantity} ${product.package ?? ''}"));
    }

    if (variant?.minQuantity != null) {
      attributes.add(_AttributeItem(
          icon: Icons.inventory,
          label: "أقل كمية",
          value: "${variant!.minQuantity} ${product.package ?? ''}"));
    }

    final colorProperty = product.properties?.firstWhere(
      (prop) =>
          prop.name?.toLowerCase().contains('لون') == true ||
          prop.name?.toLowerCase().contains('color') == true,
      orElse: () => Categories(),
    );

    if (colorProperty?.name != null) {
      attributes.add(_AttributeItem(
          icon: Icons.format_paint,
          label: "اللون",
          value: colorProperty!.name!));
    }

    if (product.brand?.name != null) {
      attributes.add(_AttributeItem(
          icon: Icons.business,
          label: "العلامة التجارية",
          value: product.brand!.name!));
    }

    if (product.properties != null) {
      for (var prop in product.properties!) {
        if ((prop.name?.toLowerCase().contains('شكل') == true) ||
            (prop.name?.toLowerCase().contains('shape') == true) ||
            (prop.name?.toLowerCase().contains('لون') == true) ||
            (prop.name?.toLowerCase().contains('color') == true)) {
          continue;
        }

        if (prop.name != null) {
          attributes.add(_AttributeItem(
              icon: Iconsax.profile_2user4,
              label: 'اسم التاجر ',
              value: prop.name!));
        }
      }
    }

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.5.h,
      children: attributes,
    );
  }
}

class _AttributeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AttributeItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: Colors.grey[600]),
          SizedBox(width: 2.w),
          Text(
            "$label: $value",
            style: GoogleFonts.cairo(
                fontSize: 14.sp,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class CompanyInfo extends StatelessWidget {
  final ProductData product;

  const CompanyInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              text: 'وصف المنتج',
              color: AppColors.primary,
              fontSize: 17.sp,
              fontweight: FontWeight.w600),
          1.height,
          CustomText(
              text: product.description ?? '',
              fontSize: 15.sp,
              textAlign: TextAlign.start),
          SizedBox(height: 1.h),
          if (product.properties != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                CustomText(
                    text: 'بيانات المتجر',
                    color: AppColors.primary,
                    fontSize: 17.sp,
                    fontweight: FontWeight.w600),
                1.height,
                _CompanyHeader(product),
                _CompanyDetails(product),
              ],
            ),
          Divider()
        ],
      ),
    );
  }
}

Widget _CompanyHeader(ProductData? product) {
  return Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(2.w),
        child: CustomCachedImage(
          imageUrl: product?.properties![0].logo ?? '',
          width: 20.w,
          height: 20.w,
          fit: BoxFit.cover,
        ),
      ),
      SizedBox(width: 3.w),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            product?.properties![0].name ?? "",
            style: GoogleFonts.cairo(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (product!.properties![0].cart_min != null)
            CustomText(
                padding: EdgeInsets.only(top: 1.h),
                text:
                    'اقل كمية للطلبية :  ${product.properties![0].cart_min! + " " + product.package!}',
                fontSize: 14.sp),
        ],
      ),
    ],
  );
}

Widget _CompanyDetails(ProductData product) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (product.properties![0].cart_min != null)
        _CompanyDetailItem(
          icon: Iconsax.wallet,
          label: "حد أدنى للطلبية",
          value: "${product.properties![0].cart_min} ج.م",
        ),
    ],
  );
}

class _CompanyDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CompanyDetailItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: Colors.grey[600]),
          SizedBox(width: 1.w),
          Text(
            "$label : $value",
            style: GoogleFonts.cairo(
                fontSize: 15.sp,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class AddToCartButton extends StatelessWidget {
  final ProductData product;

  const AddToCartButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppButton(
        "أضف إلى العربة",
        width: 45.w,
        margin: EdgeInsets.only(bottom: 4.h),
        onTap: () {
          context
              .read<CartProvider>()
              .addToCart(product.id, product.variants!.first.id,
                  product.properties!.first.id)
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
                      propertyId: product.properties!.first.id.toString(),
                    );
                  });
            }
          });
        },
      ),
    );
  }
}
