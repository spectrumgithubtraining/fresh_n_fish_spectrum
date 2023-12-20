import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Controller/verify-phone-controller.dart';

class VerifyOtp extends StatefulWidget {
  final String verificationId;
  const VerifyOtp({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final TextEditingController _otpController = TextEditingController();
  final SentOtpController _sentOtpController = Get.put(SentOtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify OTP"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter the OTP sent to your phone",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "OTP",
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Call your verification function from the controller
                // Pass the entered OTP and verification ID
                _sentOtpController.verifyOtp(_otpController.text, widget.verificationId);
              },
              child: Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }
}