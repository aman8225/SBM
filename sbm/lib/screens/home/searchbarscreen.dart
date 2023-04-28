import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/formtextfield/mytextfield.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/bulkordermodel/sku_model/sku_model.dart';
import 'package:http/http.dart' as http;
import 'package:sbm/screens/all%20cotegories/prodect%20list/prodect_list.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController txt_searchbar = TextEditingController();

  List<SkuModelResponse>? _allUsers = [];
  List<SkuModelResponse>? _foundUsers = [];

  Future? _future;
  var tokanget;

  String? dropdownvalue;
  // List<SkuModelResponse>? Sukitemslist;
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
    _allUsers = (SkuModelMassege.fromJson(json.decode(response.body)).data);
    progressDialog!.dismiss();
    if (success == true) {
      progressDialog!.dismiss();
      _allUsers = (SkuModelMassege.fromJson(json.decode(response.body)).data);
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
  initState() {
    // at the beginning, all users are shown
    _foundUsers = _allUsers;
    super.initState();
    _future = brenddata();
  }

  void _runFilter(String enteredKeyword) {
    List<SkuModelResponse>? results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers!
          .where((user) =>
              user.sku!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarbackbtnonly(context),
      body: Stack(
        children: [
          Container(
            width: deviceWidth(context, 0.2),
            height: deviceheight(context, 1.0),
            color: colorskyeblue,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  height: 48,
                  child: TextField(
                    onChanged: (value) => _runFilter(value),
                    controller: txt_searchbar,
                    decoration: InputDecoration(
                        fillColor: colorWhite,
                        filled: true,
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
                        hintText: 'Search',
                        suffixIcon: InkWell(
                            onTap: () {
                              Get.off(() => ProdectListPage(
                                  title: 'Products',
                                  Search: txt_searchbar.text.toString(),
                                  hide: 2));
                            },
                            child: Icon(
                              Icons.search,
                              size: 25,
                              color: colorgrey,
                            ))),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: _foundUsers!.isNotEmpty
                      ? ListView.builder(
                          itemCount: _foundUsers!.length,
                          itemBuilder: (context, index) => Card(
                            color: colorWhite,
                            child: InkWell(
                              onTap: () {
                                Get.off(() => ProdectListPage(
                                    title: 'Products',
                                    Search:
                                        (_foundUsers![index].sku.toString()),
                                    hide: 2));
                              },
                              child: ListTile(
                                leading: Text(
                                  _foundUsers![index].sku.toString(),
                                  style:
                                      TextStyle(fontSize: 16, color: colorgrey),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const Text(
                          'No results found',
                          style: TextStyle(fontSize: 24),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
// Widget serchbar() {
//   return AllInputDesign(
//     higthtextfield: 40.0,
//     // floatingLabelBehavior: FloatingLabelBehavior.never,
//     hintText: 'Search',
//     fillColor: colorWhite,
//     onChanged: (value) => _runFilter(value),
//     controller: txt_searchbar,
//     suffixIcon: Padding(
//       padding: const EdgeInsets.only(right: 20),
//       child: GestureDetector(
//           // onTap: (){
//           //   Get.to(() =>
//           //       ProdectListPage(
//           //           title: 'Products', Search: txt_searchbar.text.toString(), hide: 2));
//           // },
//           child: Icon(Icons.search,size: 25,color: colorgrey,)),
//     ),
//     keyBoardType: TextInputType.text,
//     validatorFieldValue: 'Search',
//
//   );
// }
}
