import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/forgotpassmode/verify_otp_modal.dart';
import 'package:sbm/screens/auth/reset_password.dart';
import 'package:http/http.dart' as http;

class Forgetpass extends StatefulWidget {
  final String? code;
  final String? mobile;
  const Forgetpass({Key? key, this.code, this.mobile}) : super(key: key);

  @override
  _ForgetpassState createState() => _ForgetpassState();
}

class _ForgetpassState extends State<Forgetpass> {
  OtpFieldController otpController = OtpFieldController();
  final _formKey = GlobalKey<FormState>();
  var OTP;
  var success, message;

  Future<VerifyOtpModalMassege> otpverify() async {
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
      Uri.parse(beasurl + 'verify-otp'),
      body: toMap(),
    );
    var Data = json.decode(response.body);
    print(Data);
    var a = Data['data'];
    print(a);
    if (Data['data'] == false) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Invalid OTP. Please try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    success =
        (VerifyOtpModalMassege.fromJson(json.decode(response.body)).success);
    message =
        (VerifyOtpModalMassege.fromJson(json.decode(response.body)).message);
    print("success 123 ==${response.body}");
    if (success == true) {
      if (success == true) {
        Navigator.pop(context);
        Get.off(() => ResetPassword(
            mobile: widget.mobile, code: widget.code, otp: OTP.toString()));
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
    return VerifyOtpModalMassege.fromJson(json.decode(response.body));
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
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7), child: const Text("Verify OTP...")),
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
      appBar: appbartitlebackbtn(context, 'Forgot Password'),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 5,
                      child: Form(
                        key: _formKey,
                        child: Container(
                            width: deviceWidth(context, 1.0),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Verification',
                                  style: textstylesubtitle1(context)!
                                      .copyWith(color: colorblue),
                                ),
                                sizedboxheight(10.0),
                                Text(
                                    'Enter the 6-digit OTP code sent to your\n'
                                    'registered email address',
                                    style: textstylesubtitle1(context)!
                                        .copyWith(height: 1.3)),
                                sizedboxheight(20.0),
                                Text(
                                  'If you have not received the OTP, then click',
                                  style: textstylesubtitle1(context),
                                ),
                                sizedboxheight(20.0),

                                otpfield(),
                                sizedboxheight(20.0),
                                sizedboxheight(30.0),
                                verifypBtn(
                                  context,
                                ),
                                sizedboxheight(20.0),
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget verifypBtn(
    context,
  ) {
    return Button(
      buttonName: 'VERIFY',
      key: Key('VERIFY'),
      borderRadius: BorderRadius.circular(5),
      onPressed: () {
        print(OTP.toString());
        otpverify();
        // if(_formKey.currentState!.validate()){
        //   otpverify();
        // }
      },
    );
  }

  Widget otpfield() {
    return OTPTextField(
        controller: otpController,
        length: 6,
        width: MediaQuery.of(context).size.width,
        textFieldAlignment: MainAxisAlignment.spaceAround,
        fieldWidth: 50,
        fieldStyle: FieldStyle.box,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 16),
        outlineBorderRadius: 10.0,
        otpFieldStyle: OtpFieldStyle(
            borderColor: colorblack,
            focusBorderColor: colorblue,
            disabledBorderColor: colorblack),
        onChanged: (pin) {
          print("Changed: " + pin);
          OTP = pin;
        },
        onCompleted: (pin) {
          print("Completed: " + pin);
        });
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["mobile"] = widget.mobile.toString();
    map["code"] = widget.code.toString();
    map["otp"] = OTP.toString();
    return map;
  }
}
