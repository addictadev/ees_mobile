import 'package:ees/app/images_preview/custom_cashed_network_image.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/widgets/app_text_field.dart';
import 'package:ees/app/widgets/custom_app_bar.dart';
import 'package:ees/models/orders_model.dart';
import 'package:flutter/material.dart';

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
            child: Padding(
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: widget.orderDetails.items
                                ?.map((item) => _buildProductItem(item))
                                .toList() ??
                            [],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Requirements Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'متطلبات الطلبية',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      AppTextField(
                        controller: TextEditingController(
                            text: widget.orderDetails.note ?? ''),
                        lines: 4,
                        hintText:
                            'نأمل التنسيق بوصول حالياً وإعلام العمالة مسبقاً عند الحضور مثل دوسية',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Order Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'حالة الطلب',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.orderDetails.status ?? 'معلق',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(widget.orderDetails.status),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Payment Method
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'طريقة الدفع',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'نقدي',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Divider(),
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
                        '${widget.orderDetails.totalPrice ?? '0'} ج.م',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'اطلب المزيد من نفس الشركة',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                              const TextSpan(
                                text: ' ج.م',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'عدد: ${item.quantity ?? 0}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'حالة: ${item.status ?? "قيد التنفيذ"}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
