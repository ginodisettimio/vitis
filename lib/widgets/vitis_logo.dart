import 'package:flutter/material.dart';

class VitisLogo extends StatelessWidget {
  final double? width;
  final double? height;
  const VitisLogo({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage("assets/images/logo.png"),
      width: width,
      height: height,
    );
  }
}