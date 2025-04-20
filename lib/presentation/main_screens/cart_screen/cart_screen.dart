import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/utils/error_view.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../app/widgets/app_text_field.dart';
import '../../../app/widgets/loginFrist.dart';
import '../../../controllers/cart_controller.dart';
import 'package:provider/provider.dart';

import '../home_screen/widgets/homeAppBar.dart';
import '../widgets/drawer.dart';
import 'widgets/cart_item.dart';
import 'widgets/empty_cart.dart';
import 'widgets/minu_order_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (IsLogin())
        Provider.of<CartProvider>(context, listen: false).getCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

// Initialize defaults
    double totalPrice = 0;
    double cartMin = 0;

    final items = cartProvider.cartModel?.data?.items ?? [];

    if (items.isNotEmpty) {
      totalPrice = double.tryParse(
              cartProvider.cartModel!.data!.totalPrice.toString()) ??
          0;
      cartMin = double.tryParse(items.first.property?.cart_min ?? "0") ?? 0;
    }

    return Consumer<CartProvider>(
        builder: (BuildContext context, value, Widget? child) {
      return Scaffold(
        bottomSheet: IsLogin()
            ? value.isLoadingGetCart
                ? SizedBox()
                : cartProvider.cartModel?.data!.items != Null &&
                        cartProvider.cartModel!.data!.items!.isNotEmpty &&
                        totalPrice >= cartMin
                    ? _buildBottomBar(cartProvider)
                    : SizedBox()
            : null,
        body: Column(
          children: [
            HomeAppBar(text: 'العربة', isHome: false),
            Expanded(
              child: IsLogin()
                  ? value.isLoadingGetCart || cartProvider.cartModel == null
                      ? loadingIndicator
                      : value.hasErrorGetCart
                          ? ErrorView(onReload: () {
                              cartProvider.getCartItems();
                            })
                          : value.cartModel!.data!.items!.isEmpty
                              ? EmptyCart()
                              : SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6.w, vertical: 3.w),
                                  child: Column(
                                    children: [
                                      _buildHeader(value),
                                      _buildOrderSummary(cartProvider),
                                      2.height,
                                      _buildPaymentMethod(),
                                      2.height,
                                      Container(
                                        margin: EdgeInsets.only(bottom: 2.h),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.primary),
                                          borderRadius:
                                              BorderRadius.circular(2.w),
                                        ),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: cartProvider
                                              .cartModel?.data!.items!.length,
                                          itemBuilder: (context, index) {
                                            return CartItemWidget(
                                                cartItem: cartProvider
                                                    .cartModel!
                                                    .data!
                                                    .items![index]);
                                          },
                                        ),
                                      ),
                                      if (cartProvider
                                              .cartModel?.data!.discount ==
                                          0)
                                        _promoCodeSection(),
                                      if (cartProvider
                                              .cartModel?.data!.discount ==
                                          0)
                                        2.height,
                                      _noteSection(),
                                      9.height
                                    ],
                                  ),
                                )
                  : LoginFristWidget(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(CartProvider value) {
    final totalPrice =
        double.tryParse(value.cartModel!.data!.totalPrice.toString()) ?? 0;
    final cartMin = double.tryParse(
            value.cartModel!.data!.items!.first.property!.cart_min ?? "0") ??
        0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: totalPrice <= cartMin
                ? Colors.red.withOpacity(.2)
                : Colors.green.withOpacity(.2),
            borderRadius: BorderRadius.circular(1.w),
          ),
          child: Row(
            children: [
              Icon(
                  totalPrice <= cartMin
                      ? Icons.cancel_outlined
                      : Icons.check_circle_outline_rounded,
                  color: totalPrice <= cartMin ? AppColors.red : Colors.green),
              1.width,
              Text(totalPrice <= cartMin ? "طلب غير صالح" : "طلب صالح",
                  style: TextStyle(
                      color:
                          totalPrice <= cartMin ? AppColors.red : Colors.green,
                      fontSize: AppFonts.t4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    final totalPrice =
        double.tryParse(cartProvider.cartModel!.data!.totalPrice.toString()) ??
            0;
    final cartMin = double.tryParse(
            cartProvider.cartModel!.data!.items!.first.property!.cart_min ??
                "0") ??
        0;
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
        if (totalPrice <= cartMin) 1.height,
        if (totalPrice <= cartMin)
          MinimumOrderWidget(
            minimumOrder: double.tryParse(cartProvider
                        .cartModel!.data!.items!.first.property!.cart_min ??
                    "0") ??
                0,
            currentAmount: double.tryParse(
                    cartProvider.cartModel!.data!.totalPrice.toString()) ??
                0,
          ),
        1.height,
        if (cartProvider.cartModel?.data!.discount == 0)
          _buildInfoRow(totalPrice <= cartMin, "إجمالي الطلب",
              "${cartProvider.cartModel?.data!.totalPrice!} ج.م", true),
        if (cartProvider.cartModel?.data!.discount != 0)
          _buildInfoRow(totalPrice <= cartMin, "إجمالي قبل الخصم",
              "${cartProvider.cartModel?.data!.totalPrice!} ج.م", true),
        if (cartProvider.cartModel?.data!.discount != 0)
          _buildInfoRow(false, "الخصم",
              "- ${cartProvider.cartModel?.data!.discount} ج.م", true),
        if (cartProvider.cartModel?.data!.discount != 0)
          _buildInfoRow(false, "الاجمالي بعد الخصم",
              "${cartProvider.cartModel?.data!.totalAfterDiscount} ج.م", true),
        _buildInfoRow(totalPrice <= cartMin, "عدد المنتجات",
            "${cartProvider.cartModel?.data!.items!.length} منتجات", true),
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
            color: AppColors.blueColor.withOpacity(.15),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text("كاش",
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      bool isActive, String title, String value, bool hasCheck) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (hasCheck)
                Icon(
                    isActive == true
                        ? Icons.cancel_outlined
                        : Icons.check_circle,
                    color: isActive == true ? AppColors.red : Colors.green,
                    size: 18),
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
      onTap: () => cartProvider.createOrder(
        cartProvider.cartModel!.data!.items!.first.property!.id,
      ),
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
                Text("${cartProvider.cartModel?.data!.items!.length} منتجات",
                    style:
                        TextStyle(color: Colors.white, fontSize: AppFonts.t4)),
                Text(
                    "${cartProvider.cartModel?.data!.totalAfterDiscount ?? cartProvider.cartModel?.data!.totalPrice} ج.م",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Spacer(),
            Text("تأكيد الطلب",
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
        CustomText(
            text: "ملاحظات الطلبيه",
            fontweight: FontWeight.w600,
            fontSize: AppFonts.t2),
        1.height,
        AppTextField(
          hintText: "اضافة ملاحظات",
          lines: 3,
          controller:
              Provider.of<CartProvider>(context, listen: false).noteController,
        )
      ],
    );
  }

  Widget _promoCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
            text: 'كود الخصم',
            fontSize: AppFonts.t2,
            fontweight: FontWeight.w600,
            padding: EdgeInsets.only(bottom: 1.h)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppTextField(
                hintText: "كود الخصم",
                borderColor: AppColors.white,
                controller:
                    Provider.of<CartProvider>(context, listen: false).copounCtn,
              ),
            ),
            2.width,
            Consumer<CartProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return SizedBox(
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      await value.applyCopun();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                      ),
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
      ],
    );
  }
}
