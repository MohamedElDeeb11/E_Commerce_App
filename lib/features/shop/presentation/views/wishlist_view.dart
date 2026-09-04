import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/core/utils/constants/sizes.dart';
import 'package:t_store/core/utils/helpers/helper_functions.dart';
import 'package:t_store/features/shop/presentation/cubit/wishlist_cubit.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WishlistCubit(),
      child: const WishlistViewBody(),
    );
  }
}

class WishlistViewBody extends StatelessWidget {
  const WishlistViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.lightContainer,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Wishlist',
          style: TextStyle(
            color: dark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          final cubit = context.read<WishlistCubit>();
          final items = cubit.wishlistItems;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.heart, size: 80, color: TColors.darkGrey),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'Your Wishlist is Empty!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: GridView.builder(
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: TSizes.gridViewSpacing,
                crossAxisSpacing: TSizes.gridViewSpacing,
                mainAxisExtent: 270,
              ),
              itemBuilder: (context, index) {
                final item = items[index];

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: dark ? TColors.darkContainer : TColors.white,
                    borderRadius: BorderRadius.circular(TSizes.productImageRadius),
                    border: Border.all(
                      color: dark ? TColors.darkerGrey : TColors.borderPrimary,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 130,
                        padding: const EdgeInsets.all(TSizes.sm),
                        decoration: BoxDecoration(
                          color: dark ? TColors.dark : TColors.lightContainer,
                          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: item.image.startsWith('assets')
                                  ? Image.asset(item.image, fit: BoxFit.contain)
                                  : Image.network(
                                      item.image,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, _, _) => Image.asset(
                                        'assets/images/products/product-shirt.png',
                                      ),
                                    ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () => cubit.removeFromWishlist(index),
                                icon: const Icon(Iconsax.heart5, color: Colors.red, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems / 2),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: dark ? Colors.white : Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.brandName,
                        style: TextStyle(
                          color: dark ? TColors.darkGrey : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item.price,
                        style: const TextStyle(
                          color: TColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}