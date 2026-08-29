import 'package:flutter/material.dart';
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/core/utils/helpers/helper_functions.dart';
import 'package:t_store/features/shop/presentation/views/product_details_view.dart';

class HorizontalProductCard extends StatelessWidget {
  const HorizontalProductCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.imageUrl,
    this.reviewsCount = '56890',
  });

  final String title;
  final String description;
  final String price;
  final String oldPrice;
  final String discount;
  final String imageUrl;
  final String reviewsCount;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        THelperFunctions.navigateToScreen(
          context,
          ProductDetailsView(
            title: title,
            price: price,
            imageUrl: imageUrl,
            description: description, brandName: 'Nexora',
          ),
        );
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: dark ? TColors.darkContainer : TColors.white,
          border: Border.all(
            color: dark ? TColors.darkerGrey : TColors.borderPrimary,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. الجزء العلوي (صورة المنتج)
            Container(
              height: 130,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: dark ? TColors.dark : TColors.lightContainer, 
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      imageUrl.isEmpty ? 'assets/images/products/product-shirt.png' : imageUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: 110,
                    ),
                  ),
                  
                  // علامة الخصم
                  if (discount.isNotEmpty)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: TColors.warning.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          discount,
                          style: const TextStyle(color: TColors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  // زرار المفضلة
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: dark ? TColors.dark.withOpacity(0.5) : TColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_border, color: TColors.primary, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            
            // 2. الجزء السفلي (التفاصيل والأسعار)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.bold,
                      color: dark ? TColors.textWhite : TColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11, 
                      color: TColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.bold,
                          color: dark ? TColors.textWhite : TColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (oldPrice.isNotEmpty)
                        Text(
                          oldPrice,
                          style: const TextStyle(
                            fontSize: 11,
                            color: TColors.darkGrey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const Icon(Icons.star_half, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        reviewsCount,
                        style: const TextStyle(fontSize: 10, color: TColors.darkGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}