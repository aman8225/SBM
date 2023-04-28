import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar.dart';

import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/formtextfield/mytextfield.dart';
import 'package:sbm/common/formtextfield/validations_field.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/loginmodel/loginmodel.dart';
import 'package:sbm/screens/auth/send_otp.dart';
import 'package:sbm/screens/auth/signupscreen.dart';

import 'forgetpassword.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  ProgressDialog? progressDialog;

  TextEditingController txt_email = TextEditingController();
  TextEditingController txt_password = TextEditingController();

  var success, message, id, email;

  Future<Loginmassege> signin() async {
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
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
    print(toMap());
    var response = await http.post(
      Uri.parse(beasurl + 'login'),
      body: toMap(),
    );

    success = (Loginmassege.fromJson(json.decode(response.body)).success);
    message = (Loginmassege.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success}");
    if (success == true) {
      if (success == true) {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: colorblue,
            textColor: Colors.white,
            fontSize: 16.0);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        prefs.setString(
          'login_user_id',
          json.encode(
            Loginmassege.fromJson(json.decode(response.body)).data!.id ?? '',
          ),
        );
        prefs.setString(
          'login_user_name',
          json.encode(
            Loginmassege.fromJson(json.decode(response.body)).data!.name ?? '',
          ),
        );
        prefs.setString(
          'login_user_email',
          json.encode(
            Loginmassege.fromJson(json.decode(response.body)).data!.email ?? '',
          ),
        );
        prefs.setString(
          'login_user_token',
          json.encode(
            Loginmassege.fromJson(json.decode(response.body)).data!.token ?? '',
          ),
        );
        prefs.setString(
          'login_user_profilepic',
          json.encode(
            Loginmassege.fromJson(json.decode(response.body)).data!.profilepic ?? '',
          ),
        );
        prefs.setString(
          'login_user_vendorCode',
          json.encode(
            Loginmassege.fromJson(json.decode(response.body)).data!.vendorCode ?? '',
          ),
        );

        Get.off(() => BottomNavBarPage());
        txt_email.clear();
        txt_password.clear();
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: colorblue,
            textColor: Colors.white,
            fontSize: 16.0);
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
    return Loginmassege.fromJson(json.decode(response.body));
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
              margin: EdgeInsets.only(left: 7), child: Text("Signing In...")),
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
  bool chack = true;
  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [

          Container(
            width: deviceWidth(context, 0.2),
            height: deviceheight(context, 1.0),
            color: colorskyeblue,
          ),
          Form(
            key: _formKey,
            child: Container(
              width: deviceWidth(context, 1.0),
              height: deviceheight(context, 1.0),
              margin: EdgeInsets.only(top: 50, left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Welcome to ', style: textstyleHeading2(context)),
                        //  Text('sbm',style: textstyleHeading2(context)!.copyWith(fontWeight: FontWeight.bold,color: colorblue)),
                        Image.asset(
                          'assets/sbm_icon.png',
                          scale: 20,
                        ),
                      ],
                    ),

                    sizedboxheight(10.0),
                    Text(
                      'Login',
                      style: textstyleHeading1(context),
                    ),

                    sizedboxheight(30.0),
                    Card(
                      elevation: 5,
                      child: Container(
                        color: colorWhite,
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username*',
                              style: textstylesubtitle1(context),
                            ),
                            sizedboxheight(8.0),
                            loginemail(),
                            sizedboxheight(10.0),
                            Text(
                              'Password*',
                              style: textstylesubtitle1(context),
                            ),
                            sizedboxheight(8.0),
                            loginPassword(context),
                            sizedboxheight(10.0),
                            forgetpassword(context),
                          ],
                        ),
                      ),
                    ),
                    sizedboxheight(30.0),
                    loginBtn(context),
                    sizedboxheight(30.0),
                    // Align(
                    //   alignment: Alignment.center,
                    //     child: Container(width: deviceWidth(context,1.0),
                    //       child: Row(
                    //
                    //         children: [
                    //           Expanded(child: Container(height: 1,color: colorblack,)),
                    //           Text('  Sign in via social  ',style: textstyleHeading6(context),),
                    //           Expanded(child: Container(height: 1,color: colorblack,)),
                    //         ],
                    //       ),
                    //     )),
                    // sizedboxheight(30.0),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     fbboxbtn1(),
                    //     sizedboxwidth(20.0),
                    //     //  Consumer<GoogleSignUpModelPage>(builder: (context,googlesignupmodel,_){
                    //     //    return  googleboxbtn2(context,googlesignupmodel);
                    //     //  }),
                    //     googleboxbtn2(context),
                    //     // sizedboxwidth(15.0),
                    //     // boxbtn3(),
                    //   ],
                    // ),
                    sizedboxheight(50.0),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Don’t have an account?',
                          style: textstyleHeading6(context),
                        )),
                    sizedboxheight(10.0),
                    Align(
                      alignment: Alignment.center,
                      child: signUpBtn(context),
                    ),
                    sizedboxheight(20.0),
                  ],
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: colorblue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      //bottomRight: Radius.circular(50),
                    ),
                  ))),
          sizedboxheight(20.0),
        ],
      ),
    );
  }

  Widget loginemail() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Jone Doe',
      controller: txt_email,
      autofillHints: [AutofillHints.email],
      textInputAction: TextInputAction.next,

      suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20, top: 15, bottom: 15),
          child: SvgPicture.asset(
            'assets/icons/user_input.svg',
            height: 0,
            width: 0,
          )

          // child: Icon(Icons.person_outline_rounded,size: 25,color: colorgrey,),
          ),
      keyBoardType: TextInputType.emailAddress,
      validatorFieldValue: 'email',
      validator: (value) {
        if (value.isEmpty) {
          return 'Email is Required.';
        }
      },
    );
  }

  Widget loginPassword(context) {
    return AllInputDesign(
      // key: Key("password11"),
      hintText: 'Password',
      floatingLabelBehavior: FloatingLabelBehavior.never,
      textInputAction: TextInputAction.done,
      autofillHints: [AutofillHints.password],
      controller: txt_password,
      //obscureText: true,
      obsecureText: chack,

      suffixIcon: TextButton(
          key: Key('password_visibility'),
          onPressed: () {
            setState((){
              chack = !chack;
            });
          },
          child: chack
              ? SvgPicture.asset(
                'assets/slicing 2/pass-hide.svg',

                color: colorgrey,
              )
              : SvgPicture.asset(
                'assets/slicing 2/pass-show.svg',

                color: colorgrey,
              )),
      validatorFieldValue: 'password',
      validator: validatePassword,
      keyBoardType: TextInputType.emailAddress,
    );
  }

  Widget forgetpassword(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          // Get.to(() => Forgetpass());
          Get.to(() => SendOTP());
        },
        child: Text(
          'Forgot Password ?',
          style: textstylesubtitle1(context)!.copyWith(color: colorblue),
        ),
      ),
    );
  }

  Widget loginBtn(context) {
    return Button(
      buttonName: 'SIGN IN',
      key: Key('login_submi'),
      borderRadius: BorderRadius.circular(5),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          print('aman1111');
          signin();
        } else {
          // model.toggleautovalidate();
        }

        // if (formKey1.currentState.validate()) {
        //   //  model.changepasswordsubmit(context, userid);
        //   // Get.to(() => BottomNavBarPage());
        // } else {
        //   // model.toggleautovalidate();
        // }
      },
    );
  }

  Widget fbboxbtn1() {
    return const CircleAvatar(
      radius: 22,
      backgroundImage: AssetImage('assets/icons/Facebook@3x.png'),
    );
  }

  Widget googleboxbtn2(context) {
    return const CircleAvatar(
      radius: 22,
      backgroundImage: AssetImage('assets/icons/Icon@3x.png'),
    );
  }

  Widget signUpBtn(context) {
    return Button(
      buttonName: 'SIGN UP',
      btnstyle: textstylesubtitle2(context)!.copyWith(color: colorWhite),
      borderRadius: BorderRadius.circular(5),
      btnWidth: deviceWidth(context, 0.3),
      btnColor: colorblack,
      onPressed: () {
        Get.to(() => SignUpScreen());
      },
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();

    map["email"] = txt_email.text.toString();
    map["password"] = txt_password.text.toString();

    return map;
  }
}
