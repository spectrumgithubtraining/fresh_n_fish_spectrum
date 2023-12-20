import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/verify-phone-controller.dart';


class SendOtp extends StatefulWidget {
  const SendOtp({Key? key}) : super(key: key);

  @override
  State<SendOtp> createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> {
  final SentOtpController _sentOtpController = Get.put(SentOtpController());
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Otp"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: "Phone Number"),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      String phoneNumber = "+91" + _phoneNumberController.text.trim();
                      _sentOtpController.sendOtp(phoneNumber);
                    },
                    child: Text("Send OTP"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}