import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/app-constant.dart';
import '../auth_ui/sentopt.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appScendoryColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Get.offAll(() => const SendOtp(),
                transition: Transition.leftToRightWithFade),
            icon: const Icon(CupertinoIcons.back, color: Colors.white)),
        centerTitle: true,
        title: Text("Orders page",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: 'Roboto-Bold',
            )),
      ),
    );
  }
}
