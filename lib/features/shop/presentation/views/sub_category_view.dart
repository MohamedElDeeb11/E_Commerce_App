import 'package:flutter/material.dart';
import 'package:t_store/features/shop/data/dummy_products.dart';
import 'package:t_store/features/shop/data/models/product_model.dart';

class SubCategoryView extends StatelessWidget {
  final String categoryTitle; // اسم القسم اللي جاي من الرئيسية (مثلا Laptops أو Shirts)

  const SubCategoryView({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    // بنفلتر المنتجات الوهمية بحيث تجيب المنتجات التابعة للقسم ده بس
    final List<ProductModel> filteredProducts = DummyData.products
        .where((product) => product.categoryName?.toLowerCase() == categoryTitle.toLowerCase())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: filteredProducts.isEmpty
          ? const Center(
              child: Text('عذراً، لا توجد منتجات متاحة في هذا القسم حالياً'),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // عمودين جنب بعض
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75, // نسبة الطول للعرض عشان الكارت يطلع مظبوط
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // صورة المنتج (مؤقتاً بنعرض أيقونة أو صورة لو متوفرة)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            ),
                            child: const Center(
                              child: Icon(Icons.shopping_bag, size: 50, color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${product.price}',
                                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}