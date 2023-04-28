import 'dart:convert';
import 'dart:core';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/appbar/appbarwidgetpage.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/cartmodel/SerchBar/serch_bar_model.dart';
import 'package:sbm/model/cartmodel/add_to_card_mode/add_to_card_mode.dart';
import 'package:sbm/screens/all%20cotegories/my%20cart/my_card_page.dart';
import 'package:sbm/model/prodectdetelsmodel/Data.dart';
import 'package:http/http.dart' as http;

class AddToCardScreen extends StatefulWidget {
  List<Variant>? stributdata;
  String? price;
  int? productid;
  String? page;
  String? sku;
  String? cartonQty;

  AddToCardScreen({Key? key, this.stributdata, this.price, this.productid, this.page, this.sku, this.cartonQty})
      : super(key: key);

  @override
  State<AddToCardScreen> createState() => _AddToCardScreenState();
}

class _AddToCardScreenState extends State<AddToCardScreen> {
  List<Variant>? users;
  List<Variant>? selectedUsers;
  List<Variant>? distinctIds;


  late FocusNode gfgFocusNode;

  TextEditingController? qtycontroller;
  TextEditingController? textEditingController;
  @override
  void initState() {
    selectedUsers = [];
    selectedUsers = [];
    distinctIds = [];
    users = widget.stributdata;
    selectedUsers!.remove;
    selectedUsers!.clear();

    distinctIds!.isEmpty;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  ProgressDialog? progressDialog;

  var success, message;

  var tokanget;
  Future<AddToCardModeMassege> addtocarddata(int id) async {
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
      var map =  Map<String, dynamic>();
      map["product_id"] = id;
      map["product_option"] = ([
        for(int i = 0; i < distinctIds!.length; i++)
          if (distinctIds![i].qut != null && distinctIds![i].qut != 0) {
             "variant_id": distinctIds![i].id,
             "quantity": distinctIds![i].qut,
          }
      ]);
      return map;
    }
    print(json.encode(toMap()));

    var response = await http.post(Uri.parse('${beasurl}carts/add'),
        body: json.encode(toMap()),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Content-Type': 'application/json'
        });
    print(response.body);
    success =
        (AddToCardModeMassege.fromJson(json.decode(response.body)).success);
    message =
        (AddToCardModeMassege.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success}");
    if (success == true) {
      for (int i = 0; i < distinctIds!.length; i++) {
        distinctIds![i].iconcolore = false;
        distinctIds![i].totalprice = 0;
        distinctIds![i].qut = 0;
        users![i].iconcolore = false;
        users![i].totalprice = 0;
        users![i].qut = 0;
      }
      selectedUsers!.clear();
      distinctIds!.clear();
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", true);
      Get.off(() => MyCardPage());
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (_) => MyCardPage()));

      notificationactionWidget(context);
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
    return AddToCardModeMassege.fromJson(json.decode(response.body));
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
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Confirm Order...")),
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

  // onSelectedRow(bool selected, ProductsAttributes user) async {
  //   setState(() {
  //     if (selected) {
  //       selectedUsers!.add(user);
  //       print(selectedUsers!.length);
  //     } else {
  //       selectedUsers!.remove(user);
  //       print(selectedUsers!.length);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding:
                  const EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 10),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        sizedboxheight(10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 80,
                              child: Text(
                                'PLEASE CONFIRM YOUR-SIZE AND QUANTITY',
                                style: textstylesubtitle1(context)!.copyWith(
                                    color: colorblack,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                color: colorblue,
                                child: Icon(
                                  Icons.close_rounded,
                                  color: colorWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Center(
                            child: Text(
                          'PLEASE CONFIRM YOUR-SIZE AND QUANTITY',
                          style: textnormail(context)!.copyWith(
                            color: colorblack,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )),
                        sizedboxheight(10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Item Group : ${widget.sku}',
                              style: textnormail(context)!.copyWith(
                                color: colorblack,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Text(
                              'Carton Qty : ${widget.cartonQty}',
                              style: textnormail(context)!.copyWith(
                                color: colorblack,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        sizedboxheight(10.0),
                        dataBody(),
                        sizedboxheight(20.0),
                        addbut(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool hide = false;
  bool closetyping = true;

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        showCheckboxColumn: false,
        columnSpacing: 25,
        dataRowHeight: 55,
        dividerThickness: 0,
        headingRowHeight: 30,
        columns: [
          DataColumn(
            label: Expanded(
                child: Text("Variant",
                    style: textbold(context)!.copyWith(
                      fontSize: 10,
                      color: colorblack54,
                    ),
                    maxLines: 2)),
            numeric: false,
          ),
          DataColumn(
            label: Expanded(
                child: Text("Quantity",
                    style: textbold(context)!
                        .copyWith(fontSize: 10, color: colorblack54),
                    maxLines: 2)),
            numeric: false,
          ),
          DataColumn(
            label: Expanded(
                child: Text("Price",
                    style: textbold(context)!
                        .copyWith(fontSize: 10, color: colorblack54),
                    maxLines: 2)),
            numeric: false,
          ),
          DataColumn(
            label: Expanded(
                child: Text(
              "Total Price",
              style: textbold(context)!
                  .copyWith(fontSize: 10, color: colorblack54),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )),
            numeric: false,
          ),
        ],
        rows: widget.stributdata!
            .map(
              (user) => DataRow(
                  color:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  selected: selectedUsers!.contains(user),
                  onSelectChanged: (b) {
                    if (user.qut != null) {
                      // onSelectedRow(b!, user);
                    }
                  },
                  cells: [
                    //for(int j=0; j<=(selectedUsers!.length==null?0:selectedUsers!.length);j++)
                    DataCell(
                      Container(
                        width: 60,
                        child: Row(
                          children: [
                            (user.iconcolore == null ? false : user.iconcolore!)
                                ? Image.asset(
                                    'assets/icons/check-blue@3x.png',
                                    scale: 3.5,
                                  )
                                : Image.asset(
                                    'assets/icons/check-grey-1@3x.png',
                                    scale: 3.5,
                                  ),
                            Container(
                                width: 42,
                                child: Text(
                                  ((user.itemCode!.contains("-"))? (user.itemCode!.split('-')[1] ): (user.itemCode!)),
                                  style: textbold(context)!.copyWith(
                                      fontSize: 11, color: colorblack54),
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        ),
                      ),
                      // Text(user.variant!,style: textbold(context)!.copyWith(fontSize: 11,color: colorblack54),),
                    ),
                    DataCell(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          user.stock! > 0
                              ? Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: colorgrey)),
                                  height: 25,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: qtycontroller,
                                    // autofocus: true,
                                    enableInteractiveSelection: false,
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    minLines: 1,
                                    onTap: () {

                                      if (selectedUsers!.contains(user.id)) {

                                      } else {
                                        selectedUsers!.add(user);
                                        distinctIds = selectedUsers!.toSet().toList();
                                      }
                                    },
                                    onChanged: (text) {
                                      setState(() {
                                        if (text.isEmpty) {
                                          selectedUsers!.remove(user);
                                          distinctIds!.remove(user);
                                          user.iconcolore = false;
                                          user.totalprice = 0.0;
                                        } else if (text.isNotEmpty) {
                                          user.iconcolore = true;
                                        }
                                      });
                                      setState(() {
                                        if (user.qut == null && user.qut == 0)
                                        user.qut = 0;
                                        user.qut = int.parse(text);
                                        user.totalprice = (double.parse(user.qut.toString()) * double.parse(widget.price.toString()));
                                      });
                                    },
                                    decoration: InputDecoration(
                                        hintText: '0',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontSize: 11,
                                          color: colorblack,
                                        )),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: colorgrey)),
                                  height: 25,
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: '0',
                                    enableInteractiveSelection: false,
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                        hintText: '0',
                                        border: InputBorder.none,
                                        // hintText: '${itemsdata[index].quantity}',
                                        hintStyle: TextStyle(
                                          fontSize: 11,
                                          color: colorblack,
                                        )),
                                  ),
                                ),
                          Text(
                            'In Stock: ${user.stock!} ',
                            style: textnormail(context)!.copyWith(
                                fontSize: 10,
                                color:
                                    user.stock == 0 ? Colors.red : colorblack),
                          ),
                        ],
                      ),

                      // Text(user.qut!),
                    ),
                    DataCell(
                      Text(
                        'AED ${widget.price}',
                        style: textbold(context)!
                            .copyWith(fontSize: 10, color: colorblue),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataCell(
                      Text(
                        'AED ${user.totalprice == null ? 0.0 : user.totalprice!.toStringAsFixed(2)}',
                        style: textbold(context)!
                            .copyWith(fontSize: 10, color: colorblue),
                        textAlign: TextAlign.center,
                      ),
                      // Text('AED ${user.totalprice!}',style: textbold(context)!.copyWith(fontSize: 11,color: colorblue),),
                    ),
                  ]),
            )
            .toList(),
      ),
    );
  }
  var aa = 0;
  bool bb = false ;
  void asasa(){
    aa = distinctIds!.length-1;

    for(int i = 0; i <  distinctIds!.length ;i++){
      print(aa);
      print(i);
      if(distinctIds![i].stock! < int.parse(distinctIds![i].qut.toString()) )
      {
        setState((){
          aa = aa+1;
        });
        Fluttertoast.showToast(
            msg: "Valu Must be less than or ${distinctIds![i].stock} .",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: colorblue,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      else{

        if(aa == i){
          setState((){
            bb = true;
          });

        }
      }

    }
  }
  Widget addbut(context) {
    return Button(
      buttonName: 'CONFIRM ORDER',
      //btnstyle: textstylesubtitle1(context)!.copyWith(color: colorWhite,fontSize: 12),
      btnWidth: deviceWidth(context),
      key: Key('confirm_order'),
      borderRadius: BorderRadius.circular(5),
      onPressed: () {
        asasa();
if(bb){
  if (distinctIds!.length != null && distinctIds!.length != 0) {
    addtocarddata(widget.productid!);
  }
}



        //   for (int i = 0; i < distinctIds!.length; i++) {
        //     for (int j = 0; j < distinctIds![i].productsAttributes!.length;
        //     j++) {
        //       if (itemsdata[i].productsAttributes![j].stock! <
        //           itemsdata[i].productsAttributes![j].quantity) {
        //         setState(() {
        //           upadetcartdata(
        //               itemsdata[i].id,
        //               itemsdata[i].productsAttributes![j].variantId,
        //               itemsdata[i].productsAttributes![j].stock);
        //           list.add(itemsdata[i].productsAttributes![j].stock);
        //           list1.add(
        //               itemsdata[i].productsAttributes![j].quantity);
        //
        //           a = true;
        //         });
        //       } else if (a) {
        //         setState(() {
        //           status = true;
        //           adddesscard = true;
        //           productcard = false;
        //           paymentcard = true;
        //           cashvalue = 2;
        //
        //           sinincard1 = true;
        //           adddesscard1 = true;
        //           productcard1 = false;
        //           a = true;
        //         });
        //       } else {
        //         setState(() {
        //           status = true;
        //           adddesscard = true;
        //           productcard = true;
        //           paymentcard = false;
        //           cashvalue = 2;
        //           sinincard1 = true;
        //           adddesscard1 = true;
        //           productcard1 = true;
        //         });
        //       }
        //
        //   }
        //
        //   if (list.isNotEmpty && list1.isNotEmpty) {
        //     print("LISTENTER");
        //     showDialog<void>(
        //       context: context,
        //       barrierDismissible: false, // user must tap button!
        //       builder: (BuildContext context) {
        //         return AlertDialog(
        //           title: const Text('Cart Product Qty Update'),
        //           content: SingleChildScrollView(
        //             child: Column(
        //               children: [
        //                 for (int i = 0; i < list.length; i++) ...[
        //                   ListTile(
        //                     title: Text(
        //                         'JSO quantity update form ${list1[i].toString()} to ${list[i].toString()}'),
        //                     tileColor: Colors.redAccent.shade100,
        //                   ),
        //                   sizedboxheight(5.0),
        //                 ]
        //
        //                 // ListView.builder(
        //                 //     physics: const NeverScrollableScrollPhysics(),
        //                 //     shrinkWrap: true,
        //                 //   itemCount: list.length,
        //                 //     itemBuilder: (BuildContext context, int index){
        //                 //   return  ListTile(
        //                 //     title:  Text('JSO quantity update form ${list[index].toString()} to ${list1[index].toString()}'),
        //                 //     tileColor: Colors.redAccent.shade100,
        //                 //   );})
        //               ],
        //             ),
        //           ),
        //           actions: <Widget>[
        //             TextButton(
        //               child: const Text('Ok'),
        //               onPressed: () {
        //                 Navigator.of(context).pop();
        //                 list.clear();
        //                 list1.clear();
        //               },
        //             ),
        //           ],
        //         );
        //       },
        //     );
        //   } else {
        //     print("ELSE");
        //   }
        //   a = false;

      }
    );
  }
}
