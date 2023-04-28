// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, annotate_overrides, use_key_in_widget_constructors, overridden_fields

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sbm/common/styles/const.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String? buttonName;
  final Key? key;
  final borderRadius;
  final double? btnWidth;
  final double? btnHeight;
  final Color? btnColor;
  final Color? btnColorGradientUp;
  final Color? btnColorGradientdown;
  final Color? borderColor;
  final Color? textColor;
  final imageAsset;
  final double? elevation;
  final double? btnfontsize;
  final btnstyle;

  Button({
    this.buttonName,
    required this.onPressed,
    this.borderRadius,
    this.btnWidth,
    this.btnHeight,
    this.btnColor,
    this.btnColorGradientUp,
    this.btnColorGradientdown,
    this.borderColor,
    this.textColor,
    this.key,
    this.imageAsset,
    this.elevation,
    this.btnstyle,
    this.btnfontsize,
  });
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width;

    return Container(
      height: btnHeight ?? 45.0,
      width: btnWidth ?? screenSize,
      decoration: BoxDecoration(
        // gradient:  LinearGradient(
        //                 begin: Alignment.topCenter,
        //                 end: Alignment.bottomCenter,
        //                 colors: [HexColor('#FDCD35'), HexColor('#FD7235')]),
        // color: btnColor ?? Colors.transparent,
        color: btnColor ?? colorblue,
        borderRadius: borderRadius ?? BorderRadius.circular(22.0),
      ),
      child: MaterialButton(
        splashColor: Colors.grey,
        // animationDuration: Duration(seconds: 10),
        hoverColor: Colors.black26,

        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(22.0),
          side: BorderSide(color: borderColor ?? Colors.transparent),
        ),
        key: key,
        elevation: elevation ?? 3,
        child: imageAsset != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [prefiximage(), sizedboxwidth(8.0), btnname(context)],
              )
            : btnname(context,),

        onPressed: onPressed,
      ),
    );
  }

  Widget prefiximage() {
    return imageAsset;
  }

  Widget btnname(context) {
    return Text(
      buttonName!,
      style: btnstyle ??
          TextStyle(
            inherit: true,
            color: textColor ?? Colors.white,
            fontFamily: 'Nunito',
            fontWeight: fontWeight500,
            fontSize: btnfontsize ?? 16,
            letterSpacing: 0.3,

          ),
      maxLines: 1,

    );
  }
}
