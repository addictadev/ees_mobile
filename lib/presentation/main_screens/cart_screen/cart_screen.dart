import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/widgets/app_text_field.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../controllers/cart_controller.dart';
import 'package:provider/provider.dart';

import '../home_screen/widgets/homeAppBar.dart';
import 'widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final TextEditingController copoun = TextEditingController();
  final TextEditingController notes = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      bottomSheet: _buildBottomBar(cartProvider),
      body: Column(
        children: [
          HomeAppBar(text: 'العربة', isHome: false),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.w),
              child: Column(
                children: [
                  _buildHeader(),
                  _buildOrderSummary(cartProvider),
                  2.height,
                  _buildPaymentMethod(),
                  2.height,
                  Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartProvider.cartItems.length,
                      itemBuilder: (context, index) {
                        return CartItemWidget(
                            cartItem: cartProvider.cartItems[index]);
                      },
                    ),
                  ),
                  _promoCodeSection(),
                  1.height,
                  _noteSection(),
                ],
              ),
            ),
          ),
          10.height
        ],
      ),
    );
  }

  Widget _promoCodeSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              hintText: "كود الخصم",
              borderColor: AppColors.white,
              controller: copoun,
            ),
          ),
          Consumer<CartProvider>(
            builder: (BuildContext context, value, Widget? child) {
              return SizedBox(
                height: 5.h,
                child: ElevatedButton(
                  onPressed: () async {
                    await value.applyCopun(copoun.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                  ),
                  child: Text(
                    "تطبيق",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppFonts.t4,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(.2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: Colors.green),
              1.width,
              Text("طلب صالح", style: TextStyle(fontSize: AppFonts.t4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        1.5.height,
        Row(
          children: [
            Image.asset(AppAssets.appLogo, height: 7.w),
            SizedBox(width: 10),
            Text("الشركة المصرية للحلول\nالكهربائية",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: AppFonts.t2)),
          ],
        ),
        1.height,
        _buildInfoRow("إجمالي الطلب", "${cartProvider.totalPrice} ج.م", true),
        _buildInfoRow(
            "عدد المنتجات", "${cartProvider.totalItems} منتجات", true),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("طريقة الدفع", style: TextStyle(fontSize: AppFonts.t2)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.bluebgColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text("كاش", style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value, bool hasCheck) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (hasCheck)
                Icon(Icons.check_circle, color: Colors.green, size: 18),
              SizedBox(width: 5),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Text(value,
              style: TextStyle(
                  color: AppColors.lightOrange, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomBar(CartProvider cartProvider) {
    return InkWell(
      onTap: () {
        // cartProvider.createOrder(propertyId, notes.text);
      },
      child: Container(
        height: 7.5.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
        margin: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 4.w),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("${cartProvider.totalItems} منتجات",
                    style:
                        TextStyle(color: Colors.white, fontSize: AppFonts.t4)),
                Text("${cartProvider.totalPrice} ج.م",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Spacer(),
            Text("إذهب للدفع",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: AppFonts.t2)),
            Spacer(),
            Container(
                padding: EdgeInsets.all(.5.w),
                decoration:
                    getBoxDecoration(fillColor: AppColors.white, radus: 1.w),
                child: Icon(Icons.arrow_forward_ios_outlined,
                    color: AppColors.primary)),
          ],
        ),
      ),
    );
  }

  _noteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ملاحظات الطلبيه",
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.t2)),
        1.height,
        AppTextField(
          hintText: "اضافة ملاحظات",
          borderColor: AppColors.white,
          lines: 4,
          controller: notes,
        )
      ],
    );
  }
}
