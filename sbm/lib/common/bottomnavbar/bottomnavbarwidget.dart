// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/screens/home/homescreen.dart';
import 'package:sbm/splash.dart';

import 'bottomnavbar.dart';

BottomNavigationBar bottomNavBarPagewidget(context, model) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: colorWhite,
    selectedItemColor: colorblue,
    unselectedItemColor: colorblack,
    showUnselectedLabels: true,
    selectedFontSize: 9,
    unselectedFontSize: 8,
    iconSize: 25,

    selectedIconTheme: IconThemeData(color: colorblue, size: 25),
    // showSelectedLabels: false,
    selectedLabelStyle: TextStyle(fontWeight: fontWeight700, color: colorblue),
    unselectedLabelStyle: TextStyle(fontWeight: fontWeight500),
    onTap: (index) {
      model.toggle(context, index);
      Get.to(BottomNavBarPage());
    },
    currentIndex: model.bottombarzindex,
    // ignore: prefer_const_literals_to_create_immutables
    items: [
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          'assets/slicing 2/user.svg',
          width: 25,
          height: 25,
          color: model.bottombarzindex == 0 ? colorblue : colorgrey,
        ),
        // icon: Icon(Icons.home_rounded),
        label: 'My Account',
      ),
      BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/slicing 2/explore.svg',
            width: 25,
            height: 25,
            color: model.bottombarzindex == 1 ? colorblue : colorgrey,
          ),
          label: 'All Categories'),
      BottomNavigationBarItem(icon: Icon(Icons.arrow_drop_up), label: ''),
      BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/slicing 2/my order.svg',
            width: 25,
            height: 25,
            color: model.bottombarzindex == 3 ? colorblue : colorgrey,
          ),
          label: 'My Orders'),
      BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/slicing 2/my item.svg',
            width: 25,
            height: 25,
            color: model.bottombarzindex == 4 ? colorblue : colorgrey,
          ),
          label: 'My Items'),
    ],
  );
}

Widget dividercontaner(context) {
  return Container(
    height: 1,
    width: deviceWidth(context, 1.0),
    color: Colors.black26,
  );
}
