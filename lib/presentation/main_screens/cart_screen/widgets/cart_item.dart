import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_svg_img.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.w, left: 4.w, right: 4.w),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                AppAssets.product1,
                width: 20.w,
                height: 20.w,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cartItem.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("كرتونة ${cartItem.cartonSize}"),
                  ],
                ),
              ),
              Text("${cartItem.price} ج.م",
                  style: TextStyle(color: Colors.blue)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                      child: Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: getBoxDecoration(
                              radus: 1.w, fillColor: AppColors.primary),
                          child: Icon(
                            Icons.add,
                            color: AppColors.white,
                          )),
                      onTap: () {}),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: CustomText(
                        text: cartItem.quantity.toString(),
                        color: AppColors.primary,
                        fontweight: FontWeight.bold),
                  ),
                  InkWell(
                      child: Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: getBoxDecoration(
                              radus: 1.w,
                              fillColor: AppColors.primary.withOpacity(.6)),
                          child: Icon(
                            Icons.remove,
                            color: AppColors.white,
                          )),
                      onTap: () {}),
                ],
              ),
              AppButton(
                'حذف',
                buttonIcon: Padding(
                  padding: EdgeInsets.only(left: 3.w),
                  child: Icon(
                    Icons.delete_outline_sharp,
                    color: AppColors.red,
                  ),
                ),
                width: 35.w,
                hieght: 5.h,
                borderNum: 1.w,
                borderColor: Colors.red.shade100,
                bgColor: AppColors.white,
                titleColor: Colors.red,
                hasBorder: true,
              )
            ],
          ),
          1.5.height,
          Divider(),
        ],
      ),
    );
  }
}

class CartItem {
  final String name;
  final double price;
  final int quantity;
  final int cartonSize;

  CartItem(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.cartonSize});
}
