import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ProductFilterBottomSheet extends StatelessWidget {
  const ProductFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProductFilterBottomSheetContent();
  }
}

class _ProductFilterBottomSheetContent extends StatefulWidget {
  const _ProductFilterBottomSheetContent();

  @override
  State<_ProductFilterBottomSheetContent> createState() =>
      _ProductFilterBottomSheetContentState();
}

class _ProductFilterBottomSheetContentState
    extends State<_ProductFilterBottomSheetContent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HomeProvider>(context, listen: false).getAllBrands();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: provider.isLoadingBrands
            ? loadingIndicator
            : Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 3.w),
                    width: 35.w,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  _buildHeader(),
                  Expanded(
                    child: CupertinoScrollbar(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 4.5.w),
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: provider.listOfBrands.isEmpty
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.spaceBetween,
                              children: [
                                provider.listOfBrands.isEmpty
                                    ? const SizedBox()
                                    : _BrandFilterSection(),
                                _ProductTypeFilterSection(),
                              ]),
                          Divider(height: 32),
                          _NewestOffers(),
                          Divider(height: 32),
                          _SortingSection(),
                          _BottomButtons(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'تصفية حسب',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewestOffers extends StatelessWidget {
  const _NewestOffers();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...provider.newestOffersFilters.entries.map((entry) {
          return SizedBox(
            height: 40,
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    activeColor: AppColors.primary,
                    value: entry.value,
                    onChanged: (bool? value) {
                      provider.updateNewestOffersFilter(entry.key, value!);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  entry.key,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _BrandFilterSection extends StatelessWidget {
  const _BrandFilterSection();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'العلامة التجارية',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...provider.listOfBrands.map((entry) {
          final isSelected =
              provider.selectedBrandIds.contains(entry.id.toString());

          return SizedBox(
            height: 40,
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    activeColor: AppColors.primary,
                    value: isSelected,
                    onChanged: (bool? value) {
                      if (value != null) {
                        provider.updateBrandFilter(entry.id.toString(), value);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  entry.name ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _ProductTypeFilterSection extends StatelessWidget {
  const _ProductTypeFilterSection();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'عدد المنتج',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...provider.productTypeFilters.entries.map((entry) {
          return SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        activeColor: AppColors.primary,
                        value: entry.value,
                        onChanged: (bool? value) {
                          provider.updateProductTypeFilter(entry.key, value!);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      entry.key,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _SortingSection extends StatelessWidget {
  const _SortingSection();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'ترتيب حسب',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...provider.sortOptions.map((option) {
          return SizedBox(
            height: 70,
            child: Column(
              children: [
                Row(
                  children: [
                    Radio<String>(
                      activeColor: AppColors.primary,
                      value: option,
                      groupValue: provider.selectedSortingText,
                      onChanged: (String? value) {
                        provider.updateSorting(value!);
                      },
                    ),
                    Text(
                      option,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Divider(color: Colors.grey[300], thickness: 1),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
              onPressed: () {
                provider.applyFilters();
                Navigator.pop(context);
              },
              child: Text(
                'تطبيق',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.cairo().fontFamily),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                provider.resetFilters();
                Navigator.pop(context);
              },
              child: Text(
                'تراجع',
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: GoogleFonts.cairo().fontFamily),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
