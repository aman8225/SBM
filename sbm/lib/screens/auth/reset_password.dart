import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/formtextfield/mytextfield.dart';
import 'package:sbm/common/formtextfield/validations_field.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:http/http.dart' as http;
import 'package:sbm/model/forgotpassmode/email_verify_modal.dart';

import 'loginscreen.dart';

class ResetPassword extends StatefulWidget {
  final String? otp;
  final String? mobile;
  final String? code;
  const ResetPassword({Key? key, this.otp, this.mobile, this.code})
      : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email_controller = TextEditingController();
  var success, message;

  Future<EmailVerifyModalMassege> addemail() async {
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
    print(toMap());
    var response = await http
        .post(Uri.parse(beasurl + 'send-forget-password-email'), body: toMap());
    print("success 123 ==${response.body}");
    success =
        (EmailVerifyModalMassege.fromJson(json.decode(response.body)).success);
    message =
        (EmailVerifyModalMassege.fromJson(json.decode(response.body)).message);

    if (success == true) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
      Get.off(() => LoginScreen());
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
    return EmailVerifyModalMassege.fromJson(json.decode(response.body));
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
              margin: EdgeInsets.only(left: 7), child: Text("Verify OTP...")),
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
    return Scaffold(
      appBar: appbarbackbtn(context, 'Reset Password'),
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
                    sizedboxheight(40.0),
                    Form(
                      key: _formKey,
                      child: Card(
                        elevation: 2,
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter Email',
                                style: textstylesubtitle1(context),
                              ),
                              sizedboxheight(8.0),
                              emailfield(),
                              sizedboxheight(15.0),

                              // Text('Confirm Password',style: textstylesubtitle1(context),),
                              // confirmpassword(),
                              // sizedboxheight(20.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    sizedboxheight(40.0),
                    savebutton(
                      context,
                    ),
                    sizedboxheight(20.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget emailfield() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("current password"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Enter Email',
      controller: email_controller,
      autofillHints: [AutofillHints.email],
      textInputAction: TextInputAction.next,
      // obsecureText: true,
      // suffixIcon: TextButton(
      //     key: Key('password_visibility'),
      //     onPressed: () {
      //       // model.toggle();
      //     },
      //     // child: Icon(Icons.visibility, size: 20.0, color: true ? colorblack :colorgrey ),
      //     //  child:Icon( icon: Icon(Icons.visibility, size: 20.0, color: true ? colorblack :colorgrey )),
      //     child: true
      //         ? ImageIcon(
      //       AssetImage('assets/icons/lock (3)@3x.png'),color: colorblack,size: 20,
      //     )
      //         : ImageIcon(
      //       AssetImage('assets/icons/lock (3)@3x.png'),color: colorblack54,
      //     )),
      keyBoardType: TextInputType.emailAddress,
      validatorFieldValue: 'enter email',
      validator: validateEmailField,
    );
  }
  // Widget currentpassword() {
  //   return AllInputDesign(
  //     // inputHeaderName: 'User Name',
  //     key: Key("current password"),
  //     floatingLabelBehavior: FloatingLabelBehavior.never,
  //     hintText: 'Enter your current password',
  //      controller: email_controller,
  //     autofillHints: [AutofillHints.password],
  //     textInputAction: TextInputAction.next,
  //     obsecureText: true,
  //     suffixIcon: TextButton(
  //         key: Key('password_visibility'),
  //         onPressed: () {
  //           // model.toggle();
  //         },
  //         // child: Icon(Icons.visibility, size: 20.0, color: true ? colorblack :colorgrey ),
  //         //  child:Icon( icon: Icon(Icons.visibility, size: 20.0, color: true ? colorblack :colorgrey )),
  //         child: true
  //             ? ImageIcon(
  //           AssetImage('assets/icons/lock (3)@3x.png'),color: colorblack,size: 20,
  //         )
  //             : ImageIcon(
  //           AssetImage('assets/icons/lock (3)@3x.png'),color: colorblack54,
  //         )),
  //     keyBoardType: TextInputType.visiblePassword,
  //     validatorFieldValue: 'enter Password',
  //     validator: validatePassword,
  //   );
  // }

  // Widget confirmpassword() {
  //   return AllInputDesign(
  //     // inputHeaderName: 'User Name',
  //     key: Key("Confirm password"),
  //     floatingLabelBehavior: FloatingLabelBehavior.never,
  //     hintText: 'Confirm password',
  //     // controller: model.loginEmail,
  //     autofillHints: [AutofillHints.password],
  //     textInputAction: TextInputAction.next,
  //     obsecureText: true,
  //     suffixIcon:TextButton(
  //         key: Key('password_visibility'),
  //         onPressed: () {
  //           // model.toggle();
  //         },
  //         // child: Icon(Icons.visibility, size: 20.0, color: true ? colorblack :colorgrey ),
  //         //  child:Icon( icon: Icon(Icons.visibility, size: 20.0, color: true ? colorblack :colorgrey )),
  //         child: true
  //             ? ImageIcon(
  //           AssetImage('assets/icons/lock (3)@3x.png'),color: colorblack,size: 20,
  //         )
  //             : ImageIcon(
  //           AssetImage('assets/icons/lock (3)@3x.png'),color: colorblack54,
  //         )),
  //     keyBoardType: TextInputType.visiblePassword,
  //     validatorFieldValue: 'Confirm Password',
  //     validator: validatePassword,
  //   );
  // }

  Widget savebutton(
    context,
  ) {
    return Button(
      buttonName: 'RESET',
      key: Key('sign up'),
      borderRadius: BorderRadius.circular(5),
      btnWidth: deviceWidth(context, 1.0),
      onPressed: () {
        // Get.to(() => SelectCategry());
        if (_formKey.currentState!.validate()) {
          addemail();
        } else {
          // model.toggleautovalidate();
        }
      },
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["mobile"] = widget.mobile.toString();
    map["code"] = widget.code.toString();
    map["otp"] = widget.otp.toString();
    map["email"] = email_controller.text.toString();
    return map;
  }
}
