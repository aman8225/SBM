import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/screens/my%20order/myorder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../common/appbar/appbarwidgetpage.dart';
import '../../../common/bottomnavbar/bottomnavbar.dart';
import '../../../common/server_url.dart';
import '../../../model/cartmodel/card_data.dart';
import '../../../model/cartmodel/cartsmodel.dart';
import '../../../model/orderseccess.dart';
import '../my cart/my_card_page.dart';

class OrderSuccess extends StatefulWidget {

  var orderid;
  OrderSuccess({Key? key, this.orderid}) : super(key: key);

  @override
  State<OrderSuccess> createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess> {
  Future? _future;
  Future? _future1;
  ProgressDialog? progressDialog;
  var tokanget;
  var success, message ;
  List<Items> itemsdata = [];
  Future<CartsDataModelMassege> productdetacardlistdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');

    var response = await http.get(Uri.parse('${beasurl}carts'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });

    success =
    (CartsDataModelMassege.fromJson(json.decode(response.body)).success);
    message = (CartsDataModelMassege.fromJson(json.decode(response.body))
        .message
        .toString());
    if (success == true) {
      progressDialog!.dismiss();
      setState(() {
        itemsdata = (CartsDataModelMassege.fromJson(json.decode(response.body))
            .data!
            .items)!;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", true);
      setState(() {
        prefs.setString(
          'cart_item_length',
          json.encode(
            (CartsDataModelMassege.fromJson(json.decode(response.body)).data!.items!.length),
          ),
        );
        notificationactionWidget(context);
      });
    } else {
      Navigator.pop(context);
      print('else==============');
    }
    return CartsDataModelMassege.fromJson(json.decode(response.body));
  }

  var successdata;
  var success1, message1 ;
  Future<OrderSaccess> ordersuccessdata() async {
    print(widget.orderid);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
  print('${beasurl}orders/${widget.orderid}');
    var response = await http.get(Uri.parse('${beasurl}orders/${widget.orderid}'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    print(response.body);
    success1 = (OrderSaccess.fromJson(json.decode(response.body)).success);
    print('${success1}>>>>>>>>>>>>>>>>>');
    message1 = (OrderSaccess.fromJson(json.decode(response.body)).message.toString());
    print('${message1}>>>>>>>>>>>>>>>>>');
    if (success1 == true) {
     // progressDialog!.dismiss();
      successdata = (OrderSaccess.fromJson(json.decode(response.body)).data!.id.toString());
      print('${successdata}>>>>>>>>>>>>>>>>>');
      _future = productdetacardlistdata();
    } else {
     // Navigator.pop(context);
      print('else==============');
    }
    return OrderSaccess.fromJson(json.decode(response.body));
  }
  @override
  void initState() {
    super.initState();
    _future1 = ordersuccessdata();
  }
  _willPopCallback() async {
    Get.off(() => BottomNavBarPage());
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return  _willPopCallback();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: deviceWidth(context, 0.2),
              height: deviceheight(context, 1.0),
              color: colorskyeblue,
            ),
            FutureBuilder(
              future: _future1,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: deviceWidth(context, 1.0),
                    height: deviceheight(context, 1.0),
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          sizedboxheight(100.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/icons/Group 2050@3x.png',
                                width: 45,
                                height: 45,
                              ),
                              sizedboxwidth(10.0),
                              Container(
                                width: deviceWidth(context, 0.6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ORDER SUCCESSFUL',
                                      style: textstyleHeading3(context)!
                                          .copyWith(color: colorblue),
                                    ),
                                    sizedboxheight(5.0),
                                    Text(
                                      'Thank you, your order has been successfuly placed ',
                                      style: textstylesubtitle2(context),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          sizedboxheight(20.0),
                          Card(
                            color: colorblacklight,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ORDER DETAILS:',
                                    style: textnormail(context)!
                                        .copyWith(color: colorWhite),
                                  ),
                                  sizedboxheight(10.0),
                                  Text(
                                    'Order ID: ${successdata??''}',
                                    style: textstyleHeading2(context)!
                                        .copyWith(color: colorWhite),
                                  ),
                                  sizedboxheight(10.0),
                                  Text(
                                    'Mode: Credit Used',
                                    style: textstylesubtitle1(context)!
                                        .copyWith(color: colorWhite),
                                  ),
                                  sizedboxheight(10.0),
                                  Text(
                                    "Your order is currently being processed. you will recieve"
                                        " an order confirmation email shortly delivery date for your items.",
                                    style: textnormail(context)!
                                        .copyWith(color: colorWhite),
                                  ),
                                  sizedboxheight(20.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      continuedhoppingBtn(context),
                                      orderBtn(context),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              // future: postlist(),
            ),
          ],
        ),
      ),);


  }

  Widget continuedhoppingBtn(context) {
    return Button(
      buttonName: 'CONTINUE SHOPPING',
      btnstyle: textstylesubtitle1(context)!.copyWith(color: colorWhite),
      btnWidth: deviceWidth(context, 0.45),
      key: const Key('shopping'),
      borderRadius: BorderRadius.circular(5),
      onPressed: () {
        Get.off(() => BottomNavBarPage());
      },
    );
  }

  Widget orderBtn(context) {
    return Button(
      buttonName: 'VIEW ORDER',
      btnColor: colorblacklight,
      borderColor: colorWhite,
      btnstyle: textstylesubtitle1(context)!.copyWith(color: colorWhite),
      btnWidth: deviceWidth(context, 0.3),
      key: const Key('order'),
      borderRadius: BorderRadius.circular(5),
      onPressed: () {
        Get.off(() => BottomNavBarPage());
      },
    );
  }
}
