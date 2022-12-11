import 'dart:async';

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
  int i = 0;
  @override
   void initState() {
    fetchData1();
    Timer.periodic(const Duration(seconds: 2), (timer){
      setState(() {
        fetchDataRealtime();
      });
    });

    super.initState();
  }

  late Map soilAuto;
  late Map test;
  RxBool isLoading = false.obs;
  RxBool switchButton = false.obs;
  RxBool switchButton2 = false.obs;

  fetchData1() async {
    isLoading.value = true;
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('SoilProjectAuto').get();
    if (snapshot.exists) {
      soilAuto = snapshot.value as Map;
      switchButton.value = soilAuto['motor'].toString() == '1' ? true : false;
      switchButton2.value = soilAuto['mode'].toString() == '1' ? true : false;
      fetchData2();
    } else {
      // print('No Soil Project Auto data available.');
      isLoading.value = false;
    }
  }

  fetchData2() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('test').get();
    if (snapshot.exists) {
      // print(snapshot.value);
      test = snapshot.value as Map;
    } else {
      // print('No data available.');
    }
    isLoading.value = false;
  }

  fetchDataRealtime() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('SoilProjectAuto').get();
    if (snapshot.exists) {
      soilAuto = snapshot.value as Map;
      switchButton.value = soilAuto['motor'].toString() == '1' ? true : false;
      switchButton2.value = soilAuto['mode'].toString() == '1' ? true : false;
      fetchData2();
    } else {
      // print('No Soil Project Auto data available.');
    }
  }

  fetchDataRealTime2() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('test').get();
    if (snapshot.exists) {
      // print(snapshot.value);
      test = snapshot.value as Map;
    } else {
      // print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.irrigationSystem),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  fetchData1();
                });
              },
              icon: const Icon(Icons.refresh_sharp))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchData1();
        },
        child: Obx(() => isLoading.value
            ? const Center(
                child: Text('Loading...'),
              )
            : _bodyWidget(context)),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      physics: const BouncingScrollPhysics(),
      children: [

        Row(
          children: [
            Expanded(
              child: _viewWidget(
                  'Humidity', 'assets/image/13.jpg', "${test['Moist'].toString()} %"),
            ),
            const Divider(),
            Expanded(
                child: _viewWidget(
                    'Rain',
                    soilAuto['Rain'].toString() == "1"
                        ? 'assets/image/megh.jpg'
                        : 'assets/image/rod.jpg',
                    soilAuto['Rain'].toString() == "1"
                        ? 'It is Raining..'
                        : 'It is not Raining.'),
            )


          ],
        ),
        const Divider(),

        Row(
          children: [
            Expanded(
              child: _viewWidget('Humidity', 'assets/image/11.jpg',
                  "${soilAuto['humidity'].toString()} %"),
            ),
            const Divider(),

            Expanded(
              child: _viewWidget('Temperature', 'assets/image/12.jpg',
                  "${soilAuto['temperature'].toString()} C"),
            )

          ],
        ),



        const Divider(),
        _viewWidget(
            'Soil',
            'assets/image/16.jpg',
            soilAuto['soil'].toString() == '0'
                ? 'Dry\nNeed Water'
                : 'Wet\nNot Need Water'),


         const Divider(),
        const Text('Machine Buttons'),
        const Divider(),
        InkWell(
          onTap: () async {
            await FirebaseDatabase.instance
                .ref('SoilProjectAuto/motor')
                .set(soilAuto['motor'].toString() == '1' ? '0' : '1')
                .then((_) {
              fetchData1();
            }).catchError((error) {
              // The write failed...
            });
          },
          child: Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _viewWidget(
                      'Pump Motor',
                      'assets/image/14.jpg',
                      soilAuto['motor'].toString() == '1'
                          ? 'ON'
                          : 'OFF'
                  ),

                  Obx(() => Switch(
                      value: switchButton.value,
                      onChanged: (value) async {
                        await FirebaseDatabase.instance
                            .ref('SoilProjectAuto/motor')
                            .set(
                                soilAuto['motor'].toString() == '1' ? '0' : '1')
                            .then((_) {
                          fetchData1();
                        }).catchError((error) {
                          // The write failed...
                        });
                      }
                   )),
                ],
              )),
        ),


        Obx(() => SwitchListTile(
            subtitle: Text(soilAuto['mode'].toString() == '0'
              ? 'Click for AUTO'
              : 'Click for  MANUAL'),
            title: const Text('Motor Mood'),
            value: switchButton2.value,
            onChanged: (value) async{
              await FirebaseDatabase.instance
                  .ref('SoilProjectAuto/mode')
                  .set(
                  soilAuto['mode'].toString() == '1' ? '0' : '1')
                  .then((_) {
                fetchData1();
              }).catchError((error) {
                // The write failed...
              });
            }
        ))


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
          SizedBox(height: 80, width: 80, child: Image.asset(image)),
          Text(
            text,
            style: const TextStyle(
                color: Colors.green, fontWeight: FontWeight.w700, fontSize: 18),
          ),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
