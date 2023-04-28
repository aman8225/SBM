import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/prodectdetelsmodel/Data.dart';

import '../../../../main.dart';

class DocumentCardPage extends StatefulWidget {
  final Data discriptiondata;
  DocumentCardPage({Key? key, required this.discriptiondata}) : super(key: key);

  @override
  State<DocumentCardPage> createState() => _DocumentCardPageState();
}

class _DocumentCardPageState extends State<DocumentCardPage> {
  bool dilogbox = false;
  Dio dio = Dio();
  double? progress = 0;
  double progress1 = 0;
  void startDownloading(url) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      print("Start Download");
      await Permission.storage.request();
    }
    Directory? downloadsDirectory;
    try {
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    } on PlatformException {
      print('Could not get the downloads directory');
    }
    String tempPath = downloadsDirectory!.path;
    var filePath = '$tempPath/$url';
    await dio.download(
      url,
      filePath,
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          dilogbox = true;
          progress = ((recivedBytes / totalBytes) * 100);
          progress1 = ((recivedBytes / totalBytes) * 1);
          print(progress);
          if(progress == 100){
            dilogbox = false;
            progress = 0;
            progress1 = 0;
            Fluttertoast.showToast(
                msg: "Data File Downloads",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.white,
                textColor: Colors.blue,
                fontSize: 16.0
            );
          }
        });
      },
      deleteOnError: true,
    ).then((_) {
      print("Then Here $_");
    }).catchError((_a) {
      print("Error Show $_a");
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.discriptiondata.techDocuments == null
          ? Container()
          : Stack(
            children: [
              Container(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedboxheight(8.0),
                        Text(
                          'Download the tech douments for more details:',
                          style: textstylesubtitle1(context),
                        ),
                        sizedboxheight(10.0),
                        Container(
                         height: MediaQuery.of(context).size.height,
                          child: ListView.builder(

                              itemCount:
                                  widget.discriptiondata.techDocuments!.length,
                              itemBuilder: ((itemBuilder, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: deviceWidth(context, 1.0),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: colorblue),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/icons/icon-4@3x.png',
                                                scale: 5,
                                              ),
                                              Container(
                                                width: deviceWidth(context, 0.5),
                                                child: Text(
                                                  '    Title: DOWNLOAD DATASHEET',
                                                  style:
                                                      textstylesubtitle1(context)!
                                                          .copyWith(
                                                              color: colorblue,
                                                              fontSize: 12),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                              onTap: () {
                                                startDownloading(widget
                                                    .discriptiondata.techDocuments![index]);
                                              },
                                              child: Icon(
                                                Icons.arrow_circle_down,
                                                color: colorblue,
                                              ))
                                          // Image.asset('assets/icons/icon-4@3x.png',scale: 1,),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })),
                        ),
                        // card(context),
                        //
                        // card(context),
                        //
                        // card(context),
                        //
                        // card(context),
                      ],
                    ),
                  ),
                ),
              dilogbox? Center(
                child: Container(

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularPercentIndicator(
                      radius: 40.0,
                      animation: false,
                      animationDuration: 1200,
                      lineWidth:10.0,
                      percent: progress1,
                      center:  Text(
                        progress!.toStringAsFixed(2),
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0,color: colorblue),
                      ),
                      circularStrokeCap: CircularStrokeCap.butt,
                      backgroundColor: colorWhite,
                      progressColor: colorblue,
                    ),
                  ),
                ),
              ):Container(),
            ],
          ),
    );
  }

  Widget card(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: deviceWidth(context, 1.0),
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: colorblue),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons/icon-4@3x.png',
                    scale: 5,
                  ),
                  Container(
                    width: deviceWidth(context, 0.5),
                    child: Text(
                      '    DOWNLOAD DATASHEET',
                      style: textstylesubtitle1(context)!
                          .copyWith(color: colorblue, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_circle_down,
                color: colorblue,
              )
              // Image.asset('assets/icons/icon-4@3x.png',scale: 1,),
            ],
          ),
        ),
      ),
    );
  }
}
