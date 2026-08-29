import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/core/utils/constants/sizes.dart';
import 'package:t_store/core/utils/helpers/helper_functions.dart';
import 'package:t_store/features/shop/presentation/cubit/cart_cubit.dart';
import 'package:t_store/features/shop/presentation/cubit/wishlist_cubit.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description, required this.brandName,
  });

  final String title;
  final String price;
  final String imageUrl;
  final String brandName;
  final String description;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  String selectedSize = '8';

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.lightContainer,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(TSizes.defaultSpace / 1.5),
        decoration: BoxDecoration(
          color: dark ? TColors.darkerGrey : TColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(TSizes.cardRadiusLg),
            topRight: Radius.circular(TSizes.cardRadiusLg),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: dark ? TColors.dark : TColors.lightContainer,
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                border: Border.all(color: TColors.borderPrimary),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.bag, color: TColors.primary),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(TSizes.md),
                  backgroundColor: TColors.primary,
                  side: const BorderSide(color: TColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                  ),
                ),
                onPressed: () {
                  CartCubit().addToCart(
                    CartItemModel(
                      title: widget.title,
                      price: widget.price,
                      image: widget.imageUrl,
                      brandName: 'Nexora',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to Cart Successfully!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text(
                  'Buy Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 380,
              width: double.infinity,
              decoration: BoxDecoration(
                color: dark ? TColors.darkContainer : TColors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 50,
                        left: TSizes.defaultSpace,
                        right: TSizes.defaultSpace,
                        bottom: TSizes.defaultSpace,
                      ),
                      child: Center(
                        child: widget.imageUrl.startsWith('http')
                            ? Image.network(
                                widget.imageUrl,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/images/products/product-shirt.png',
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Image.asset(
                                widget.imageUrl.isEmpty
                                    ? 'assets/images/products/product-shirt.png'
                                    : widget.imageUrl,
                                fit: BoxFit.contain,
                                width: double.infinity,
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: TSizes.spaceBtwSections,
                    left: TSizes.defaultSpace,
                    right: TSizes.defaultSpace,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: dark ? TColors.dark : TColors.white,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: dark ? Colors.white : Colors.black,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        BlocBuilder<WishlistCubit, WishlistState>(
                          bloc: WishlistCubit(),
                          builder: (context, state) {
                            final cubit = WishlistCubit();
                            final currentItem = WishlistItemModel(
                              title: widget.title,
                              price: widget.price,
                              image: widget.imageUrl,
                              brandName: 'Nexora',
                            );
                            final inWishlist = cubit.isExist(currentItem);

                            return CircleAvatar(
                              backgroundColor: dark ? TColors.dark : TColors.white,
                              child: IconButton(
                                icon: Icon(
                                  inWishlist ? Iconsax.heart5 : Iconsax.heart,
                                  color: inWishlist
                                      ? Colors.red
                                      : (dark ? Colors.white : Colors.black),
                                ),
                                onPressed: () {
                                  cubit.toggleWishlist(currentItem);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        inWishlist
                                            ? 'Removed from Wishlist'
                                            : 'Added to Wishlist',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: dark ? Colors.white : TColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        widget.price,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: TColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '4.5',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: dark ? Colors.white : Colors.black,
                        ),
                      ),
                      const Text(
                        ' (20 Review)',
                        style: TextStyle(color: TColors.darkGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(
                    widget.description.isEmpty
                        ? 'No description available for this product.'
                        : widget.description,
                    style: const TextStyle(
                      color: TColors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const Text(
                    'Size',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    children: [
                      _buildSizeChip('8', dark),
                      const SizedBox(width: 8),
                      _buildSizeChip('10', dark),
                      const SizedBox(width: 8),
                      _buildSizeChip('38', dark),
                      const SizedBox(width: 8),
                      _buildSizeChip('40', dark, isDisabled: true),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections * 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeChip(String size, bool dark, {bool isDisabled = false}) {
    final isSelected = selectedSize == size;

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              setState(() {
                selectedSize = size;
              });
            },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isSelected
              ? TColors.primary
              : (dark ? TColors.darkContainer : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? TColors.primary
                : (dark ? TColors.darkerGrey : TColors.borderPrimary),
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                size,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDisabled
                          ? TColors.darkGrey
                          : (dark ? Colors.white : Colors.black)),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isDisabled)
                Container(
                  width: 30,
                  height: 1.5,
                  color: TColors.darkGrey,
                ),
            ],
          ),
        ),
      ),
    );
  }
}