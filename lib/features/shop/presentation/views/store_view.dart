import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/core/utils/constants/sizes.dart';
import 'package:t_store/core/utils/helpers/helper_functions.dart';

class StoreView extends StatelessWidget {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return DefaultTabController(
      length: 5, // عدد تبويبات الأقسام الرئيسية
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Store',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: dark ? TColors.white : TColors.textPrimary,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Iconsax.shopping_cart,
                color: dark ? TColors.white : TColors.dark,
              ),
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    children: [
                      // 1. شريط البحث في المتجر
                      Container(
                        padding: const EdgeInsets.all(TSizes.md),
                        decoration: BoxDecoration(
                          color: dark ? TColors.dark : TColors.light,
                          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                          border: Border.all(color: TColors.grey),
                        ),
                        child: const Row(
                          children: [
                            Icon(Iconsax.search_normal, color: TColors.darkGrey),
                            SizedBox(width: TSizes.spaceBtwItems),
                            Text('Search in store...', style: TextStyle(color: TColors.darkGrey)),
                          ],
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      // 2. عنوان البراندات المميزة مع زرار View All
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Featured Brands',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('View All', style: TextStyle(color: TColors.primary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems / 1.5),

                      // 3. شبكة مصغرة لعرض البراندات (Brands Grid)
                      GridView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 80,
                          mainAxisSpacing: TSizes.spaceBtwItems / 2,
                          crossAxisSpacing: TSizes.spaceBtwItems / 2,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(TSizes.sm),
                            decoration: BoxDecoration(
                              color: dark ? TColors.darkContainer : Colors.white,
                              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                              border: Border.all(
                                color: dark ? TColors.darkerGrey : TColors.borderPrimary,
                              ),
                            ),
                            child: Row(
                              children: [
                                // أيقونة أو لوجو البراند
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: dark ? TColors.dark : TColors.light,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Iconsax.shop, color: TColors.primary),
                                ),
                                const SizedBox(width: TSizes.spaceBtwItems / 2),
                                // اسم البراند وعدد المنتجات
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Nike',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '256 Products',
                                        style: TextStyle(color: TColors.darkGrey, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 4. التبويبات العلوية (TabBar) للأقسام داخل المتجر
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    isScrollable: true,
                    indicatorColor: TColors.primary,
                    labelColor: dark ? TColors.white : TColors.primary,
                    unselectedLabelColor: TColors.darkGrey,
                    tabs: const [
                      Tab(text: 'Sports'),
                      Tab(text: 'Furniture'),
                      Tab(text: 'Electronics'),
                      Tab(text: 'Clothes'),
                      Tab(text: 'Cosmetics'),
                    ],
                  ),
                  dark,
                ),
              ),
            ];
          },
          // محتوى التبويبات المتغيرة
          body: TabBarView(
            children: [
              _buildCategoryTabContent(dark),
              _buildCategoryTabContent(dark),
              _buildCategoryTabContent(dark),
              _buildCategoryTabContent(dark),
              _buildCategoryTabContent(dark),
            ],
          ),
        ),
      ),
    );
  }

  // محتوى تجريبي لكل تبويب
  Widget _buildCategoryTabContent(bool dark) {
    return ListView(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      children: [
        const Text(
          'You might like these',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        // شبكة منتجات مصغرة داخل التبويب
        GridView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 220,
            mainAxisSpacing: TSizes.spaceBtwItems,
            crossAxisSpacing: TSizes.spaceBtwItems,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: dark ? TColors.darkContainer : TColors.white,
                borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                border: Border.all(color: dark ? TColors.darkerGrey : TColors.borderPrimary),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: dark ? TColors.dark : TColors.light,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(TSizes.cardRadiusLg),
                        topRight: Radius.circular(TSizes.cardRadiusLg),
                      ),
                    ),
                    child: const Center(
                      child: Icon(Iconsax.box, size: 40, color: TColors.primary),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Product Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        SizedBox(height: 4),
                        Text('\$135.0', style: TextStyle(color: TColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// مساعد لتثبيت الـ TabBar فوق الـ Scroll
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this._dark);

  final TabBar _tabBar;
  final bool _dark;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: _dark ? TColors.dark : TColors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}