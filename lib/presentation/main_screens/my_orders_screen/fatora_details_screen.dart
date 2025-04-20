import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_cashed_network_image.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/app_text_field.dart';
import 'package:ees/app/widgets/custom_app_bar.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:ees/models/orders_model.dart';
import 'package:ees/presentation/main_screens/main_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../app/utils/app_fonts.dart';
import '../../../controllers/orders_controller.dart';
import 'widgets/ordersDialog.dart';

class FatoraDetailsScreen extends StatefulWidget {
  final OrderItemDetails orderDetails;
  const FatoraDetailsScreen({super.key, required this.orderDetails});

  @override
  State<FatoraDetailsScreen> createState() => _FatoraDetailsScreenState();
}

class _FatoraDetailsScreenState extends State<FatoraDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomeAppBar(
            text: 'تفاصيل الطلبية',
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Company Info Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: CustomCachedImage(
                                  imageUrl:
                                      widget.orderDetails.property?.logo ?? ""),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.orderDetails.property?.name ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Products List
                  Column(
                    children: widget.orderDetails.items
                            ?.map((item) => _buildProductItem(item))
                            .toList() ??
                        [],
                  ),

                  // Requirements Section
                  if (widget.orderDetails.note != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        2.height,
                        const Text(
                          'ملاحظات الطلبية',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          width: 100.w,
                          decoration: getBoxDecoration(
                              borderColor: AppColors.primary,
                              withShadwos: false),
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 4.w),
                          margin: EdgeInsets.symmetric(vertical: 2.h),
                          child: CustomText(
                              text: widget.orderDetails.note ?? '',
                              fontSize: 15.sp,
                              textAlign: TextAlign.start),
                        ),
                      ],
                    ),

                  2.height,
                  // Order Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('حالة الطلب',
                          style: TextStyle(fontSize: AppFonts.t2)),
                      Text(
                        widget.orderDetails.status ?? 'معلق',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(widget.orderDetails.status),
                        ),
                      ),
                    ],
                  ),

                  1.height,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("طريقة الدفع",
                          style: TextStyle(fontSize: AppFonts.t2)),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4.w, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.blueColor.withOpacity(.15),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text("كاش",
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),

                  1.height,
                  Divider(),

                  1.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'إجمالي الطلب',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${double.tryParse(widget.orderDetails.totalPrice!)!.toStringAsFixed(1)} ج.م',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.lightOrange,
                        ),
                      ),
                    ],
                  ),

                  // Button

                  widget.orderDetails.status == 'تم التعديل'
                      ? Container(
                          decoration: getBoxDecoration(
                              fillColor: AppColors.bluebgColor),
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          margin: EdgeInsets.symmetric(vertical: 2.h),
                          child: Column(children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit_attributes_sharp,
                                  color: AppColors.darkOrange,
                                ),
                                2.width,
                                CustomText(
                                    text: 'تحديث الطلبية',
                                    fontSize: 16.sp,
                                    color: AppColors.lightOrange,
                                    fontweight: FontWeight.w700,
                                    padding:
                                        EdgeInsets.only(bottom: 1.h, top: 1.h)),
                              ],
                            ),
                            ...widget.orderDetails.items!.map((item) {
                              return Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Iconsax.card_edit,
                                        color: AppColors.lightOrange,
                                      ),
                                      1.width,
                                      Expanded(
                                        child: CustomText(
                                            text:
                                                'تم تحديث الطلبية من قبل المورد الكميه المتاحه من ${item.productName} هي ${item.seller_quantity} بدلا من ${item.quantity}',
                                            fontSize: 14.sp,
                                            textAlign: TextAlign.start),
                                      ),
                                    ],
                                  ),
                                  1.height,
                                  if (item.status == 'تم التعديل')
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppButton(
                                            'قبول الكميه المتاحه',
                                            width: 41.w,
                                            hieght: 5.h,
                                            fontSize: AppFonts.t44,
                                            onTap: () =>
                                                Provider.of<OrdersController>(
                                                        context,
                                                        listen: false)
                                                    .acceptEdit(
                                                        orderId: item.variantId,
                                                        quantity: item
                                                            .seller_quantity),
                                          ),
                                          AppButton(
                                            'رفض',
                                            fontSize: AppFonts.t44,
                                            width: 41.w,
                                            hieght: 5.h,
                                            bgColor: AppColors.red,
                                            onTap: () {
                                              Provider.of<OrdersController>(
                                                      context,
                                                      listen: false)
                                                  .cancelOrderItem(
                                                      item.variantId);
                                            },
                                          )
                                        ]),
                                  1.height,
                                  if (widget.orderDetails.items!.last != item)
                                    Divider(
                                        color: Colors.grey[300], thickness: 1),
                                ],
                              );
                            })
                          ]),
                        )
                      : 2.height,

                  widget.orderDetails.status == 'تم الاستلام'
                      ? Column(
                          children: [
                            AppButton(
                              'تقييم المورد',
                              margin: EdgeInsets.only(top: 5.h, bottom: 2.h),
                              onTap: () => showRatingDialog(context),
                            ),
                            AppButton(
                                'اطلب المزيد من شركة ${widget.orderDetails.property?.name}',
                                fontSize: AppFonts.t44,
                                bgColor: AppColors.white,
                                titleColor: AppColors.primary,
                                borderColor: AppColors.primary,
                                hasBorder: true,
                                buttonIcon: Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 6.w,
                                    color: AppColors.primary,
                                  ),
                                ), onTap: () {
                              NavigationManager.navigatToAndFinish(MainScreen(
                                currentIndex: 0,
                              ));
                            }),
                          ],
                        )
                      : widget.orderDetails.status == 'قيد الانتظار' ||
                              widget.orderDetails.status == 'تم التعديل'
                          ? Column(
                              children: [
                                AppButton(
                                  'الغاء الطلب',
                                  margin: EdgeInsets.only(top: 1.h),
                                  onTap: () =>
                                      showCancelOrderDialog(context, () {
                                    Provider.of<OrdersController>(context,
                                            listen: false)
                                        .cancelOrder(
                                            widget.orderDetails.id ?? 0,
                                            fromDetails: true);
                                  }),
                                  bgColor: AppColors.white,
                                  hasBorder: true,
                                  borderColor: AppColors.red,
                                  titleColor: AppColors.red,
                                ),
                              ],
                            )
                          : SizedBox()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
      case 'تم التسليم':
        return Colors.green;
      case 'pending':
      case 'معلق':
        return Colors.orange;
      case 'cancelled':
      case 'ملغي':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  Widget _buildProductItem(Items item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: item.image != null && item.image!.isNotEmpty
                ? CustomCachedImage(imageUrl: item.image!)
                : const Icon(Icons.lightbulb_outline, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.productName ?? 'منتج غير معروف',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textDirection: TextDirection.rtl,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: item.price ?? '0',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: ' ج.م',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontFamily: GoogleFonts.cairo().fontFamily,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'حالة: ${item.status ?? "قيد التنفيذ"}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      'عدد: ${item.quantity ?? 0}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
