// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/cartmodel/card_data.dart';
import 'package:sbm/model/cartmodel/cartsmodel.dart';

import '../server_url.dart';

class AppbarmodalPage extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  incrementCounter() {
    _counter++;
    notifyListeners();
    print('counter>>>>...  $_counter');
  }

  counterreset() {
    _counter = 0;
    notifyListeners();

    print('counter>>>>  $_counter');
  }

  int _showFilterValues = 0;
  int get showFilterValues => _showFilterValues;

  // String? _tokanget;
  // String? get tokanget => _tokanget;
  //
  //
  // bool? _success;
  // bool?get success => _success;
  //
  //  String?  _message;
  //  String?get message =>  _message;
  //
  // List <Items> itemsdata= [];
  //
  // Future<CartsDataModelMassege> productdetacardlist(context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _tokanget = prefs.getString('login_user_token');
  //   _tokanget = tokanget!.replaceAll('"', '');
  //   check().then((intenet) {
  //     if (intenet != null && intenet) {
  //       // progressDialog = ProgressDialog(context, dismissable: false);
  //       // progressDialog?.setMessage(Text("Loading...."));
  //        // progressDialog?.show();
  //
  //     }else{
  //       Fluttertoast.showToast(
  //           msg: "Please check your Internet connection!!!!",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           backgroundColor: colorblue,
  //           textColor:colorWhite,
  //           fontSize: 16.0);
  //     }
  //   });
  //   var response = await http.get(Uri.parse(beasurl+'carts'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $tokanget',
  //       });
  //   _success = (CartsDataModelMassege.fromJson(json.decode(response.body)).success);
  //   _message = (CartsDataModelMassege.fromJson(json.decode(response.body)).message.toString());
  //   if(success==true){
  //       itemsdata = (CartsDataModelMassege.fromJson(json.decode(response.body)).data!.items)!;
  //   }else{
  //     Navigator.pop(context);
  //     Fluttertoast.showToast(
  //         msg: _message!,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: colorblue,
  //         textColor: colorWhite,
  //         fontSize: 16.0);
  //   }
  //   return CartsDataModelMassege.fromJson(json.decode(response.body));
  // }
  //
  // Future<bool> check() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     return true;
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     return true;
  //   }
  //   return false;
  // }
}
