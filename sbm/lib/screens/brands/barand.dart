import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:sbm/common/formtextfield/mytextfield.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/brandmodel/brandmodel.dart';
import 'package:http/http.dart' as http;

class Brand extends StatefulWidget {
  Brand({Key? key}) : super(key: key);

  @override
  State<Brand> createState() => _BrandState();
}

class _BrandState extends State<Brand> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future? _future;
  var tokanget;

  ProgressDialog? progressDialog;
  var success, message, data;
  List<brandData> branddatda = [];
  Future<BrandMassegeModel> brenddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');

    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(Text("Loading...."));
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
    var response = await http.get(Uri.parse(beasurl + 'brands'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    print('aman home${response.body}');
    print(BrandMassegeModel.fromJson(json.decode(response.body)).data);
    print(BrandMassegeModel.fromJson(json.decode(response.body)).message);
    success = (BrandMassegeModel.fromJson(json.decode(response.body)).success);
    message = (BrandMassegeModel.fromJson(json.decode(response.body)).message);
    data = (BrandMassegeModel.fromJson(json.decode(response.body)).data);
    branddatda =
        (BrandMassegeModel.fromJson(json.decode(response.body)).data!.data)!;
    print('aman length${branddatda.length}');
    progressDialog!.dismiss();
    if (success == true) {
      if (message == "Home Page Details") {
        Navigator.pop(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
      }
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
    return BrandMassegeModel.fromJson(json.decode(response.body));
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
    _future = brenddata();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {
      return Scaffold(
        appBar: appbarnotifav(context, 'Brands'),
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
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: serchbar(),
                      ),
                      sizedboxheight(30.0),
                      Card(
                        elevation: 2,
                        child: Container(
                          height: deviceheight(context, 0.7),
                          padding: EdgeInsets.only(top: 10),
                          child: FutureBuilder(
                            future: _future,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return GridView.builder(
                                    gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 100,
                                        childAspectRatio: 5 / 6.5,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 10),
                                    itemCount: branddatda.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      print(
                                          'aman branddatda${branddatda.length}');
                                      return Column(
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(30.0),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: colorblue),
                                                  borderRadius:
                                                  BorderRadius.circular(30),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          branddatda[index]
                                                              .brandLogo!,
                                                          scale: 3))),
                                              width: 50, height: 50,

                                              /// child: Image.network(categories[index].logo??'',scale:1.5,),
                                            ),
                                          ),
                                          sizedboxheight(5.0),
                                          Column(
                                            children: [
                                              Text(
                                                branddatda[index].brandName!,
                                                style: TextStyle(height: 1.3),
                                                maxLines: 2,
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                            // future: postlist(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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

    return Scaffold(
      appBar: appbarnotifav(context, 'Brands'),
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
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: serchbar(),
                    ),
                    sizedboxheight(30.0),
                    Card(
                      elevation: 2,
                      child: Container(
                        height: deviceheight(context, 0.7),
                        padding: EdgeInsets.only(top: 10),
                        child: FutureBuilder(
                          future: _future,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 100,
                                          childAspectRatio: 5 / 6.5,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 10),
                                  itemCount: branddatda.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    print(
                                        'aman branddatda${branddatda.length}');
                                    return Column(
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: colorblue),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        branddatda[index]
                                                            .brandLogo!,
                                                        scale: 3))),
                                            width: 50, height: 50,

                                            /// child: Image.network(categories[index].logo??'',scale:1.5,),
                                          ),
                                        ),
                                        sizedboxheight(5.0),
                                        Column(
                                          children: [
                                            Text(
                                              branddatda[index].brandName!,
                                              style: TextStyle(height: 1.3),
                                              maxLines: 2,
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                          // future: postlist(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget serchbar() {
    return AllInputDesign(
      higthtextfield: 40.0,
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Search',
      // controller: model.loginEmail,
      // autofillHints: [AutofillHints.email],
      textInputAction: TextInputAction.done,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.search,
          size: 25,
          color: colorgrey,
        ),
      ),
      keyBoardType: TextInputType.text,
      validatorFieldValue: 'Search',
    );
  }
}
