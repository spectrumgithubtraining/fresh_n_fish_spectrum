import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../Services/Validator/validator.dart';
import '../../Utils/app-constant.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  Widget getTextField(
      {required String hint,
      required var icons,
      required var validator,
      required var controller}) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: icons,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          filled: true,
          fillColor: const Color(0xFFF1F4FF),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black54,
            fontFamily: 'Roboto-Regular',
            fontSize: 15.sp,
            height: 0.h,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appScendoryColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppConstant.appScendoryColor,
        elevation: 0,
      ),
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 60.0).w,
                width: MediaQuery.of(context).size.width,
                child: Column(children: [
                  Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFD771),
                      fontSize: 30.sp,
                      fontFamily: 'Roboto-Bold',
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Create an account so you can \n explore all the existing jobs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: 323.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getTextField(
                            hint: "Email",
                            icons: const Icon(Icons.email),
                            validator: (value) => Validator.validateEmail(
                                  email: value,
                                ),
                            controller: null),
                        SizedBox(
                          height: 26.h,
                        ),
                        getTextField(
                            hint: "Password",
                            icons: const Icon(Icons.lock),
                            validator: (value) => Validator.validatePassword(
                                  password: value,
                                ),
                            controller: null),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot your password?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto-Regular',
                                color: AppConstant.appTextColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                height: 0.h,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        SizedBox(
                            width: 357.w,
                            height: 50.h,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(9.r))),
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                          Color(0xFF1F41BB))),
                              onPressed: () async {},
                              child: Text(
                                'Sign in',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppConstant.appTextColor,
                                  fontSize: 20.sp,
                                  height: 0.h,
                                  fontFamily: 'Roboto-Bold',
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 30.0).w,
                width: MediaQuery.of(context).size.width,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  SizedBox(
                    width: 60.w,
                    height: 44.h,
                    child: SvgPicture.asset('assets/images/flat-color-icons_google.svg'),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  SizedBox(
                    width: 60.w,
                    height: 44.h,
                    child: SvgPicture.asset(
                        'assets/images/ic_sharp-local-phone.svg'),
                  ),
                ]),
              ),
            ]),
      ),
    );
  }
}