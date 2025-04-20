// product_filter_bottom_sheet.dart
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProductFilterBottomSheet extends StatelessWidget {
  const ProductFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProductFilterBottomSheetContent();
  }
}

class _ProductFilterBottomSheetContent extends StatelessWidget {
  const _ProductFilterBottomSheetContent();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          children: [
            // Drag indicator
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            _buildHeader(),

            // Product type toggle
            _buildInstallmentToggle(),

            // Filter sections
            Expanded(
              child: CupertinoScrollbar(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: const [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Brand filters
                          _BrandFilterSection(),

                          // Product type filters
                          _ProductTypeFilterSection(),
                        ]),

                    Divider(height: 32),

                    // Sorting options
                    _SortingSection(),
                    _BottomButtons(),
                  ],
                ),
              ),
            ),
            // Bottom buttons
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

  Widget _buildInstallmentToggle() {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'طريقة الدفع',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '(كاش)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[600],
                    ),
                  ),
                ],
              ),
              CupertinoSwitch(
                value: provider.isInstallmentEnabled,
                onChanged: provider.toggleInstallmentPayment,
                activeColor: Colors.blue,
              ),
            ],
          ),
        );
      },
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
        ...provider.brandFilters.entries.map((entry) {
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
                      provider.updateBrandFilter(entry.key, value!);
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
        // Display standard product type filters
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
        // Width filter option
        SizedBox(
          height: 40,
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  activeColor: AppColors.primary,
                  value: provider.showWidthFilterOption,
                  onChanged: (bool? value) {
                    provider.toggleWidthFilterOption(value!);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'احدد العرض',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
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
                      groupValue: provider.selectedSorting,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                provider.resetFilters();
                Navigator.pop(context);
              },
              child: const Text(
                'تراجع',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
              onPressed: () {
                provider.applyFilters();
                Navigator.pop(context);
              },
              child: const Text(
                'تطبيق',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
