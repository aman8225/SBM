import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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
import 'package:sbm/model/profilemodel/profile_details_model/profile_details_model.dart';
import 'package:sbm/model/profilemodel/update_profile_model/update_profile_model.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sbm/screens/profile_update/view_profile/view_profile.dart';

class ProfileUpdate extends StatefulWidget {
  ProfileDetailsModelResponse? profiledata;
  ProfileUpdate({Key? key, this.profiledata}) : super(key: key);

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String initialCountry = 'AE';
  PhoneNumber number = PhoneNumber(isoCode: 'AE');

  String _selectedGender = 'Trading Customer';
  File? image = null;
  String? base64Image;
  File? logo = null;
  String? base64logo;

  final ImagePicker _picker = ImagePicker();
  Future<void> getImage(imagetype) async {
    var images = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {

      if (images != null) {
        File file = File( images.path);
        if (imagetype == 1) {
          setState(() {
            image = file;
            final bytes = File(image!.path).readAsBytesSync();
            base64Image = "data:image/png;base64," + base64Encode(bytes);
          });
        } else {
          setState(() {
            logo = file;
            final bytes = File(logo!.path).readAsBytesSync();
            base64logo = "data:image/png;base64," + base64Encode(bytes);
            print("img_pan : $base64logo");
          });
        }
      }
    });
  }
  // Future<void> filepicker(int imagetype) async {
  //   final XFile? images = await _picker.pickImage(source: ImageSource.gallery);
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     File file = File(result.files.single.path!);
  //     print('file${file}');
  //     if (imagetype == 1) {
  //       setState(() {
  //         image = file;
  //         final bytes = File(image!.path).readAsBytesSync();
  //         base64Image = "data:image/png;base64," + base64Encode(bytes);
  //
  //         print("img_pan : $base64Image");
  //       });
  //     } else {
  //       setState(() {
  //         logo = file;
  //         final bytes = File(logo!.path).readAsBytesSync();
  //         base64logo = "data:image/png;base64," + base64Encode(bytes);
  //         print("img_pan : $base64logo");
  //       });
  //     }
  //   }
  // }

  final _formKey = GlobalKey<FormState>();

  ProgressDialog? progressDialog;

  TextEditingController txt_email = TextEditingController();
  TextEditingController txt_name = TextEditingController();
  TextEditingController txt_address = TextEditingController();
  TextEditingController txt_city = TextEditingController();
  TextEditingController txt_country = TextEditingController();
  TextEditingController txt_landmark = TextEditingController();
  TextEditingController controller = TextEditingController();

  void seve() {
    txt_email.text = widget.profiledata!.email!;
    txt_name.text = widget.profiledata!.name!;
    txt_address.text = widget.profiledata!.address!;
    txt_city.text = widget.profiledata!.city!;
    txt_country.text = widget.profiledata!.country!;
    txt_landmark.text = widget.profiledata!.landmark == null
        ? ''
        : widget.profiledata!.landmark!;
    controller.text = widget.profiledata!.phone!;
    base64logo = widget.profiledata!.businessLogo == null
        ? null
        : widget.profiledata!.businessLogo!;
    base64Image = widget.profiledata!.profilepic!;
  }

  var success, message, id, email;

  var tokanget;
  Future<UpdateProfileModelMassege> updateprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
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
    Map toMap() {
      var map = new Map<String, dynamic>();
      map["name"] = txt_name.text.toString();
      map["email"] = txt_email.text.toString();
      map["phone"] = controller.text.toString();
      map["address"] = txt_address.text.toString();
      map["city"] = txt_city.text.toString();
      map["country"] = txt_country.text.toString();
      map["landmark"] = txt_landmark.text.isEmpty ? "" : txt_landmark.text;
      map["business_card"] = base64logo==null?" ":base64logo;
      map["profilepic"] = base64Image;
      return map;
    }

    print(toMap());
    var response = await http.post(Uri.parse('${beasurl}updateProfileRequest'),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
        });
    print("success 123 ==response.body${response.body}");

    success = (UpdateProfileModelMassege.fromJson(json.decode(response.body))
        .success);
    message = (UpdateProfileModelMassege.fromJson(json.decode(response.body))
        .message);
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
    return UpdateProfileModelMassege.fromJson(json.decode(response.body));
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
              margin: EdgeInsets.only(left: 7),
              child: Text("Profile Update...")),
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
  void initState() {
    super.initState();
    seve();
  }

  Future<bool> _willPopCallback() async {
    Get.off(() => ProfileDetails());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {

      return Scaffold(
        appBar: appbarnotifav(context, 'Profile Update'),
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
                      Container(
                        child: Stack(
                          children: [
                            CircleAvatar(
                                radius: 46,
                                backgroundColor: colorgrey,
                                child: base64Image == null
                                    ? CircleAvatar(
                                  radius: 45,
                                  backgroundColor: colorskyeblue,
                                  child: SvgPicture.asset(
                                    'assets/slicing 2/profile update.svg',
                                    height: 50,
                                    width: 50,
                                  ),
                                )
                                    : (image == null
                                    ? CircleAvatar(
                                  radius: 45,
                                  backgroundColor: colorskyeblue,
                                  backgroundImage:
                                  NetworkImage(base64Image!),
                                  //backgroundImage: FileImage(image!=null?image:widget.profiledata!.profilepic),
                                )
                                    : CircleAvatar(
                                  radius: 45,
                                  backgroundColor: colorskyeblue,
                                  backgroundImage: FileImage(image! ),
                                  //backgroundImage: FileImage(image!=null?image:widget.profiledata!.profilepic),
                                ))),
                            Positioned(
                              bottom: 10,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  getImage(1);
                                  // filepicker(1);
                                },
                                child: CircleAvatar(
                                  radius: 13,
                                  backgroundColor: colorgrey,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: colorWhite,
                                    child: Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: colorblue,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      sizedboxheight(20.0),
                      UploadCompanyLogo(context),
                      sizedboxheight(10.0),
                      Card(
                        elevation: 2,
                        child: Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Name*',
                                  style: textstylesubtitle1(context),
                                ),
                                sizedboxheight(8.0),
                                signupname(),
                                sizedboxheight(10.0),
                                Text(
                                  'Email Address*',
                                  style: textstylesubtitle1(context),
                                ),
                                sizedboxheight(8.0),
                                signupemail(),
                                sizedboxheight(10.0),
                                Text(
                                  'Phone Number*',
                                  style: textstylesubtitle1(context),
                                ),
                                sizedboxheight(8.0),
                                signupmobile(),
                                sizedboxheight(10.0),
                                Text(
                                  'Address*',
                                  style: textstylesubtitle1(context),
                                ),
                                sizedboxheight(8.0),
                                signupaddress(),
                                sizedboxheight(10.0),
                                Text(
                                  'City/ Town/ District*',
                                  style: textstylesubtitle1(context),
                                ),
                                sizedboxheight(8.0),
                                signupcitytown(),
                                sizedboxheight(10.0),
                                Text(
                                  'Country*',
                                  style: textstylesubtitle1(context),
                                ),
                                sizedboxheight(8.0),
                                signupcountry(),
                                sizedboxheight(10.0),
                                Text(
                                  'Landmark (Optional)',
                                  style: textstylesubtitle1(context),
                                ),
                                sizedboxheight(8.0),
                                signuplandmark(),
                                sizedboxheight(10.0),
                                // _selectedGender != 'Trading Customer'
                                //     ? Text(
                                //   'Landmark (Optional)',
                                //   style: textstylesubtitle1(context),
                                // )
                                //     : Container(),
                                // sizedboxheight(8.0),
                                // _selectedGender != 'Trading Customer'
                                //     ? signuplandmark()
                                //     : Container(),
                                // sizedboxheight(10.0),
                                // sizedboxheight(10.0),
                                // _selectedGender == 'Trading Customer'
                                //     ? const Text(
                                //     'Business Business Card (we have to make a'
                                //         'note that to upload .png format only for the'
                                //         'File)*')
                                //     : Container(),
                                // _selectedGender == 'Trading Customer'
                                //     ? sizedboxheight(10.0)
                                //     : Container(),
                                // _selectedGender == 'Trading Customer'
                                //     ? businesscard(context)
                                //     : Container(),
                                // _selectedGender == 'Trading Customer'
                                //     ? sizedboxheight(10.0)
                                //     : Container(),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    signInBtn(context),
                                    signUpBtn(context, _selectedGender),
                                  ],
                                ),
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


  }

  Widget signupname() {
    return AllInputDesign(
      initialValue: txt_name,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: widget.profiledata!.name,
      controller: txt_name,
      autofillHints: [AutofillHints.name],
      textInputAction: TextInputAction.next,
      suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20, top: 15, bottom: 15),
          child: SvgPicture.asset(
            'assets/icons/user_input.svg',
            height: 0,
            width: 0,
          )),
      keyBoardType: TextInputType.name,
      validatorFieldValue: 'name',
      validator: validateName,
    );
  }

  Widget signupemail() {
    return AllInputDesign(
      initialValue: txt_email,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: widget.profiledata!.email,
      controller: txt_email,
      autofillHints: [AutofillHints.email],
      textInputAction: TextInputAction.next,
      suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20, top: 15, bottom: 15),
          child: SvgPicture.asset(
            'assets/slicing 2/mail.svg',
            height: 0,
            width: 0,
          )),
      keyBoardType: TextInputType.emailAddress,
      validatorFieldValue: 'email',
      validator: validateEmailField,
    );
  }


  Widget signupmobile() {
    return AllInputDesign(
      initialValue: controller,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: widget.profiledata!.email,
      controller: controller,
      autofillHints: [AutofillHints.telephoneNumberDevice],
      textInputAction: TextInputAction.next,

      keyBoardType: TextInputType.number,
      validatorFieldValue: 'number',
      validator: validateMobile,
    );
  }



  // Widget signupphone() {
  //   return Container(
  //     decoration: BoxDecoration(
  //         border: Border.all(color: colorgrey),
  //         borderRadius: BorderRadius.circular(10)),
  //     padding: const EdgeInsets.only(left: 5),
  //     child: InternationalPhoneNumberInput(
  //       spaceBetweenSelectorAndTextField: 0,
  //       textAlignVertical: TextAlignVertical.top,
  //       initialValue: number,
  //       onInputChanged: (PhoneNumber number) {
  //         print(number.phoneNumber);
  //       },
  //       onInputValidated: (bool value) {
  //         print(value);
  //       },
  //       selectorConfig: const SelectorConfig(
  //         selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
  //       ),
  //       ignoreBlank: false,
  //       autoValidateMode: AutovalidateMode.disabled,
  //       selectorTextStyle: const TextStyle(color: Colors.black),
  //       //initialValue: number,
  //       textFieldController: controller,
  //       formatInput: false,
  //       keyboardType:
  //           const TextInputType.numberWithOptions(signed: true, decimal: true),
  //       inputBorder: InputBorder.none,
  //       onSaved: (PhoneNumber number) {
  //         print('On Saved: $number');
  //       },
  //     ),
  //   );
  // }

  Widget signupaddress() {
    return AllInputDesign(
      initialValue: txt_address,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: widget.profiledata!.address,
      controller: txt_address,
      autofillHints: [AutofillHints.addressCityAndState],
      textInputAction: TextInputAction.next,
      suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20, top: 15, bottom: 15),
          child: SvgPicture.asset(
            'assets/slicing 2/address.svg',
            color: colorgrey,
            height: 0,
            width: 0,
          )),
      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'address',
      validator: validateAddressName,
    );
  }

  Widget signupcitytown() {
    return AllInputDesign(
      initialValue: txt_city,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: widget.profiledata!.city,
      controller: txt_city,
      autofillHints: [AutofillHints.addressCityAndState],
      textInputAction: TextInputAction.next,
      suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20, top: 15, bottom: 15),
          child: SvgPicture.asset(
            'assets/slicing 2/address.svg',
            color: colorgrey,
            height: 0,
            width: 0,
          )),
      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'city',
      validator: (value) {
        if (value.isEmpty) {
          return 'city Name is Required.';
        }
      },
    );
  }

  Widget signupcountry() {
    return AllInputDesign(
      initialValue: txt_country,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: widget.profiledata!.country,
      controller: txt_country,
      autofillHints: [AutofillHints.countryName],
      textInputAction: TextInputAction.next,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Image.asset(
          'assets/icons/smartphone (4).png',
          scale: 8,
          color: colorblue,
        ),
        // child: Icon(Icons.check_box_outline_blank,size: 20,color: colorblue,),
      ),
      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'country',
      validator: (value) {
        if (value.isEmpty) {
          return 'country Name is Required.';
        }
      },
    );
  }

  Widget signuplandmark() {
    return AllInputDesign(
        initialValue: txt_landmark,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: '',
        controller: txt_landmark,
        autofillHints: [AutofillHints.addressCity],
        textInputAction: TextInputAction.next,
        keyBoardType: TextInputType.streetAddress,
        validatorFieldValue: 'landmark',
        // validator: (value) {
        //   if (value.isEmpty) {
        //     return 'landmark is Required.';
        //   }
        // }
        );
  }

  Widget signUpBtn(context, _selectedGender) {
    return Button(
      buttonName: 'SAVE ADDRESS',
      btnstyle: textstylesubtitle1(context)!.copyWith(fontSize: 13,color: colorWhite,overflow: TextOverflow.ellipsis),
      key: Key('sign up'),
      borderRadius: BorderRadius.circular(5),
      btnWidth: deviceWidth(context, 0.45),
      onPressed: () {
          if (_formKey.currentState!.validate()) {
            updateprofile();
          }
      },
    );
  }

  Widget signInBtn(context) {
    return Button(
      buttonName: 'CANCEL',
      btnstyle: textstylesubtitle1(context)!.copyWith(fontSize: 12,color: colorWhite,overflow: TextOverflow.ellipsis, ),
      borderRadius: BorderRadius.circular(5),
      btnWidth: deviceWidth(context, 0.25),
      btnColor: colorblack54,
      onPressed: () {
         Get.back();

        // if (formKey1.currentState.validate()) {
        //   //  model.changepasswordsubmit(context, userid);
        //   // Get.to(() => BottomNavBarPage());
        // } else {
        //   // model.toggleautovalidate();
        // }
      },
    );
  }

  Widget businesscard(context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: colorskyeblue,
        ),
        height: 60,
        width: deviceWidth(context, 1.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16.5,
                backgroundColor: colorblue,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: colorskyeblue,
                  child: Icon(
                    Icons.add,
                    color: colorblue,
                  ),
                ),
              ),
              sizedboxwidth(10.0),
              Text('Upload Business Card')
            ],
          ),
        ),
      ),
    );
  }

  Widget UploadCompanyLogo(context) {
    return InkWell(
      onTap: () {
        getImage(2);
       // filepicker(2);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: colorskyeblue,
          ),
          height: 60,
          width: deviceWidth(context, 1.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                base64logo == null
                    ? CircleAvatar(
                        radius: 16.5,
                        backgroundColor: colorblue,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: colorskyeblue,
                          child: Icon(
                            Icons.add,
                            color: colorblue,
                          ),
                        ),
                      )
                    : (logo == null
                        ? Image.network(
                            base64logo!,
                            height: 40,
                            width: 100,
                          )
                        : Image.file(
                            logo!,
                            height: 40,
                            width: 100,
                          )),
                sizedboxwidth(10.0),
                Text('Upload Company Logo')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
