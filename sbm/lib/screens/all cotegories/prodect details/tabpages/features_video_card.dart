import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:video_player/video_player.dart';
import 'package:sbm/model/prodectdetelsmodel/Data.dart';

class FeaturesVideoCardPage extends StatefulWidget {
  List<Featurevideos> fvideo;
  FeaturesVideoCardPage({Key? key, required this.fvideo}) : super(key: key);

  @override
  State<FeaturesVideoCardPage> createState() => _FeaturesVideoCardPageState();
}

class _FeaturesVideoCardPageState extends State<FeaturesVideoCardPage> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  int? _playBackTime;
  @override
  void initState() {
    super.initState();
  }
  bool abc = false;
  int ind = 0 ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
          child: SingleChildScrollView(
        physics:  BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListView.separated(
              shrinkWrap: true,
              cacheExtent: 1000,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              // key: PageStorageKey(widget.position),
              addAutomaticKeepAlives: true,
              itemCount: widget.fvideo.isEmpty ? 0 : widget.fvideo.length,
              itemBuilder: (BuildContext context, int index) => Container(
                width: double.infinity,
                height: 250.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.fvideo[index].name!),
                    sizedboxheight(5.0),
                    InkWell(
                      onTap: (){
                       setState(() {
                         abc = true;
                         ind = index;
                       });
                      },
                      child: index != ind? Container(
                        color: colorgrey,
                        width: deviceWidth(context, 1.0),
                        height: 200,
                        child: Image.asset("assets/play-button.png",scale: 6,),
                      ):VideoWidgetFeatuer(
                      play: true,
                      url: widget.fvideo[index].video,
                    ),
                    )

                  ],
                ),
              ),
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
            sizedboxheight(200.0)
          ],
        ),
      )),

    );
  }

  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}

class VideoWidgetFeatuer extends StatefulWidget {
  final bool? play;
  final String? url;

  const VideoWidgetFeatuer({Key? key, @required this.url, @required this.play})
      : super(key: key);

  @override
  _VideoWidgetFeatuerState createState() => _VideoWidgetFeatuerState();
}

class _VideoWidgetFeatuerState extends State<VideoWidgetFeatuer> {
   late VideoPlayerController videoPlayerController;
   Future<void>? _initializeVideoPlayerFuture;
  VideoPlayerController? _controller;
  int? _playBackTime;
  late ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    print("widget.url??????${widget.url}");
    videoPlayerController =  VideoPlayerController.network(widget.url!.replaceAll(" ", "%20"));
    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      setState(() {

      });
    });

  } // This closing tag was missing

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            height: 220,
            child: Card(
              elevation: 5.0,
              child: Chewie(
                controller: ChewieController(
                  videoPlayerController: videoPlayerController,
                  aspectRatio: 3 / 2,
                  autoInitialize: true,
                  looping: false,
                  autoPlay: true,
                  errorBuilder: (context, errorMessage) {
                    return Center(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        } else {
          return Container(
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
