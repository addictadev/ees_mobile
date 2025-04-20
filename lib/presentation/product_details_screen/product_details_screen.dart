import 'dart:developer';

import 'package:ees/app/widgets/custom_app_bar.dart';
import 'package:ees/models/products_home_data_model.dart';
import 'package:ees/presentation/main_screens/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'widgets/product_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen(
      {super.key, required this.product, required String productName});
  final ProductData product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    log(widget.product.toJson().toString());
    return Scaffold(
      body: Column(
        children: [
          CustomeAppBar(text: widget.product.name ?? ''),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  ProductCard(product: widget.product),
                  Divider(),
                  CompanyInfo(product: widget.product),
                  IsLogin()
                      ? AddToCartButton(product: widget.product)
                      : SizedBox(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
