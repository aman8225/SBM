import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar_modelpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbarwidget.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/videos_data_model/videosdatamodel.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

List<VideosDataResponse> _urls = [];

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future? _future;
  var tokanget;

  ProgressDialog? progressDialog;
  var success, message, data;
  Future<VideosDataModelMassege> whishlistdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    print("CLICKED 123 ==" + tokanget!);
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(Text("Loading...."));
        // progressDialog.setMessage(Text("Please Wait for $timerCount seconds"));
        progressDialog?.show();
      } else {
        Fluttertoast.showToast(
            msg: "Please check your Internet connection!!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: colorblue,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
    var response =
        await http.get(Uri.parse(beasurl + 'getProductVideos'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    progressDialog!.dismiss();
    success =
        (VideosDataModelMassege.fromJson(json.decode(response.body)).success);
    message =
        (VideosDataModelMassege.fromJson(json.decode(response.body)).message);

    print('aman length${_urls.length}');
    progressDialog!.dismiss();
    if (success == true) {
      progressDialog!.dismiss();
      data = (VideosDataModelMassege.fromJson(json.decode(response.body)).data);
      _urls =
          (VideosDataModelMassege.fromJson(json.decode(response.body)).data!);
    } else {
      print('else==============');
      progressDialog!.dismiss();
    }
    return VideosDataModelMassege.fromJson(json.decode(response.body));
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _future = whishlistdata();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {

      return Scaffold(
        appBar: appbarnotifav(context, 'Download Video'),
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
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _urls.length == 0
                            ? Container(
                          width: deviceWidth(context, 1.0),
                          height: deviceheight(context, 1.0),
                          child: const Center(
                            child: Text('No Data'),
                          ),
                        )
                            : GridView.builder(
                            gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 220,
                                childAspectRatio: 2 / 2.6,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5),
                            itemCount: _urls.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return Card(
                                elevation: 3,
                                child: Container(
                                  width: deviceWidth(context, 0.4),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      _urls[index].video==""?Image.network(_urls[index].placeholder.toString()): MyWidget(index),
                                      sizedboxheight(8.0),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          _urls[index].productName!,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      sizedboxheight(8.0),
                                      Container(
                                        height: 25,
                                        color: colorblue,
                                        child: Center(
                                          child: Text(
                                            'IN PROGRESS',
                                            style: textnormail(context)!
                                                .copyWith(color: colorWhite),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    // future: postlist(),
                  )),
            ),
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
}

class MyWidget extends StatefulWidget {
  final int index;
  MyWidget(this.index) : super(key: ValueKey('MyWidget: $index'));

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(_urls[widget.index].video!)
      ..setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<dynamic> _init() async {
    await _controller.initialize();
    return Null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init(),
      builder: (context, future) => !future.hasData
          ? const Align(child: CircularProgressIndicator())
          : future.hasError
              ? const Align(child: Icon(Icons.error))
              : GestureDetector(
                  onTap: () => _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play(),
                  child: Stack(
                    children: [
                      Align(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
