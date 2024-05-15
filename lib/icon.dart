
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SvgIcon extends StatelessWidget {
  final String assetName;

  const SvgIcon(this.assetName, {Key? key}) : super(key: key); // Убираем параметр цвета

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: 24,
      height: 24,
    );
  }
}

class DoubleIcon extends StatelessWidget {
  final String topIconAsset;
  final String bottomIconAsset;

  const DoubleIcon({
    Key? key,
    required this.topIconAsset,
    required this.bottomIconAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center, // Центрируем иконки относительно друг друга
      children: [
        SvgPicture.asset(
          bottomIconAsset,
          width: 28,
          height: 28,
        ),
        SvgPicture.asset(
          topIconAsset,
          width: 24,
          height: 24,
        ),
      ],
    );
  }
}

