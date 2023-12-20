import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../View/auth_ui/verifyotp.dart';
import '../View/main_page.dart';


class SentOtpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendOtp(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // This callback will be invoked in case of automatic verification
          // You may choose to sign in the user here
          await _auth.signInWithCredential(credential);
          Get.snackbar("Success", "Automatic Verification Completed");
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle the verification failure
          Get.snackbar("Error", "Verification Failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          // This callback will be invoked when the code is successfully sent
          // Save the verification ID somewhere to use it later
          Get.snackbar("Code Sent", "Code Sent to $phoneNumber");
          Get.to(() => VerifyOtp(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // This callback will be invoked when the code auto-retrieval has timed out
          Get.snackbar("Timeout", "Auto Retrieval Timeout: $verificationId");
        },
      );
    } catch (e) {
      // Handle exceptions
      Get.snackbar("Error", "Error: $e");
    }
  }

  void verifyOtp(String otp, String verificationId) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      // Sign in the user with the credential
      await _auth.signInWithCredential(credential);

      // Display success message
      Get.snackbar("Success", "Verification Successful");

      // Navigate to the next screen or perform any other action
      // For example, you might want to navigate to a home screen
      Get.offAll(() => const MainPage());
    } catch (e) {
      // Handle exceptions
      Get.snackbar("Error", "Verification Failed: $e");
    }
  }
}