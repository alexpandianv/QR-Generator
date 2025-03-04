import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:qr_generator/pages/app_pages.dart';
import 'package:qr_generator/view/qr_show_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/login_history_screeb.dart';
class AuthController extends GetxController {final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var isAuthenticated = false.obs;

var showSpinner = false.obs;
final RxBool isOtpSent = false.obs; // To toggle between login & OTP input

void loginWithPhone(String phone) {
  if (phone.length == 10) {
    showSpinner.value = true;
    Future.delayed(Duration(seconds: 2), () {
      isOtpSent.value = true;
      showSpinner.value = false;
    });
  } else {
    Get.snackbar("Error", "Enter a valid phone number", backgroundColor: Colors.white);
  }
}
void verifyOtp(String otp) {
  if (otp == "123456") {
    showSpinner.value = true;
    Future.delayed(Duration(seconds: 2), () {
      isOtpSent.value = false;
      Get.offAll(() => QRShowScreen());
      showSpinner.value = false;
    });
  } else {
    Get.snackbar("Error", "Invalid OTP", backgroundColor: Colors.white);
  }
}


/// Save login details to Firebase Firestore and SharedPreferences
///
Future<void> saveLoginDetails(String userId, String qrData) async {
  try {
    String ip = await getPublicIP();
    String location = await getLocation(ip);
    String timestamp = DateTime.now().toIso8601String(); // Save as ISO format
    // await _firestore.collection('login_details').doc(userId).set({
    //   'ip': ip,
    //   'location': location,
    //   'qrData': qrData,
    //   'timestamp': Timestamp.now(), // Firestore timestamp
    // });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve existing logins
    List<String> loginHistory = prefs.getStringList('login_history') ?? [];

    // Append new login details
    Map<String, String> newEntry = {
      'ip': ip,
      'location': location,
      'qrData': qrData,
      'timestamp': timestamp,
    };

    loginHistory.add(jsonEncode(newEntry));

    await prefs.setStringList('login_history', loginHistory);

    // Save last login details separately
    await prefs.setString('last_ip', ip);
    await prefs.setString('last_location', location);
    await prefs.setString('last_qrData', qrData);

    print("Saved IP: $ip");
    print("Saved Location: $location");
    print("Saved QR Data: $qrData");

    Get.snackbar("Success", "Login details saved successfully!",backgroundColor: Colors.white);

    // Navigate to the history screen after saving
    Get.to(() => LoginHistoryScreen());
  } catch (e) {
    Get.snackbar("Error", "Failed to save login details: $e",backgroundColor: Colors.white);
  }
}


/// Get the public IP address of the user
Future<String> getPublicIP() async {
  try {
    final response = await http.get(Uri.parse('https://api.ipify.org?format=json'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['ip'];
    } else {
      throw Exception("Failed to get IP address");
    }
  } catch (e) {
    return "Unknown IP";
  }
}

/// Get the location based on the IP address
Future<String> getLocation(String ip) async {
  try {
    final response = await http.get(Uri.parse('http://ip-api.com/json/$ip'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return "${data['city']}, ${data['country']}";
    } else {
      throw Exception("Failed to get location");
    }
  } catch (e) {
    return "Unknown Location";
  }
}

/// Retrieve saved login details from SharedPreferences
Future<Map<String, String>> getSavedLoginDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return {
    'ip': prefs.getString('ip') ?? 'No IP Found',
    'location': prefs.getString('location') ?? 'No Location Found',
    'qrData': prefs.getString('qrData') ?? 'No QR Data Found',
  };
}

/// Logout and clear saved data
Future<void> signOut() async {
  await _auth.signOut();
  isAuthenticated.value = false;

  // Clear SharedPreferences on logout
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  Get.offAllNamed(Routes.LOGIN);
}

}
