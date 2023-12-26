import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../utils/app-constant.dart';
class UpiPage extends StatefulWidget {
  const UpiPage({super.key});

  @override
  State<UpiPage> createState() => _UpiPageState();
}

class _UpiPageState extends State<UpiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        elevation: 2,
        leading: IconButton(
            onPressed: () => Get.offAll(() => null,
                transition: Transition.leftToRightWithFade),
            icon: const Icon(CupertinoIcons.back, color: Colors.white)),
        centerTitle: true,
        title: Text("Cart page",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: 'Roboto-Regular',
            )),
      ),
    );
  }
}
