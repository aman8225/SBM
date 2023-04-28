import 'dart:convert';
import 'dart:core';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/appbar/appbarwidgetpage.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/aboutus_model/aboutus_model.dart';
import 'package:sbm/model/cartmodel/cartsmodel.dart';
import 'package:sbm/screens/all%20cotegories/allcategories.dart';
import 'package:sbm/screens/home/homescreen.dart';
import 'package:sbm/screens/my%20account/myaccount.dart';
import 'package:sbm/screens/news%20uplodes/newsuplodes.dart';
import 'package:http/http.dart' as http;
import 'package:sbm/screens/notification/notification.dart';
import '../../screens/my items/myitems.dart';
import '../../screens/my order/myorder.dart';
import '../server_url.dart';

class BottomnavbarModelPage extends ChangeNotifier {
  int _bottombarzindex = 2;
  int get bottombarzindex => _bottombarzindex;

  final List _bottombarScreens = [
     MyAccount(),
     AllCategories(),
     Home(),
     MyOrder(),
     MyItems(),
  ];

  List get bottombarScreens => _bottombarScreens;

  toggle(context, index) async {
    if (index == 10) {
      // var dbcontroller = Provider.of<DashboardModelPage>(context, listen: false);
      // if (dbcontroller.isGeustLoggedIn) {
      //   await geustloginfirst(context);
      // } else {
      //   _bottombarzindex = index;
      //   notifyListeners();
      // }
    } else {
      _bottombarzindex = index;
      notifyListeners();
    }
  }

  togglebottomindexreset() {
    _bottombarzindex = 2;
    notifyListeners();
  }

  accountpage() {
    _bottombarzindex = 0;
    notifyListeners();
  }

  categoriespage() {
    _bottombarzindex = 1;
    notifyListeners();
  }

  newspage() {
    _bottombarzindex = 3;
    notifyListeners();
  }

  String? _tokanget11;
  String? get tokanget11 => _tokanget11!;

  ProgressDialog? progressDialog;

  bool? _success11;
  bool? get success11 => _success11;

  String? _message11;
  String? get message11 => _message11;

  Data? _aboutusdatalist;
  Data? get aboutusdatalist => _aboutusdatalist;

  Future<AboutUsModelMassege> aboutusdata(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget11 = prefs.getString('login_user_token');
    _tokanget11 = tokanget11!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(const Text("Loading...."));
      } else {
        Fluttertoast.showToast(
            msg: "Please check your Internet connection!!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: colorblue,
            textColor: colorWhite,
            fontSize: 16.0);
      }
    });
    var response =
        await http.get(Uri.parse('${beasurl}pages/about-us'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_tokanget11',
    });
    _success11 =
        (AboutUsModelMassege.fromJson(json.decode(response.body)).success);
    _message11 =
        (AboutUsModelMassege.fromJson(json.decode(response.body)).message);

    progressDialog!.dismiss();
    if (success11 == true) {
      progressDialog!.dismiss();
      _aboutusdatalist =
          (AboutUsModelMassege.fromJson(json.decode(response.body)).data);
    } else {
      print('else==============');
    }
    return AboutUsModelMassege.fromJson(json.decode(response.body));
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

  Future? _future1;
  String? _tokanget;
  String? get tokanget => _tokanget!;


  bool? _success;
  bool? get success => _success;

  String? _message;
  String? get message => _message;
  Future<CartsDataModelMassege> productdetacardlistdata(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(Text("Loading...."));

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
    print(beasurl + 'carts');
    print(tokanget);
    var response = await http.get(Uri.parse(beasurl + 'carts'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    var a = json.decode(response.body);
    var b = a['message'];
    if (b == 'You have no items in your shopping cart.') {
     // Navigator.pop(context);
        prefs.setString(
          'cart_item_length',
          "0",
        );
        notificationactionWidget(context);

    }
    _success =
    (CartsDataModelMassege.fromJson(json.decode(response.body)).success);
    _message = (CartsDataModelMassege.fromJson(json.decode(response.body))
        .message
        .toString());
    if (success == true) {
      // Navigator.pop(context);
      progressDialog!.dismiss();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", true);
      if (b != 'You have no items in your shopping cart.'){
        prefs.setString(
          'cart_item_length',
          json.encode(
            (CartsDataModelMassege.fromJson(json.decode(response.body)).data!.items!.length),
          ),
        );
      }

        abc(context);
        notificationactionWidget(context);
      progressDialog!.dismiss();
    } else {
      Navigator.pop(context);
      progressDialog!.dismiss();
      print('else==============');
      Fluttertoast.showToast(
          msg: message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return CartsDataModelMassege.fromJson(json.decode(response.body));
  }
}
