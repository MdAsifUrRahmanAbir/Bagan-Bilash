import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/routes.dart';
import 'utils/strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(Strings.appName),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        children: [

          _buttonWidget(
            onTap: (){
              Get.toNamed(Routes.plantDetectPage);
            },
            text: Strings.plantDetection,
            image: 'assets/image/1.jpeg'
          ),
          
          _buttonWidget(
            onTap: (){
              Get.toNamed(Routes.diseasesDetectPage);
            },
            text: Strings.plantRog,
            image: 'assets/image/2.jpeg'
          ),

          _buttonWidget(
            onTap: (){
              Get.toNamed(Routes.soilDetectPage);
            },
            text: Strings.soilDetection,
            image: 'assets/image/3.jpeg'
          ),

          _buttonWidget(
            onTap: (){
              Get.toNamed(Routes.irrigationPage);
            },
            text: Strings.irrigationSystem,
            image: 'assets/image/4.jpeg'
          )
        ],
      ),
      bottomNavigationBar: const LinearProgressIndicator(
        color: Colors.green,
        backgroundColor: Colors.blueGrey,
      ),
    );
  }



  _buttonWidget({VoidCallback? onTap, String? text,  String? image}){
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Card(
        elevation: 3,
        shadowColor: Colors.green,
        child: Container( 
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          alignment: Alignment.bottomCenter,
          // decoration: BoxDecoration(
          //   image: DecorationImage(image: AssetImage(
          //     image!,
          //   ),
          //     fit: BoxFit.fill,
          //     opacity: 10,
          //     filterQuality: FilterQuality.high
          //   ),
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(15),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(image!),
              ),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(7)
                ),
                child: Text(
                    text!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
