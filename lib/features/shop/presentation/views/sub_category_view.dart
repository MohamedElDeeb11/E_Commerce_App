import 'package:flutter/material.dart';
import 'package:t_store/core/common/view_models/app_bar_view_model.dart';
import 'package:t_store/core/common/view_models/rounded_image_view_model.dart';
import 'package:t_store/core/common/view_models/section_heading_view_model.dart';
import 'package:t_store/core/common/widgets/app_bar.dart';
import 'package:t_store/core/common/widgets/horizontal_product_card.dart';
import 'package:t_store/core/common/widgets/rounded_image.dart';
import 'package:t_store/core/common/widgets/section_heading.dart';
import 'package:t_store/core/utils/constants/image_strings.dart';
import 'package:t_store/core/utils/constants/sizes.dart';

class SubCategoryView extends StatelessWidget {
  const SubCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarModel: AppBarModel(
          hasArrowBack: true,
          title: const Text("Sports Shirts"),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                // 1. البانر
                RoundedImage(
                  roundedImageModel: RoundedImageModel(
                    image: TImages.promoBanner2,
                    applyImageRadius: true,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),

                Column(
                  children: [
                    // 2. الهيدر
                    SectionHeading(
                      sectionHeadingModel: SectionHeadingModel(
                        title: 'Sports Shirts',
                        showActionButton: false, 
                      ), title: 'Sports Shirts',
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    // 3. لستة المنتجات
                    SizedBox(
                      height: 160, 
                      child: ListView.separated(
                        itemCount: 5,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => const HorizontalProductCard(
                          title: 'Nike Sports Shirt',
                          description: 'Nike',
                          price: '\$25.0',
                          oldPrice: '\$35.0',
                          discount: '15%', imageUrl: '',
                        ),
                        separatorBuilder: (context, index) => const SizedBox(
                          width: TSizes.spaceBtwItems,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}