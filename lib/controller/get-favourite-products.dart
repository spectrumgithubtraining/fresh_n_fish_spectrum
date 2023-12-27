import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/favorite_model.dart';
import '../models/product-model.dart';

class FavouriteProduct extends GetxController{
  Future<void> deleteFavoriteItem({
    required String uId,
    required String productId,
    int quantityDecrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('favorite')
        .doc(uId)
        .collection('favoriteItems')
        .doc(productId);

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      await documentReference.delete();
      Get.snackbar(
        "Item",
        "removed from favoritefavorite",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );

    }
  }

  Future<void> addFavoriteItem(
      {required String uId,
        required ProductModel productModel,
        int quantityIncrement = 1}) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('favorite')
        .doc(uId)
        .collection('favoriteItems')
        .doc(productModel.productId.toString());
    DocumentSnapshot snapshot = await documentReference.get();
    if (snapshot.exists) {
      print("Product already exist");
      print("Product quantity updated: $quantityIncrement");
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      print("Product quantity updated: $updatedQuantity");
      double totalPrice = double.parse(productModel.isSale
          ? productModel.salePrice
          : productModel.fullPrice) *
          updatedQuantity;
      print("Product quantity updated: $totalPrice");
      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });
      Get.snackbar(
        "Product Added to favorite",
        "${productModel.productName} to favorite",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('favorite')
          .doc(uId)
          .set({'uId': uId, 'createdAt': DateTime.now()});
      FavoriteModel favoriteModel = FavoriteModel(
        productId: productModel.productId,
        categoryId: productModel.categoryId,
        productName: productModel.productName,
        categoryName: productModel.categoryName,
        salePrice: productModel.salePrice,
        fullPrice: productModel.fullPrice,
        productImages: productModel.productImages,
        deliveryTime: productModel.deliveryTime,
        isSale: productModel.isSale,
        productDescription: productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: double.parse(productModel.isSale
            ? productModel.salePrice
            : productModel.fullPrice),
      );
      await documentReference.set(favoriteModel.toMap());

      Get.snackbar(
        "Product Added to favorite",
        "You have added the ${productModel.productName}",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      print("product added");
    }
  }
}