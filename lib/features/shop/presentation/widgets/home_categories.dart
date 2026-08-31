import 'package:flutter/material.dart';
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/core/utils/constants/sizes.dart';
import 'package:t_store/core/utils/helpers/helper_functions.dart';
import 'package:t_store/features/shop/presentation/views/sub_category_view.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final List<Map<String, String>> categories = [
      {'title': 'Shirts', 'image': 'assets/icons/categories/mens-shirts.png'},
      {'title': 'Sports', 'image': 'assets/icons/categories/sports-accessories.png'},
      {'title': 'Beauty', 'image': 'assets/icons/categories/beauty.png'},
      {'title': 'Furniture', 'image': 'assets/icons/categories/furniture.png'},
      {'title': 'Laptops', 'image': 'assets/icons/categories/laptops.png'},
      {'title': 'Mobiles', 'image': 'assets/icons/categories/smartphones.png'},
    ];

    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: categories.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              // تم تعديل التوجيه هنا ليرسل اسم القسم مع الشاشة 👈
              THelperFunctions.navigateToScreen(
                context, 
                SubCategoryView(categoryTitle: category['title']!),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: TSizes.spaceBtwItems),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(TSizes.sm),
                    decoration: BoxDecoration(
                      color: dark ? TColors.darkContainer : TColors.light,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: dark ? TColors.darkerGrey : TColors.borderPrimary,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        category['image']!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.category,
                          color: TColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  SizedBox(
                    width: 55,
                    child: Text(
                      category['title']!,
                      style: TextStyle(
                        color: dark ? Colors.white : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}