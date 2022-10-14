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
    Timer(const Duration(seconds: 3), () {
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
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: const Text(
          Strings.appName,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            fontStyle: FontStyle.italic,
            color: Colors.green
          ),
        ),
      ),
    );
  }
}
