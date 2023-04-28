import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:sbm/screens/all%20cotegories/my%20cart/serchcart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/appbar/appbarwidgetpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar_modelpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbarwidget.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/bulkordermodel/sku_model/sku_model.dart';
import 'package:sbm/model/cartmodel/SerchBar/serch_bar_model.dart';
import 'package:sbm/model/cartmodel/card_data.dart';
import 'package:sbm/model/cartmodel/DeleteWishlistModel/DeleteWishlistModel.dart';
import 'package:sbm/model/cartmodel/cartsmodel.dart';
import 'package:sbm/screens/all%20cotegories/add_to_card_screen/add_to_card_screen.dart';
import 'package:sbm/screens/all%20cotegories/checkout%20product/checkout.dart';
import 'package:http/http.dart' as http;
import 'package:sbm/screens/all%20cotegories/my%20cart/update_card_model/update_card_model.dart';

import '../../../common/formtextfield/mytextfield.dart';
import '../prodect details/prodect_details.dart';

class MyCardPage extends StatefulWidget {
  const MyCardPage({Key? key}) : super(key: key);

  @override
  State<MyCardPage> createState() => _MyCardPageState();
}

class _MyCardPageState extends State<MyCardPage> {

  TextEditingController txt_searchbar = TextEditingController();
  List<SkuModelResponse>? _allUsers = [];
  List<SkuModelResponse>? _foundUsers = [];

 ///////////////// searchbar sku list ///////////
  Future? _future1;
  var tokanget;

  String? dropdownvalue;
  TextEditingController qutcontroller = TextEditingController();
  ProgressDialog? progressDialog;


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



  void _runFilter(String enteredKeyword) {
    List<SkuModelResponse>? results = [];
    if (enteredKeyword.isEmpty) {
      results = _allUsers;
    } else {
      results = _allUsers!
          .where((user) =>
          user.sku!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundUsers = results;
    });

  }

  //////////////////// productcarddatalist ///.//////

  Future? _future;

  var success, message, data, grandTotal, vat, vatAmount, deiscountamount ,cartond;
  var amountPayable;
  List<Items> itemsdata = [];
  List<ProductsAttributes> productsAttributes = [];
  String? quantity;
  Future<CartsDataModelMassege> productdetacardlistdata(show) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(Text("Loading...."));
        if (show == 1) progressDialog?.show();
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
    print('${beasurl}carts');
    var response = await http.get(Uri.parse('${beasurl}carts'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    print('carddetails api${response.body}');
    var a = json.decode(response.body);
    var b = a['message'];
    if (b == 'You have no items in your shopping cart.') {
      Navigator.pop(context);
      setState(() {
        prefs.setString(
          'cart_item_length',
          "0",
        );
        notificationactionWidget(context);
      });
    }
    print('carddetails api${response.body}');
    success =
        (CartsDataModelMassege.fromJson(json.decode(response.body)).success);

    message = (CartsDataModelMassege.fromJson(json.decode(response.body))
        .message
        .toString());
    if (success == true) {
      if (show == 1) Navigator.pop(context);
      progressDialog!.dismiss();
      setState(() {
        grandTotal = (CartsDataModelMassege.fromJson(json.decode(response.body))
            .data!
            .grandTotal);
        print('aman grandTotal1 ${grandTotal.toString()}');
        vat = (CartsDataModelMassege.fromJson(json.decode(response.body))
            .data!
            .vat);
        print('aman grandTotal2 ${vat.toString()}');
        vatAmount = (CartsDataModelMassege.fromJson(json.decode(response.body))
            .data!
            .vatAmount);
        print('aman grandTotal3 ${vatAmount.toString()}');
        amountPayable =
            (CartsDataModelMassege.fromJson(json.decode(response.body))
                .data!
                .amountPayable);
        print('aman grandTotal4 ${amountPayable.toString()}');
        itemsdata = (CartsDataModelMassege.fromJson(json.decode(response.body))
            .data!
            .items)!;
        print('aman grandTotal5 ${itemsdata.length}');
        productsAttributes =
            (CartsDataModelMassege.fromJson(json.decode(response.body))
                .data!
                .items![0]
                .productsAttributes)!;
        print('aman grandTotal6 ${productsAttributes.length}');
        deiscountamount = (CartsDataModelMassege.fromJson(json.decode(response.body)).data!.totalDiscount)!;
        print('aman grandTotal7 ${deiscountamount.toString()}');
        cartond = (CartsDataModelMassege.fromJson(json.decode(response.body)).data!.cartonsTotal)!;
        print('aman grandTotal${cartond.toString()}');
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

      progressDialog!.dismiss();
    } else {
      Navigator.pop(context);
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
    return CartsDataModelMassege.fromJson(json.decode(response.body));
  }


 //////////////////////// delete card list ///////////////////

  Future<DeleteCartProductModelMassege> deletewishlist(
      String product_Id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        showLoaderDialog(context, 'Delete Cart');
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
      map["product_id"] = product_Id.toString();
      return map;
    }
     print(toMap());
    var response = await http
        .post(Uri.parse('${beasurl}carts/destroy'), body: toMap(), headers: {
      'Authorization': 'Bearer $tokanget',
    });

    print(response.body);
    success =
        (DeleteCartProductModelMassege.fromJson(json.decode(response.body))
            .success);
    message =
        (DeleteCartProductModelMassege.fromJson(json.decode(response.body))
            .message);
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
        productdetacardlistdata(2);
        notificationactionWidget(context);
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
    return DeleteCartProductModelMassege.fromJson(json.decode(response.body));
  }

  showLoaderDialog(BuildContext context, text) {
    AlertDialog alert = AlertDialog(
      content:  Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("${text}...")),
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
/////////////////////// searchproductdata /////////////////

  SearchData? Serchdata;
  var uprice ;
  List<Variant>? productsAttributeslist;
  Future<SerchBarModel> searchproductdata(search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');

    check().then((intenet) {
      if (intenet != null && intenet) {
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
    print('${beasurl}productSearchBySKU?sku=$search');
    var response =
    await http.get(Uri.parse('${beasurl}productSearchBySKU?sku=$search'), headers: {
      'Authorization': 'Bearer $tokanget',
    });
    print(response.body);
    success = (SerchBarModel.fromJson(json.decode(response.body)).success);
    message = (SerchBarModel.fromJson(json.decode(response.body)).message);
    Serchdata = (SerchBarModel.fromJson(json.decode(response.body)).data);
    uprice = (SerchBarModel.fromJson(json.decode(response.body)).data!.regularPrice);
    productsAttributeslist = (SerchBarModel.fromJson(json.decode(response.body)).data!.variant);

    progressDialog!.dismiss();
    if (success == true) {
      progressDialog!.dismiss();
      Get.to(() => AddToCardScreen(
          stributdata: Serchdata!.variant,
          price: Serchdata!.uprice,
          productid: Serchdata!.id,
          sku: Serchdata!.sku,
          cartonQty: Serchdata!.cartonQty,
          page: "cart"));
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
    return SerchBarModel.fromJson(json.decode(response.body));
  }



  // TextEditingController txt_applycoopan = TextEditingController();
  //
  // var success1,message1,id,email;
  //
  //  // int? deiscountamount = 0 ;
  //  int? deiscountamount = 0 ;
  // Future<ApplyCoopanModeMassege> applycopandata() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   tokanget = prefs.getString('login_user_token');
  //   tokanget = tokanget!.replaceAll('"', '');
  //   check().then((intenet) {
  //     if (intenet != null && intenet) {
  //       showLoaderDialog(context ,'Apply Coopan');
  //     }else{
  //       Fluttertoast.showToast(
  //           msg: "Please check your Internet connection!!!!",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           backgroundColor: colorblue,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }
  //   });
  //   Map toMap() {
  //     var map = new Map<String, dynamic>();
  //     map["coupon_code"] = txt_applycoopan.text.toString();
  //     return map;
  //   }
  //   var response = await http.post(Uri.parse(beasurl+'applyCoupon'), body: toMap(),
  //       headers: {
  //         'Authorization': 'Bearer $tokanget',
  //       });
  //   success1 = (ApplyCoopanModeMassege.fromJson(json.decode(response.body)).success);
  //   message1 = (ApplyCoopanModeMassege.fromJson(json.decode(response.body)).message);
  //   print("success 123 ==${success1}");
  //   if(success1==true){
  //     deiscountamount = (ApplyCoopanModeMassege.fromJson(json.decode(response.body)).amount);
  //     if(success1==true){
  //       Navigator.pop(context);
  //       Fluttertoast.showToast(
  //           msg: message1,
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           backgroundColor: colorblue,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //         productdetacardlistdata(2);
  //
  //     }
  //   }else{
  //     Navigator.pop(context);
  //     print('else==============');
  //     Fluttertoast.showToast(
  //         msg: message1,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: colorblue,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  //   return ApplyCoopanModeMassege.fromJson(json.decode(response.body));
  // }

  var product_id, variant_id, update_quantity;

  Future<UpdateCardModelMassege> upadetcartdata(
      product_id, variant_id, update_quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        showLoaderDialog(context, 'updated Cart...');
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
      map["product_id"] = product_id.toString();
      map["variant_id"] = variant_id.toString();
      map["quantity"] = update_quantity.toString();

      return map;
    }

    var response = await http
        .post(Uri.parse('${beasurl}carts/update'), body: toMap(), headers: {
      'Authorization': 'Bearer $tokanget',
    });

    print(UpdateCardModelMassege.fromJson(json.decode(response.body)).data);
    print(UpdateCardModelMassege.fromJson(json.decode(response.body)).message);
    success =
        (UpdateCardModelMassege.fromJson(json.decode(response.body)).success);
    message =
        (UpdateCardModelMassege.fromJson(json.decode(response.body)).message);
    if (success == true) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
      productdetacardlistdata(2);
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
    return UpdateCardModelMassege.fromJson(json.decode(response.body));
  }

  TextEditingController? qty_controller;
  @override
  void initState() {
    super.initState();
    _future = productdetacardlistdata(1);
    _foundUsers = _allUsers;
    _future = brenddata();
  }

  final _formKey = GlobalKey<FormState>();
  double? add;

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {
      return Scaffold(
        appBar: appbarnotifav(
          context,
          'My Cart',
        ),
        body: Stack(
          children: [
            Container(
              width: deviceWidth(context, 0.2),
              height: deviceheight(context, 1.0),
              color: colorskyeblue,
            ),
            itemsdata.isNotEmpty? Form(
              key: _formKey,
              child: Container(
                height: deviceheight(context, 1.0),
                width: deviceWidth(context, 1.0),
                padding: EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5,right: 5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                              onTap: () {
                                Get.to(() => Serchcaet());
                              },
                              child: serchbar()),
                        ),
                      ),
                      FutureBuilder(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              // height: deviceheight(context,0.5),
                              // width: deviceWidth(context,1.0),
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemCount: itemsdata.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        color: colorskyeblue,
                                        elevation: 1,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: deviceWidth(context, 1.0),
                                              color: colorWhite,
                                              padding: const EdgeInsets.only(
                                                  bottom: 5, right: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: deviceWidth(
                                                        context, 0.83),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      mainAxisSize:
                                                      MainAxisSize.max,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProdectDetails(title: topsaleProducts[index].productName!,slug:topsaleProducts[index].slug!)));
                                                            Get.to(() => ProdectDetails(
                                                                title: itemsdata[index].productName!,
                                                                slug: itemsdata[index].slug!));
                                                          },
                                                          child: Container(
                                                              width: deviceWidth(context, 0.77),
                                                              height: 70,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child: Image.network(itemsdata[index].thumbnailImage!,
                                                                        width: deviceWidth(
                                                                            context,
                                                                            0.15),
                                                                        height: 60,
                                                                      )),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Text(
                                                                      itemsdata[
                                                                      index]
                                                                          .productName!,
                                                                      style: textstylesubtitle1(
                                                                          context),
                                                                      overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                      maxLines: 2,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                        ),
                                                        Container(
                                                          width: deviceWidth(
                                                              context, 0.05),
                                                          child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                deletewishlist(itemsdata[index].id.toString());
                                                              });
                                                            },
                                                            child:
                                                            SvgPicture.asset(
                                                              'assets/slicing 2/rubbish-bin.svg',
                                                              height: 15,
                                                              width: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() => ProdectDetails(
                                                          title: itemsdata[index].productName!,
                                                          slug: itemsdata[index].slug!));
                                                    },
                                                    child: Container(
                                                      width:
                                                      deviceWidth(context, 0.8),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            left: 12),
                                                        child: RichText(
                                                          text: TextSpan(children: <
                                                              InlineSpan>[
                                                            for (var string
                                                            in itemsdata[index]
                                                                .productCategories!)
                                                              TextSpan(
                                                                  text:
                                                                  "${string.categoryName!}, ",
                                                                  style: textnormail(
                                                                      context)!
                                                                      .copyWith(
                                                                      color:
                                                                      colorblue,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          ]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: deviceWidth(
                                                            context, 0.83),
                                                        child: DataTable(
                                                          columnSpacing: 25,
                                                          dataRowHeight: 30,
                                                          headingRowHeight: 30,
                                                          horizontalMargin: 10,
                                                          dividerThickness:
                                                          0.0000000001,
                                                          columns: <DataColumn>[
                                                            DataColumn(
                                                              label: Text(
                                                                'Size',
                                                                style: textbold(
                                                                    context),
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: Text(
                                                                'Quantity',
                                                                style: textbold(
                                                                    context),
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: Text(
                                                                'Cartons',
                                                                style: textbold(
                                                                    context),
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: Text(
                                                                'Price',
                                                                style: textbold(
                                                                    context),
                                                              ),
                                                            ),
                                                          ],
                                                          rows: itemsdata[index]
                                                              .productsAttributes! // Loops through dataColumnText, each iteration assigning the value to element
                                                              .map(
                                                            ((element) =>
                                                                DataRow(
                                                                  cells: <
                                                                      DataCell>[
                                                                    DataCell(
                                                                        Text(
                                                                          element.itemCode!,
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                              11),
                                                                        )), //Extracting from Map element the value
                                                                    DataCell(
                                                                        Container(
                                                                          decoration:
                                                                          BoxDecoration(border: Border.all(color: colorgrey)),
                                                                          height:
                                                                          30,
                                                                          child:
                                                                          TextFormField(
                                                                            keyboardType: TextInputType.number,
                                                                            controller: qty_controller,
                                                                            style: TextStyle(fontSize: 11),
                                                                            initialValue: '${element == '0' ? 1 : element.quantity}',
                                                                            enableInteractiveSelection: false,
                                                                            textAlign: TextAlign.center,
                                                                            textInputAction: TextInputAction.done,
                                                                            onFieldSubmitted: (text) {
                                                                              setState(() {
                                                                                if (int.parse(text) == 0) {
                                                                                  text = 1.toString();
                                                                                }else{
                                                                                  upadetcartdata(itemsdata[index].id, element.variantId, text);
                                                                                }
                                                                              });
                                                                            },
                                                                            onChanged:
                                                                                (text) {
                                                                              setState(() {
                                                                                if (int.parse(text) == 0) {
                                                                                  text = 1.toString();
                                                                                }
                                                                                upadetcartdata(itemsdata[index].id, element.variantId, text);
                                                                              });
                                                                            },
                                                                            decoration: InputDecoration(
                                                                                hintText: '1',
                                                                                border: InputBorder.none,
                                                                                fillColor: colorgrey,
                                                                                // hintText: '${itemsdata[index].quantity}',
                                                                                hintStyle: TextStyle(
                                                                                  fontSize: 11,
                                                                                  color: colorblack,
                                                                                )),
                                                                          ),
                                                                        )),
                                                                    // DataCell(Text('${element.quantity}',style: TextStyle(fontSize: 11),)),
                                                                    DataCell(
                                                                        Text(
                                                                          ((int.parse(element.quantity.toString())) / (int.parse(itemsdata[index].uSCartQty.toString()))).toStringAsFixed(2),
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                              11),
                                                                        )),
                                                                    DataCell(
                                                                        Text(
                                                                          'AED ${itemsdata[index].price.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              13,
                                                                              color:
                                                                              colorblue,
                                                                              fontWeight:
                                                                              FontWeight.bold),
                                                                        )),
                                                                  ],
                                                                )),
                                                          )
                                                              .toList(),
                                                        ),
                                                      ),
                                                      // Container(
                                                      //   width: deviceWidth(context,0.15),
                                                      //   child: Column(
                                                      //     crossAxisAlignment: CrossAxisAlignment.start,
                                                      //     children: [
                                                      //       Text('Price:'),
                                                      //       Text('AED ${itemsdata[index].subtotal!}',style: textstylesubtitle1(context)!.copyWith(color: colorblue,fontWeight: FontWeight.bold,fontSize: 13),overflow: TextOverflow.ellipsis,maxLines: 3,)
                                                      //     ],),
                                                      // )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .end,
                                                  children: [
                                                    // Container(
                                                    //   child: Row(
                                                    //     mainAxisAlignment:
                                                    //     MainAxisAlignment.end,
                                                    //     children: [
                                                    //       Text(
                                                    //         'Cartons Size: ',
                                                    //         style: textnormail(
                                                    //             context),
                                                    //       ),
                                                    //       Text(
                                                    //         '${itemsdata[index].uSCartQty!}',
                                                    //         style: textstylesubtitle1(
                                                    //             context)!
                                                    //             .copyWith(
                                                    //             color:
                                                    //             colorblue,
                                                    //             fontWeight:
                                                    //             FontWeight
                                                    //                 .bold),
                                                    //       )
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            'Price: ',
                                                            style: textnormail(
                                                                context),
                                                          ),
                                                          Text(
                                                            'AED ${itemsdata[index].subtotal!}',
                                                            style: textstylesubtitle1(
                                                                context)!
                                                                .copyWith(
                                                                color:
                                                                colorblue,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          } else {
                            //  Timer(
                            //   Duration(seconds: 3),
                            //       () {
                            //     // status ? Get.offAll(() => BottomNavBarPage()) : Get.offAll(() => IntroductionPage());
                            //         Center(
                            //               child: CircularProgressIndicator(),
                            //            );
                            //   },
                            // );
                            return Center(
                              child: Container(
                                height: deviceheight(context, 1.0),
                                width: deviceWidth(context, 1.0),
                                child: Center(child: Text('No Data')),
                              ),
                            );
                          }
                        },
                        // future: postlist(),
                      ),
                      sizedboxheight(10.0),
                      paymentsummarycard(context),
                      // sizedboxheight(5.0),
                      // itemsdata.length==0?Container():coopncard(context),
                      //
                      // deiscountamount==0?Container(): Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Text('Coupon applied successfully!  ',
                      //       style: textstylesubtitle1(context)!.copyWith(color:HexColor('20c997') ),),
                      //     Icon(Icons.check_circle_outline_outlined,color: HexColor('20c997'),)
                      //   ],
                      // ),
                      // success1!=false?Container():Text(' ${message1}',style: textstylesubtitle1(context)!.copyWith(color: Colors.red)),
                      // deiscountamount==0?Container():
                      // Text('TEST COUPON CODE Test',style: textstylesubtitle1(context)),
                      //
                      //
                      // deiscountamount==0?Container():
                      // InkWell(
                      //   onTap: (){
                      //     setState(() {
                      //       deiscountamount=0;
                      //     });
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Text('Clear promocode',style: textstylesubtitle1(context)!.copyWith(color: colorgrey)),
                      //       Icon(Icons.highlight_remove,color: colorgrey,)
                      //
                      //     ],
                      //   ),
                      // ),
                      sizedboxheight(10.0),
                      itemsdata.length == 0 ? Container() : checkoutBtn(context),
                      sizedboxheight(20.0),
                    ],
                  ),
                ),
              ) ,
            ):
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: InkWell(
                          onTap: () {
                            Get.to(() => Serchcaet());
                          },
                          child: serchbar()),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'No results found',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
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
          elevation: 2.0,
          child: SvgPicture.asset(
            'assets/slicing 2/home (10).svg',
            width: 25,
            height: 25,
            color: colorWhite,
          ),
        ),
        bottomNavigationBar: bottomNavBarPagewidget(context, model),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );});

    return Scaffold(
      appBar: appbarnotifav(
        context,
        'My Cart',
      ),
      body: Stack(
        children: [
          Container(
            width: deviceWidth(context, 0.2),
            height: deviceheight(context, 1.0),
            color: colorskyeblue,
          ),
          itemsdata.isNotEmpty? Form(
            key: _formKey,
            child: Container(
              height: deviceheight(context, 1.0),
              width: deviceWidth(context, 1.0),
              padding: EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            // height: deviceheight(context,0.5),
                            // width: deviceWidth(context,1.0),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: itemsdata.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: colorskyeblue,
                                      elevation: 1,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: deviceWidth(context, 1.0),
                                            color: colorWhite,
                                            padding: EdgeInsets.only(
                                                bottom: 5, right: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: deviceWidth(
                                                      context, 0.83),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                          width: deviceWidth(
                                                              context, 0.77),
                                                          height: 70,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Image
                                                                      .network(
                                                                    itemsdata[
                                                                            index]
                                                                        .thumbnailImage!,
                                                                    width: deviceWidth(
                                                                        context,
                                                                        0.15),
                                                                    height: 60,
                                                                  )),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  itemsdata[
                                                                          index]
                                                                      .productName!,
                                                                  style: textstylesubtitle1(
                                                                      context),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 2,
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                      Container(
                                                        width: deviceWidth(
                                                            context, 0.05),
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              deletewishlist(
                                                                  itemsdata[
                                                                          index]
                                                                      .id
                                                                      .toString());
                                                            });
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/slicing 2/rubbish-bin.svg',
                                                            height: 15,
                                                            width: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width:
                                                      deviceWidth(context, 0.8),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12),
                                                    child: RichText(
                                                      text: TextSpan(children: <
                                                          InlineSpan>[
                                                        for (var string
                                                            in itemsdata[index]
                                                                .productCategories!)
                                                          TextSpan(
                                                              text:
                                                                  "${string.categoryName!}, ",
                                                              style: textnormail(
                                                                      context)!
                                                                  .copyWith(
                                                                      color:
                                                                          colorblue,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: deviceWidth(
                                                          context, 0.83),
                                                      child: DataTable(
                                                        columnSpacing: 25,
                                                        dataRowHeight: 30,
                                                        headingRowHeight: 30,
                                                        horizontalMargin: 10,
                                                        dividerThickness:
                                                            0.0000000001,
                                                        columns: <DataColumn>[
                                                          DataColumn(
                                                            label: Text(
                                                              'Size',
                                                              style: textbold(
                                                                  context),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              'Quantity',
                                                              style: textbold(
                                                                  context),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              'Cartons',
                                                              style: textbold(
                                                                  context),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              'Price',
                                                              style: textbold(
                                                                  context),
                                                            ),
                                                          ),
                                                        ],
                                                        rows: itemsdata[index]
                                                            .productsAttributes! // Loops through dataColumnText, each iteration assigning the value to element
                                                            .map(
                                                              ((element) =>
                                                                  DataRow(
                                                                    cells: <
                                                                        DataCell>[
                                                                      DataCell(
                                                                          Text(
                                                                        '${element.itemCode!}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                11),
                                                                      )), //Extracting from Map element the value
                                                                      DataCell(
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(border: Border.all(color: colorgrey)),
                                                                        height:
                                                                            30,
                                                                        child:
                                                                            TextFormField(
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          controller:
                                                                              qty_controller,
                                                                          style:
                                                                              TextStyle(fontSize: 11),
                                                                          initialValue:
                                                                              '${element == '0' ? 1 : element.quantity}',
                                                                          enableInteractiveSelection:
                                                                              false,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          onFieldSubmitted:
                                                                              (text) {
                                                                            setState(() {
                                                                              if (int.parse(text) == 0) {
                                                                                text = 1.toString();
                                                                                print('addtext${text}');
                                                                              }
                                                                              upadetcartdata(itemsdata[index].id, element.variantId, text);
                                                                            });
                                                                          },
                                                                          onChanged:
                                                                              (text) {
                                                                            setState(() {
                                                                              if (int.parse(text) == 0) {
                                                                                text = 1.toString();
                                                                                print('addtext${text}');
                                                                              }
                                                                              upadetcartdata(itemsdata[index].id, element.variantId, text);
                                                                            });
                                                                          },
                                                                          decoration: InputDecoration(
                                                                              hintText: '0',
                                                                              border: InputBorder.none,
                                                                              fillColor: colorgrey,
                                                                              // hintText: '${itemsdata[index].quantity}',
                                                                              hintStyle: TextStyle(
                                                                                fontSize: 11,
                                                                                color: colorblack,
                                                                              )),
                                                                        ),
                                                                      )),
                                                                      // DataCell(Text('${element.quantity}',style: TextStyle(fontSize: 11),)),
                                                                      DataCell(
                                                                          Text(
                                                                        '${((int.parse(itemsdata[index].quantity.toString())) / (int.parse(itemsdata[index].uSCartQty.toString()))).toStringAsFixed(2)}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                11),
                                                                      )),
                                                                      DataCell(
                                                                          Text(
                                                                        'AED ${itemsdata[index].price.toString()}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                colorblue,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      )),
                                                                    ],
                                                                  )),
                                                            )
                                                            .toList(),
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   width: deviceWidth(context,0.15),
                                                    //   child: Column(
                                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                                    //     children: [
                                                    //       Text('Price:'),
                                                    //       Text('AED ${itemsdata[index].subtotal!}',style: textstylesubtitle1(context)!.copyWith(color: colorblue,fontWeight: FontWeight.bold,fontSize: 13),overflow: TextOverflow.ellipsis,maxLines: 3,)
                                                    //     ],),
                                                    // )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          'Cartons Size: ',
                                                          style: textnormail(
                                                              context),
                                                        ),
                                                        Text(
                                                          '${itemsdata[index].uSCartQty!}',
                                                          style: textstylesubtitle1(
                                                                  context)!
                                                              .copyWith(
                                                                  color:
                                                                      colorblue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          'Price: ',
                                                          style: textnormail(
                                                              context),
                                                        ),
                                                        Text(
                                                          'AED ${itemsdata[index].subtotal!}',
                                                          style: textstylesubtitle1(
                                                                  context)!
                                                              .copyWith(
                                                                  color:
                                                                      colorblue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          );
                        } else {
                          //  Timer(
                          //   Duration(seconds: 3),
                          //       () {
                          //     // status ? Get.offAll(() => BottomNavBarPage()) : Get.offAll(() => IntroductionPage());
                          //         Center(
                          //               child: CircularProgressIndicator(),
                          //            );
                          //   },
                          // );
                          return Center(
                            child: Container(
                              height: deviceheight(context, 1.0),
                              width: deviceWidth(context, 1.0),
                              child: Center(child: Text('No Data')),
                            ),
                          );
                        }
                      },
                      // future: postlist(),
                    ),
                    sizedboxheight(10.0),
                    paymentsummarycard(context),
                    // sizedboxheight(5.0),
                    // itemsdata.length==0?Container():coopncard(context),
                    //
                    // deiscountamount==0?Container(): Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Text('Coupon applied successfully!  ',
                    //       style: textstylesubtitle1(context)!.copyWith(color:HexColor('20c997') ),),
                    //     Icon(Icons.check_circle_outline_outlined,color: HexColor('20c997'),)
                    //   ],
                    // ),
                    // success1!=false?Container():Text(' ${message1}',style: textstylesubtitle1(context)!.copyWith(color: Colors.red)),
                    // deiscountamount==0?Container():
                    // Text('TEST COUPON CODE Test',style: textstylesubtitle1(context)),
                    //
                    //
                    // deiscountamount==0?Container():
                    // InkWell(
                    //   onTap: (){
                    //     setState(() {
                    //       deiscountamount=0;
                    //     });
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Text('Clear promocode',style: textstylesubtitle1(context)!.copyWith(color: colorgrey)),
                    //       Icon(Icons.highlight_remove,color: colorgrey,)
                    //
                    //     ],
                    //   ),
                    // ),
                    sizedboxheight(10.0),
                    itemsdata.length == 0 ? Container() : checkoutBtn(context),
                    sizedboxheight(20.0),
                  ],
                ),
              ),
            ) ,
          ):Padding(
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
                              if(txt_searchbar.text.isNotEmpty){
                                searchproductdata(txt_searchbar.text);
                              }
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
                          // Get.off(() => ProdectListPage(
                          //     title: 'Products',
                          //     Search:
                          //     (_foundUsers![index].sku.toString()),
                          //     hide: 2));
                          if(txt_searchbar.text.isNotEmpty){
                            searchproductdata(_foundUsers![index].sku);
                          }
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

  // Widget itamcard(context){
  //   return Card(
  //     color: colorskyeblue,
  //     elevation: 5,
  //     child: Column(
  //       children: [
  //         Container(
  //           color: colorWhite,
  //           width: deviceWidth(context,1.0),
  //           padding: EdgeInsets.all(5),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Image.asset('assets/img_2.png',width: deviceWidth(context,0.15),),
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                  width: deviceWidth(context,0.6),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text('Style No: LSA/(SBP Standard)',
  //                           style: textbold(context),),
  //                         Icon(Icons.delete,color: colorblue,size: 20,)
  //                       ],
  //                     ),
  //                   ),
  //                   sizedboxheight(10.0),
  //                   Container(
  //                     width: deviceWidth(context,0.75),
  //                     child: Table(
  //
  //                       defaultColumnWidth: FixedColumnWidth(deviceWidth(context,0.2)),
  //                       defaultVerticalAlignment: TableCellVerticalAlignment.middle,
  //
  //                       children: [
  //
  //                         TableRow( children: [
  //                           Column(children:[
  //                             Row(
  //                             children: [
  //                               Column(
  //                                 children: [
  //                                   Text('Siz:',style: textbold(context),),
  //                                 ],
  //                               ),
  //                               Column(
  //                                 children: [
  //                                   Text('38',style: textbold(context)!.copyWith(color: colorblue)),
  //                                 ],
  //                               ),
  //                             ],
  //                           )]),
  //                           Column(children:[
  //                             Row(
  //                             children: [
  //                               Column(
  //                                 children: [
  //                                   Text('Qty:',style: textbold(context),),
  //                                 ],
  //                               ),
  //                               Column(
  //                                 children: [
  //                                   Text('  01',style: textbold(context),),
  //                                 ],
  //                               ),
  //                             ],
  //                           )]),
  //                           Column(children:[
  //                             Row(
  //                               children: [
  //                                 Column(
  //                                   children: [
  //                                     Text('Price:',style: textbold(context),),
  //                                   ],
  //                                 ),
  //                                 Container(width: deviceWidth(context,0.15),
  //                                   child: Column(
  //                                     children: [
  //                                       Text('AED t20',style: textbold(context)!.copyWith(color: colorblue),),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ],
  //                             )]),
  //                         ]),
  //                         TableRow( children: [
  //                           Padding(
  //                             padding: const EdgeInsets.only(top: 8,bottom: 8),
  //                             child: Column(children:[
  //                               Row(
  //                                 children: [
  //                                   Column(
  //                                     children: [
  //                                       Text('Siz:',style: textbold(context),),
  //                                     ],
  //                                   ),
  //                                   Column(
  //                                     children: [
  //                                       Text('38',style: textbold(context)!.copyWith(color: colorblue)),
  //                                     ],
  //                                   ),
  //                                 ],
  //                               )]),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(top: 8,bottom: 8),
  //                             child: Column(children:[
  //                               Row(
  //                                 children: [
  //                                   Column(
  //                                     children: [
  //                                       Text('Qty:',style: textbold(context),),
  //                                     ],
  //                                   ),
  //                                   Column(
  //                                     children: [
  //                                       Text('  01',style: textbold(context),),
  //                                     ],
  //                                   ),
  //                                 ],
  //                               )]),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(top: 8,bottom: 8),
  //                             child: Column(children:[
  //                               Row(
  //                                 children: [
  //                                   Column(
  //                                     children: [
  //                                       Text('Price:',style: textbold(context),),
  //                                     ],
  //                                   ),
  //                                   Container(width: deviceWidth(context,0.15),
  //                                     child: Column(
  //                                       children: [
  //                                         Text('AED t20',style: textbold(context)!.copyWith(color: colorblue),),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ],
  //                               )]),
  //                           ),
  //                         ]),
  //                         TableRow( children: [
  //                           Column(children:[
  //                             Row(
  //                               children: [
  //                                 Column(
  //                                   children: [
  //                                     Text('Siz:',style: textbold(context),),
  //                                   ],
  //                                 ),
  //                                 Column(
  //                                   children: [
  //                                     Text('38',style: textbold(context)!.copyWith(color: colorblue)),
  //                                   ],
  //                                 ),
  //                               ],
  //                             )]),
  //                           Column(children:[
  //                             Row(
  //                               children: [
  //                                 Column(
  //                                   children: [
  //                                     Text('Qty:',style: textbold(context),),
  //                                   ],
  //                                 ),
  //                                 Column(
  //                                   children: [
  //                                     Text('  01',style: textbold(context),),
  //                                   ],
  //                                 ),
  //                               ],
  //                             )]),
  //                           Column(children:[
  //                             Row(
  //                               children: [
  //                                 Column(
  //                                   children: [
  //                                     Text('Price:',style: textbold(context),),
  //                                   ],
  //                                 ),
  //                                 Container(
  //                                   width: deviceWidth(context,0.15),
  //                                   child: Column(
  //                                     children: [
  //                                       Text('AED t20',style: textbold(context)!.copyWith(color: colorblue),),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ],
  //                             )]),
  //                         ]),
  //                       ],
  //                     ),
  //                   )
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               Text('Price:',style: textbold(context)),
  //               Text('AED 420',style: textstylesubtitle1(context)!.copyWith(color: colorblue)),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget paymentsummarycard(context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
              mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: Container(
                  width: deviceWidth(context, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //sizedboxheight(5.0),
                        Container(
                          width: deviceWidth(context, 1.0),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Expanded(
                                  child: Text(
                                    'Products Your Shopping cart contains ',
                                    style: textstylesubtitle1(context)!
                                        .copyWith(fontWeight: FontWeight.bold,),
                                      textAlign: TextAlign.start)),
                              Expanded(
                                  child: Text(
                                    itemsdata.length.toString() ,
                                    style: textstylesubtitle1(context)!
                                        .copyWith(fontWeight: FontWeight.bold, color: colorblue,),
                                      textAlign: TextAlign.end),),
                            ],
                          ),
                        ),
                          Divider(
                            thickness: 1,
                            color: colorgrey,
                          ),
                        sizedboxheight(5.0),
                        Container(
                          width: deviceWidth(context, 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  child: Text('Total no. of Cartons :',
                                      style: textstylesubtitle1(context)!
                                          .copyWith(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start)),
                              Expanded(
                                  child: Text(cartond.toString(),
                                      style: textstylesubtitle1(context)!
                                          .copyWith(fontWeight: FontWeight.bold, color: colorblue,),
                                      textAlign: TextAlign.end)),
                            ],
                          ),
                        ),

                        sizedboxheight(10.0),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Container(
                  width: deviceWidth(context, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Summary',
                          style: textstyleHeading3(context),
                        ),
                        //sizedboxheight(5.0),

                        sizedboxheight(10.0),
                        Container(
                          width: deviceWidth(context, 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  child: Text('Item Sub Total Amount:',
                                      style: textstylesubtitle1(context),
                                      textAlign: TextAlign.start)),
                              Expanded(
                                  child: Text('AED ${grandTotal.toString()}',
                                      style: textstylesubtitle1(context)!.copyWith(
                                          color: colorblue,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.end)),
                            ],
                          ),
                        ),
                        sizedboxheight(5.0),
                        Container(
                          width: deviceWidth(context, 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  child: Text(
                                'Total Discount:',
                                style: textstylesubtitle1(context),
                                textAlign: TextAlign.start,
                              )),
                              Expanded(
                                  child: Text(
                                'AED ${deiscountamount.toString()}',
                                style: textstylesubtitle1(context)!.copyWith(
                                    color: colorgreen, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              )),
                            ],
                          ),
                        ),
                        sizedboxheight(5.0),
                        Container(
                          width: deviceWidth(context, 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  child: Text('VAT($vat):',
                                      style: textstylesubtitle1(context),
                                      textAlign: TextAlign.start)),
                              Expanded(
                                  child: Text('AED ${vatAmount.toString()}',
                                      style: textstylesubtitle1(context)!
                                          .copyWith(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.end)),
                            ],
                          ),
                        ),

                        // sizedboxheight(8.0),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text('Total shiping:',style: textstylesubtitle1(context)),
                        //     Text('AED 100.00',style: textstylesubtitle1(context)),
                        //   ],
                        // ),
                        //sizedboxheight(5.0),

                        sizedboxheight(5.0),
                        Container(
                          width: deviceWidth(context, 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  child: Text('Amount Payable:',
                                      style: textstylesubtitle1(context)!
                                          .copyWith(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start)),
                              Expanded(
                                  child: Text(
                                      'AED ${(amountPayable!.toStringAsFixed(2))}',
                                      style: textstyleHeading6(context)!.copyWith(
                                          color: colorblue,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.end)),
                            ],
                          ),
                        ),
                        sizedboxheight(10.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center();
        }
      },
      // future: postlist(),
    );
  }

  // Widget coopncard(context){
  //   return Card(
  //     child: Container(
  //       width: deviceWidth(context,1.0),
  //       child: coopnfield(context),
  //     ),
  //   );
  // }

  // Widget coopnfield(context) {
  //   return AllInputDesign(
  //     widthtextfield: deviceWidth(context,1.0),
  //     enabledBorderRadius: BorderRadius.circular(0),
  //     focusedBorderRadius: BorderRadius.circular(0),
  //     floatingLabelBehavior: FloatingLabelBehavior.never,
  //     hintText: 'Enter Promo Code Here',
  //      controller: txt_applycoopan,
  //     autofillHints: [AutofillHints.postalCode],
  //     textInputAction: TextInputAction.done,
  //     suffixIcon:applyBtn(context),
  //     keyBoardType: TextInputType.text,
  //     validatorFieldValue: 'promo_code',
  //   validator:  (value) {
  //   if (value.isEmpty) {
  //   return 'Required Promo Code.';
  //   }
  //
  //   },
  //   );
  // }

  // Widget applyBtn(context) {
  //   return Button(
  //     buttonName: 'APPLY',
  //     btnWidth: deviceWidth(context,0.25),
  //     key: Key('apply'),
  //     btnColor: colorblack,
  //     borderRadius: BorderRadius.circular(0),
  //
  //     onPressed: () {
  //       if(_formKey.currentState!.validate()){
  //         if(txt_applycoopan.text.isNotEmpty){
  //           applycopandata();
  //         }
  //       }
  //
  //     //  applycopandata();
  //       // Get.to(() => BottomNavBarPage());
  //     },
  //   );
  // }

  Widget checkoutBtn(context) {
    return Button(
      buttonName: 'PROCEED TO CHECKOUT',
      key: Key('checkout'),
      borderRadius: BorderRadius.circular(5),
      onPressed: () {
        print(itemsdata.length);
        if (itemsdata.length != 0) {
          Get.off(() => CheckoutPage());
        }
      },
    );
  }
  Widget serchbar() {
    return AllInputDesign(
      higthtextfield: 40.0,
      // floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Search',
      fillColor: colorWhite,
      enabled: false,
      controller: txt_searchbar,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: GestureDetector(
            onTap: () {
              Get.to(() => Serchcaet());
            },
            child: Icon(
              Icons.search,
              size: 25,
              color: colorgrey,
            )),
      ),
      keyBoardType: TextInputType.text,
      validatorFieldValue: 'Search',
    );
  }
}
