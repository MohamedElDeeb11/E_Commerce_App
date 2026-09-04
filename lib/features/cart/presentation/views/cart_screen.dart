import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/core/dependency_injection/service_locator.dart';
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/core/utils/helpers/helper_functions.dart';
import 'package:t_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:t_store/features/cart/presentation/cubit/cart_state.dart';
import 'package:t_store/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:t_store/features/checkout/presentation/views/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<CartCubit>().getCartItems());

    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.lightContainer,
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartError) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        },
        builder: (context, state) {
          if (state is CartLoading) return const Center(child: CircularProgressIndicator(color: TColors.primary));
          if (state is CartLoaded) {
            final items = state.items;
            if (items.isEmpty) return const Center(child: Text('Your Cart is Empty!'));
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final p = item.product;
                      final img = p?.thumbnail?.isNotEmpty == true ? p!.thumbnail! : '';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: dark ? TColors.darkContainer : TColors.white,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50, height: 50,
                              child: Image.network(img, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p?.name ?? 'Product', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: dark ? TColors.textWhite : TColors.textPrimary), maxLines: 1),
                                  Text('\$${item.totalPrice}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: TColors.primary)),
                                  Row(
                                    children: [
                                      IconButton(icon: const Icon(Icons.remove, size: 14), onPressed: () => context.read<CartCubit>().decrementQuantity(item.id)),
                                      Text('${item.quantity}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                      IconButton(icon: const Icon(Icons.add, size: 14), onPressed: () => context.read<CartCubit>().incrementQuantity(item.id)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Iconsax.trash, color: Colors.red, size: 16),
                              onPressed: () => context.read<CartCubit>().removeFromCart(item.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: dark ? TColors.darkContainer : TColors.white),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal'), Text('\$${state.subtotal.toStringAsFixed(2)}')]),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total'), Text('\$${state.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: TColors.primary))]),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: TColors.primary, minimumSize: const Size(double.infinity, 40)),
                        onPressed: () {
                          THelperFunctions.navigateToScreen(
                            context,
                            BlocProvider(
                              create: (context) => sl<CheckoutCubit>(),
                              child: CheckoutScreen(
                                cartItems: items,
                                subtotal: state.subtotal,
                                shippingFee: state.shippingFee,
                                totalAmount: state.totalPrice,
                              ),
                            ),
                          );
                        },
                        child: const Text('Checkout', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('No cart items found'));
        },
      ),
    );
  }
}

