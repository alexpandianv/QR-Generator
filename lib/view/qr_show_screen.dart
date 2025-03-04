import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_generator/utilitz/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_generator/controller/auth_controller.dart';

import 'login_history_screen.dart' show LoginHistoryScreen;

class QRShowScreen extends StatefulWidget {
  @override
  _QRShowScreenState createState() => _QRShowScreenState();
}

class _QRShowScreenState extends State<QRShowScreen> {
  final AuthController authController = Get.find();
  final int randomNumber = Random().nextInt(1000000);
  String savedIp = "Loading...";
  String savedLocation = "Loading...";
  String savedQrData = "Loading...";
  String lastLoginTime = "No previous login";

  @override
  void initState() {
    super.initState();
   ;
    _loadLastLoginTime();
  }


  void _loadLastLoginTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> loginHistory = prefs.getStringList('login_history') ?? [];

    if (loginHistory.isNotEmpty) {
      Map<String, String> lastEntry = Map<String, String>.from(
        jsonDecode(loginHistory.first),
      );
      setState(() {
        lastLoginTime = _formatTime(lastEntry['timestamp']!);
      });
    }
  }

 Future< void> _saveLoginData(qrData) async {
    await authController.saveLoginDetails("userId", qrData);
    String timestamp = DateTime.now().toIso8601String();

    setState(() {
      lastLoginTime = _formatTime(timestamp);
    });
    Get.to(() => LoginHistoryScreen());
  }

  String _formatTime(String timestamp) {
    DateTime parsedTime = DateTime.parse(timestamp).toLocal();
    int hour = parsedTime.hour > 12
        ? parsedTime.hour - 12
        : (parsedTime.hour == 0 ? 12 : parsedTime.hour);
    String minute = parsedTime.minute.toString().padLeft(2, '0');
    String period = parsedTime.hour >= 12 ? 'PM' : 'AM';

    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    String qrData = randomNumber.toString();

    return Scaffold(
      backgroundColor: backGroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 55.0),
              child: Column(
                children: [
                  // Login Title Container
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 77),

                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 66),
                      decoration: BoxDecoration(
                        color: backGroundColor2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "PLUGIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [

                                // Top-left Triangle
                                Positioned(
                                  top: 88,
                                  left: -20,
                                  child:  ClipPath(
                                    clipper: TriangleClipper(position: TrianglePosition.bottomLeft),
                                    child: Container(
                                      width: 250,
                                      height: 155,
                                      color: Colors.grey.shade900, // Change color if needed
                                    ))),

                                  Positioned(
                                  top: 88,
                                    left: -20,
                                  child: ClipPath(
                                    clipper: TriangleClipper(position: TrianglePosition.topRight),
                                    child: Container(
                                      width: 250,
                                      height: 155,
                                      color: backGroundColor, // Change color if needed
                                    ),
                                  ),
                                ),

                                Positioned(
                                  top: 0,
                                  child:
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: QrImageView(
                                      data: qrData,
                                      version: QrVersions.auto,
                                      size: 122.0,
                                      backgroundColor: Colors.white,
                                    ),
                                  )

                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 99),
                                  padding: EdgeInsets.all(35),

                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 18),

                                      Text(
                                        'Generated Number',
                                        style: TextStyle(color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 18),
                                      Text(
                                            qrData, // Replace with qrData
                                        style: TextStyle(color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    border: Border.all(
                                        color: Colors.white, width: 0.5),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 4),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Icon(
                                            Icons.access_time,
                                            color: Colors.white),
                                        SizedBox(width: 8),
                                        Text(
                                          'Last Login at, $lastLoginTime',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Logout Button (Top Right Corner)
          Positioned(
            top: 10,
            right: -25,
            child:
            ClipOval(
              child: Material(
                color: Colors.blueAccent.withAlpha(55), // Semi-transparent blue
                child: InkWell(
                  onTap: () => authController.signOut(),
                  splashColor: Colors.blueAccent, // Ripple effect
                  child: Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "Logout",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Save Button
      bottomNavigationBar: Obx(()=>BottomAppBar(
        height: MediaQuery
            .sizeOf(context)
            .height * 0.14,
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
await _saveLoginData(qrData.toString())  ;
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              backgroundColor: backGroundColorButton,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:authController.showSpinner.value==true?CircularProgressIndicator(color: Colors.white,): Text(
              'Save',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
        ),
      ),
    ));
  }


}

enum TrianglePosition { topLeft, topRight, bottomLeft, bottomRight }

class TriangleClipper extends CustomClipper<Path> {
  final TrianglePosition position;

  TriangleClipper({required this.position});

  @override
  Path getClip(Size size) {
    Path path = Path();

    switch (position) {
      case TrianglePosition.topLeft:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(0, size.height);
        break;

      case TrianglePosition.topRight:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, 0);
        break;

      case TrianglePosition.bottomLeft:
        path.moveTo(0, size.height);
        path.lineTo(size.width, size.height);
        path.lineTo(0, 0);
        break;

      case TrianglePosition.bottomRight:
        path.moveTo(size.width, size.height);
        path.lineTo(size.width, 0);
        path.lineTo(0, size.height);
        break;
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}