import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sbm/common/commonwidgets/commonwidgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/appbar/appbarwidgetpage.dart';
import '../../../common/bottomnavbar/bottomnavbar.dart';
import '../../../common/styles/const.dart';
import '../my cart/my_card_page.dart';

class WebScreen extends StatefulWidget {
  String link;
   WebScreen({Key? key, required this.link}) : super(key: key);

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  @override
  void initState() {
    super.initState();

  }
  _willPopCallback() async {
    Get.off(() => BottomNavBarPage());
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return  _willPopCallback();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon:  Icon(Icons.arrow_back_ios, color: colorblack54),
              onPressed: () {
                _willPopCallback();
                notificationactionWidget(context);
              }),
        ),
        body:  WebView(
          initialUrl: widget.link,
           javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
