import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_cashed_network_image.dart';
import 'package:ees/app/images_preview/custom_svg_img.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/consts.dart';
import 'package:ees/app/utils/error_view.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:ees/models/orders_model.dart';
import 'package:ees/presentation/main_screens/my_orders_screen/fatora_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../controllers/orders_controller.dart';
import 'empty_Orders.dart';
import 'ordersDialog.dart';

class InvoiceTab extends StatelessWidget {
  final String type;
  final String status;
  final List<OrderItemDetails>? orderList;
  const InvoiceTab(
      {super.key,
      required this.type,
      required this.status,
      required this.orderList});

  @override
  Widget build(BuildContext context) {
    return Provider.of<OrdersController>(context, listen: false).hasError
        ? ErrorView(onReload: () {
            Provider.of<OrdersController>(context, listen: false)
                .getAllOrders(status);
          })
        : orderList!.isEmpty
            ? EmptyOrders()
            : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: orderList?.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 3.w),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade200, blurRadius: 5),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTag(
                                "الرقم التعريفي : # ${orderList?[index].id}",
                                AppAssets.numIc),
                            _buildTag(
                                "  حالة الطلب : ${orderList?[index].status}",
                                AppAssets.switchIcon),
                          ],
                        ),
                        1.height,
                        _buildTag(
                            "تاريخ الطلب : ${formatOrderDate(orderList?[index].orderedAt)}",
                            AppAssets.calenderIc),
                        2.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomCachedImage(
                                imageUrl:
                                    orderList?[index].property?.logo ?? '',
                                height: 20.w,
                                width: 20.w),
                            2.width,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(orderList?[index].property?.name ?? '',
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5),
                                  Text(
                                      'عدد المنتجات: ${orderList?[index].items?.length}',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'إجمالي التكلفة: ${orderList?[index].totalPrice} ج.م',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: AppColors.primary)),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        if (type == 'current') ...[
                          Text('حالة الطلب : ${orderList?[index].status}',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.lightOrange,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 5),
                          Text('وسيتم الرد خلال أيام عمل',
                              style: TextStyle(fontSize: 14.sp)),
                        ],
                        if (type == 'confirmed')
                          Container(
                            padding: EdgeInsets.all(3.w),
                            margin: EdgeInsets.only(top: 3.w),
                            decoration: getBoxDecoration(
                                fillColor:
                                    AppColors.lightOrange.withOpacity(.1),
                                withShadwos: false),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_city_outlined,
                                  color: AppColors.lightOrange,
                                ),
                                2.width,
                                Expanded(
                                  child: CustomText(
                                      text:
                                          'اقرب فرع لاستلام  الطلبيه : ${orderList?[index].property?.address}',
                                      color: AppColors.lightOrange,
                                      textAlign: TextAlign.start,
                                      fontweight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        2.height,
                        Row(
                          children: [
                            if (type == 'current')
                              Expanded(
                                child: AppButton(
                                  'الغاء الطلب',
                                  onTap: () =>
                                      showCancelOrderDialog(context, () {
                                    Provider.of<OrdersController>(context,
                                            listen: false)
                                        .cancelOrder(orderList?[index].id ?? 0);
                                  }),
                                  bgColor: AppColors.white,
                                  hasBorder: true,
                                  borderColor: AppColors.red,
                                  titleColor: AppColors.red,
                                ),
                              ),
                            if (type == 'current') SizedBox(width: 10),
                            Expanded(
                              child: AppButton(
                                'تفاصيل الفاتورة',
                                onTap: () {
                                  NavigationManager.navigatTo(
                                      FatoraDetailsScreen(
                                          orderDetails: orderList![index]));
                                },
                                bgColor: AppColors.white,
                                hasBorder: true,
                                borderColor: AppColors.primary,
                                titleColor: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        if (type == 'previous') SizedBox(width: 10),
                        if (orderList?[index].status == 'تم الاستلام' &&
                                orderList?[index].is_rated == null ||
                            orderList?[index].is_rated == '0')
                          AppButton(
                            'تقييم المورد',
                            onTap: () => showRatingDialog(context,
                                orderId: orderList?[index].id,
                                vendorId: orderList?[index].property?.id),
                            margin: EdgeInsets.symmetric(vertical: 3.w),
                          ),
                      ],
                    ),
                  );
                });
  }
}

Widget _buildTag(String text, icon) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(1.5.w),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomSvgImage(
          assetName: icon,
          height: 16.sp,
          color: Colors.grey[700],
          width: 12.sp,
        ),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
      ],
    ),
  );
}
