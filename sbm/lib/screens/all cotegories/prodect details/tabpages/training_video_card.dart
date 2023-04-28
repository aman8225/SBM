import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:video_player/video_player.dart';
import 'package:sbm/model/prodectdetelsmodel/Data.dart';

class TrainingVideoCardPage extends StatefulWidget {
  List<TranningVideos> tvideo;
  TrainingVideoCardPage({Key? key, required this.tvideo}) : super(key: key);

  @override
  State<TrainingVideoCardPage> createState() => _TrainingVideoCardPageState();
}

class _TrainingVideoCardPageState extends State<TrainingVideoCardPage> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  int? _playBackTime;
  @override
  void initState() {
    super.initState();
    // for (int i = 0; i < widget.tvideo.length; i++)
    //   _controller = VideoPlayerController.network(widget.tvideo[i].video!)
    //     ..initialize().then((_) {
    //       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //       setState(() {});
    //     });
  }
  bool abc = false;
  int ind = 0 ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: SingleChildScrollView(
        physics: new BouncingScrollPhysics(),
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
              itemCount: widget.tvideo.isEmpty ? 0 : widget.tvideo.length,
              itemBuilder: (BuildContext context, int index) => Container(
                width: double.infinity,
                height: 300.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.tvideo[index].name!),
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
                      ):VideoWidgetTvideo(
                        play: true,
                        url: widget.tvideo[index].video,
                      ),
                    )

                  ],
                ),
              ),
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ],
        ),
      )),

      // Container(
      //     padding: EdgeInsets.only(left: 8,right: 8,bottom: 8),
      //   child:  ListView.builder(
      //       itemCount:widget.tvideo.length,
      //       itemBuilder: ((BuildContext context,int index){
      //         return Padding(
      //           padding: const EdgeInsets.all(10.0),
      //           child: Container(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               // mainAxisAlignment: MainAxisAlignment.start,
      //               children: [
      //                 Text(widget.tvideo[index].name!),
      //                 sizedboxheight(10.0),
      //                 Stack(
      //                   children: [
      //                     Center(
      //                       child: _controller!.value.isInitialized
      //                           ? AspectRatio(
      //                         aspectRatio: _controller!.value.aspectRatio,
      //                         child: VideoPlayer(_controller!),
      //                       )
      //                           : Container(),
      //                     ),
      //                     Positioned(
      //                       left: deviceWidth(context,0.4),
      //                       top: deviceheight(context,0.1),
      //                       child: FloatingActionButton(
      //                         onPressed: () {
      //                           setState(() {
      //                             _controller!.value.isPlaying
      //                                 ? _controller!.pause()
      //                                 : _controller!.play();
      //                           });
      //                         },
      //                         child: Icon(
      //                           _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 )
      //               ],
      //             ),
      //           ),
      //         );
      //       }))
      // ),
    );
  }

  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}

class VideoWidgetTvideo extends StatefulWidget {
  final bool? play;
  final String? url;

  const VideoWidgetTvideo({Key? key, @required this.url, @required this.play})
      : super(key: key);

  @override
  _VideoWidgetTvideoState createState() => _VideoWidgetTvideoState();
}

class _VideoWidgetTvideoState extends State<VideoWidgetTvideo> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController = new VideoPlayerController.network(widget.url!);
    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
  } // This closing tag was missing

  @override
  void dispose() {
    videoPlayerController.dispose();
    //    widget.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            height: 250,
            child: Card(
              key:  PageStorageKey(widget.url),
              elevation: 5.0,
              child: Chewie(
                key:  PageStorageKey(widget.url),
                controller: ChewieController(
                  videoPlayerController: videoPlayerController,
                  aspectRatio: 3 / 2,
                  // Prepare the video to be played and display the first frame
                  autoInitialize: true,
                  looping: false,
                  autoPlay: false,
                  // Errors can occur for example when trying to play a video
                  // from a non-existent URL
                  errorBuilder: (context, errorMessage) {
                    return Center(
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
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
