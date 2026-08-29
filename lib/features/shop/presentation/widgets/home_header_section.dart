import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/core/utils/constants/sizes.dart';
import 'package:t_store/core/utils/helpers/helper_functions.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: TSizes.spaceBtwItems,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. زرار القائمة
          Container(
            decoration: BoxDecoration(
              color: dark ? TColors.darkerGrey : TColors.light,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Iconsax.menu,
                color: dark ? TColors.white : TColors.dark,
              ),
            ),
          ),

          // 2. اللوجو واسم الماركة (Nexora)
          Row(
            children: [
              const Icon(
                Icons.shopping_bag, 
                color: TColors.primary, 
                size: 32,
              ), 
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              const Text(
                'Nexora',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary, 
                ),
              ),
            ],
          ),
          
          // 3. صورة البروفايل وحدها على اليمين
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.user, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}