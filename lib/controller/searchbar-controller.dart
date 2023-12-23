import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchBarController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Object?>>> getSearchData(
      String uId, String query) async {
    final QuerySnapshot productData = await _firestore
        .collection('products')
        .where('categoryId', isEqualTo: query)
        .get();
    return productData.docs;
  }
}
