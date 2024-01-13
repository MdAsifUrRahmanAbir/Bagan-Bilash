import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class CustomLoadingAPI extends StatelessWidget {
  const CustomLoadingAPI({
    super.key,
    this.color = Colors.greenAccent,
  });
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20
        ),
        child: SpinKitThreeBounce(
          color: color.withOpacity(0.5),
          size: 30.0,
        ),
      ),
    );
  }
}
