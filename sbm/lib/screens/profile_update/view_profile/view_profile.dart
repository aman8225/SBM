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
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/profilemodel/profile_details_model/profile_details_model.dart';
import 'package:http/http.dart' as http;

import '../profile_update.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future? _future;
  var tokanget;

  ProgressDialog? progressDialog;
  var success, message, data;
  ProfileDetailsModelResponse? profiledata;
  Future<ProfileDetailsModelMassege> userprofildata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
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
    var response = await http.get(Uri.parse('${beasurl}userProfile'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    print(response.body);
    progressDialog!.dismiss();
    success = (ProfileDetailsModelMassege.fromJson(json.decode(response.body))
        .success);
    message = (ProfileDetailsModelMassege.fromJson(json.decode(response.body))
        .message);
    profiledata =
        (ProfileDetailsModelMassege.fromJson(json.decode(response.body)).data);

    progressDialog!.dismiss();
    if (success == true) {
      progressDialog!.dismiss();
      profiledata =
          (ProfileDetailsModelMassege.fromJson(json.decode(response.body))
              .data);
      prefs.setString(
        'login_user_profilepic',
        json.encode(
          ProfileDetailsModelMassege.fromJson(json.decode(response.body)).data!.profilepic ?? '',
        ),
      );

    } else {
      print('else==============');
      progressDialog!.dismiss();
    }
    return ProfileDetailsModelMassege.fromJson(json.decode(response.body));
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
    _future = userprofildata();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {

      return Scaffold(
        appBar: appbarnotifav(context, 'Profile Details'),
        body: Stack(
          children: [
            Container(
              width: deviceWidth(context, 0.2),
              height: deviceheight(context, 1.0),
              color: colorskyeblue,
            ),
            FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: deviceWidth(context, 1.0),
                    height: deviceheight(context, 1.0),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: colorgrey)),
                                    width: deviceWidth(context, 0.35),
                                    height: deviceheight(context, 0.15),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        profiledata!.profilepic == null
                                            ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              profiledata!.profilepic!),
                                          radius: 30,
                                          backgroundColor: colorgrey,
                                        )
                                            : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              profiledata!.profilepic!),
                                          radius: 30,
                                          backgroundColor: colorgrey,
                                        ),
                                        const Text(
                                          'Your profile',
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: colorgrey)),
                                    width: deviceWidth(context, 0.35),
                                    height: deviceheight(context, 0.15),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        profiledata!.businessLogo == null
                                            ? SvgPicture.asset(
                                          'assets/slicing 2/logo.svg',
                                          height:
                                          deviceheight(context, 0.055),
                                        )
                                            : Image.network(
                                          profiledata!.businessLogo!,
                                          height:
                                          deviceheight(context, 0.1),
                                        ),
                                        const Text(
                                          'Your company logo',
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            sizedboxheight(12.0),
                            profiledata!.vendorCode == null?Container(): Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: colorgrey)),
                                width: deviceWidth(context, 1.0),
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Vendor Code '),
                                    sizedboxheight(12.0),
                                    Row(
                                      children: [

                                        sizedboxwidth(15.0),
                                        Text(profiledata!.vendorCode!),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            sizedboxheight(12.0),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: colorgrey)),
                                width: deviceWidth(context, 1.0),
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Your Name'),
                                    sizedboxheight(12.0),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/slicing 2/user_input.svg',
                                          width: 20,
                                          height: 20,
                                        ),
                                        sizedboxwidth(15.0),
                                        Text(profiledata!.name == null
                                            ? ''
                                            : profiledata!.name!),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            sizedboxheight(12.0),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: colorgrey)),
                                width: deviceWidth(context, 1.0),
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Email Address'),
                                    sizedboxheight(12.0),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/slicing 2/mail.svg',
                                          width: 16,
                                          height: 16,
                                        ),
                                        sizedboxwidth(15.0),
                                        Text(profiledata!.email == null
                                            ? ''
                                            : profiledata!.email!),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            sizedboxheight(12.0),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: colorgrey)),
                                width: deviceWidth(context, 1.0),
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Phone Number'),
                                    sizedboxheight(12.0),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/slicing 2/smartphone (4).svg',
                                          width: 20,
                                          height: 20,
                                        ),
                                        sizedboxwidth(15.0),
                                        Text(profiledata!.phone == null
                                            ? ''
                                            : profiledata!.phone!),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            sizedboxheight(12.0),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: colorgrey)),
                                width: deviceWidth(context, 1.0),
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Address'),
                                    sizedboxheight(12.0),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/slicing 2/address.svg',
                                          width: 20,
                                          height: 20,
                                          color: colorgrey,
                                        ),
                                        sizedboxwidth(15.0),
                                        Container(
                                            width: deviceWidth(context, 0.65),
                                            child: Text(profiledata!.address ==
                                                null
                                                ? ''
                                                : '${profiledata!.address!}\n${profiledata!.city!}\n${profiledata!.country!}')),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            sizedboxheight(12.0),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: colorgrey)),
                                width: deviceWidth(context, 1.0),
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text('User Name'),
                                    sizedboxheight(12.0),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [


                                        Container(
                                            width: deviceWidth(context, 0.65),
                                            child: Text((profiledata!.firstName == null ? '' : '${profiledata!.firstName!} ' )
                                               + (profiledata!.lastName == null ? '' :'${profiledata!.lastName!}'))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            sizedboxheight(15.0),
                            Text("Sales Person Details",style: textstyleHeading2(context),),
                            sizedboxheight(12.0),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: colorgrey)),
                                width: deviceWidth(context, 1.0),
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Sales Person Name'),
                                    sizedboxheight(12.0),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        // SvgPicture.asset(
                                        //   'assets/slicing 2/address.svg',
                                        //   width: 20,
                                        //   height: 20,
                                        //   color: colorgrey,
                                        // ),

                                        Container(
                                            width: deviceWidth(context, 0.65),
                                            child: Text(profiledata!.salesPersonFirstName ==
                                                null
                                                ? ''
                                                : '${profiledata!.salesPersonFirstName}')),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            sizedboxheight(12.0),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: colorgrey)),
                                width: deviceWidth(context, 1.0),
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Sales Email '),
                                    sizedboxheight(12.0),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        // SvgPicture.asset(
                                        //   'assets/slicing 2/address.svg',
                                        //   width: 20,
                                        //   height: 20,
                                        //   color: colorgrey,
                                        // ),

                                        Container(
                                            width: deviceWidth(context, 0.65),
                                            child: Text(profiledata!.salesPersonEmail ==
                                                null
                                                ? ''
                                                : '${profiledata!.salesPersonEmail}')),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            sizedboxheight(20.0),
                            loginBtn(context),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              // future: postlist(),
            )
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


  }

  Widget loginBtn(context) {
    return Button(
      buttonName: 'Edit Profile',
      key: Key('edit_profile'),
      borderRadius: BorderRadius.circular(5),
      onPressed: () {
        Get.to(() => ProfileUpdate(profiledata: profiledata));

        // if (formKey1.currentState.validate()) {
        //   //  model.changepasswordsubmit(context, userid);
        //   // Get.to(() => BottomNavBarPage());
        // } else {
        //   // model.toggleautovalidate();
        // }
      },
    );
  }
}
