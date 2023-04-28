import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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
import 'package:sbm/model/contact_us_model/contact_us_model.dart';
import 'package:sbm/model/contact_us_model/contact_us_user_modal/contact_us_user_modal.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {


  final _formKey = GlobalKey<FormState>();
  Future? _future;
  ProgressDialog? progressDialog;

  TextEditingController txt_addemail = TextEditingController();
  TextEditingController txt_addname = TextEditingController();
  TextEditingController txt_addcontact = TextEditingController();
  TextEditingController txt_addmessage = TextEditingController();

  var success,message,id,email;
  var tokanget;

  Future<ContactUsModelMassege> submitcontactus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');

    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        showLoaderDialog(context);
      }else{
        Fluttertoast.showToast(
            msg: "Please check your Internet connection!!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: colorblue,
            textColor: Colors.white,
            fontSize: 16.0);
      }

    });
    var response = await http.post(Uri.parse(beasurl+'conatctus'), body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
        });
    success = (ContactUsModelMassege.fromJson(json.decode(response.body)).success);
    message = (ContactUsModelMassege.fromJson(json.decode(response.body)).message);

    if(success==true){

        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: colorblue,
            textColor: Colors.white,
            fontSize: 16.0);

        txt_addemail.clear();
        txt_addname.clear();
        txt_addcontact.clear();
        txt_addemail.clear();
    }else{
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
    return ContactUsModelMassege.fromJson(json.decode(response.body));
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
  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content:  Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Signing In..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  ContactUsUserModalResponse? contactusdata;
  Future<ContactUsUserModalMassege> contactus_userditails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(Text("Loading ...."));
        //  progressDialog?.show();
      }else{
        Fluttertoast.showToast(
            msg: "Please check your Internet connection!!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: colorblue,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
    var response = await http.get(Uri.parse(beasurl+'settings'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
     print(response.body);
      success = (ContactUsUserModalMassege.fromJson(json.decode(response.body)).success);
      message = (ContactUsUserModalMassege.fromJson(json.decode(response.body)).message);

    if(success==true){
      if(success==true){
         progressDialog?.dismiss();
         contactusdata = (ContactUsUserModalMassege.fromJson(json.decode(response.body)).data);
      }
    }else{
       progressDialog?.dismiss();
      print('else==============');
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return ContactUsUserModalMassege.fromJson(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();
    _future = contactus_userditails();
  }
  void urlluncher (url) async {

    if(await canLaunch(url)){
      await launch(url);
    }else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {

      return Scaffold(


        appBar: appbarnotifav(context, 'Contact Us'),
        body: Stack(
          children: [
            Container(
              width: deviceWidth(context,0.2),
              height: deviceheight(context, 1.0),
              color: colorskyeblue,
            ),
            Form(
              key: _formKey,
              child: Container(
                width: deviceWidth(context,1.0),
                height: deviceheight(context,1.0),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        sizedboxheight(30.0),
                        FutureBuilder(
                          future: _future,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return
                                Stack(
                                  children: [
                                    Card(

                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            sizedboxheight(40.0),
                                            Text('${contactusdata!.websiteName}',style: textstyleHeading2(context)!.copyWith(fontWeight: FontWeight.bold),),
                                            sizedboxheight(10.0),
                                            Html(
                                              data: """
                                                 ${contactusdata!.companyAddress}
                                                  """,
                                            ),
                                            sizedboxheight(10.0),
                                            Text('M : ${contactusdata!.phoneNumber}',
                                              style: textstyleHeading3(context)!.copyWith(height: 1.5),textAlign: TextAlign.center,),
                                            Text('E : ${contactusdata!.email} / ${contactusdata!.registrationEmail}',
                                              style: textstyleHeading3(context)!.copyWith(height: 1.5),textAlign: TextAlign.center,),
                                            sizedboxheight(20.0),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    urlluncher (contactusdata!.facebookLink);
                                                  },
                                                  child: CircleAvatar(
                                                    child: SvgPicture.asset(
                                                      'assets/facebook-f.svg',
                                                      height: 22,width: 22,
                                                      color: colorWhite,
                                                    ),
                                                    radius: 25,
                                                    backgroundColor:colorblue ,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    urlluncher (contactusdata!.twitterLink);
                                                  },
                                                  child: CircleAvatar(
                                                    child: SvgPicture.asset(
                                                      'assets/twitter.svg',
                                                      height: 22,width: 22,
                                                      color: colorWhite,
                                                    ),
                                                    radius: 25,
                                                    backgroundColor:colorblue ,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    urlluncher (contactusdata!.linkedinLink);
                                                  },
                                                  child: CircleAvatar(
                                                    child: SvgPicture.asset(
                                                      'assets/linkedin-in.svg',
                                                      height: 22,width: 22,
                                                      color: colorWhite,
                                                    ),
                                                    radius: 25,
                                                    backgroundColor:colorblue ,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    urlluncher (contactusdata!.youtubeLink);
                                                  },
                                                  child: CircleAvatar(
                                                    child: SvgPicture.asset(
                                                      'assets/icons8-youtube-logo-50.svg',
                                                      height: 28,width: 28,
                                                      color: colorWhite,
                                                    ),
                                                    radius: 25,
                                                    backgroundColor:colorblue ,
                                                  ),
                                                ),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 1,
                                      left: deviceWidth(context,0.30),
                                      child:  Image.network(
                                        '${contactusdata!.logo}',
                                        scale: 4.5,
                                      ),),
                                  ],
                                );
                            }else
                            {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }},
                          // future: postlist(),
                        ),

                        sizedboxheight(10.0),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                sizedboxheight(40.0),

                                addname(),
                                addemail(),
                                addcompanyname(),
                                addcontact(),
                                addmessage(),
                              ],
                            ),
                          ),
                        ),
                        sizedboxheight(30.0),
                        loginBtn(context),
                        sizedboxheight(30.0),
                      ],
                    ),
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
      appBar: appbarnotifav(context, 'Contact Us'),
      body: Stack(
        children: [
          Container(
            width: deviceWidth(context,0.2),
            height: deviceheight(context, 1.0),
            color: colorskyeblue,
          ),
          Form(
            key: _formKey,
            child: Container(
              width: deviceWidth(context,1.0),
              height: deviceheight(context,1.0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      sizedboxheight(30.0),
                      FutureBuilder(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return
                              Stack(
                                children: [
                                  Card(

                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          sizedboxheight(40.0),
                                          Text('${contactusdata!.websiteName}',style: textstyleHeading2(context)!.copyWith(fontWeight: FontWeight.bold),),
                                          sizedboxheight(10.0),
                                          Html(
                                            data: """
                                                 ${contactusdata!.companyAddress}
                                                  """,
                                          ),
                                          sizedboxheight(10.0),
                                          Text('M : ${contactusdata!.phoneNumber}',
                                            style: textstyleHeading3(context)!.copyWith(height: 1.5),textAlign: TextAlign.center,),
                                          Text('E : ${contactusdata!.email} / ${contactusdata!.registrationEmail}',
                                            style: textstyleHeading3(context)!.copyWith(height: 1.5),textAlign: TextAlign.center,),
                                          sizedboxheight(20.0),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: (){
                                                  urlluncher (contactusdata!.facebookLink);
                                                },
                                                child: CircleAvatar(
                                                  child: SvgPicture.asset(
                                                    'assets/facebook-f.svg',
                                                    height: 22,width: 22,
                                                    color: colorWhite,
                                                  ),
                                                  radius: 25,
                                                  backgroundColor:colorblue ,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: (){
                                                  urlluncher (contactusdata!.twitterLink);
                                                },
                                                child: CircleAvatar(
                                                  child: SvgPicture.asset(
                                                    'assets/twitter.svg',
                                                    height: 22,width: 22,
                                                    color: colorWhite,
                                                  ),
                                                  radius: 25,
                                                  backgroundColor:colorblue ,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: (){
                                                  urlluncher (contactusdata!.linkedinLink);
                                                },
                                                child: CircleAvatar(
                                                  child: SvgPicture.asset(
                                                    'assets/linkedin-in.svg',
                                                    height: 22,width: 22,
                                                    color: colorWhite,
                                                  ),
                                                  radius: 25,
                                                  backgroundColor:colorblue ,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: (){
                                                  urlluncher (contactusdata!.youtubeLink);
                                                },
                                                child: CircleAvatar(
                                                  child: SvgPicture.asset(
                                                    'assets/icons8-youtube-logo-50.svg',
                                                    height: 28,width: 28,
                                                    color: colorWhite,
                                                  ),
                                                  radius: 25,
                                                  backgroundColor:colorblue ,
                                                ),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 1,
                                    left: deviceWidth(context,0.30),
                                    child:  Image.network(
                                     '${contactusdata!.logo}',
                                      scale: 4.5,
                                    ),),
                                ],
                              );
                          }else
                          {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }},
                        // future: postlist(),
                      ),

                      sizedboxheight(10.0),
                      Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              sizedboxheight(40.0),

                              addname(),
                              addemail(),
                              addcompanyname(),
                              addcontact(),
                              addmessage(),
                            ],
                          ),
                        ),
                      ),
                      sizedboxheight(30.0),
                      loginBtn(context),
                      sizedboxheight(30.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addname() {
    return AllInputDesign(
       inputHeaderName: 'Name',
      key: Key("name"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',

       controller: txt_addname,
      autofillHints: [AutofillHints.name],
      textInputAction: TextInputAction.next,
      keyBoardType: TextInputType.name,
      validatorFieldValue: 'name',
      validator: validateName,
    );
  }

  Widget addemail() {
    return AllInputDesign(
       inputHeaderName: 'Email',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',

       controller: txt_addemail,
      autofillHints: [AutofillHints.email],
      textInputAction: TextInputAction.next,

      keyBoardType: TextInputType.emailAddress,
      validatorFieldValue: 'email',
      validator: validateEmailField,
    );
  }

  Widget addcompanyname() {
    return AllInputDesign(
       inputHeaderName: 'Company Name',
      key: Key("companyname"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',

      // controller: model.loginEmail,
      autofillHints: [AutofillHints.name],
      textInputAction: TextInputAction.next,

      keyBoardType: TextInputType.name,
      validatorFieldValue: 'companyname',
     // validator: validateName,
    );
  }

  Widget addcontact() {
    return AllInputDesign(
       inputHeaderName: 'Contact',
      key: Key("contact"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',

       controller: txt_addcontact,
      autofillHints: [AutofillHints.name],
      textInputAction: TextInputAction.next,

      keyBoardType: TextInputType.number,
      validatorFieldValue: 'contact',
      validator: validateMobile,
    );
  }

  Widget addmessage() {
    return AllInputDesign(
       inputHeaderName: 'Message',
      key: Key("message"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
      maxLines: 5,

       controller: txt_addmessage,
      autofillHints: [AutofillHints.name],
      textInputAction: TextInputAction.next,

      keyBoardType: TextInputType.multiline,
      validatorFieldValue: 'message',
      validator: (value) {
        if (value.isEmpty) {
          return 'Message is Required.';
        }

      },
    );
  }

  Widget loginBtn(context) {
    return Button(
      buttonName: 'SEND',

      key: Key('send'),
      borderRadius: BorderRadius.circular(5),

      onPressed: () {
        if (_formKey.currentState!.validate()) {
          print('aman1111');
          submitcontactus();;
        } else {
          // model.toggleautovalidate();
        }

       // Get.to(() => BottomNavBarPage());

      },
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();

    map["name"] = txt_addname.text.toString();
    map["email"] = txt_addemail.text.toString();
    map["contact"] = txt_addcontact.text.toString();
    map["message"] = txt_addmessage.text.toString();

    return map;
  }
}
