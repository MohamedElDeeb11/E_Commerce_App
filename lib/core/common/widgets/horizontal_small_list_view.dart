import 'package:flutter/material.dart';
import 'horizontal_product_card.dart'; // استدعاء الكارت

class HorizontalSmallListView extends StatelessWidget {
  const HorizontalSmallListView({super.key, this.items});

  final List<dynamic>? items;

  @override
  Widget build(BuildContext context) {
    // لستة صور حقيقية متنوعة من مسارات المشروع
    final List<String> productImages = [
      'assets/images/products/product-shirt.png',
      'assets/images/products/samsung_s9_mobile.png',
      'assets/images/products/product-shirt_blue_1.png',
      'assets/images/products/product-slippers.png',
      'assets/images/products/samsung_s9_mobile_back.png',
    ];

    return SizedBox(
      height: 245, // زودنا الارتفاع سيكا عشان ميبقاش فيه أي تداخل
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productImages.length, // عدد المنتجات على حسب الصور المتاحة
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: HorizontalProductCard(
              title: index.isEven ? 'Women Printed Kurta' : 'Smart Electronics',
              description: index.isEven ? 'Nehru Jacket, Kurta...' : 'Original Samsung Device',
              price: index.isEven ? '₹999' : '\$299',
              oldPrice: index.isEven ? '₹2499' : '\$450',
              discount: '60% OFF',
              imageUrl: productImages[index], // بنمرر كل صورة حسب الـ index
            ),
          );
        },
      ),
    );
  }
}