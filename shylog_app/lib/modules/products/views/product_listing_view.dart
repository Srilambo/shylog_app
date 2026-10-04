import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/product_card.dart';
import '../../../data/sample_data.dart';
import '../controllers/product_controller.dart';

class ProductListingView extends StatelessWidget {
  const ProductListingView({super.key});

  @override
  Widget build(BuildContext context) {
    final prodCtrl = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog & Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              Get.bottomSheet(
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filter By Category',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: SampleData.categories.map((cat) {
                          return Obx(() {
                            final isSel = prodCtrl.selectedCategory.value == cat;
                            return ChoiceChip(
                              label: Text(cat),
                              selected: isSel,
                              onSelected: (_) {
                                prodCtrl.selectCategory(cat);
                                Get.back();
                              },
                            );
                          });
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ContentConstraint(
        maxWidth: 1200,
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (val) => prodCtrl.updateSearch(val),
                decoration: InputDecoration(
                  hintText: "Filter all boys' clothing items...",
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                  filled: true,
                  fillColor: Theme.of(context).cardTheme.color,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),
            // Category Chips Bar
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: SampleData.categories.length,
                separatorBuilder: (_, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = SampleData.categories[index];
                  return Obx(() {
                    final isSel = prodCtrl.selectedCategory.value == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSel,
                      onSelected: (_) => prodCtrl.selectCategory(cat),
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            // Product Grid
            Expanded(
              child: Obx(() {
                final items = prodCtrl.filteredProducts;
                if (items.isEmpty) {
                  return const Center(
                    child: Text('No items found matching criteria.'),
                  );
                }

                final cols = Breakpoints.getGridColumnCount(context);
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.64,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: items[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
