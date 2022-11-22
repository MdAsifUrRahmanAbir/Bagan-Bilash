import 'package:flutter/material.dart';

import 'utils/strings.dart';

class IrrigationPage extends StatelessWidget {
  const IrrigationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.irrigationSystem),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(),
    );
  }
}
