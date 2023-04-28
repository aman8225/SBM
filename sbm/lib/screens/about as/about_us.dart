import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:provider/provider.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar_modelpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbarwidget.dart';

import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/aboutus_model/aboutus_model.dart';
import 'package:video_player/video_player.dart';

class About_Us extends StatefulWidget {
  Data? aboutusdata;
  About_Us({Key? key, this.aboutusdata}) : super(key: key);

  @override
  State<About_Us> createState() => _About_UsState();
}

class _About_UsState extends State<About_Us> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    print("widget.aboutusdata");
    print(widget.aboutusdata!.video.toString());
    print("widget.aboutusdata");
    super.initState();
    setState(() {
      _controller = VideoPlayerController.network(
          '${widget.aboutusdata!.video.toString()}')
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {

      return Scaffold(
      appBar: appbarnotifav(context, 'About Us'),
      body: Stack(
        children: [
          Container(
            width: deviceWidth(context, 0.2),
            height: deviceheight(context, 1.0),
            color: colorskyeblue,
          ),

          Container(
            width: deviceWidth(context, 1.0),
            height: deviceheight(context, 1.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: _controller!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                                // child: VideoPlayer(_controller!),
                              )
                            : Container(),
                      ),
                      Positioned(
                        left: deviceWidth(context, 0.45),
                        top: deviceheight(context, 0.1),
                        child: FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              _controller!.value.isPlaying
                                  ? _controller!.pause()
                                  : _controller!.play();
                            });
                          },
                          child: Icon(
                            _controller!.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Html(
                      data: """
                                ${widget.aboutusdata!.pageDescription == null ? '' : widget.aboutusdata!.pageDescription!.trim()}
                                """,
                    ),
                  )
                ],
              ),
            ),
          )

          // Container(
          //   width: deviceWidth(context,1.0),
          //   height: deviceheight(context,1.0),
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: [
          //         Stack(
          //           children: [
          //             Center(
          //               child: _controller!.value.isInitialized
          //                   ? AspectRatio(
          //                 aspectRatio: _controller!.value.aspectRatio,
          //                 child: VideoPlayer(_controller!),
          //               )
          //                   : Container(),
          //             ),
          //             Positioned(
          //               left: deviceWidth(context,0.45),
          //               top: deviceheight(context,0.1),
          //               child: FloatingActionButton(
          //                 onPressed: () {
          //                   setState(() {
          //                     _controller!.value.isPlaying
          //                         ? _controller!.pause()
          //                         : _controller!.play();
          //                   });
          //                 },
          //                 child: Icon(
          //                   _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //
          //         Padding(
          //           padding: const EdgeInsets.all(15.0),
          //           child: Text('Lorem Ipsum is simply dummy text of the '
          //           'printing and typesetting industry. Lorem Ipsum has'
          //               ' been the industry\'s standard dummy text ever '
          //               'since the 1500s,when an unknown printer took a '
          //               'galley of type and scrambled it to make a type '
          //               'specimen book.It has survived not only five centuries,'
          //               ' but also the leap into electronic typesetting,'
          //               ' remaining essentially unchanged. It was '
          //               'popularised in the 1960s with the release of '
          //               'Letraset sheets containing Lorem Ipsum passages, '
          //               'and more recently with desktop publishing software '
          //               'like Aldus PageMaker including versions of '
          //               'Lorem Ipsum.\n\n'
          //               'Lorem Ipsum is simply dummy text of the '
          //               'printing and typesetting industry. Lorem Ipsum has'
          //               ' been the industry\'s standard dummy text ever '
          //               'since the 1500s,when an unknown printer took a '
          //               'galley of type and scrambled it to make a type '
          //               'specimen book.It has survived not only five centuries,'
          //               ' but also the leap into electronic typesetting,'
          //               ' remaining essentially unchanged. It was '
          //               'popularised in the 1960s with the release of '
          //               'Letraset sheets containing Lorem Ipsum passages, '
          //               'and more recently with desktop publishing software '
          //               'like Aldus PageMaker including versions of '
          //               'Lorem Ipsum.',style: textstylesubtitle1(context)!.copyWith(fontSize: 14,height: 1.5),),
          //         )
          //
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          model.togglebottomindexreset();
           Get.to(BottomNavBarPage());
        },
        tooltip: 'Increment',
        child: SvgPicture.asset(
          'assets/slicing 2/home (10).svg',
          width: 25,
          height: 25,
          color: colorWhite,
        ),
        elevation: 2.0,
      ),
      bottomNavigationBar: bottomNavBarPagewidget(context, model),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );});
  }

  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}
