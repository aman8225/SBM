import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/formtextfield/mytextfield.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:http/http.dart' as http;
import 'package:sbm/model/prodectdetelsmodel/addfeedbackmodel/addfeedbackmodel.dart';

class AddFeedbackCardPage extends StatefulWidget {
  final int? ID;
  const AddFeedbackCardPage({Key? key, this.ID}) : super(key: key);

  @override
  State<AddFeedbackCardPage> createState() => _AddFeedbackCardPageState();
}

class _AddFeedbackCardPageState extends State<AddFeedbackCardPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController txt_titel = TextEditingController();
  TextEditingController txt_comment = TextEditingController();
  ProgressDialog? progressDialog;
  var success, message;
  var tokanget;

  Future<AddFeedbackModelMassege> addfeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
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
    var response = await http.post(Uri.parse(beasurl + 'productreview/create'),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
        });

    print(response.body);
    success =
        (AddFeedbackModelMassege.fromJson(json.decode(response.body)).success);
    message =
        (AddFeedbackModelMassege.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success}");
    if (success == true) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);

      txt_titel.clear();
      txt_comment.clear();
    } else {
      progressDialog?.dismiss();
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
    return AddFeedbackModelMassege.fromJson(json.decode(response.body));
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
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Submit Feedback...")),
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedboxheight(8.0),
                Text(
                  'Add a Headline:',
                  style: textstylesubtitle1(context)!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                sizedboxheight(5.0),
                AllInputDesign(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: 'ex: Very good or bad experience!',
                  controller: txt_titel,
                  textInputAction: TextInputAction.next,
                  keyBoardType: TextInputType.text,
                  validatorFieldValue: 'experience',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Headline is Required.';
                    }
                  },
                ),
                sizedboxheight(8.0),
                Text(
                  'Write your review:',
                  style: textstylesubtitle1(context)!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                sizedboxheight(5.0),
                AllInputDesign(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: 'Write you experience in brief ...',
                  maxLines: 5,
                  controller: txt_comment,
                  textInputAction: TextInputAction.done,
                  keyBoardType: TextInputType.text,
                  validatorFieldValue: 'headline',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Review is Required.';
                    }
                  },
                ),
                sizedboxheight(8.0),
                submitBut(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget submitBut(context) {
    return Button(
      buttonName: 'SUBMIT NOW',
      key: Key('submit_but'),
      borderRadius: BorderRadius.circular(5),
      btnWidth: deviceWidth(context, 0.5),
      onPressed: () {
        //  Get.to(() => BottomNavBarPage());

        if (_formKey.currentState!.validate()) {
          print(txt_titel);
          print(txt_comment);
          print(widget.ID);
          addfeedback();
          //  model.changepasswordsubmit(context, userid);
          // Get.to(() => BottomNavBarPage());
        } else {
          // model.toggleautovalidate();
        }
      },
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();

    map["title"] = txt_titel.text.toString();
    map["comment"] = txt_comment.text.toString();
    map["proid"] = widget.ID.toString();

    return map;
  }
}
