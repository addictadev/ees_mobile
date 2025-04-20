import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_asset_img.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/app/widgets/custom_app_bar.dart';
import 'package:ees/controllers/static_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_html/flutter_html.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key, this.title, this.isTerms});
  final String? title;
  final bool? isTerms;

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  @override
  void initState() {
    Future.microtask(() {
      Provider.of<StaticProvider>(context, listen: false).getStaticData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StaticProvider>(
          builder: (BuildContext context, value, Widget? child) {
        return Column(
          children: [
            CustomeAppBar(
              text:
                  widget.isTerms == true ? "الشروط والاحكام" : "سياسة الخصوصية",
            ),
            CustomImageAsset(
              assetName: AppAssets.appLogo,
              width: 50.w,
            ),
            1.height,
            Expanded(
                child: value.isLoading
                    ? Center(child: loadingIndicator)
                    : SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        physics: BouncingScrollPhysics(),
                        child: Html(
                            data: widget.isTerms == true
                                ? value.staticModel!.data!.first.terms ?? ""
                                : value.staticModel!.data!.first.privacy ??
                                    ""))),
          ],
        );
      }),
    );
  }
}
