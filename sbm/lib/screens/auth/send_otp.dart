import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/formtextfield/mytextfield.dart';
import 'package:sbm/common/formtextfield/validations_field.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/forgotpassmode/bander_code_modal.dart';
import 'package:sbm/model/forgotpassmode/send_otp_model.dart';
import 'package:http/http.dart' as http;

import 'forgetpassword.dart';

class SendOTP extends StatefulWidget {
  const SendOTP({Key? key}) : super(key: key);

  @override
  _SendOTPState createState() => _SendOTPState();
}

class _SendOTPState extends State<SendOTP> {
  TextEditingController controller_mobile = TextEditingController();
  TextEditingController controller_mobile_contrycod = TextEditingController();
  TextEditingController code_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String initialCountry = 'AE';
  PhoneNumber number = PhoneNumber(isoCode: 'AE');

  List gender = ["Mobile", "Email"];

  String? select = 'Mobile';

  var success1, message1, mobole, code;
  Data? data;
  Future<BanderCodeModalMassege> verifybandercod() async {
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
    print(toMap1());
    var response = await http.post(
      Uri.parse(beasurl + 'verify-vendor-code'),
      body: toMap1(),
    );
    var Data = json.decode(response.body);
    print(Data);
    var a = Data['data'];
    print(a);
    if (Data['data'] == false) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Vendor Code and Mobile Number dose't Match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    success1 =
        (BanderCodeModalMassege.fromJson(json.decode(response.body)).success);
    message1 =
        (BanderCodeModalMassege.fromJson(json.decode(response.body)).message);

    if (success1 == true) {
      data = (BanderCodeModalMassege.fromJson(json.decode(response.body)).data);
      Navigator.pop(context);
      print(controller_mobile.text);
      print(data!.phone);
      print("success 123 ==${data!.phone == controller_mobile.text}");
      print(data!.phone == controller_mobile.text);
      if (data!.phone == controller_mobile.text) {
        mobole = data!.mobile;
        code = data!.vendorCode;
        sendotp();
      } else {
        Fluttertoast.showToast(
            msg: "Vendor Code and Mobile Number dose't Match",
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
          msg: message1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return BanderCodeModalMassege.fromJson(json.decode(response.body));
  }

  var success, message;

  Future<SendOtpModel> sendotp() async {
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
      Uri.parse(beasurl + 'send-otp'),
      body: toMap(),
    );
    success = (SendOtpModel.fromJson(json.decode(response.body)).success);
    message = (SendOtpModel.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success}");
    if (success == true) {
      Navigator.pop(context);
      Get.off(() => Forgetpass(mobile: mobole, code: code));
      email_controller.clear();
      code_controller.clear();
      controller_mobile.clear();
      controller_mobile_contrycod.clear();
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
    return SendOtpModel.fromJson(json.decode(response.body));
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
              margin: EdgeInsets.only(left: 7), child: Text("Send OTP...")),
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
      appBar: appbarbackbtn(context, 'Forgot Password'),
      body: Container(
        height: deviceheight(context, 1.0),
        width: deviceWidth(context, 1.0),
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizedboxheight(20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      addRadioButton(0, 'Mobile'),
                      Text('OR'),
                      addRadioButton(1, 'Email'),
                    ],
                  ),
                  sizedboxheight(10.0),
                  Text(
                    'Enter Vendor Code*',
                    style: textstylesubtitle1(context),
                  ),
                  sizedboxheight(8.0),
                  entercodefeild(),
                  sizedboxheight(10.0),
                  if (select == "Email")
                    Text(
                      'Enter Email*',
                      style: textstylesubtitle1(context),
                    ),
                  if (select == "Email") sizedboxheight(8.0),
                  if (select == "Email") otpemail(),
                  sizedboxheight(10.0),
                  Text(
                    'Enter Mobile*',
                    style: textstylesubtitle1(context),
                  ),
                  sizedboxheight(8.0),
                  signupphone(),
                  sizedboxheight(50.0),
                  sendBtn(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget entercodefeild() {
    return AllInputDesign(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Enter code',
      controller: code_controller,
      autofillHints: [AutofillHints.name],
      textInputAction: TextInputAction.next,
      keyBoardType: TextInputType.name,
      validatorFieldValue: 'name',
      validator: (value) {
        if (value.isEmpty) {
          return 'vendor code is Required.';
        } else if (value.length < 2) {
          return 'vendor code required at least 2 Characters';
        }
      },
    );
  }

  Widget otpemail() {
    return AllInputDesign(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Enter Email',
      controller: email_controller,
      autofillHints: [AutofillHints.email],
      textInputAction: TextInputAction.next,
      keyBoardType: TextInputType.emailAddress,
      validatorFieldValue: 'email',
      validator: validateEmailField,
    );
  }

  Widget signupphone() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: colorgrey),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.only(left: 5),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          print(number.phoneNumber);
          controller_mobile_contrycod.text = number.phoneNumber!;
          print(controller_mobile_contrycod.text);
        },
        onInputValidated: (bool value) {
          print(value);
        },
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: TextStyle(color: Colors.black),
        initialValue: number,
        textFieldController: controller_mobile,
        formatInput: false,
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        inputBorder: InputBorder.none,
        onSaved: (PhoneNumber number) {
          print('On Saved: $number');
        },
      ),
    );
  }

  Widget sendBtn(context) {
    return Button(
      buttonName: 'SEND OTP',
      btnstyle: textstylesubtitle2(context)!.copyWith(color: colorWhite),
      borderRadius: BorderRadius.circular(5),
      onPressed: () {
        // Get.to(() => LoginScreen());
        if (_formKey.currentState!.validate()) {
          verifybandercod();
        } else {
          // model.toggleautovalidate();
        }
      },
    );
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: colorblue,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (dynamic value) {
            setState(() {
              select = value;
              print(select);
            });
          },
        ),
        Text(title)
      ],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["code"] = code_controller.text.toString();
    map["mobile"] = controller_mobile_contrycod.text.toString();
    return map;
  }

  Map toMap1() {
    var map = new Map<String, dynamic>();
    map["code"] = code_controller.text.toString();
    return map;
  }
}
