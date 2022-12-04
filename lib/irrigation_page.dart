
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import 'utils/strings.dart';

class IrrigationPage extends StatefulWidget {
  const IrrigationPage({Key? key}) : super(key: key);

  @override
  State<IrrigationPage> createState() => _IrrigationPageState();
}

class _IrrigationPageState extends State<IrrigationPage> {
  @override
  void initState() {
    fetchData1();
    super.initState();
  }

  late Map soilAuto;
  late Map test;
  RxBool isLoading = false.obs;

  fetchData1() async {
    isLoading.value = true;
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('SoilProjectAuto').get();
    if (snapshot.exists) {
      print(snapshot.value);
      soilAuto = snapshot.value as Map;
    } else {
      const SnackBar(
        content: Text('No Soil Project Auto data available.'),
      );
      print('No Soil Project Auto data available.');
    }
    fetchData2();
  }

  fetchData2() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('test').get();
    if (snapshot.exists) {
      print(snapshot.value);
      test = snapshot.value as Map;
    } else {
      print('No data available.');
    }
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.irrigationSystem),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Obx(() => isLoading.value
          ? const Center(child: Text('Loading...'),)
          : _bodyWidget(context)),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 20
      ),
     physics: const BouncingScrollPhysics(),
      children: [

        _viewWidget('Humidity', 'assets/image/13.jpg', "${test['Moist'].toString()} %"),

        const Divider(),
        _viewWidget('Rain', 'assets/image/4.jpeg', soilAuto['Rain'].toString() == "1" ? 'It is Raining..' : 'It is not Raining.'),

        const Divider(),
        _viewWidget('Humidity', 'assets/image/11.jpg', "${soilAuto['humidity'].toString()} %"),

        const Divider(),
        _viewWidget('Temperature', 'assets/image/12.jpg', "${soilAuto['temperature'].toString()} C"),

        const Divider(),

        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: (){

                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10
                  ),
                  child: _viewWidget('Motor Switch',
                      'assets/image/14.jpg',
                      soilAuto['motor'].toString() == '1' ? 'Motor ON' : 'Motor OFF'
                  ),
                ),

              ),
            )
          ],
        )

      ],
    );
  }

  _viewWidget(String text, String image, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
              width: 80,
              child: Image.asset(image)),
          Text(text),
          Text(value),
        ],
      ),
    );
  }
}