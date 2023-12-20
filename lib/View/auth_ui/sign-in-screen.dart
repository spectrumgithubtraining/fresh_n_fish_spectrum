import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fresh_n_fish_spectrum/View/auth_ui/sentopt.dart';
import 'package:fresh_n_fish_spectrum/View/auth_ui/sign-up-screen.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import '../../Controller/email-sign-in-controller.dart';
import '../../Controller/google-sign-in-controller.dart';
import '../../Services/Validator/validator.dart';
import '../../Utils/app-constant.dart';
import '../main_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _loading = false;
  get passwordTextController => _passwordTextController;

  get emailTextController => _emailTextController;
  final EmailPassController _emailPassController =
      Get.put(EmailPassController());
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());
  Widget getTextField(
      {required String hint,
      required var icons,
      required var validator,
      required var controller,
      required var keyboardType}) {
    return TextFormField(
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
          errorStyle: const TextStyle(
            color: Colors.yellow,
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConstant.appScendoryColor,
        body: SingleChildScrollView(
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 60.0).w,
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: [
                      Text(
                        'Login here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppConstant.yellowText,
                          fontSize: 30.sp,
                          fontFamily: 'Roboto-Bold',
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      const Text(
                        'Welcome back you’ve been missed!',
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
                      child: Form(
                        key: _formKey,
                        child: SizedBox(
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
                                  controller: _emailTextController,
                                  keyboardType: TextInputType.emailAddress),
                              SizedBox(
                                height: 26.h,
                              ),
                              getTextField(
                                  hint: "Password",
                                  icons: const Icon(Icons.lock),
                                  validator: (value) =>
                                      Validator.validatePassword(
                                        password: value,
                                      ),
                                  controller: _passwordTextController,
                                  keyboardType: TextInputType.visiblePassword),
                              SizedBox(
                                height: 15.h,
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  onPressed: () {
                                    Get.off(const SignUp());
                                  },
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
                                                    BorderRadius.circular(
                                                        9.r))),
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                Color(0xFF1F41BB))),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _loading = true;
                                        });
                                        try {
                                          UserCredential? userCredential =
                                              await _emailPassController
                                                  .signinUser(
                                            _emailTextController.text,
                                            _passwordTextController.text,
                                          );
                                          if (userCredential!
                                              .user!.emailVerified) {
                                            final user = userCredential.user;
                                            Get.off(() => const MainPage(),
                                                transition: Transition
                                                    .leftToRightWithFade);
                                          }
                                        } catch (e) {
                                          print(e);
                                        } finally {
                                          setState(() {
                                            _loading = false;
                                          });
                                        }
                                      }
                                    },
                                    child: _loading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
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
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 30.0).w,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _googleSignInController.signInWithGoogle();
                            },
                            child: SizedBox(
                              width: 60.w,
                              height: 44.h,
                              child: SvgPicture.asset(
                                  'assets/images/flat-color-icons_google.svg'),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          GestureDetector(
                            onTap: () => Get.to(()=>SendOtp()),
                            child: SizedBox(
                              width: 60.w,
                              height: 44.h,
                              child: SvgPicture.asset(
                                  'assets/images/ic_sharp-local-phone.svg'),
                            ),
                          ),
                        ]),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
