import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/get-cart-product-controller.dart';
import '../../models/product-model.dart';

import '../../utils/app-constant.dart';
import '../main-page.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final CartItemController _CartItemController = Get.put(CartItemController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppConstant.appTextColor),
          backgroundColor: AppConstant.appMainColor,
          centerTitle: true,
          title: Text("Products details page",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontFamily: 'Roboto-Regular',
              )),
          leading: IconButton(
              onPressed: () => Get.offAll(() => const MainPage(),
                  transition: Transition.leftToRightWithFade),
              icon: const Icon(CupertinoIcons.back, color: Colors.white)),
        ),
        body: Container(
          alignment: Alignment.center,
          width: Get.width,
          height: Get.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //product images

              SizedBox(
                height: Get.height / 60,
              ),
              CarouselSlider(
                items: widget.productModel.productImages
                    .map(
                      (imageUrls) => ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: imageUrls,
                          fit: BoxFit.cover,
                          width: Get.width - 10,
                          placeholder: (context, url) => const ColoredBox(
                            color: Colors.white,
                            child: Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  aspectRatio: 2.5,
                  viewportFraction: 1,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.productModel.productName,
                                  style: TextStyle(
                                    color: AppConstant.appMainColor,
                                    fontSize: 18.sp,
                                    fontFamily: 'Roboto-Bold',
                                  )),
                              const Icon(Icons.favorite_outline)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              widget.productModel.isSale == true &&
                                      widget.productModel.salePrice != ''
                                  ? Text(
                                      "Price : ₹ " +
                                          widget.productModel.salePrice,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        fontFamily: 'Roboto-Bold',
                                      ))
                                  : Text(
                                      "Price : ₹ " +
                                          widget.productModel.fullPrice,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        fontFamily: 'Roboto-Bold',
                                      )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                              "Category : " + widget.productModel.categoryName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.sp,
                                fontFamily: 'Roboto-Regular',
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(widget.productModel.productDescription,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.sp,
                                fontFamily: 'Roboto-Regular',
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              child: Container(
                                width: Get.width / 3.0,
                                height: Get.height / 16,
                                decoration: BoxDecoration(
                                  color: AppConstant.appScendoryColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: TextButton(
                                  child: Text("WhatsApp",
                                      style: TextStyle(
                                        color: AppConstant.appTextColor,
                                        fontSize: 13.sp,
                                        fontFamily: 'Roboto-Regular',
                                      )),
                                  onPressed: () {
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Material(
                              child: Container(
                                width: Get.width / 3.0,
                                height: Get.height / 16,
                                decoration: BoxDecoration(
                                  color: AppConstant.appScendoryColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: TextButton(
                                  child: const Text(
                                    "Add to cart",
                                    style: TextStyle(
                                        color: AppConstant.appTextColor),
                                  ),
                                  onPressed: () async {
                                    // Get.to(() => SignInScreen());
                                    await _CartItemController
                                        .checkProductExistence(
                                            uId: user!.uid,
                                            productModel: widget.productModel);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
