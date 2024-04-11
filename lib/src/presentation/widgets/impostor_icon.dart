import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impostors/src/utils/app_colors.dart';

class ImpostorIcon extends StatelessWidget {
  const ImpostorIcon({super.key, this.size, this.color});

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/impostor.svg',
      height: size ?? 32,
      width: size ?? 32,
      colorFilter: ColorFilter.mode(
        color ?? AppColors.primary,
        BlendMode.srcIn,
      ),
    );
  }
}
