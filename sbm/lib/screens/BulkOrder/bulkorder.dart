import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar_modelpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbarwidget.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/formtextfield/mytextfield.dart';
import 'package:sbm/common/formtextfield/validations_field.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/bulkordermodel/bulk_order_model/bulk_order_model.dart';
import 'package:sbm/model/bulkordermodel/sku_model/sku_model.dart';
import 'package:http/http.dart' as http;

class BulkOrder extends StatefulWidget {
  BulkOrder({Key? key}) : super(key: key);

  @override
  State<BulkOrder> createState() => _BulkOrderState();
}

class _BulkOrderState extends State<BulkOrder> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  String initialCountry = 'AE';

  PhoneNumber number = PhoneNumber(isoCode: 'AE');
  List<SkuModelResponse> cart = [];

  var tokanget;
  ProgressDialog? progressDialog;
  var success, message;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController txt_name = TextEditingController();
  TextEditingController txt_email = TextEditingController();
  TextEditingController txt_description = TextEditingController();
  TextEditingController txt_brand = TextEditingController();

  var success1, message1;

  Future<BulkOrderModelMassege> addbulkorder() async {
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
    Map toMap() {
      var map = new Map<String, dynamic>();

      map["business_or_customer"] = 0;
      map["items"] = ([
        for (int i = 0; i < cart.length; i++)
          if (cart[i].sku!.isNotEmpty && cart[i].qty != null && cart[i].qty != 0 && cart[i].qty != '0'){
              "product_or_category_details": cart[i].sku,
              "quantity": cart[i].qty,
          }
      ]);
      map["name"] = txt_name.text.toString();
      map["email"] = txt_email.text.toString();
      map["phone"] = controller.text.toString();
      map["description"] = txt_description.text.toString();

      return map;
    }

    print(json.encode(toMap()));
    var response = await http.post(Uri.parse('${beasurl}rfq/create'),
        body: json.encode(toMap()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokanget',
        });
    print("response.body${response.body}");
    success =
        (BulkOrderModelMassege.fromJson(json.decode(response.body)).success);
    message =
        (BulkOrderModelMassege.fromJson(json.decode(response.body)).message);
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

        txt_email.clear();
        txt_name.clear();
        txt_description.clear();
        controller.clear();
        cart = [];
        cart.isEmpty;

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
    return BulkOrderModelMassege.fromJson(json.decode(response.body));
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content:  Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Bulk Order...")),
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
    // TODO: implement initState
    super.initState();
    setState(() {
      cart.add(SkuModelResponse(sku: ""));
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {
      return Scaffold(
        appBar: AppBar(
          leading:  IconButton(
            icon:  Icon(Icons.arrow_back_ios, color: colorblack54),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
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
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buying for Your Business?',
                      style: textstyleHeading3(context),
                    ),
                    Text(
                      'Get the Best Quotes',
                      style: textstyleHeading3(context),
                    ),
                    Text(
                      'Fill in the below fields to help us serve you better.',
                      style: textnormail(context),
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cart.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return CartWidget(
                              cart: cart, index: index, callback: refresh);
                        }),
                    cart.last.sku!.isNotEmpty
                        ? businesscard(context)
                        : Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 2,
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: colorgrey),
                              color: colorWhite,
                            ),
                            width: deviceWidth(context, 1.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16.5,
                                    backgroundColor: colorblack54,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: colorskyeblue,
                                      child: Icon(
                                        Icons.add,
                                        color: colorblack54,
                                      ),
                                    ),
                                  ),
                                  sizedboxwidth(10.0),
                                  Text(
                                    'ADD PRODUCT CATEGORY',
                                    style: textbold(context),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    checkbox(),
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
                                'Name*',
                                style: textstylesubtitle1(context),
                              ),
                              namefeild(),
                              sizedboxheight(10.0),
                              Text(
                                'Email*',
                                style: textstylesubtitle1(context),
                              ),
                              emailfeild(),
                              sizedboxheight(10.0),
                              Text(
                                'Phone No.*',
                                style: textstylesubtitle1(context),
                              ),
                              phonefeild(),
                              sizedboxheight(10.0),
                              Text(
                                'Description*',
                                style: textstylesubtitle1(context),
                              ),
                              descriptionfeild(),
                              sizedboxheight(10.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    sizedboxheight(10.0),
                    submitBtn(context),
                    sizedboxheight(10.0),
                  ],
                ),
              ),
            )
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
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: colorblack54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buying for Your Business?',
                    style: textstyleHeading3(context),
                  ),
                  Text(
                    'Get the Best Quotes',
                    style: textstyleHeading3(context),
                  ),
                  Text(
                    'Fill in the below fields to help us serve you better.',
                    style: textnormail(context),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cart.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return CartWidget(
                            cart: cart, index: index, callback: refresh);
                      }),
                  cart.last.sku!.isNotEmpty
                      ? businesscard(context)
                      : Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 2,
                            child: InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: colorgrey),
                                  color: colorWhite,
                                ),
                                width: deviceWidth(context, 1.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16.5,
                                        backgroundColor: colorblack54,
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: colorskyeblue,
                                          child: Icon(
                                            Icons.add,
                                            color: colorblack54,
                                          ),
                                        ),
                                      ),
                                      sizedboxwidth(10.0),
                                      Text(
                                        'ADD PRODUCT CATEGORY',
                                        style: textbold(context),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  checkbox(),
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
                              'Name*',
                              style: textstylesubtitle1(context),
                            ),
                            namefeild(),
                            sizedboxheight(10.0),
                            Text(
                              'Email*',
                              style: textstylesubtitle1(context),
                            ),
                            emailfeild(),
                            sizedboxheight(10.0),
                            Text(
                              'Phone No.*',
                              style: textstylesubtitle1(context),
                            ),
                            phonefeild(),
                            sizedboxheight(10.0),
                            Text(
                              'Description*',
                              style: textstylesubtitle1(context),
                            ),
                            descriptionfeild(),
                            sizedboxheight(10.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  sizedboxheight(10.0),
                  submitBtn(context),
                  sizedboxheight(10.0),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget productdetailsfeild() {
  //   return AllInputDesign(
  //     // inputHeaderName: 'User Name',
  //     // key: Key("email1"),
  //     floatingLabelBehavior: FloatingLabelBehavior.never,
  //     hintText: '',
  //     // controller: model.loginEmail,
  //     //autofillHints: [AutofillHints.email],
  //     textInputAction: TextInputAction.next,
  //
  //     keyBoardType: TextInputType.text,
  //     validatorFieldValue: 'product',
  //   //  validator: validateEmailField,
  //   );
  // }

  Widget brandfeild() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
      controller: txt_brand,
      //autofillHints: [AutofillHints.email],
      textInputAction: TextInputAction.done,

      keyBoardType: TextInputType.text,
      validatorFieldValue: 'brand',
      //  validator: validateEmailField,
    );
  }

  Widget namefeild() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Jone Doe',
      controller: txt_name,
      // autofillHints: [AutofillHints.name],
      textInputAction: TextInputAction.next,

      keyBoardType: TextInputType.name,
      validatorFieldValue: 'name',
      validator: validateName,
    );
  }

  Widget emailfeild() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
      controller: txt_email,
      autofillHints: [AutofillHints.email],
      textInputAction: TextInputAction.next,

      keyBoardType: TextInputType.emailAddress,
      validatorFieldValue: 'email',
      validator: validateEmailField,
    );
  }

  Widget phonefeild() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: colorgrey),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.only(left: 5),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {},
        onInputValidated: (bool value) {},
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: TextStyle(color: Colors.black),
        initialValue: number,
        textFieldController: controller,
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

  Widget descriptionfeild() {
    return AllInputDesign(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
      maxLines: 5,
      controller: txt_description,
      textInputAction: TextInputAction.done,
      keyBoardType: TextInputType.text,
      validatorFieldValue: 'description',
      validator: (value) {
        if (value.isEmpty) {
          return 'Description is Required.';
        }
      },
    );
  }

  Widget submitBtn(context) {
    return Button(
      buttonName: 'SUBMIT RFQ',
      btnstyle: textstylesubtitle1(context)!.copyWith(color: colorWhite),
      borderRadius: BorderRadius.circular(5),
      onPressed: () {

          if( cart.isNotEmpty  )
            if (_formKey.currentState!.validate()) {
              addbulkorder();
            }


      },
    );
  }

  Widget businesscard(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 2,
        child: InkWell(
          onTap: () {
            setState(() {
              setState(() {});
              if (cart.last.sku!.isNotEmpty && cart.last.qty!.isNotEmpty) {
                cart.add(SkuModelResponse(sku: ""));
              }
              ;
              print('aman');
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: colorblue),
              color: colorskyeblue,
            ),
            width: deviceWidth(context, 1.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
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
                  Text(
                    'ADD PRODUCT CATEGORY',
                    style: textbold(context),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool rememberMe = false;

  Widget checkbox() {
    return Row(
      children: [
        Checkbox(
            value: rememberMe,
            onChanged: (value) {
              setState(() {
                rememberMe = !rememberMe;
              });
            }),
        Text(
          'I AM BUSINESS CUSTOMER',
          style: textbold(context)!.copyWith(color: colorblue),
        ),
      ],
    );
  }
}

class CartWidget extends StatefulWidget {
  List<SkuModelResponse>? cart;
  int? index;
  VoidCallback? callback;

  CartWidget({this.cart, this.index, this.callback});
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  Future? _future;
  var tokanget;

  String? dropdownvalue;
  List<SkuModelResponse>? Sukitemslist;
  TextEditingController qutcontroller = TextEditingController();
  ProgressDialog? progressDialog;
  var success, message;

  Future<SkuModelMassege> brenddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');

    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(Text("Loading...."));
        // progressDialog?.show();
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
    var response =
        await http.get(Uri.parse(beasurl + 'getAllProductsSKU'), headers: {
      'Authorization': 'Bearer $tokanget',
    });
    print(response.body);
    success = (SkuModelMassege.fromJson(json.decode(response.body)).success);
    message = (SkuModelMassege.fromJson(json.decode(response.body)).message);
    Sukitemslist = (SkuModelMassege.fromJson(json.decode(response.body)).data);
    progressDialog!.dismiss();
    if (success == true) {
      progressDialog!.dismiss();
      Sukitemslist =
          (SkuModelMassege.fromJson(json.decode(response.body)).data);
    } else {
      print('else==============');
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return SkuModelMassege.fromJson(json.decode(response.body));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = brenddata();
  }

  String? _value;
  @override
  void didUpdateWidget(oldWidget) {
    if (oldWidget.cart![widget.index!].sku !=
        widget.cart![widget.index!].sku!) {
      _value = widget.cart![widget.index!].sku!;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product/Category Details*',
              style: textstylesubtitle1(context),
            ),
            Container(
                width: deviceWidth(context),
                decoration: BoxDecoration(
                    border: Border.all(color: colorgrey),
                    borderRadius: BorderRadius.circular(8)),
                height: 45,
                padding: EdgeInsets.only(left: 10, right: 10),
                child: FutureBuilder(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint:  Text("Select SKU"),
                              onChanged: (String? value) {
                                setState(() {
                                  _value = value!;
                                  widget.cart![widget.index!].sku = value;
                                });
                              },
                              value: _value,
                              items: Sukitemslist!.map((map) {
                                return  DropdownMenuItem<String>(
                                  value: map.sku,
                                  child:  Text(map.sku!,
                                      style:
                                           TextStyle(color: Colors.black)),
                                );
                              }).toList(),
                            ),
                          ),
                          //  Expanded(child: Pizza(cartItem: widget.cart![widget.index!] ,sukitemslist:Sukitemslist!)),
                        ],
                      );
                    } else {
                      return const Center();
                    }
                  },
                )),
            // productdetailsfeild(),
            sizedboxheight(10.0),
            Text(
              'Qty*',
              style: textstylesubtitle1(context),
            ),
            Container(
              height: 48,
              child: TextField(
                controller: qutcontroller,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: colorblack,
                    // fontFamily: 'Nunito',
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
                onSubmitted: (text) {
                  setState(() {
                    widget.cart![widget.index!].qty = text.toString();
                  });
                },
                onChanged: (text) {
                  setState(() {
                    widget.cart![widget.index!].qty = text.toString();
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorWhitetextfield,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colorblue, width: 0.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colorgrey, width: 0.8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colorblue, width: 0.6),
                  ),
                ),
              ),
            ),
            /*     AllInputDesign(
              controller: qutcontroller,
              onSubmitted: (text){
                setState(() {
                 widget.cart![widget.index!].qty = text.toString();
                });
               },
              onSaved: (text){
                setState(() {
                  widget.cart![widget.index!].qty = text.toString();
                });
              },
              onChanged: (text){
                setState(() {
                  widget.cart![widget.index!].qty = text.toString();
                });
              },

            ),*/

            sizedboxheight(10.0),
            /*Text('Brand*',style: textstylesubtitle1(context),),
             brandfeild(),
             sizedboxheight(10.0),*/
          ],
        ),
      ),
    );
  }
}
