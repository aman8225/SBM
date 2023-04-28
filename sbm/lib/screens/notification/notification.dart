import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/appbar/appbarpage.dart';
import '../../common/bottomnavbar/bottomnavbar.dart';
import '../../common/bottomnavbar/bottomnavbar_modelpage.dart';
import '../../common/bottomnavbar/bottomnavbarwidget.dart';
import '../../common/server_url.dart';
import '../../model/notification_model/notification_model.dart';


class Notification_screen extends StatefulWidget {
  const Notification_screen({Key? key}) : super(key: key);

  @override
  _Notification_screenState createState() => _Notification_screenState();
}

class _Notification_screenState extends State<Notification_screen> {

  Future? _future;
  var tokanget;

  ProgressDialog? progressDialog;
  var success, message;
  List<NotificationList> notificationList = [];
  Data? data;
  int? notifyCount;
  Future<NotificationDataModel> notificationdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');

    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(const Text("Loading...."));
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
    var response = await http.get(Uri.parse('${beasurl}getNotificationList'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    print('aman home${response.body}');

    success = (NotificationDataModel.fromJson(json.decode(response.body)).success);
    message = (NotificationDataModel.fromJson(json.decode(response.body)).message);
    data = (NotificationDataModel.fromJson(json.decode(response.body)).data);
    notificationList = (NotificationDataModel.fromJson(json.decode(response.body)).data!.notificationList)!;
   print('rahul rahul rahiul ${notificationList.length}');
    progressDialog!.dismiss();
    if (success == true) {
      setState(() {
        notificationList = (NotificationDataModel.fromJson(json.decode(response.body)).data!.notificationList)!;
        notifyCount = (NotificationDataModel.fromJson(json.decode(response.body)).data!.notifyCount);
      });
      progressDialog!.dismiss();
    } else {
      Navigator.pop(context);
      print('else==============');
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return NotificationDataModel.fromJson(json.decode(response.body));
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
    _future = notificationdata();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {
          return Scaffold(
          appBar: appbarnotifav(context, 'Notification'),
          body: Stack(
            key: _scaffoldKey,
            children: [
              Container(
                width: deviceWidth(context, 0.2),
                height: deviceheight(context, 1.0),
                color: colorskyeblue,
              ),
              Container(
                  width: deviceWidth(context, 1.0),
                  height: deviceheight(context, 1.0),
                  padding: const EdgeInsets.all(10),
                  child:notifyCount == 0 ?Container(

                    width: deviceWidth(context, 1.0),
                    height: deviceheight(context, 1.0),
                    child: const Center(
                      child: Text("No Data" ),
                    ),
                  ): ListView.builder(
                      shrinkWrap: true,
                      itemCount: notificationList.length,
                      itemBuilder: (BuildContext context, int index){
                    return InkWell(
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title:  Text(notificationList[index].subject.toString(),style: textheding(context),),
                              content:Html(
                                data: notificationList[index].message.toString(),
                                style: {
                                  "body": Style(
                                      fontSize:  const FontSize(12.0),
                                      fontWeight: FontWeight.normal,

                                  ),
                                },
                              ),
                            )
                        );
                      },
                      child: Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(notificationList[index].subject.toString(),style: textheding(context),),
                              Html(
                                data: notificationList[index].message.toString(),
                                style: {
                                  "body": Style(
                                    fontSize:  const FontSize(12.0),
                                    fontWeight: FontWeight.normal,
                                    maxLines: 2
                                  ),
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }) ),

            ],
          ),
            floatingActionButton:  FloatingActionButton(
              onPressed: () {
                model.togglebottomindexreset();
                Get.to(BottomNavBarPage());
              },
              tooltip: 'Increment',
              elevation: 2.0,
              child: SvgPicture.asset(
                'assets/slicing 2/home (10).svg',
                width: 25,
                height: 25,
                color: colorWhite,
              ),
            ),
            bottomNavigationBar: bottomNavBarPagewidget(context, model),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );});
      },
    );
  }
}
