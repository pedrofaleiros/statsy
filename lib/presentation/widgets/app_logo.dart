import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo.svg',
      width: size,
      height: size,
    );
  }
}

class AppLogoGray extends StatelessWidget {
  const AppLogoGray({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo-gray.svg',
      width: size,
      height: size,
    );
  }
}
