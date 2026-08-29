import 'package:flutter/material.dart';
import 'package:t_store/core/utils/constants/colors.dart'; // ضفنا سطر الألوان هنا
import 'package:t_store/core/common/widgets/horizontal_small_list_view.dart';
import 'package:t_store/core/common/view_models/section_heading_view_model.dart';
import 'package:t_store/core/common/widgets/section_heading.dart';
import '../widgets/home_header_section.dart';
import '../widgets/home_categories.dart';
import '../widgets/promo_banner_carousel_slider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // المتغير ده بيعرف التطبيق في الوضع الفاتح ولا المظلم
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. الهيدر العلوي (الـ App Bar وشريط البحث معاً)
              const HomeHeaderSection(),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. عنوان التصنيفات مع أزرار الفلتر والترتيب
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Featured',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: dark ? Colors.white : Colors.black, // يتغير مع الدارك مود
                          ),
                        ),
                        Row(
                          children: [
                            // زرار Sort
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: dark ? TColors.darkContainer : Colors.grey[200], // خلفية متفاعلة
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Sort ',
                                    style: TextStyle(
                                        color: dark ? Colors.white : Colors.black), // لون النص
                                  ),
                                  Icon(
                                    Icons.sort,
                                    size: 16,
                                    color: dark ? Colors.white : Colors.black, // لون الأيقونة
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            
                            // زرار Filter
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: dark ? TColors.darkContainer : Colors.grey[200], // خلفية متفاعلة
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Filter ',
                                    style: TextStyle(
                                        color: dark ? Colors.white : Colors.black), // لون النص
                                  ),
                                  Icon(
                                    Icons.filter_alt_outlined,
                                    size: 16,
                                    color: dark ? Colors.white : Colors.black, // لون الأيقونة
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 3. التصنيفات الدائرية
                    const HomeCategories(),
                    const SizedBox(height: 24),

                    // 4. البانر الإعلاني المتحرك (Slider)
                    const PromoBannerCarouselSlider(),
                    const SizedBox(height: 24),

                    // 5. قسم عرض اليوم (Deal of the Day)
                    const ColoredSectionHeader(
                      title: 'Deal of the Day',
                      subtitle: '22h 55m 20s remaining',
                      color: Colors.blue,
                      icon: Icons.access_time,
                    ),
                    const SizedBox(height: 16),

                    HorizontalSmallListView(items: const []),
                    const SizedBox(height: 24),

                    // 6. بانر عروض خاصة
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/banners/banner_4.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 7. المنتجات الرائجة (Trending Products)
                    const ColoredSectionHeader(
                      title: 'Trending Products',
                      subtitle: 'Last Date 29/02/22',
                      color: Colors.redAccent,
                      icon: Icons.calendar_month,
                    ),
                    const SizedBox(height: 16),

                    HorizontalSmallListView(items: const []),
                    const SizedBox(height: 24),

                    // 8. بانر الصيف
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/banners/banner_2.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 9. الوافدون الجدد (New Arrivals)
                    const SectionHeading(
                      sectionHeadingModel: SectionHeadingModel(
                        title: 'New Arrivals',
                        showActionButton: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    HorizontalSmallListView(items: const []),
                    const SizedBox(height: 24),

                    // 10. قسم ممول (Sponsored)
                    Text(
                      'Sponsored',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : Colors.black, // يتغير مع الدارك مود
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/banners/banner_3.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// هيدر الأقسام الملونة
class ColoredSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const ColoredSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              foregroundColor: Colors.white,
            ),
            child: const Text('View all ->'),
          )
        ],
      ),
    );
  }
}