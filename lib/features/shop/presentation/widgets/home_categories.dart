import 'package:flutter/material.dart';
import 'package:t_store/core/utils/constants/colors.dart'; // ضفنا ملف الألوان هنا

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. تحديد وضع التطبيق (فاتح ولا مظلم)
    final dark = Theme.of(context).brightness == Brightness.dark;

    // لستة التصنيفات الحقيقية مع مسارات صورها الصحيحة من المشروع
    final List<Map<String, String>> categories = [
      {'title': 'Beauty', 'image': 'assets/icons/categories/beauty.png'},
      {'title': 'Furniture', 'image': 'assets/icons/categories/furniture.png'},
      {'title': 'Laptops', 'image': 'assets/icons/categories/laptops.png'},
      {'title': 'Smartphones', 'image': 'assets/icons/categories/smartphones.png'},
      {'title': 'Fashion', 'image': 'assets/icons/categories/mens-shirts.png'},
      {'title': 'Shoes', 'image': 'assets/icons/categories/mens-shoes.png'},
      {'title': 'Jewellery', 'image': 'assets/icons/categories/womens-jewellery.png'},
    ];
    
    return SizedBox(
      height: 90,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              children: [
                // دايرة الصورة
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    // 2. تغيير لون الخلفية أوتوماتيك بناءً على الثيم
                    color: dark ? TColors.darkContainer : Colors.grey[100],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(categories[index]['image']!),
                      fit: BoxFit.cover,
                      // 3. تغيير لون الأيقونة نفسها (أبيض في الدارك مود، أسود في اللايت مود)
                      colorFilter: dark 
                          ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                          : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  categories[index]['title']!,
                  style: Theme.of(context).textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}