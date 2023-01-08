import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'utils/strings.dart';

class SoilDetectPage extends StatefulWidget {
  const SoilDetectPage({Key? key}) : super(key: key);

  @override
  State<SoilDetectPage> createState() => _SoilDetectPageState();
}

class _SoilDetectPageState extends State<SoilDetectPage> {
  List? _outputs;
  XFile? _image;
  String? plantName;

  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();

    loadModel().then((value) {
      setState(() {});
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/soilDetect/model_unquant.tflite",
      labels: "assets/soilDetect/labels.txt",
    );
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);

    output?.forEach((element) {
      debugPrint(element);
    });

    setState(() {
      _outputs = output;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future getImageCamera() async {
    var image =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return null;
    setState(() {
      _image = image;
    });
    classifyImage(File(_image!.path));
  }

  Future getImageGallery() async {
    var image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image == null) return null;
    setState(() {
      _image = image;
    });
    classifyImage(File(_image!.path));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.soilDetection),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: _bodyWidget(context),
    );
  }

  _bodyWidget(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child: _image == null
                ? Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          "Upload an image",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(File(_image!.path)),
                          fit: BoxFit.cover),
                      color: Colors.transparent,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          _openBottomSheet(context, _outputs?[0]["label"],
                              'Confidence: ${((_outputs?[0]["confidence"]) * 100).toStringAsFixed(2)} %');
                        },
                        child: Card(
                          color: Colors.white,
                          shadowColor: Colors.green,
                          elevation: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${_outputs?[0]["label"]}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green),
                                ),
                                const Text(
                                  "CLICK ME",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              elevation: 0,
              margin: const EdgeInsets.all(0),
              color: Colors.grey.withOpacity(0.1),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  topLeft: Radius.circular(15.0),
                ),
              ),
              child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25.0),
                      topLeft: Radius.circular(25.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                            onPressed: () {
                              getImageCamera();
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                            onPressed: () {
                              getImageGallery();
                            },
                            icon: const Icon(
                              Icons.image,
                              color: Colors.white,
                            )),
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  void _openBottomSheet(BuildContext context, String plantName, String conf) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "Back",
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Plant Name: $plantName'),
                    Text(conf),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        'assets/image/4.jpeg',
                      ),
                    ),
                    Text(
                      infoData[plantName]),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
  }


  Map<String, dynamic> infoData = {
    'Burnt ash soil':
      'Minerals: \n\tHigh Minerals:iron, manganese, boron, copper and zinc\n\tLow Minerals :Need To mix Gerden Soil + NPK\nOrganic Matter: Nearly 10%\n\nMunsell Color: GLEY2 6/10G',

    'Composed Soil':
      'Minerals: \n\tHigh Minerals:-Nitrogen, Phosphorus, Potassium, Sulphur, Magnesium, Calcium\n\tLow Minerals :-Null(Good For Plant)\nOrganic Matter: 16.67-23.70%\n\nMunsell Color:10R3/1',

    'Alovera':
      'Minerals: \n\tigh Minerals: Calcium carbonate and Phosphate\n\tLow Minerals :  Need Of Mixed Gerden Soil + Nitrogen, Phosphorus, and Potassium\nOrganic Matter: 0.7%\n\nMunsell Color:2.5Y7/2',

    'Gerden soil':
      'Minerals: \n\tHigh Minerals:Boron, Silicon, Calcium, Magnesium, Carbon, Potassium and Copper.\n\tLow Minerals :Nitrogen & Phosphorus\nOrganic Matter:2–10%\n\nMunsell Color:5YR5/3',

    'Gray Soil':
      'Minerals: \n\tHigh Minerals:Magnesium, Carbonates of Lime, Quartz, Kaolin and other Clay Minerals.\n\tLow Minerals :Nitrogen, Phosphorus, and Potassium\nOrganic Matter:0-3%\n\nMunsell Color: GLEY2 4/10G',

    'Regur Soil':
      'Minerals: \n\tHigh Minerals:-Calcium carbonate, Magnesium, Potash and Lime, Iron, Aluminium.\n\tLow Minerals :-Nitrogen and Phosphorus.\nOrganic Matter:3-6%\n\nMunsell Color: 10R 2.5/1',

    'Terra Rossa':
      'Minerals: \n\tHigh Minerals:Nitrogen, Phosphorus, and Potassium,  Iron oxide\n\tLow Minerals :This Soil Is very Hard, \n\tNeed to Mix:30%Terra Rossa + 30%Sand + 40%Composed Soil\nOrganic Matter:High content of organic matter\n\nMunsell Color: 2.5R4/6',

    'White Sand':
      'Minerals: \n\tHigh Minerals:Silica and Oxygen\n\tLow Minerals: Need To Mix Gerden Soil + NPK\nOrganic Matter:0.26%\n\nMunsell Color: 5Y8/1',

    'Unknown Object':
      'Sorry Unknown Object Detected! \n\tTRY AGAIN!!'
  };
}
