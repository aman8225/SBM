import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sbm/screens/auth/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'common/appbar/appbarwidgetpage.dart';
import 'common/bottomnavbar/bottomnavbar.dart';
import 'common/styles/const.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;

    Timer(
      Duration(seconds: 3),
      () {
        // status ? Get.offAll(() => BottomNavBarPage()) : Get.offAll(() => IntroductionPage());
        status
            ? Get.offAll(() => BottomNavBarPage())
            : Get.offAll(() => LoginScreen());
      },
    );
  }
  Future<void> abc(context) async {
    (context as Element).reassemble();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    cartitemlength = prefs.getString('cart_item_length');
    cartitemlength = cartitemlength!.replaceAll('"', '');
    print("cartitemlength??????$cartitemlength");
    //(context as Element).reassemble();
  }
  void initState() {
    super.initState();
    getValuesSF();
    abc(context);
    notificationactionWidget(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      // bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(50),
                    ),
                  )),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      // bottomRight: Radius.circular(50),
                    ),
                  )),
            ),
            Container(
              width: deviceWidth(context, 1.0),
              height: deviceheight(context, 1.0),
              child: Image.asset(
                'assets/sbm_icon.png',
                scale: 10,
              ),

              // Image.asset(
              //   'assets/icons/logo@3x.png',
              //   scale: 3,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
