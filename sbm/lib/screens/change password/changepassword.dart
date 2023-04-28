import 'dart:async';
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
import 'package:sbm/common/formtextfield/mytextfield.dart';
import 'package:sbm/common/formtextfield/validations_field.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:http/http.dart' as http;
import 'package:sbm/model/change_passeword_model/change_passeword_model.dart';
import 'package:sbm/screens/auth/loginscreen.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  ProgressDialog? progressDialog;

  TextEditingController txt_currentpass = TextEditingController();
  TextEditingController txt_newpass = TextEditingController();
  TextEditingController txt_confirmpass = TextEditingController();

  var success, message, id, email;

  var tokanget;
  // List<ChangePassewordModelResponse>? changepadddata = [];
  Future<ChangePassewordModelMassege> changepassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    print("CLICKED 123 ==" + tokanget!);
    check().then((intenet) {
      if (intenet != null && intenet) {
        showLoaderDialog(context);
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
    print("????????????????????????${toMap()}");
    var response = await http
        .post(Uri.parse('${beasurl}changepassword'), body: toMap(), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    success = (ChangePassewordModelMassege.fromJson(json.decode(response.body))
        .success);
    message = (ChangePassewordModelMassege.fromJson(json.decode(response.body))
        .message
        .toString());
    if (success == true) {
      //Navigator.pop(context);
      // Fluttertoast.showToast(
      //     msg: message,
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     backgroundColor: colorblue,
      //     textColor: Colors.white,
      //     fontSize: 16.0);

      Get.off(() => LoginScreen());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", false);
      prefs.remove("login_user_token");
      prefs.remove("login_user_name");
      prefs.remove("login_user_email");
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
    return ChangePassewordModelMassege.fromJson(json.decode(response.body));
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

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content:  Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Change Password...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {
      return Scaffold(
        appBar: appbarnotifav(context, 'Change Password'),
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
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Card(
                          elevation: 3,
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Password*',
                                  style: textstylesubtitle1(context),
                                ),
                                currentpassword(),
                                sizedboxheight(15.0),
                                Text(
                                  'New Password*',
                                  style: textstylesubtitle1(context),
                                ),
                                newpassword(),
                                sizedboxheight(15.0),
                                Text(
                                  'Confirm Password*',
                                  style: textstylesubtitle1(context),
                                ),
                                confirmpassword(),
                                sizedboxheight(20.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    savebutton(
                                      context,
                                    ),
                                  ],
                                ),
                                sizedboxheight(20.0),
                              ],
                            ),
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
      appBar: appbarnotifav(context, 'Change Password'),
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
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Card(
                        elevation: 3,
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Password*',
                                style: textstylesubtitle1(context),
                              ),
                              currentpassword(),
                              sizedboxheight(15.0),
                              Text(
                                'New Password*',
                                style: textstylesubtitle1(context),
                              ),
                              newpassword(),
                              sizedboxheight(15.0),
                              Text(
                                'Confirm Password*',
                                style: textstylesubtitle1(context),
                              ),
                              confirmpassword(),
                              sizedboxheight(20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  savebutton(
                                    context,
                                  ),
                                ],
                              ),
                              sizedboxheight(20.0),
                            ],
                          ),
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
  bool view2 = true ;
  Widget currentpassword() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      key: Key("current password"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Enter your current password',
      controller: txt_currentpass,
      autofillHints: [AutofillHints.password],
      textInputAction: TextInputAction.next,
      obsecureText: view2,
      suffixIcon: TextButton(
          key: Key('password_visibility'),
          onPressed: () {
            setState((){
              view2 = !view2;
            });
          },
          child: view2
              ? SvgPicture.asset(
            'assets/slicing 2/pass-hide.svg',

            color: colorgrey,
          )
              : SvgPicture.asset(
            'assets/slicing 2/pass-show.svg',

            color: colorgrey,
          )),
      keyBoardType: TextInputType.visiblePassword,
      validatorFieldValue: 'curent Password',
      validator: validatePassword,
    );
  }
bool view = true ;
  Widget newpassword() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      key: Key("new password"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Enter new password',
      controller: txt_newpass,
      autofillHints: [AutofillHints.password],
      textInputAction: TextInputAction.next,
      obsecureText: view,
      suffixIcon: TextButton(
          key: Key('password_visibility'),
          onPressed: () {
            setState((){
              view = !view;
            });
          },
          child: view
              ? SvgPicture.asset(
            'assets/slicing 2/pass-hide.svg',

            color: colorgrey,
          )
              : SvgPicture.asset(
            'assets/slicing 2/pass-show.svg',

            color: colorgrey,
          )),
      keyBoardType: TextInputType.visiblePassword,
      validatorFieldValue: 'new Password',
      validator: validatePassword,
    );
  }
  bool view1 = true ;
  Widget confirmpassword() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      key: Key("Confirm password"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Confirm password',
      controller: txt_confirmpass,
      autofillHints: [AutofillHints.password],
      textInputAction: TextInputAction.next,
      obsecureText: view1,
      suffixIcon:  TextButton(
          key: Key('password_visibility'),
          onPressed: () {
            setState((){
              view1 = !view1;
            });
          },
          child: view1
              ? SvgPicture.asset(
            'assets/slicing 2/pass-hide.svg',

            color: colorgrey,
          )
              : SvgPicture.asset(
            'assets/slicing 2/pass-show.svg',

            color: colorgrey,
          )),
      keyBoardType: TextInputType.visiblePassword,
      validatorFieldValue: 'Confirm Password',
      validator: validatePassword,
    );
  }

  Widget savebutton(
    context,
  ) {
    return Button(
      buttonName: 'Save Change',
      key: Key('sign up'),
      borderRadius: BorderRadius.circular(5),
      btnWidth: deviceWidth(context, 0.45),
      onPressed: () {
        print('aman');
        if (_formKey.currentState!.validate()) {
          changepassword();
        } else {
          // model.toggleautovalidate();
        }
      },
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["current_password"] = txt_currentpass.text.toString();
    map["new_password"] = txt_newpass.text.toString();
    map["confirm_new_password"] = txt_confirmpass.text.toString();
    return map;
  }
}
