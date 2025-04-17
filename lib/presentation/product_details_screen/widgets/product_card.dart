import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_cashed_network_image.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/controllers/cart_controller.dart';
import 'package:ees/models/products_home_data_model.dart';
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
        ClipRRect(
            borderRadius: BorderRadius.circular(2.w),
            child: CustomCachedImage(
              imageUrl: product.image ?? '',
              width: 20.w,
              height: 20.w,
              fit: BoxFit.contain,
            )),
        2.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.package ?? '',
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

    final brandCategory = product.categories?.firstWhere(
      (cat) => cat.name != null,
      orElse: () => Categories(),
    );

    if (brandCategory?.name != null) {
      attributes.add(_AttributeItem(
          icon: Icons.business,
          label: "العلامة التجارية",
          value: brandCategory!.name!));
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
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CompanyHeader(product),
          _CompanyDetails(product),
          SizedBox(height: 2.h),
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
          fit: BoxFit.contain,
        ),
      ),
      SizedBox(width: 3.w),
      Text(
        product?.properties![0].name ?? "",
        style: GoogleFonts.cairo(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
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
        onTap: () {
          context.read<CartProvider>().addToCart(product.id,
              product.variants!.first.id, product.properties!.first.id);
        },
      ),
    );
  }
}
