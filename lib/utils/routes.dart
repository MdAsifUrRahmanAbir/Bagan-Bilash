import 'package:get/get.dart';

import '../home_page.dart';
import '../plant_detect_page.dart';
import '../plant_detect_page2.dart';
import '../splash_screen.dart';

class Routes{
  static const String splashScreen = '/splashScreen';
  static const String homePage = '/homePage';
  static const String plantDetectPage = '/plantDetectPage';
  static const String plantDetectPage2 = '/plantDetectPage2';

  static var list = [
    GetPage(
      name: splashScreen,
      page: () =>  const SplashScreen(),
    ),
    GetPage(
      name: homePage,
      page: () =>  const HomePage(),
    ),
    GetPage(
      name: plantDetectPage,
      page: () =>  const PlantDetectPage(),
    ),
    GetPage(
      name: plantDetectPage2,
      page: () =>  const PlantDetectPage2(),
    ),
  ];
}