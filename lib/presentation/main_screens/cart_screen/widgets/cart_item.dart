import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_asset_img.dart';
import 'package:ees/app/images_preview/custom_cashed_network_image.dart';
import 'package:ees/app/utils/app_assets.dart';
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
      padding: EdgeInsets.only(bottom: 1.w, left: 4.w, right: 4.w, top: 3.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCachedImage(
                imageUrl: widget.cartItem.product!.image ?? '',
                width: 20.w,
                height: 18.w,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.cartItem.product!.name ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    .5.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${widget.cartItem.quantity}  ${widget.cartItem.product!.package ?? ""}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        Text(
                            '${(double.parse(widget.cartItem.variant!.price!.toString()) * double.parse(widget.cartItem.quantity.toString()))} ج.م',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          .8.height,
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
              InkWell(
                onTap: () => Provider.of<CartProvider>(context, listen: false)
                    .deleteCartItem(widget.cartItem.product!.id.toString()),
                child: CustomImageAsset(
                  assetName: AppAssets.deleteBtn,
                  width: 25.w,
                ),
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
              ? SizedBox(
                  height: 2.w,
                )
              : Divider(),
        ],
      ),
    );
  }
}
