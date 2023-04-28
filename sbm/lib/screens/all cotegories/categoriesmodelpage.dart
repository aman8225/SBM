// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/all_cotegories_data_model/all_cotegories_data_model.dart';
import 'checkboxmodel.dart';
import 'package:http/http.dart' as http;

class CategoriModelPage extends ChangeNotifier {
  int _showFilterValues = 0;
  int get showFilterValues => _showFilterValues;

  filterbtnkeyTap(index) {
    _showFilterValues = index;
    notifyListeners();
  }

  List<MultiselectCheckbox> filterpriceValues = [
    MultiselectCheckbox(
      title: 'Safety Shoes',
    ),
    MultiselectCheckbox(
      title: 'Safety Helmets',
    ),
    MultiselectCheckbox(
      title: 'Safety Jackets',
    ),
  ];
  List selectmulti = [];

  List<MultiselectCheckbox> filtercusRValues = [
    MultiselectCheckbox(
      title: 'Safety Shoes',
    ),
    MultiselectCheckbox(
      title: 'Safety Helmets',
    ),
    MultiselectCheckbox(
      title: 'Safety Jackets',
    ),
  ];
  List selectmultiCustomerR = [];

  List<MultiselectCheckbox> filterOfferRValues = [
    MultiselectCheckbox(
      title: 'Safety Shoes',
    ),
    MultiselectCheckbox(
      title: 'Safety Helmets',
    ),
    MultiselectCheckbox(
      title: 'Safety Jackets',
    ),
  ];
  List selectmultiOffer = [];

  List<MultiselectCheckbox> filterdiscountValues = [
    MultiselectCheckbox(
      title: 'Safety Shoes',
    ),
    MultiselectCheckbox(
      title: 'Safety Helmets',
    ),
    MultiselectCheckbox(
      title: 'Safety Jackets',
    ),
  ];
  List selectmultidiscount = [];

  List<MultiselectCheckbox> filterbudgetValues = [
    MultiselectCheckbox(
      title: 'Safety Shoes',
    ),
    MultiselectCheckbox(
      title: 'Safety Helmets',
    ),
    MultiselectCheckbox(
      title: 'Safety Jackets',
    ),
  ];
  List selectmultibudget = [];

  List<MultiselectCheckbox> filteravailabilityValues = [
    MultiselectCheckbox(
      title: 'Safety Shoes',
    ),
    MultiselectCheckbox(
      title: 'Safety Helmets',
    ),
    MultiselectCheckbox(
      title: 'Safety Jackets',
    ),
    MultiselectCheckbox(
      title: 'Respiratory Masks',
    ),
    MultiselectCheckbox(
      title: 'Safety Gloves',
    ),
    MultiselectCheckbox(
      title: 'Face Protection',
    ),
    MultiselectCheckbox(
      title: 'Work Wear',
    ),
    MultiselectCheckbox(
      title: 'Hearing Protection',
    ),
    MultiselectCheckbox(
      title: 'Trafic',
    ),
  ];
  List selectmultiavailability = [];

  // var tokanget;
  bool? _success;
  bool? get success => _success!;

  String? _tokanget;
  String? get tokanget => _tokanget!;

  String? _message;
  String? get message => _message!;

  ProgressDialog? progressDialog;

  List<AllCotegoriesDataModelResponse>? _filterkeybtnname;
  List<AllCotegoriesDataModelResponse>? get filterkeybtnname =>
      _filterkeybtnname!;

  Future<AllCotegoriesDataModelMassege> categoriesdata(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = tokanget!.replaceAll('"', '');
    print('${beasurl}products/getAllProductCategories');
    var response = await http
        .get(Uri.parse('${beasurl}products/getAllProductCategories'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_tokanget',
    });
    print('getAllProductCategories${response.body}');

    _success =
        (AllCotegoriesDataModelMassege.fromJson(json.decode(response.body))
            .success);
    _message =
        (AllCotegoriesDataModelMassege.fromJson(json.decode(response.body))
            .message);
    _filterkeybtnname =
        (AllCotegoriesDataModelMassege.fromJson(json.decode(response.body))
            .data);
   // progressDialog!.dismiss();
    if (success == true) {
    //  progressDialog!.dismiss();
    } else {
      print('else==============');
      Fluttertoast.showToast(
          msg: message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return AllCotegoriesDataModelMassege.fromJson(json.decode(response.body));
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
}
