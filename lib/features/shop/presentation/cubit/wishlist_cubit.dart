
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistItemModel {
  final String title;
  final String price;
  final String image;
  final String brandName;

  WishlistItemModel({
    required this.title,
    required this.price,
    required this.image,
    required this.brandName,
  });
}

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistUpdated extends WishlistState {
  final List<WishlistItemModel> items;
  WishlistUpdated(this.items);
}

class WishlistCubit extends Cubit<WishlistState> {
  static final WishlistCubit _instance = WishlistCubit._internal();
  factory WishlistCubit() => _instance;
  WishlistCubit._internal() : super(WishlistInitial());

  final List<WishlistItemModel> wishlistItems = [];

  bool isExist(WishlistItemModel item) {
    final exists = wishlistItems.any((element) => 
      element.title.trim().toLowerCase() == item.title.trim().toLowerCase()
    );
    print('Checking item "${item.title}" -> Exists: $exists');
    return exists;
  }

  void toggleWishlist(WishlistItemModel item) {
    print('--- Toggle Wishlist clicked for: ${item.title} ---');
    final index = wishlistItems.indexWhere((element) => 
      element.title.trim().toLowerCase() == item.title.trim().toLowerCase()
    );
    
    if (index >= 0) {
      wishlistItems.removeAt(index);
      print('Removed! Total items: ${wishlistItems.length}');
    } else {
      wishlistItems.add(item);
      print('Added! Total items: ${wishlistItems.length}');
    }
    emit(WishlistUpdated(List.from(wishlistItems)));
  }

  void removeFromWishlist(int index) {
    wishlistItems.removeAt(index);
    emit(WishlistUpdated(List.from(wishlistItems)));
  }
}

