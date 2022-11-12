import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'utils/strings.dart';


class PlantDetectPage2 extends StatefulWidget {
  const PlantDetectPage2({Key? key}) : super(key: key);

  @override
  State<PlantDetectPage2> createState() => _PlantDetectPage2State();
}

class _PlantDetectPage2State extends State<PlantDetectPage2> {
  List? _outputs;
  XFile? _image;
  String? plantName;

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
      print(element);
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
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
            Strings.plantDetection
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                flex: 9,
                child: _image == null
                    ? Container(
                  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4DCFF),
                    borderRadius:
                    BorderRadius.all(Radius.circular(25.0)),
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
                    child: GestureDetector(
                      onTap: (){
                        _openBottomSheet(
                            context,
                            _outputs?[0]["label"],
                            'Confidence: ${((_outputs?[0]["confidence"]) * 100).toStringAsFixed(2)} %'
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "${_outputs?[0]["label"]}",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Card(
                  margin: const EdgeInsets.all(0),
                  color: const Color(0xFFD4DCFF),
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
                          topRight: Radius.circular(15.0),
                          topLeft: Radius.circular(15.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xFF65708F),
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
                              color: Color(0xFF65708F),
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
        ),
      ),
    );
  }

  void _openBottomSheet(BuildContext context, String plantName, String conf) {
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10
            ),
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                      onPressed: (){
                        Get.back();
                      },
                      child: const Text("Back",)
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Plant Name: $plantName'),
                    Text(conf),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }


}
