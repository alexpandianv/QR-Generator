import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_generator/utilitz/color.dart';

import '../controller/auth_controller.dart';

class LoginOtpScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  final _focusNodeOtp = FocusNode();
  final _focusNodeEnterMobile = FocusNode();

  @override
  Widget build(BuildContext context) {
    _focusNodeEnterMobile.requestFocus();
    return SafeArea(
      child: Scaffold(
        backgroundColor: backGroundColor, // Background color
        body:
        Stack(
          children: [
            // Login Title Container (Fixed Position)

            // Full-height white container
            Positioned.fill(
              top: 120, // Pushes it below the title container
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
                  // Center form items
                  children: [
                    Row(
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    TextField(
                      focusNode: _focusNodeEnterMobile,
                      controller: phoneController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        // Allow only numbers
                        LengthLimitingTextInputFormatter(10),
                        // Limit to 6 characters
                      ],

                      style: TextStyle(color: Colors.white),
                      // White text inside
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        // Dim white label
                        filled: true,
                        fillColor: backGroundColor,
                        // Background color for the field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          // Rounded corners
                          borderSide: BorderSide.none, // Remove default border
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ), // Padding for better spacing
                      ),
                    ),

                    SizedBox(height: 33),
                    Row(
                      children: [
                        Text(
                          "OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    TextField(
                      focusNode: _focusNodeOtp,
                      style: TextStyle(color: Colors.white),
                      // White text inside
                      controller: otpController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        // Allow only numbers
                        LengthLimitingTextInputFormatter(6),
                        // Limit to 6 characters
                      ],

                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        // Dim white label
                        filled: true,
                        fillColor: backGroundColor,
                        // Background color for the field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          // Rounded corners
                          borderSide: BorderSide.none, // Remove default border
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ), // Padding for better spacing
                      ),

                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 33),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          height: MediaQuery.sizeOf(context).height * 0.075,

                          child: ElevatedButton(
                            onPressed: () {
                              if (!authController.isOtpSent.value) {
                                authController.loginWithPhone(
                                  phoneController.text,
                                );
                                if (phoneController.text.length == 10) {}
                                _focusNodeOtp.requestFocus();
                              } else {
                                authController.verifyOtp(otpController.text);
                                FocusScope.of(context).unfocus();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: backGroundColorButton,
                              // Background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                // Rounded corners
                                side: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ), // Border
                              ),
                            ),
                            child: Obx(
                              () =>
                                  authController.showSpinner.value == true
                                      ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : Text(
                                        authController.isOtpSent.value
                                            ? 'Verify OTP'
                                            : 'LOGIN',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                        ), // Text color
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 75, // Adjust vertical position
              left: 100, // Centered horizontally with padding
              right: 100, // Equal padding on both sides
              child: Container(
                // Wrap in a normal container to avoid background leaks
                decoration: BoxDecoration(
                  color: backGroundColor2, // Correct background color
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Proper rounded corners
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                // Better spacing
                alignment: Alignment.center,
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
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
