import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/product-model.dart';

class SearchBarController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<ProductModel> searchResults = <ProductModel>[].obs;

  Future<void> getSearchData(String query) async {
    final QuerySnapshot productData = await _firestore
        .collection('products')
        .where('productName', isGreaterThanOrEqualTo: query)
        .where('productName', isLessThan: query + 'z')
        .get();

    searchResults.assignAll(productData.docs
        .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
    print(searchResults);
  }
}
