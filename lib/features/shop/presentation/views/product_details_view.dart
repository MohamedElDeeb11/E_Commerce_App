import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/core/utils/constants/sizes.dart';
import 'package:t_store/core/utils/helpers/helper_functions.dart';
import 'package:t_store/features/shop/domain/entities/product_entity.dart';
import 'package:t_store/features/shop/presentation/cubit/cart_cubit.dart';
import 'package:t_store/features/shop/presentation/cubit/wishlist_cubit.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsView({
    super.key,
    required this.product,
  });

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
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('السعر الإجمالي', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                  '\$${widget.product.price}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: TColors.primary),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: TSizes.spaceBtwItems),
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
                    context.read<CartCubit>().addToCart(
                      CartItemModel(
                        title: widget.product.name,
                        price: '\$${widget.product.price}',
                        image: widget.product.images.isNotEmpty ? widget.product.images.first : '',
                        brandName: widget.product.brandName ?? 'Nexora',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to Cart Successfully! 🚀'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Text(
                    'أضف إلى السلة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
              height: 350,
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
                      padding: const EdgeInsets.all(TSizes.defaultSpace * 2),
                      child: Center(
                        child: widget.product.images.isNotEmpty && widget.product.images.first.isNotEmpty
                            ? Image.network(
                                widget.product.images.first,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag, size: 120, color: TColors.primary),
                              )
                            : const Icon(Icons.shopping_bag, size: 120, color: TColors.primary),
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
                          builder: (context, state) {
                            // تم استخدام watch/read بأمان من خلال الـ context الخاص بالـ BlocBuilder
                            final wishlistCubit = BlocProvider.of<WishlistCubit>(context);
                            final currentItem = WishlistItemModel(
                              title: widget.product.name,
                              price: '\$${widget.product.price}',
                              image: widget.product.images.isNotEmpty ? widget.product.images.first : '',
                              brandName: widget.product.brandName ?? 'Nexora',
                            );
                            final inWishlist = wishlistCubit.isExist(currentItem);

                            return CircleAvatar(
                              backgroundColor: dark ? TColors.dark : TColors.white,
                              child: IconButton(
                                icon: Icon(
                                  inWishlist ? Iconsax.heart5 : Iconsax.heart,
                                  color: inWishlist ? Colors.red : (dark ? Colors.white : Colors.black),
                                ),
                                onPressed: () {
                                  wishlistCubit.toggleWishlist(currentItem);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(inWishlist ? 'Removed from Wishlist' : 'Added to Wishlist'),
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
                          widget.product.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: dark ? Colors.white : TColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: TColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.product.brandName ?? 'Nexora',
                          style: const TextStyle(color: TColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          SizedBox(width: 4),
                          Text(
                            '4.5',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(' (20 تقييم)', style: TextStyle(color: TColors.darkGrey)),
                        ],
                      ),
                      Text(
                        widget.product.stock > 0 ? 'متاح في المخزون (${widget.product.stock})' : 'غير متوفر',
                        style: TextStyle(
                          color: widget.product.stock > 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const Text('وصف المنتج', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(
                    widget.product.description ?? 'لا يوجد وصف متاح لهذا المنتج.',
                    style: const TextStyle(color: TColors.textSecondary, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const Text('المقاس', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    children: [
                      _buildSizeChip('S', dark),
                      const SizedBox(width: 8),
                      _buildSizeChip('M', dark),
                      const SizedBox(width: 8),
                      _buildSizeChip('L', dark),
                      const SizedBox(width: 8),
                      _buildSizeChip('XL', dark),
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

  Widget _buildSizeChip(String size, bool dark) {
    final isSelected = selectedSize == size;

    return GestureDetector(
      onTap: () => setState(() => selectedSize = size),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isSelected ? TColors.primary : (dark ? TColors.darkContainer : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? TColors.primary : (dark ? TColors.darkerGrey : TColors.borderPrimary),
          ),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: isSelected ? Colors.white : (dark ? Colors.white : Colors.black),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}