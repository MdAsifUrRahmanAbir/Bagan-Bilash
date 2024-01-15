import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'utils/custom_loading_api.dart';
import 'utils/strings.dart';

class PlantDiseasesDetectPage extends StatefulWidget {
  const PlantDiseasesDetectPage({super.key});

  @override
  State<PlantDiseasesDetectPage> createState() =>
      _PlantDiseasesDetectPageState();
}

class _PlantDiseasesDetectPageState extends State<PlantDiseasesDetectPage> {
  List _outputs = [];
  // Map? _output;
  XFile? _image;
  String? plantName;

  RxBool isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();

    loadModel().then((value) {
      setState(() {

      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/PlantsRog/model_unquant.tflite",
      labels: "assets/PlantsRog/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false
    );
    setState(() {

    });
  }

  classifyImage(File image) async {
    isLoading.value = true;
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 6,
        threshold: 0.05,
        imageMean: 127.5,
        imageStd: 127.5,
    );

    setState(() {

    });


    setState(() {
      _outputs = output!;
      Future.delayed(const Duration(seconds: 1), (){
        isLoading.value = false;
      });
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
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(Strings.plantRog),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: _bodyWidget(context),
      ),
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
                : Obx(() => isLoading.value
                  ? const CustomLoadingAPI()
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
                            _openBottomSheet(context, _outputs[0]["label"],
                                'Confidence: ${((_outputs[0]["confidence"]) * 100).toStringAsFixed(2)} %');
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
                                    "${_outputs[0]["label"]}",
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
                    )),
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

  _openBottomSheet(BuildContext context, String plantName, String conf) {
    debugPrint("$plantName \n$conf");
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
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        medicineImage[plantName],
                      ),
                    ),
                    Text(
                      infoData[plantName]
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
  }

  Map<String, dynamic> infoData = {
    'Ant':
        '1.Mix 2 tea-spoon Finis in 1 litre water \n2.Aply the water on plants',
    'Fungus':
        '1.Mix half tea-spoon SAAF in 1 litre water\n2.Spray it on plant leaf',
    'Mileybug':
        '1.mix 1 ml Fighter in 1 litre water\n2.Spray the mixed water on the body of Mili Bug ',
    'White Fly': '1.Mix 0.5 ML Tido in 1 litre water\n2.Spray it on plant leaf',
    'Unknown Object': 'Sorry Unknown Diseases Detected! \n\tTRY AGAIN!!'
  };

  Map<String, dynamic> medicineImage = {
    'Ant': 'assets/medicine/Ant.jpg',
    'Fungus': 'assets/medicine/Fungus.jpg',
    'Mileybug': 'assets/medicine/Mileybug.jpg',
    'White Fly': 'assets/medicine/White Fly.jpg',
    'Unknown Object': 'assets/medicine/Unknown Diseases.png'
  };
}