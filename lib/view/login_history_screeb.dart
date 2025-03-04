import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_generator/utilitz/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../controller/auth_controller.dart';

class LoginHistoryScreen extends StatefulWidget {
  @override
  _LoginHistoryScreenState createState() => _LoginHistoryScreenState();
}

class _LoginHistoryScreenState extends State<LoginHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, String>> todayLogins = [];
  List<Map<String, String>> yesterdayLogins = [];
  List<Map<String, String>> otherLogins = [];

  final AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadLoginHistory();
  }

  void _loadLoginHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> loginHistory = prefs.getStringList('login_history') ?? [];

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    todayLogins.clear();
    yesterdayLogins.clear();
    otherLogins.clear();

    for (String entry in loginHistory) {
      Map<String, String> data = Map<String, String>.from(jsonDecode(entry));
      DateTime? entryDate = DateTime.tryParse(data['timestamp'] ?? '');
      if (entryDate == null) continue;

      DateTime entryDay = DateTime(
          entryDate.year, entryDate.month, entryDate.day);

      if (entryDay == today) {
        todayLogins.add(data);
      } else if (entryDay == yesterday) {
        yesterdayLogins.add(data);
      } else {
        otherLogins.add(data);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Stack(
        children: [
          // Full-height white container
          Positioned.fill(
            top: 120, // Pushes below the title container
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // TabBar
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87),
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.white,
                      tabs: const [
                        Tab(text: "Today"),
                        Tab(text: "Yesterday"),
                        Tab(text: "Other"),
                      ],
                    ),
                  ),

                  // TabBarView (must be inside Expanded to take full space)
                  showSpinner == true ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator(
                        color: Colors.white,
                      )
                      ]) : Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildHistoryList(todayLogins, "No logins today"),
                        _buildHistoryList(
                            yesterdayLogins, "No logins yesterday"),
                        _buildHistoryList(otherLogins, "No older logins found"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // "Last Login" Title Container (Fixed Position)
          Positioned(
            top: 75, // Adjust vertical position
            left: 50, // Center horizontally with padding
            right: 50,
            child: Container(
              decoration: BoxDecoration(
                color: backGroundColor2,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              alignment: Alignment.center,
              child: const Text(
                "Last Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Logout Button (Fixed Position)
          Positioned(
            top: 10,
            right: -15, // Adjusted to fit within screen bounds
            child: ClipOval(
              child: Material(
                color: Colors.blueAccent.withAlpha(55), // Semi-transparent blue
                child: InkWell(
                  onTap: () => authController.signOut(),
                  splashColor: Colors.blueAccent,
                  child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    child: const Text(
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
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.14,
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              Get.offAll(() => QRShowScreen());
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: backGroundColorButton,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: showSpinner == true ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(
                  color: Colors.white,
                )
                ]) : Text(
              'Save',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  bool showSpinner = false;
}

Widget _buildHistoryList(List<Map<String, String>> logins,
    String emptyMessage) {
  if (logins.isEmpty) {
    return Center(
      child: Text(
        emptyMessage,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  return ListView.builder(
    itemCount: logins.length,
    itemBuilder: (context, index) {
      final data = logins[index];
      return Card(color: Colors.grey.shade900, elevation: 5,
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
            title: Text(
              "${data['timestamp'] != null ? DateFormat('hh:mm a').format(
                  DateTime.parse(data['timestamp']!).toLocal()) : 'N/A'}",
              style: TextStyle(color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Prevent unnecessary space
              children: [
                Text("IP: ${data['ip'] ?? 'N/A'}",
                  style: TextStyle(color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),),
                Text("${data['location'] ?? 'N/A'}",
                  style: TextStyle(color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),),
              ],
            ),
            trailing:
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
              QrImageView(
                data: data['qrData'] ?? "No Data",
                size: 50,
                backgroundColor: Colors.white,
              ),
            )),
      );
    },
  );
}}
