import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
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
import 'package:http/http.dart' as http;
import 'package:sbm/model/addressmodel/addressmodel.dart';
import 'package:sbm/model/addressmodel/delet_sddress_model/delet_address_model.dart';
import 'package:sbm/model/addressmodel/edit_address_model/edit_address_model.dart';
import 'package:sbm/model/addressmodel/setDefaultAddressMode/setDefaultAddressMode.dart';
import 'package:sbm/model/addressmodel/setnewaddressmode/setnewaddressmodel.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({Key? key}) : super(key: key);

  @override
  _MyAddressState createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String initialCountry = 'AE';
  PhoneNumber number = PhoneNumber(isoCode: 'AE');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future? _future;
  var tokanget;
  var editaddressID;
  var editdataapi = 0;

  ProgressDialog? progressDialog;
  var success, message, data;
  List<AddAddressResponse> addressdatalist = [];
  var  setaddressid;
  var  setaddressid1;

  Future<Addressmodelmessege> addressesdata() async {
    // showLoaderDialog(context);
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
    print('${beasurl}addresses');
    var response = await http.get(Uri.parse('${beasurl}addresses'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });

    success =
        (Addressmodelmessege.fromJson(json.decode(response.body)).success);
    message =
        (Addressmodelmessege.fromJson(json.decode(response.body)).message);

    if (success == true) {
      setState(() {
        addressdatalist = (Addressmodelmessege.fromJson(json.decode(response.body)).data)!;
        setaddressid = (Addressmodelmessege.fromJson(json.decode(response.body)).data!.first.addressId);
        setaddressid1 = (Addressmodelmessege.fromJson(json.decode(response.body)).data!.first.id);
        selectedGender = setaddressid == null ? setaddressid1.toString():setaddressid.toString();
      });
      progressDialog!.dismiss();

    } else {
      progressDialog!.dismiss();
      print('else==============');
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return Addressmodelmessege.fromJson(json.decode(response.body));
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

  TextEditingController txt_name = TextEditingController();
  TextEditingController txt_email = TextEditingController();
  TextEditingController controller = TextEditingController();
  TextEditingController txt_pincode = TextEditingController();
  TextEditingController txt_address = TextEditingController();
  TextEditingController txt_city = TextEditingController();
  TextEditingController txt_state = TextEditingController();
  TextEditingController txt_country = TextEditingController();
  TextEditingController txt_landmark = TextEditingController();

  Future<SetAddressModelMessege> addnewaddress() async {
    print("CLICKED 123 ==");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        showLoaderDialog(context, "Add New Address...");
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
    var response = await http
        .post(Uri.parse('${beasurl}addresses/add'), body: toMap(), headers: {
      'Authorization': 'Bearer $tokanget',
    });
    success =
        (SetAddressModelMessege.fromJson(json.decode(response.body)).success);
    message =
        (SetAddressModelMessege.fromJson(json.decode(response.body)).message);
    if (success == true) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
      editdataapi = 0;
      setState(() {
        _future = addressesdata();
      });
      txt_email.clear();
      txt_name.clear();
      txt_pincode.clear();
      txt_address.clear();
      txt_city.clear();
      txt_country.clear();
      txt_state.clear();
      txt_landmark.clear();
      controller.clear();
      addnewaddresscard = false;
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
    return SetAddressModelMessege.fromJson(json.decode(response.body));
  }

  showLoaderDialog(BuildContext context, text) {
    AlertDialog alert = AlertDialog(
      content:  Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Add New Address...")),
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

  String? addressid;
  setDefaultAddressModeresponse? setaddressdata;
  Future<setDefaultAddressModeMessege> setdefaultaddress(addressid) async {
    check().then((intenet) {
      if (intenet != null && intenet) {
        showLoaderDialog(context, "Set Default Address");
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
      var map =  Map<String, dynamic>();
      map["address_id"] = addressid.toString();
      return map;
    }

    var response = await http.post(Uri.parse('${beasurl}setDefaultAddress'),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
        });

    print(
        setDefaultAddressModeMessege.fromJson(json.decode(response.body)).data);
    print(setDefaultAddressModeMessege
        .fromJson(json.decode(response.body))
        .message);
    success = (setDefaultAddressModeMessege
        .fromJson(json.decode(response.body))
        .success);
    message = (setDefaultAddressModeMessege
        .fromJson(json.decode(response.body))
        .message);
    setaddressdata = (setDefaultAddressModeMessege
        .fromJson(json.decode(response.body))
        .data);

    if (success == true) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
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
    return setDefaultAddressModeMessege.fromJson(json.decode(response.body));
  }

  Future<DeletAddressModelMassege> deleteaddress(int adress_Id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        showLoaderDialog(context, "Set Delete Address");
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
      var map =  Map<String, dynamic>();
      map["address_id"] = adress_Id.toString();
      return map;
    }

    var response = await http
        .post(Uri.parse('${beasurl}addresses/delete'), body: toMap(), headers: {
      'Authorization': 'Bearer $tokanget',
    });

    print(response.body);
    success =
        (DeletAddressModelMassege.fromJson(json.decode(response.body)).success);
    message =
        (DeletAddressModelMassege.fromJson(json.decode(response.body)).message);
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
      setState(() {
        _future = addressesdata();
      });
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
    return DeletAddressModelMassege.fromJson(json.decode(response.body));
  }

  Future<EditAddressModelMassege> editaddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        showLoaderDialog(context, "Set Delete Address");
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
      var map =  Map<String, dynamic>();
      map["address_id"] = editaddressID.toString();
      map["name"] = txt_name.text.toString();
      map["email"] = txt_email.text.toString();
      map["phone_number"] = controller.text.toString();
      map["pincode"] = txt_pincode.text.toString();
      map["address"] = txt_address.text.toString();
      map["city"] = txt_city.text.toString();
      map["state"] = txt_state.text.toString();
      map["country"] = txt_country.text.toString();
      map["landmark"] = txt_landmark.text.toString();
      return map;
    }

    print(toMap());
    var response = await http
        .post(Uri.parse('${beasurl}addresses/update'), body: toMap(), headers: {
      'Authorization': 'Bearer $tokanget',
    });

    print(response.body);
    success =
        (EditAddressModelMassege.fromJson(json.decode(response.body)).success);
    message =
        (EditAddressModelMassege.fromJson(json.decode(response.body)).message);
    print("success 123  editaddress ==${response.body}");
    if (success == true) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        _future = addressesdata();
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", true);
      prefs.setString(
        'login_user_id',
        json.encode(
          EditAddressModelMassege.fromJson(json.decode(response.body))
                  .data!
                  .id ??
              '',
        ),
      );
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
    return EditAddressModelMassege.fromJson(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();
    _future = addressesdata();
  }

  String? selectedGender ;
  bool addnewaddresscard = false;
  @override
  Widget build(BuildContext context) {

    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {

      return Scaffold(
        backgroundColor: colorskyeblue,
        appBar: appbarnotifav(context, 'My Address'),
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
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: deviceWidth(context, 1.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: colorblue),
                              color: colorWhite),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  addnewaddresscard = true;
                                  txt_email.clear();
                                  txt_name.clear();
                                  txt_pincode.clear();
                                  txt_address.clear();
                                  txt_city.clear();
                                  txt_country.clear();
                                  txt_state.clear();
                                  txt_landmark.clear();
                                  controller.clear();
                                  editaddressID = null;
                                  editdataapi = 0;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: colorblue,
                                  ),
                                  Text(
                                    'Add Delivery Address',
                                    style: textstylesubtitle1(context)!
                                        .copyWith(color: colorblue),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        addresscard(),
                        sizedboxheight(10.0),
                        FutureBuilder(
                          future: _future,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  width: deviceWidth(context, 1.0),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: colorblue)),
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      hint: const Text("Select Address"),
                                      value: selectedGender ?? "select address",
                                      isDense: true,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedGender = newValue;
                                          setdefaultaddress(selectedGender);
                                        });
                                        print(selectedGender);
                                      },
                                      items: addressdatalist
                                          .map((AddAddressResponse map) {
                                        return  DropdownMenuItem<String>(
                                          value: map.id.toString(),
                                          child: Container(
                                            width: deviceWidth(context, 0.6),
                                            child: Text(
                                              '${map.address},  ${map.country},  '
                                                  '${map.state}.',
                                              style: textstylesubtitle2(context)!
                                                  .copyWith(
                                                  height: 1.5,
                                                  fontSize: 13,
                                                  color: colorblack),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                //  child: CircularProgressIndicator(),
                              );
                            }
                          },
                          // future: postlist(),
                        ),

                        // Container(
                        //   color: colorWhite,
                        //   height: 50,width: deviceWidth(context,1.0),
                        //   child: DropdownButton<String>(
                        //     hint: Text("$hintValue"),
                        //     iconSize: 20,
                        //     items: steuerklassen.map((String dropDownStringItem) {
                        //       return DropdownMenuItem(
                        //         value: dropDownStringItem,
                        //         child: Text(dropDownStringItem),
                        //       );
                        //     }).toList(),
                        //     onChanged: (selectedValue) {
                        //       setState(() {
                        //         for (int i = 0; i < steuerklassen.length; i++)
                        //           if (steuerklassen[i] == selectedValue) {
                        //             this.steuerklassen_value = i + 1;
                        //           }
                        //         hintValue = "Steuerklasse $selectedValue";
                        //
                        //       });
                        //     },
                        //   ),
                        // ),
                        sizedboxheight(10.0),
                        addnewaddresscard
                            ? Text(
                          'Add Delivery Address',
                          style: textstyleHeading3(context),
                        )
                            : Container(),
                        sizedboxheight(10.0),
                        addnewaddresscard
                            ? Card(
                          elevation: 3,
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
                                // signupphone(),
                                sizedboxheight(10.0),
                                Text(
                                  'Pincode*',
                                  style: textstylesubtitle1(context),
                                ),
                                sizedboxheight(8.0),
                                pincode(),
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
                                  'State*',
                                  style: textstylesubtitle1(context),
                                ),
                                sizedboxheight(8.0),
                                signupstate(),
                                sizedboxheight(10.0),
                                Text(
                                  'Country*',
                                  style: textstylesubtitle1(context),
                                ),
                                sizedboxheight(8.0),
                                signupcountry(),
                                sizedboxheight(10.0),
                                Text(
                                  'Landmark (Optional)*',
                                  style: textstylesubtitle1(context),
                                ),
                                sizedboxheight(8.0),
                                signuplandmark(),
                                sizedboxheight(10.0),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    cancelbutton(context),
                                    saveaddressBtn(context),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                            : Container(),
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
      backgroundColor: colorskyeblue,
      appBar: appbarnotifav(context, 'My Address'),
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
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: deviceWidth(context, 1.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: colorblue),
                            color: colorWhite),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                addnewaddresscard = true;
                                txt_email.clear();
                                txt_name.clear();
                                txt_pincode.clear();
                                txt_address.clear();
                                txt_city.clear();
                                txt_country.clear();
                                txt_state.clear();
                                txt_landmark.clear();
                                controller.clear();
                                editaddressID = null;
                                editdataapi = 0;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: colorblue,
                                ),
                                Text(
                                  'Add Delivery Address',
                                  style: textstylesubtitle1(context)!
                                      .copyWith(color: colorblue),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      addresscard(),
                      sizedboxheight(10.0),
                      FutureBuilder(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width: deviceWidth(context, 1.0),
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: colorblue)),
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: const Text("Select Address"),
                                    value: selectedGender,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedGender = newValue;
                                        setdefaultaddress(selectedGender);
                                      });
                                      print(selectedGender);
                                    },
                                    items: addressdatalist
                                        .map((AddAddressResponse map) {
                                      return new DropdownMenuItem<String>(
                                        value: map.id.toString(),
                                        child: Container(
                                          width: deviceWidth(context, 0.6),
                                          child: Text(
                                            '${map.address},  ${map.country},  '
                                            '${map.state}.',
                                            style: textstylesubtitle2(context)!
                                                .copyWith(
                                                    height: 1.5,
                                                    fontSize: 13,
                                                    color: colorblack),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                                //  child: CircularProgressIndicator(),
                                );
                          }
                        },
                        // future: postlist(),
                      ),

                      // Container(
                      //   color: colorWhite,
                      //   height: 50,width: deviceWidth(context,1.0),
                      //   child: DropdownButton<String>(
                      //     hint: Text("$hintValue"),
                      //     iconSize: 20,
                      //     items: steuerklassen.map((String dropDownStringItem) {
                      //       return DropdownMenuItem(
                      //         value: dropDownStringItem,
                      //         child: Text(dropDownStringItem),
                      //       );
                      //     }).toList(),
                      //     onChanged: (selectedValue) {
                      //       setState(() {
                      //         for (int i = 0; i < steuerklassen.length; i++)
                      //           if (steuerklassen[i] == selectedValue) {
                      //             this.steuerklassen_value = i + 1;
                      //           }
                      //         hintValue = "Steuerklasse $selectedValue";
                      //
                      //       });
                      //     },
                      //   ),
                      // ),
                      sizedboxheight(10.0),
                      addnewaddresscard
                          ? Text(
                              'Add Delivery Address',
                              style: textstyleHeading3(context),
                            )
                          : Container(),
                      sizedboxheight(10.0),
                      addnewaddresscard
                          ? Card(
                              elevation: 3,
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
                                   // signupphone(),
                                    sizedboxheight(10.0),
                                    Text(
                                      'Pincode*',
                                      style: textstylesubtitle1(context),
                                    ),
                                    sizedboxheight(8.0),
                                    pincode(),
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
                                      'State*',
                                      style: textstylesubtitle1(context),
                                    ),
                                    sizedboxheight(8.0),
                                    signupstate(),
                                    sizedboxheight(10.0),
                                    Text(
                                      'Country*',
                                      style: textstylesubtitle1(context),
                                    ),
                                    sizedboxheight(8.0),
                                    signupcountry(),
                                    sizedboxheight(10.0),
                                    Text(
                                      'Landmark (Optional)*',
                                      style: textstylesubtitle1(context),
                                    ),
                                    sizedboxheight(8.0),
                                    signuplandmark(),
                                    sizedboxheight(10.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        cancelbutton(context),
                                        saveaddressBtn(context),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
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

  Widget addresscard() {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            //height: addressdatalist.length*deviceheight(context,0.2),
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: addressdatalist.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: deviceWidth(context, 0.6),
                                    child: Text(
                                      '${addressdatalist[index].name}  ${addressdatalist[index].phone}',
                                      style: textstyleHeading3(context),
                                    )),
                                popMenus(
                                  context: context,
                                  options: [
                                    {
                                      "menu": "Edit",
                                      "menu_id": 1,
                                      "address_id": addressdatalist[index].id,
                                      "index": index
                                    },
                                    {
                                      "menu": "Delete",
                                      "menu_id": 2,
                                      "address_id": addressdatalist[index].id,
                                    },
                                  ],
                                )
                              ],
                            ),
                            Text(
                              '${addressdatalist[index].address}',
                              style: textstylesubtitle2(context)!
                                  .copyWith(height: 1.5, fontSize: 13),
                              maxLines: 2,
                            ),
                            Text(
                              '${addressdatalist[index].city},  ${addressdatalist[index].state},  '
                              '${addressdatalist[index].country}.',
                              style: textstylesubtitle2(context)!
                                  .copyWith(height: 1.5, fontSize: 13),
                              maxLines: 2,
                            ),
                            Text(
                              '${addressdatalist[index].pincode}',
                              style: textstylesubtitle2(context)!
                                  .copyWith(height: 1.5, fontSize: 13),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      // future: postlist(),
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
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.person_outline_rounded,
          size: 25,
          color: colorgrey,
        ),
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
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.mail_outline,
          size: 25,
          color: colorgrey,
        ),
      ),
      keyBoardType: TextInputType.emailAddress,
      validatorFieldValue: 'email',
      validator: validateEmailField,
    );
  }

  Widget signupmobile() {
    return AllInputDesign(
      initialValue: controller,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Phone Number',
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
  //     padding: EdgeInsets.only(left: 5),
  //     child: InternationalPhoneNumberInput(
  //       spaceBetweenSelectorAndTextField: 0,
  //       textAlignVertical: TextAlignVertical.top,
  //       onInputChanged: (PhoneNumber number) {
  //         print(number.phoneNumber);
  //       },
  //       onInputValidated: (bool value) {
  //         print(value);
  //       },
  //       selectorConfig: SelectorConfig(
  //         selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
  //       ),
  //       ignoreBlank: false,
  //       autoValidateMode: AutovalidateMode.disabled,
  //       selectorTextStyle: TextStyle(color: Colors.black),
  //       initialValue: number,
  //       textFieldController: controller,
  //       formatInput: false,
  //       keyboardType:
  //           TextInputType.numberWithOptions(signed: true, decimal: true),
  //       inputBorder: InputBorder.none,
  //       onSaved: (PhoneNumber number) {
  //         print('On Saved: $number');
  //       },
  //     ),
  //   );
  // }

  Widget pincode() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
      controller: txt_pincode,
      autofillHints: [AutofillHints.addressCityAndState],
      textInputAction: TextInputAction.next,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.location_on_outlined,
          size: 25,
          color: colorgrey,
        ),
      ),

      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'pincode',
      validator: validatePromoCode,
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
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.location_on_outlined,
          size: 25,
          color: colorgrey,
        ),
      ),

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
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.location_on_outlined,
          size: 25,
          color: colorgrey,
        ),
      ),

      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'city',
      validator: validatecityName,
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
        child: Image.asset(
          'assets/icons/smartphone (4).png',
          scale: 8,
          color: colorblue,
        ),
        // child: Icon(Icons.check_box_outline_blank,size: 20,color: colorblue,),
      ),
      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'country',
      validator: validatecountryName,
    );
  }

  Widget signupstate() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
      controller: txt_state,
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
      validatorFieldValue: 'state',
      validator: validatestateName,
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

      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'landmark',

    );
  }

  Widget saveaddressBtn(
    context,
  ) {
    return Button(
      buttonName: 'SAVE ADDRESS',
      btnstyle: textstylesubtitle1(context)!.copyWith(fontSize: 13,color: colorWhite,overflow: TextOverflow.ellipsis),
      key: Key('save address'),
      borderRadius: BorderRadius.circular(5),
      btnWidth: deviceWidth(context, 0.45),
      onPressed: () {
        if (editdataapi == 1) {
          editaddress();
        } else {
          if (_formKey.currentState!.validate()) {
            print('aman1111');
            addnewaddress();

          } else {
            // model.toggleautovalidate();
          }
        }
      },
    );
  }

  Widget cancelbutton(context) {
    return Button(
      buttonName: 'CANCEL',
      btnstyle: textstylesubtitle1(context)!.copyWith(fontSize: 12,color: colorWhite,overflow: TextOverflow.ellipsis, ),
      borderRadius: BorderRadius.circular(5),
      btnWidth: deviceWidth(context, 0.25),
      btnColor: colorblack54,

      onPressed: () {
        setState(() {
          addnewaddresscard = false;
          txt_email.clear();
          txt_name.clear();
          txt_pincode.clear();
          txt_address.clear();
          txt_city.clear();
          txt_country.clear();
          txt_state.clear();
          txt_landmark.clear();
          controller.clear();
          editaddressID = null;
          editdataapi = 0;
        });
      },
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = txt_name.text.toString();
    map["email"] = txt_email.text.toString();
    map["phone_number"] = controller.text.toString();
    map["pincode"] = txt_pincode.text.toString();
    map["address"] = txt_address.text.toString();
    map["city"] = txt_city.text.toString();
    map["state"] = txt_state.text.toString();
    map["country"] = txt_country.text.toString();
    map["landmark"] = txt_landmark.text.toString();

    return map;
  }

  Widget popMenus({
    List<Map<String, dynamic>>? options,
    BuildContext? context,
  }) {
    return PopupMenuButton(
      iconSize: 24.0,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      icon: Icon(
        Icons.more_horiz_rounded,
        color: colorblack54,
        size: 24.0,
      ),
      offset: Offset(0, 10),
      itemBuilder: (BuildContext bc) {
        return options!
            .map(
              (selectedOption) => PopupMenuItem(
                onTap: (){

                  if (selectedOption['menu'] == "Edit") {
                    setState(() {
                      print(selectedOption['index']);
                      addnewaddresscard = true;
                      txt_name.text =
                      addressdatalist[selectedOption['index']].name ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .name!;
                      txt_email.text =
                      addressdatalist[selectedOption['index']]
                          .email ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .email!;
                      controller.text =
                      addressdatalist[selectedOption['index']]
                          .phone ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .phone!;
                      txt_pincode.text =
                      addressdatalist[selectedOption['index']]
                          .pincode ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .pincode!;
                      txt_address.text =
                      addressdatalist[selectedOption['index']]
                          .address ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .address!;
                      txt_city.text =
                      addressdatalist[selectedOption['index']].city ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .city!;
                      txt_state.text =
                      addressdatalist[selectedOption['index']]
                          .state ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .state!;
                      txt_country.text =
                      addressdatalist[selectedOption['index']]
                          .country ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .country!;
                      txt_landmark.text =
                      addressdatalist[selectedOption['index']]
                          .landmark ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .landmark!;
                      editaddressID = selectedOption['address_id'];
                      editdataapi = 1;
                    });
                  }
                  if (selectedOption['menu'] == "Delete") {
                    setState(() {
                      deleteaddress(selectedOption['address_id']);
                    });
                  }
                },
                height: 15.0,
                value: selectedOption,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        print(selectedOption['menu']);
                        print(selectedOption['address_id']);
                        Navigator.pop(context!);
                        if (selectedOption['menu'] == "Edit") {
                          setState(() {
                            print(selectedOption['index']);
                            addnewaddresscard = true;
                            txt_name.text =
                                addressdatalist[selectedOption['index']].name ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .name!;
                            txt_email.text =
                                addressdatalist[selectedOption['index']]
                                            .email ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .email!;
                            controller.text =
                                addressdatalist[selectedOption['index']]
                                            .phone ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .phone!;
                            txt_pincode.text =
                                addressdatalist[selectedOption['index']]
                                            .pincode ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .pincode!;
                            txt_address.text =
                                addressdatalist[selectedOption['index']]
                                            .address ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .address!;
                            txt_city.text =
                                addressdatalist[selectedOption['index']].city ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .city!;
                            txt_state.text =
                                addressdatalist[selectedOption['index']]
                                            .state ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .state!;
                            txt_country.text =
                                addressdatalist[selectedOption['index']]
                                            .country ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .country!;
                            txt_landmark.text =
                                addressdatalist[selectedOption['index']]
                                            .landmark ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .landmark!;
                            editaddressID = selectedOption['address_id'];
                            editdataapi = 1;
                          });
                        }
                        if (selectedOption['menu'] == "Delete") {
                          setState(() {
                            deleteaddress(selectedOption['address_id']);
                          });
                        }
                      },
                      child: Text(
                        selectedOption['menu'] ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          color: colorblack54,
                        ),
                      ),
                    ),
                    (options.length == (options.indexOf(selectedOption) + 1))
                        ? SizedBox(
                            width: 0.0,
                            height: 0.0,
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                          ),
                  ],
                ),

              ),
            )
            .toList();
      },
      onSelected: (value) async {},
    );
  }
}
