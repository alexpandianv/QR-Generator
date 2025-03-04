import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_generator/utilitz/color.dart';
import 'qr_show_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  final int randomQr = Random().nextInt(1000000); // Generate random QR code

  @override
  Widget build(BuildContext context) {
    // Navigate to Dashboard after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => LoginOtpScreen());
    });

    return Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // QR Code
            QrImageView(
              data: randomQr.toString(),
              version: QrVersions.auto,
              size: 150.0,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 20),

            // App Name
            ClipRRect(
            borderRadius: BorderRadius.all(
             Radius.circular(5)),
              child: Container(color:backGroundColor2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "QR - Generator",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
