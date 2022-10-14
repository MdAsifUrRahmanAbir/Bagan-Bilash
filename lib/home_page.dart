import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/routes.dart';
import 'utils/strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        children: [
          _buttonWidget(
            onTap: (){
              Get.toNamed(Routes.plantDetectPage);
            },
            text: Strings.plantDetection
          )
        ],
      ),
    );
  }



  _buttonWidget({VoidCallback? onTap, String? text}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 150,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(text!),
      ),
    );
  }

}
