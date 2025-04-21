import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_cashed_network_image.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../controllers/cart_controller.dart';
import '../../../../models/cart_model.dart';

class CartItemWidget extends StatefulWidget {
  final Items cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.w, left: 4.w, right: 4.w, top: 1.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCachedImage(
                imageUrl: widget.cartItem.product!.image ?? '',
                width: 20.w,
                height: 20.w,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.cartItem.product!.name ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${widget.cartItem.quantity}  ${widget.cartItem.product!.package ?? ""}"),
                        Text(
                            '${(double.parse(widget.cartItem.variant!.price!.toString()) * double.parse(widget.cartItem.quantity.toString()))} ر.س',
                            style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ],
                ),
              ),
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
                      onTap: () {
                        if (widget.cartItem.quantity! >=
                            widget.cartItem.variant!.maxQuantity!) {
                          showCustomedToast(
                              ' الحد الاقصى للمنتج ${widget.cartItem.variant!.maxQuantity}',
                              ToastType.error);
                        } else {
                          Provider.of<CartProvider>(context, listen: false)
                              .incrementCartItem(widget.cartItem.id);
                        }
                      }),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomText(
                        text: widget.cartItem.quantity.toString(),
                        color: AppColors.primary,
                        fontweight: FontWeight.bold),
                  ),
                  InkWell(
                      child: Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: getBoxDecoration(
                              radus: 1.w, fillColor: AppColors.primary),
                          child: Icon(
                            Icons.remove,
                            color: AppColors.white,
                          )),
                      onTap: () {
                        if (widget.cartItem.quantity! <=
                            widget.cartItem.variant!.minQuantity!.toInt()) {
                          showCustomedToast(
                              ' الحد الادنى للمنتج ${widget.cartItem.variant!.minQuantity}',
                              ToastType.error);
                        } else {
                          Provider.of<CartProvider>(context, listen: false)
                              .decrementCartItem(widget.cartItem.id);
                        }
                      }),
                ],
              ),
              AppButton(
                'حذف',
                buttonIcon: Padding(
                  padding: EdgeInsets.only(left: 3.w),
                  child: Icon(
                    Iconsax.trash,
                    size: 5.5.w,
                    color: AppColors.red,
                  ),
                ),
                width: 32.w,
                hieght: 5.h,
                fontSize: 3.5.w,
                borderNum: 1.w,
                borderColor: AppColors.red,
                bgColor: AppColors.white,
                titleColor: AppColors.red,
                hasBorder: true,
                onTap: () => Provider.of<CartProvider>(context, listen: false)
                    .deleteCartItem(widget.cartItem.product!.id.toString()),
              )
            ],
          ),
          Provider.of<CartProvider>(context, listen: false)
                      .cartModel!
                      .data!
                      .items!
                      .length ==
                  1
              ? SizedBox()
              : 1.5.height,
          Provider.of<CartProvider>(context, listen: false)
                      .cartModel!
                      .data!
                      .items!
                      .length ==
                  1
              ? SizedBox()
              : Divider(),
        ],
      ),
    );
  }
}
