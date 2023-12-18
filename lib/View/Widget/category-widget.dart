import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fresh_n_fish_spectrum/Models/categories-model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Controller/get-category-data-controller.dart';
import '../../Controller/get-product-data-controller.dart';

import '../../Models/product-model.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final CategoryDataController _categoryDataController =
      Get.put(CategoryDataController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
      future: _categoryDataController.getCategoryData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator or placeholder widget
          return SizedBox(
              width: 20.w,
              height: 20.h,
              child: const Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          // Handle error
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been loaded successfully
          List<QueryDocumentSnapshot<Object?>> data = snapshot.data!;
          int dataLength = data.length;

          // Rest of your widget tree using the 'data'

          return GridView.builder(
            itemCount: dataLength,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 0.80,
            ),
            itemBuilder: (context, index) {
              final productData = data[index];
              CategoriesModel categoryModel = CategoriesModel(
                  categoryId: productData['categoryId'],
                  categoryImg: productData['categoryImg'],
                  categoryName: productData['categoryName'],
                  createdAt: productData['createdAt'],
                  updatedAt: productData['updatedAt']);
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black26,
                      width: 2.0.w,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          offset: const Offset(3, 2),
                          blurRadius: 7.r)
                    ]),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        width: 150.w,
                        height: 150.h,
                        child: Padding(
                          padding: EdgeInsets.all(13.0.w),
                          child: Image.network(
                           "${categoryModel.categoryImg}",
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "${categoryModel.categoryName}",
                        style: TextStyle(
                            color: const Color(0xFF505050),
                            fontFamily: 'Poppins',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 13.0.w),
                            child: Text(
                              ' ₹ ${categoryModel.categoryName}',
                              style: TextStyle(
                                  color: const Color(0xFFCF1919),
                                  fontFamily: 'Poppins',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          Flexible(
                            child: CircleAvatar(
                              radius: 20.0,
                              backgroundColor: const Color(0xFF660018),
                              child: IconButton(
                                  icon: const Icon(Icons.add_shopping_cart,
                                      color: Colors.white),
                                  onPressed: () async {}),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
