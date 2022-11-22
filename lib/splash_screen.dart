import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/routes.dart';
import 'utils/strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  navigate() async {
    Timer(const Duration(seconds: 4), () {
      Get.offNamedUntil(Routes.homePage , (route) => false);
    });
  }

  @override
  void initState() {
    navigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: const [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/image/4.jpeg'),
                ),
                Text(
                  Strings.appName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    fontStyle: FontStyle.italic,
                    color: Colors.green
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

          ],
        ),
      ),
      bottomNavigationBar: const LinearProgressIndicator(
        color: Colors.green,
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
