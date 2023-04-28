import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/formtextfield/mytextfield.dart';
import 'package:sbm/common/formtextfield/validations_field.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/signupmodel/signupmodel.dart';
import 'package:http/http.dart' as http;

import 'loginscreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  String initialCountry = 'AE';
  PhoneNumber number = PhoneNumber(isoCode: 'AE');

  String _selectedGender = 'Other Customer';

  TextEditingController txt_name = TextEditingController();
  TextEditingController txt_email = TextEditingController();
  TextEditingController controller_mobile = TextEditingController();
  TextEditingController txt_address = TextEditingController();
  TextEditingController txt_city = TextEditingController();
  TextEditingController txt_country = TextEditingController();
  TextEditingController txt_landmark = TextEditingController();
  TextEditingController txt_password = TextEditingController();

  var success,message,id,email;
  String? roleselect = '4';

  Future<SignUpDataMassege> signup() async {
    check().then((intenet) {
      if (intenet != null && intenet) {
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

    print('signup toMap${toMap().toString()}');
    var response = await http.post(Uri.parse(beasurl+'register'), body: toMap());

    success = (SignUpDataMassege.fromJson(json.decode(response.body)).success);
    message = (SignUpDataMassege.fromJson(json.decode(response.body)).message);

    if(success==true){

      if(success==true){
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: colorblue,
            textColor: Colors.white,
            fontSize: 16.0);
        // prefs.remove('user_name');
        // prefs.remove('email');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);

        prefs.setString(
                  'login_user_id',
                  json.encode(
                    SignUpDataMassege.fromJson(json.decode(response.body)).data!.id??"",
                  ),
                );
        prefs.setString(
          'login_user_name',
          json.encode(
            SignUpDataMassege.fromJson(json.decode(response.body)).data!.name??"",
          ),
        );
        prefs.setString(
          'login_user_email',
          json.encode(
            SignUpDataMassege.fromJson(json.decode(response.body)).data!.email??'',
          ),
        );
        prefs.setString(
          'login_user_token',
          json.encode(
            SignUpDataMassege.fromJson(json.decode(response.body)).data!.token??"",
          ),
        );
        prefs.setString(
          'login_user_profilepic',
          json.encode(
            SignUpDataMassege.fromJson(json.decode(response.body)).data!.profilepic ?? '',
          ),
        );
        Get.off(() => BottomNavBarPage());
        txt_email.clear();
        txt_address.clear();
        txt_city.clear();
        txt_country.clear();
        txt_landmark.clear();
        txt_password.clear();
        controller_mobile.clear();

      }
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
    return SignUpDataMassege.fromJson(json.decode(response.body));
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
          Container(margin: EdgeInsets.only(left: 7),child:Text("Signing Up..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorskyeblue,
        flexibleSpace: Padding(
          padding:  EdgeInsets.only(left: deviceWidth(context,0.2)),
          child: Container(
            color: colorWhite,

          ),
        ),

        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: colorblack54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
              height: deviceheight(context, 1.0),
              margin: EdgeInsets.only(top: 10,left: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Welcome to ',style: textstyleHeading2(context)),
                        //  Text('sbm',style: textstyleHeading2(context)!.copyWith(fontWeight: FontWeight.bold,color: colorblue)),
                        Image.asset('assets/sbm_icon.png',scale: 20,),
                      ],
                    ),

                    // Text.rich(
                    //   TextSpan(
                    //     children: [
                    //       TextSpan(text: 'Welcome, to ',style: textstyleHeading2(context),),
                    //
                    //       TextSpan(text: 'sbm market place',style: textstyleHeading1(context)!.copyWith(color: colorblue)),
                    //     ],
                    //   ),
                    // ),

                    sizedboxheight(10.0),
                    Text('Sign Up / Registration',style: textstyleHeading1(context),),

                    sizedboxheight(30.0),


                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Card(
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    width: deviceWidth(context,0.38),
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          activeColor: colorblue,
                                          value: 'Trading Customer',
                                          groupValue: _selectedGender,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedGender = value!;
                                              roleselect='3';
                                            });
                                          },
                                        ),
                                        const Expanded(child: Text('Trading Customer',
                                          maxLines: 2,),)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: deviceWidth(context,0.38),
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          activeColor: colorblue,
                                          value: 'Other Customer',
                                          groupValue: _selectedGender,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedGender = value!;
                                              roleselect='4';
                                            });
                                          },
                                        ),
                                        Expanded(child: const Text('Other Customer',
                                          maxLines: 2,))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text('Your Name*',style: textstylesubtitle1(context),),
                              sizedboxheight(8.0),
                              signupname(),
                              sizedboxheight(10.0),
                              Text('Email Address*',style: textstylesubtitle1(context),),
                              sizedboxheight(8.0),
                              signupemail(),
                              sizedboxheight(10.0),

                              Text('Phone Number*',style: textstylesubtitle1(context),),
                              sizedboxheight(8.0),
                              signupphone(),
                              sizedboxheight(10.0),
                              Text('Address*',style: textstylesubtitle1(context),),
                              sizedboxheight(8.0),
                              signupaddress(),
                              sizedboxheight(10.0),
                              Text('City/ Town/ District*',style: textstylesubtitle1(context),),
                              sizedboxheight(8.0),
                              signupcitytown(),
                              sizedboxheight(10.0),
                              Text('Country*',style: textstylesubtitle1(context),),
                              sizedboxheight(8.0),
                              signupcountry(),
                              sizedboxheight(10.0),
                              Text('Landmark (Optional)',style: textstylesubtitle1(context),),
                              sizedboxheight(8.0),
                              signuplandmark(),
                              sizedboxheight(10.0),
                              Text('Password',style: textstylesubtitle1(context),),
                              sizedboxheight(8.0),
                              signupPassword(context),
                              sizedboxheight(10.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    sizedboxheight(10.0),
                    _selectedGender=='Trading Customer'? Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text('Business Business Card (we have to make a'
                         'note that to upload .png format only for the File)*'),
                    ):Container(),
                    _selectedGender=='Trading Customer'? sizedboxheight(10.0):Container(),
                    _selectedGender=='Trading Customer'?Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: businesscard(context),
                    ):Container(),
                  _selectedGender=='Trading Customer'? sizedboxheight(10.0):Container(),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: signUpBtn(context ,_selectedGender),
                    ),
                    sizedboxheight(30.0),
                    _selectedGender!='Trading Customer'?Container(
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.center,
                              child: Text('Already have sbm account!',style: textstyleHeading6(context),)),
                          sizedboxheight(10.0),
                          Align(
                            alignment: Alignment.center,
                            child:signInBtn(context),
                          ),
                          sizedboxheight(10.0),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                  height: 50,width:50,
                                  decoration:  BoxDecoration(
                                    color: colorblue,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(100),
                                      //bottomRight: Radius.circular(50),
                                    ),)))
                        ],
                      ),
                    ):Container(),

                  ],
                ),
              ),
            ),
          ),
          // Align(
          //     alignment: Alignment.bottomRight,
          //     child: Container(
          //         height: 50,width:50,
          //         decoration: const BoxDecoration(
          //           color: Colors.blue,
          //           borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(100),
          //             //bottomRight: Radius.circular(50),
          //           ),)))
        ],
      ),
    );
  }

  Widget signupname() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Jone Doe',
       controller: txt_name,
      autofillHints: [AutofillHints.name],
      textInputAction: TextInputAction.next,

      suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20,top: 15,bottom:15 ),
          child: SvgPicture.asset(
            'assets/icons/user_input.svg',
            height: 0,width: 0,
          )

      ),
      keyBoardType: TextInputType.name,
      validatorFieldValue: 'name',
      validator: validateName,
    );
  }

  Widget signupemail() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
       controller: txt_email,
      autofillHints: [AutofillHints.email],
      textInputAction: TextInputAction.next,

      suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20,top: 15,bottom:15),
          child: SvgPicture.asset(
            'assets/slicing 2/mail.svg',
            height: 0,width: 0,
          )
      ),
      keyBoardType: TextInputType.emailAddress,
      validatorFieldValue: 'email',
      validator: validateEmailField,
    );
  }
  String? a ;
  Widget signupphone() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: colorgrey),
          borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.only(left: 5),
      child: InternationalPhoneNumberInput(
        spaceBetweenSelectorAndTextField: 0,
        textAlignVertical: TextAlignVertical.top,
        onInputChanged: (PhoneNumber number) {

         setState(() {
           print("number.phoneNumber  ${number.phoneNumber}");
           a = number.phoneNumber ;
         });
        },
        onInputValidated: (bool value) {
          print(value);
          print("value${value}");
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
  Widget signupaddress() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
       controller: txt_address,
      autofillHints: [AutofillHints.addressCityAndState],
      textInputAction: TextInputAction.next,


      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'address',
      validator: validateAddressName,
    );
  }
  Widget signupcitytown() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
       controller: txt_city,
      autofillHints: [AutofillHints.addressCityAndState],
      textInputAction: TextInputAction.next,


      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'city',
      validator: validateAddressName,
    );
  }
  Widget signupcountry() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
       controller: txt_country,
      autofillHints: [AutofillHints.countryName],
      textInputAction: TextInputAction.next,

      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Image.asset('assets/icons/smartphone (4).png',scale: 7,color: colorblue,),
        // child: AssetImage('assets/icons/smartphone (4).png'),
        // child: Icon(Icons.check_box_outline_blank,size: 20,color: colorblue,),
      ),
      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'country',
      validator: validateAddressName,
    );
  }
  Widget signuplandmark() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
       controller: txt_landmark,
      autofillHints: [AutofillHints.addressCity],
      textInputAction: TextInputAction.next,

      // suffixIcon: Padding(
      //   padding: const EdgeInsets.only(right: 20),
      //   child: ImageIcon(AssetImage('assets/icons/smartphone (4).png'),size: 10,color: colorblue,),
      //   // child: Icon(Icons.check_box_outline_blank,size: 20,color: colorblue,),
      // ),
      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'landmark',
    //  validator: validateAddressName,
    );
  }
bool veiw = true;
  Widget signupPassword(context) {
    return AllInputDesign(
      // key: Key("password11"),
      hintText: 'Password',
      floatingLabelBehavior: FloatingLabelBehavior.never,
      textInputAction: TextInputAction.done,
      autofillHints: [AutofillHints.password],
       controller: txt_password,
      obsecureText: veiw  ,
      // onEditingComplete: ()=>TextInput.finishAutofillContext(),
      // prefixIcon: Image(image: AssetImage('assets/icons/lock.png')),
      suffixIcon: TextButton(
          key: Key('password_visibility'),
          onPressed: () {
           setState((){
             veiw = !veiw;
           });
          },
          // child: Icon(Icons.visibility, size: 20.0, color: true ? colorblack :colorgrey ),
          //  child:Icon( icon: Icon(Icons.visibility, size: 20.0, color: true ? colorblack :colorgrey )),
          child: veiw
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

  Widget signUpBtn(context,_selectedGender) {
    return Button(
      buttonName:_selectedGender!='Trading Customer'? 'SIGN UP':'REGISTER',

      key: Key('sign)up'),
      borderRadius: BorderRadius.circular(5),

      onPressed: () {

        print('${roleselect}');
        print('${txt_email.text}');
        print('${txt_address.text}');
        print('${txt_city.text}');
        print('${txt_country.text}');
        print('${txt_landmark.text}');
        print('${txt_password.text}');
        print('${controller_mobile.text}');
        print('${number.phoneNumber.toString()}');
        print('${txt_name.text}');
        if (_formKey.currentState!.validate()) {

          signup();
        } else {
          // model.toggleautovalidate();
        }


      },
    );
  }

  Widget signInBtn(context) {
    return Button(
      buttonName: 'SIGN IN',
      btnstyle: textstylesubtitle2(context)!.copyWith(color: colorWhite),
      borderRadius: BorderRadius.circular(5),

      btnWidth: 100,
      btnColor: colorblack,
      onPressed: () {
        Get.to(() => LoginScreen());
      },
    );
  }
  Widget businesscard(context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: colorskyeblue,
        ),

        width: deviceWidth(context,1.0),
     child: Padding(
       padding: const EdgeInsets.all(8.0),
       child: Row(

         children: [
           CircleAvatar(radius: 18,
               backgroundColor: colorblue,
               child: CircleAvatar(
                   radius: 17,
                   backgroundColor: colorskyeblue,
                   child: Icon(Icons.add,color: colorblue,))),
           Text('   Upload Business Card')
         ],
       ),
     ),
      ),
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = txt_name.text.toString();
    map["email"] = txt_email.text.toString();
    map["password"] = txt_password.text.toString();
    map["user_role"] = roleselect;
    map["address"] = txt_address.text.toString();
    map["phone_number"] = a.toString();
    map["city"] = txt_city.text.toString();
    map["country"] = txt_country.text.toString();
    return map;
  }
}
