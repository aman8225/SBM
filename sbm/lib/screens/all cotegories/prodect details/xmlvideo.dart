import 'package:flutter/material.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/appbar/appbarpage.dart';

class XmlVideo extends StatefulWidget {
  String? video;
   XmlVideo({Key? key, this.video}) : super(key: key);

  @override
  State<XmlVideo> createState() => _XmlVideoState();
}

class _XmlVideoState extends State<XmlVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarbackbtnonly(context),
       body: Stack(
         children: [
           Container(
             width: deviceWidth(context, 0.2),
             height: deviceheight(context, 1.0),
             color: colorskyeblue,
           ),
           Container(
             width: deviceWidth(context),
             height: deviceheight(context),
             child: Center(
               child: WebView(
                 initialUrl: widget.video.toString(),
                 javascriptMode: JavascriptMode.unrestricted,

               ),
             ),
           ),
         ],
       ),



    );
  }
}
