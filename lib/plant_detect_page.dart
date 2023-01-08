import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'utils/strings.dart';

class PlantDetectPage extends StatefulWidget {
  const PlantDetectPage({Key? key}) : super(key: key);

  @override
  State<PlantDetectPage> createState() => _PlantDetectPageState();
}

class _PlantDetectPageState extends State<PlantDetectPage> {
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
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
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
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(Strings.plantDetection),
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
                  topRight: Radius.circular(25.0),
                  topLeft: Radius.circular(25.0),
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
                        margin: const EdgeInsets.all(20),
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
                        margin: const EdgeInsets.all(20),
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Text(
                  infoData[plantName]
                ),
              ],
            ),
          );
        });
  }

  Map<String, dynamic> infoData = {
    'Adenium':
        'Humidity levels:\t 50-60%		\nMoisture:\t50-60%		\nTemp: \t18-30℃	 \nSun: \tSun Light	 \nPlant Sight:\tOutdoor',
    'Air Plant':
        'Water : \tSpray water 4 times in a week	 	\nPlant Sight:\tIndoor',
    'Alovera':
        'Humidity levels: \t40-70%	\nMoisture:\t40-70%	  \nTemp: \t18-30℃	\nSun:\tSun Light	  \nPlant Sight:\tSemi Indoor/Outdoor',
    'Araian Wax':
        'Humidity levels: \t40-70%	\nMoisture:\t40-70%	  \nTemp: \t18-30℃	 \nSun: \tIndirect Bright Sun Light	  \nPlant Sight:\tSemi Indoor',
    'Baby Tears':
        'Humidity levels : \t75-76%	 \nMoisture:\t55-76%		\nTemp: \t18-30℃	\nSun: \tIndirect Bright Sun Light	  \nPlant Sight:\tIndoor',
    'Bonsai':
        'Humidity levels :\t40-50%	\nMoisture:\t40-50%		\nTemp: \t18-30℃	 \nSun: \tSun Light	  \nPlant Sight:\tOutdoor',
    'Bunny Cactus':
        'Water:\tWhen soil dry then watering 70-90%		\nTemp: \t18-50℃	 \nSun: \tSun Light	  \nPlant Sight:\tOutdoor',
    'Cactus':
        'Water: \tWhen soil dry then watering 70-90%		\nTemp: \t18-50℃	 \nSun: \tSun Light		\nPlant Sight:\tOutdoor',
    'Caladium':
        'Humidity levels:\t50-70%		\nMoisture:\t50-70%	  \nTemp: \t18-25℃	 \nSun: \tIndirect Bright Sun Light	  \nPlant Sight:\tIndoor',
    'Elephant Ear':
        'Humidity levels: \t50-70% 	 \nMoisture:\t50-70% 	\nTemp: \t18-30℃	 \nSun: \tIndirect Bright Sun Light	  \nPlant Sight:\tIndoor',
    'Jade Plant':
        'Humidity levels:\t50-70%	 \nMoisture:\t50-70%	\nTemp: \t18-30℃	 \nSun: \tIndirect Bright Sun Light	  \nPlant Sight: \tSemi Indoor',
    'Kamini Bonsai':
        'Humidity levels :\t40-50%		\nMoisture:\t40-50%		\nTemp: \t18-30℃	\nSun: \tSun Light	 \nPlant Sight:\tOutdoor',
    "Kata Mukut":
        'Humidity levels:\t50-70%	 \nMoisture:\t40-55%	 \nTemp: \t18-50℃	\nSun: \tIndirect Bright Sun Light/Full sunlight	  \nPlant Sight:\tSemi Indoor/Outdoor',
    "Lucky Bamboo":
        'Humidity levels:\t50-60%		\nMoisture:\t50-60%		\nTemp: \t18-30℃	 \nSun: \tIndirect Bright Sun Light	  \nPlant Sight:\tIndoor',
    'Mini Bamboo':
        'Humidity levels:\t50-70%	\nMoisture:\t50-70%		\nTemp: \t18-30℃	 \nSun: \tSun Light	  \nPlant Sight:\tOutdoor',
    'Pencil Cactus':
        'Water:\tWhen soil dry then watering 70-90%		\nTemp: \t18-50℃	 \nSun: \tSun Light	  \nPlant Sight:\tOutdoor',
    'Pothos':
        'Humidity levels:\t50-70%		\nMoisture:\t50-70%		\nTemp: \t18-30℃	 \nSun: \tIndirect Bright Sun Light	  \nPlant Sight:\tIndoor',
    'Snake Plant':
        'Humidity levels:\t50-70%		\nMoisture:\t50-70%		\nTemp: \t18-30℃	 \nSun: \tIndirect Bright Sun Light	  \nPlant Sight:\tIndoor',
    'Spider Plant':
        'Humidity levels:\t50-60%		\nMoisture:\t50-60%		\nTemp: \t18-30℃	 \nSun: \tIndirect Bright Sun Light	  \nPlant Sight:\tIndoor',
    'Wondering Jew':
        'Humidity levels:\t50-70%	 \nMoisture:\t50-70%		\nTemp: \t18-30℃	 \nSun: \tIndirect Bright Sun Light	  \nPlant Sight:\tIndoor',
    'Unknown Object': 'Sorry Unknown Object Detected! \n\tTRY AGAIN!!'
  };
}
