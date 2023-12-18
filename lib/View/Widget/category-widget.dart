import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

          return ListView.builder(
            itemCount: dataLength,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final productData = data[index];
              CategoriesModel categoryModel = CategoriesModel(
                  categoryId: productData['categoryId'],
                  categoryImg: productData['categoryImg'],
                  categoryName: productData['categoryName'],
                  createdAt: productData['createdAt'],
                  updatedAt: productData['updatedAt']);
              return Padding(
                padding: EdgeInsets.all(8.0.w),
                child: GestureDetector(
                    onTap: () => null,
                    child: SizedBox(
                      height: 100.h,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFC0C0C0),
                            radius: 35.r,
                            child: CachedNetworkImage(
                              imageUrl: categoryModel.categoryImg,
                              fit: BoxFit.fill,
                              width: 45.w,
                              placeholder: (context, url) => const ColoredBox(
                                color: Colors.white,
                                child:
                                    Center(child: CupertinoActivityIndicator()),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Flexible(
                            child: Text(
                              categoryModel.categoryName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF494949),
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0.h,
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              );
            },
          );
        }
      },
    );
  }
}
