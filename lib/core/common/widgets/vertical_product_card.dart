import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/core/common/view_models/brand_title_with_verification_view_model.dart';
import 'package:t_store/core/common/view_models/circular_container_view_model.dart';
import 'package:t_store/core/common/view_models/product_price_text_view_model.dart';
import 'package:t_store/core/common/view_models/product_title_text_view_model.dart';
import 'package:t_store/core/common/view_models/rounded_image_view_model.dart';
import 'package:t_store/core/common/widgets/add_to_cart_container.dart';
import 'package:t_store/core/common/widgets/brand_title_with_verification.dart';
import 'package:t_store/core/common/widgets/circular_container.dart';
import 'package:t_store/core/common/widgets/product_price_text.dart';
import 'package:t_store/core/common/widgets/product_title_text.dart';
import 'package:t_store/core/common/widgets/rounded_image.dart';
import 'package:t_store/core/common/widgets/sale_tag.dart';
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/core/utils/constants/shadow_styles.dart';
import 'package:t_store/core/utils/constants/sizes.dart';
import 'package:t_store/core/utils/helpers/helper_functions.dart';
import 'package:t_store/features/shop/domain/entities/product_entity.dart';
import 'package:t_store/features/shop/presentation/views/product_details_view.dart';
import 'package:t_store/features/shop/presentation/cubit/wishlist_cubit.dart';

class VerticalProductCard extends StatefulWidget {
  const VerticalProductCard({super.key, required this.product});
  
  final ProductEntity product;

  @override
  State<VerticalProductCard> createState() => _VerticalProductCardState();
}

class _VerticalProductCardState extends State<VerticalProductCard> {
  late bool isInWishlist;
  late WishlistItemModel currentItem;

  @override
  void initState() {
    super.initState();
    currentItem = WishlistItemModel(
      title: widget.product.name,
      price: "\$${widget.product.price}",
      image: widget.product.images.isNotEmpty ? widget.product.images.first : '',
      brandName: widget.product.brandName ?? 'Nexora',
    );
    isInWishlist = WishlistCubit().isExist(currentItem);
  }

  @override
  void didUpdateWidget(covariant VerticalProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentItem = WishlistItemModel(
      title: widget.product.name,
      price: "\$${widget.product.price}",
      image: widget.product.images.isNotEmpty ? widget.product.images.first : '',
      brandName: widget.product.brandName ?? 'Nexora',
    );
    isInWishlist = WishlistCubit().isExist(currentItem);
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
         THelperFunctions.navigateToScreen(
          context,
          ProductDetailsView(
            title: widget.product.name,
            price: "\$${widget.product.price}",
            imageUrl: widget.product.images.isNotEmpty ? widget.product.images.first : '',
            description: widget.product.description ?? '',
            brandName: widget.product.brandName ?? 'Nexora',
          ),
        );
        setState(() {
          isInWishlist = WishlistCubit().isExist(currentItem);
        });
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [TShadowStyle.verticalProductCardShadow],
          borderRadius: const BorderRadius.all(
            Radius.circular(TSizes.productImageRadius),
          ),
          color: dark ? TColors.darkerGrey : TColors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircularContainer(
              circularContainerModel: CircularContainerModel(
                padding: const EdgeInsets.all(TSizes.sm),
                height: 180,
                color: dark ? TColors.dark : TColors.light,
                child: Stack(
                  children: [
                    RoundedImage(
                      roundedImageModel: RoundedImageModel(
                        isNetworkImage: true,
                        backgroundColor: dark ? TColors.dark : TColors.light,
                        image: widget.product.images.first,
                        onTap: () async {
                           THelperFunctions.navigateToScreen(
                            context,
                            ProductDetailsView(
                              title: widget.product.name,
                              price: "\$${widget.product.price}",
                              imageUrl: widget.product.images.isNotEmpty ? widget.product.images.first : '',
                              description: widget.product.description ?? '',
                              brandName: widget.product.brandName ?? 'Nexora',
                            ),
                          );
                          setState(() {
                            isInWishlist = WishlistCubit().isExist(currentItem);
                          });
                        },
                        applyImageRadius: true,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SaleTag(
                          discountPercentage: widget.product.discountPercentage,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: isInWishlist 
                                ? Colors.red.withOpacity(0.15) 
                                : (dark ? TColors.darkerGrey : TColors.white),
                            shape: BoxShape.circle,
                            boxShadow: isInWishlist 
                                ? [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    )
                                  ] 
                                : [],
                          ),
                          child: IconButton(
                            onPressed: () {
                              WishlistCubit().toggleWishlist(currentItem);
                              setState(() {
                                isInWishlist = WishlistCubit().isExist(currentItem);
                              });
                            },
                            icon: Icon(
                              isInWishlist ? Iconsax.heart5 : Iconsax.heart,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductTitleText(
                    productTitleTextModel: ProductTitleTextModel(
                      title: widget.product.name,
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems / 2,
                  ),
                  BrandTitleWithVerification(
                    brandTitleWithVerificationModel:
                        BrandTitleWithVerificationModel(
                      brandName: widget.product.brandName ?? '',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ProductPriceText(
                          productPriceTextModel: ProductPriceTextModel(
                            currencySymbol: "\$",
                            price: widget.product.price.toString(),
                            maxLines: 1,
                            smallSize: true,
                          ),
                        ),
                      ),
                      const AddToCartContainer()
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

