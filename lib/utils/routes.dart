import 'package:get/get.dart';

import '../home_page.dart';
import '../plant_detect_page.dart';
import '../plant_diseases_detect_page.dart';
import '../soil_detect_page.dart';
import '../irrigation_page.dart';
import '../splash_screen.dart';

class Routes{
  static const String splashScreen = '/splashScreen';
  static const String homePage = '/homePage';
  static const String plantDetectPage = '/plantDetectPage';
  static const String diseasesDetectPage = '/diseasesDetectPage';
  static const String soilDetectPage = '/soilDetectPage';
  static const String irrigationPage = '/irrigationPage';

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
      name: diseasesDetectPage,
      page: () =>  const PlantDiseasesDetectPage(),
    ),
    GetPage(
      name: soilDetectPage,
      page: () =>  const SoilDetectPage(),
    ),
    GetPage(
      name: irrigationPage,
      page: () =>  const IrrigationPage(),
    ),
  ];
}