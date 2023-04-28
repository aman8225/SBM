import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20list/product_lidt1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar_modelpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbarwidget.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/formtextfield/mytextfield.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/viewallmodal/filttermodel/filttermodel.dart';
import 'package:sbm/model/viewallmodal/viewallcategorydatamodel/Categorydata.dart';
import 'package:sbm/model/viewallmodal/viewallcategorydatamodel/ViewAllCategoryDataModelMessege.dart';
import 'package:sbm/model/viewallmodal/viewallmodel.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20details/prodect_details.dart';

import 'package:http/http.dart' as http;
import 'package:sbm/screens/home/searchbarscreen.dart';

import '../../../model/cartmodel/SerchBar/serch_bar_model.dart';
import '../add_to_card_screen/add_to_card_screen.dart';

class ProdectListPage extends StatefulWidget {
  final String? title;
  final String? slug;
  final int? id;
  final int? hide;
  final String? Search;

  ProdectListPage(
      {Key? key, this.title, this.slug, this.id, this.hide, this.Search})
      : super(key: key);

  @override
  _ProdectListPageState createState() => _ProdectListPageState();
}

class _ProdectListPageState extends State<ProdectListPage> {
  Future? _future;
  Future? _future1;
  Future? _future2;

  ProgressDialog? progressDialog;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var success, message;
  var tokanget;

  List<ChildCategoires> childCategoires = [];

  Future<ViewAllMassege> veiwalldatalist(String Slage) async {
    print("CLICKED 123 ==");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(Text("Loading...."));
        // progressDialog.setMessage(Text("Please Wait for $timerCount seconds"));
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
    print(beasurl + 'productCategory/' + Slage);
    var response = await http
        .get(Uri.parse(beasurl + 'productCategory/' + Slage), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    progressDialog!.dismiss();
    print(response.body);
    setState(() {
      success = (ViewAllMassege.fromJson(json.decode(response.body)).success);
      message = (ViewAllMassege.fromJson(json.decode(response.body)).message);
      setState(() {
        childCategoires = (ViewAllMassege.fromJson(json.decode(response.body))
            .data!
            .childCategoires)!;
      });

    });
    progressDialog!.dismiss();
    if (success == true) {
      progressDialog?.dismiss();

    } else {
      Navigator.pop(context);
      progressDialog?.dismiss();
      print('else==============');
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return ViewAllMassege.fromJson(json.decode(response.body));
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

  var APIURL;
  var select_api = 0;
  var success1, message1, data1;
  List<Categorydata> categorydata = [];

  Future<ViewAllCategoryDataModelMessege> veiwallcategorydatalist(
      int ID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(Text("Loading...."));
        // progressDialog.setMessage(Text("Please Wait for $timerCount seconds"));
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
    print('widget.id${widget.id}');
    switch (select_api) {
      case 0:
        {
          APIURL = '${beasurl}products?page=1&cat_id=${ID}';
          print('APIURL0${APIURL}');
        }
        break;
      case 1:
        {
          APIURL;
          print('APIURL1$APIURL');
        }
        break;
      case 2:
        {
          APIURL;
          print('EPIDURAL1${APIURL}');
        }
        break;
      case 10:
        {
          APIURL = '${beasurl}products?page=1&searchText=${widget.Search}&orderby=id&order=DESC';
          print('APIURL1${APIURL}');
        }
        break;
      default:
        {
          APIURL = '${beasurl}products?page=1&cat_id=${ID}';
        }
        break;
    }
     print(APIURL);
    var response = await http.get(Uri.parse(APIURL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    print('APIURL1${APIURL}   ?? response.body${response.body}');
    setState(() {
      success1 = (ViewAllCategoryDataModelMessege.fromJson(json.decode(response.body)).success);
      message1 = (ViewAllCategoryDataModelMessege.fromJson(json.decode(response.body)).message);
      data1 = (ViewAllCategoryDataModelMessege.fromJson(json.decode(response.body)).data);
      categorydata = (ViewAllCategoryDataModelMessege.fromJson(json.decode(response.body)).data!.data)!;
    });
    progressDialog!.dismiss();
    if (success1 == true) {
        progressDialog?.dismiss();
        Navigator.pop(context);

    } else {
      progressDialog?.dismiss();
      print('else==============');
      Fluttertoast.showToast(
          msg: message1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return ViewAllCategoryDataModelMessege.fromJson(json.decode(response.body));
  }

  var success2, message2, data2;

  List<PopularBrands>? popularBrands = [];
  List<Category>? category = [];
  List<PriceInAED>? priceInAED = [];
  List<Brands>? brands = [];
  List<Discount>? discount = [];
  List<String>? badges = [];
  List<String>? availability = [];

  Future<FiltterDataModelMessege> filtterdatalist() async {
    print("CLICKED 123 ==");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(Text("Loading...."));
        // progressDialog.setMessage(Text("Please Wait for $timerCount seconds"));
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
    var response = await http.get(Uri.parse('${beasurl}filterList'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });

    setState(() {
      success2 = (FiltterDataModelMessege.fromJson(json.decode(response.body))
          .success);
      message2 = (FiltterDataModelMessege.fromJson(json.decode(response.body))
          .message);
      popularBrands =
          (FiltterDataModelMessege.fromJson(json.decode(response.body))
              .data!
              .popularBrands);
      category = (FiltterDataModelMessege.fromJson(json.decode(response.body))
          .data!
          .category);
      priceInAED = (FiltterDataModelMessege.fromJson(json.decode(response.body))
          .data!
          .priceInAED);
      brands = (FiltterDataModelMessege.fromJson(json.decode(response.body))
          .data!
          .brands);
      discount = (FiltterDataModelMessege.fromJson(json.decode(response.body))
          .data!
          .discount);
      badges = (FiltterDataModelMessege.fromJson(json.decode(response.body))
          .data!
          .badges);
      availability =
          (FiltterDataModelMessege.fromJson(json.decode(response.body))
              .data!
              .availability);
    });

    progressDialog!.dismiss();

    if (success2 == true) {
        progressDialog?.dismiss();
        Navigator.pop(context);
    } else {
      Navigator.pop(context);
      progressDialog?.dismiss();
      print('else==============');
      Fluttertoast.showToast(
          msg: message2,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return FiltterDataModelMessege.fromJson(json.decode(response.body));
  }

//////////////add card //////////////
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

  @override
  void initState() {
    super.initState();
    if (widget.hide != 2) {

      _future = veiwalldatalist(widget.slug!);
      _future1 = veiwallcategorydatalist(widget.id!);
      _future2 = filtterdatalist();
    }
    if (widget.hide == 2) {
      select_api = 10;
      _future =
          veiwalldatalist('sbm-ffp2-respirator-flat-fold-type-with-valve');
      _future1 = veiwallcategorydatalist(0);
      _future2 = filtterdatalist();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {
      return Scaffold(
        appBar: appbarnotifav(context, widget.title),
        body: Stack(
          children: [
            Container(
              width: deviceWidth(context, 0.2),
              height: deviceheight(context, 1.0),
              color: colorskyeblue,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2,
                        child: InkWell(
                            onTap: () {
                              Get.to(() => SearchBar());
                            },
                            child: serchbar()),
                      ),

                      widget.hide == 1 || widget.hide == 2
                          ? Container()
                          : FutureBuilder(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return trendingList();
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                        // future: postlist(),
                      ),
                      //trendingList(trending),
                      FutureBuilder(
                        future: _future1,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return categorydata.length == 0
                                ? Container(
                              height: 400,
                              child: const Center(child: Text("No Data")),
                            )
                                : Container(
                              width: deviceWidth(context, 1.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Wrap(
                                      children: [
                                        for (int index = 0;
                                        index < categorydata.length;
                                        index++) ...[
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8),
                                            child: Card(
                                              child: InkWell(
                                                onTap: () {
                                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProdectDetails(title: topsaleProducts[index].productName!,slug:topsaleProducts[index].slug!)));
                                                  Get.to(() => ProdectDetails(
                                                      title: categorydata[index].productName!,
                                                      slug: categorydata[index].slug!));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: colorgrey,
                                                          width: 0.5),
                                                      borderRadius: BorderRadius.circular(6)),
                                                  width: deviceWidth(context, 0.43),
                                                  padding: const EdgeInsets.only(
                                                    top: 8,
                                                    left: 8,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Image.network(categorydata[index].thumbnailImage!,
                                                        width: deviceWidth(context, 0.32),
                                                        height: deviceheight(context, 0.12),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      sizedboxheight(3.0),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: deviceWidth(context, 0.4),
                                                            height: 30,
                                                            child: Text(categorydata[index].productName!,
                                                              style: textstylesubtitle2(context)!.copyWith(
                                                                  color: colorblack, fontWeight: FontWeight.bold,
                                                                  height: 1.2),
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                          sizedboxheight(3.0),
                                                          Container(
                                                              width: deviceWidth(context, 0.4),
                                                              child: Text(
                                                                'SKU:${categorydata[index].sku!}',
                                                                style: textstylesubtitle2(context)!.copyWith(
                                                                    fontSize: 9,
                                                                    height: 1.2),
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              )),
                                                          sizedboxheight(3.0),
                                                          Container(
                                                            width: deviceWidth(context, 0.4),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.spaceAround,
                                                              children: [
                                                                Container(
                                                                  width: deviceWidth(context, 0.28),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: Text(
                                                                            'AED\n${categorydata[index].uprice == null ? '0' : categorydata[index].uprice}',
                                                                            style: textstylesubtitle2(context)!.copyWith(
                                                                                color: colorblack,
                                                                                fontWeight: FontWeight.bold,
                                                                                height: 1.2),
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines:
                                                                            2,
                                                                          )),
                                                                      Expanded(
                                                                          child:
                                                                          Text(
                                                                            'AED\n${categorydata[index].regularPrice == null ? '0' : categorydata[index].regularPrice}',
                                                                            style: textstylesubtitle2(context)!.copyWith(
                                                                                fontSize: 9,
                                                                                decoration: TextDecoration.lineThrough,
                                                                                height: 1.2),
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 2,
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),

                                                                (int.fromEnvironment(categorydata[index].discountPercent!) >= 0)?
                                                                Container(
                                                                  width: deviceWidth(context, 0.1),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(3),
                                                                    color: colorgreen,
                                                                  ),
                                                                  child:
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(3.0),
                                                                    child: Center(
                                                                        child: Text(
                                                                          '${categorydata[index].discountPercent!.split(".")[0]}% off',
                                                                          style: textstylesubtitle2(context)!.copyWith(
                                                                              color: colorWhite,
                                                                              fontSize: 7,
                                                                              height: 1.2),
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 2,
                                                                        )),
                                                                  ),
                                                                ):Container(
                                                                  width: deviceWidth(context, 0.1),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      sizedboxheight(3.0),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProdectDetails(title: topsaleProducts[index].productName!,slug:topsaleProducts[index].slug!)));
                                                              Get.to(() => ProdectDetails(
                                                                  title: categorydata[index].productName!,
                                                                  slug: categorydata[index].slug!));
                                                            },
                                                            child: Container(
                                                              width: deviceWidth(context, 0.25),
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius.only(
                                                                  topLeft: Radius.circular(5),
                                                                  topRight: Radius.circular(5),
                                                                ),
                                                                color: colorblue,
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'DETAIL VIEW',
                                                                  style: textstylesubtitle1(context)!.copyWith(
                                                                      color: colorWhite,
                                                                      fontSize: 10,
                                                                      height: 1.2),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 2,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //sizedboxwidth(20.0),
                                                          InkWell(
                                                            onTap: () {
                                                              if(categorydata[index].sku != null){
                                                                searchproductdata(categorydata[index].sku);
                                                              }
                                                            },
                                                            child: Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration:
                                                              BoxDecoration(
                                                                borderRadius: const BorderRadius.only(
                                                                  bottomRight: Radius.circular(5),
                                                                ),
                                                                color: colorblue,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.all(10.0),
                                                                child: SvgPicture.asset(
                                                                  'assets/slicing 2/shopping-cart.svg',
                                                                  height: 10,
                                                                  width: 10,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ]
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              // GridView.builder(
                              //     gridDelegate:
                              //         const SliverGridDelegateWithMaxCrossAxisExtent(
                              //             maxCrossAxisExtent: 200,
                              //             childAspectRatio: 2 / 2.9,
                              //             crossAxisSpacing: 5,
                              //             mainAxisSpacing: 5),
                              //     itemCount: categorydata.length,
                              //     physics: NeverScrollableScrollPhysics(),
                              //     itemBuilder: (BuildContext ctx, index) {
                              //       return Card(
                              //         child: InkWell(
                              //           onTap: () {
                              //             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProdectDetails(title: topsaleProducts[index].productName!,slug:topsaleProducts[index].slug!)));
                              //             Get.to(() => ProdectDetails(
                              //                 title: categorydata[index]
                              //                     .productName!,
                              //                 slug: categorydata[index]
                              //                     .slug!));
                              //           },
                              //           child: Container(
                              //             decoration: BoxDecoration(
                              //                 border: Border.all(
                              //                     color: colorgrey,
                              //                     width: 0.5),
                              //                 borderRadius:
                              //                     BorderRadius.circular(6)),
                              //             // width: deviceWidth(context,0.43),
                              //             padding: const EdgeInsets.only(
                              //               top: 8,
                              //               left: 8,
                              //             ),
                              //             child: Column(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment
                              //                       .spaceBetween,
                              //               children: [
                              //                 Image.network(
                              //                   categorydata[index]
                              //                       .thumbnailImage!,
                              //                   width: deviceWidth(
                              //                       context, 0.32),
                              //                   height: deviceheight(
                              //                       context, 0.12),
                              //                   fit: BoxFit.cover,
                              //                 ),
                              //                 sizedboxheight(3.0),
                              //                 Column(
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment
                              //                           .start,
                              //                   children: [
                              //                     Container(
                              //                       width: deviceWidth(
                              //                           context, 0.4),
                              //                       child: Text(
                              //                         categorydata[index]
                              //                             .productName!,
                              //                         style: textstylesubtitle2(
                              //                                 context)!
                              //                             .copyWith(
                              //                                 color:
                              //                                     colorblack,
                              //                                 fontWeight:
                              //                                     FontWeight
                              //                                         .bold,
                              //                                 height: 1.2),
                              //                         overflow: TextOverflow
                              //                             .ellipsis,
                              //                         maxLines: 2,
                              //                       ),
                              //                     ),
                              //                     sizedboxheight(3.0),
                              //                     Container(
                              //                         width: deviceWidth(
                              //                             context, 0.4),
                              //                         child: Text(
                              //                           'SKU:${categorydata[index].sku!}',
                              //                           style: textstylesubtitle2(
                              //                                   context)!
                              //                               .copyWith(
                              //                                   fontSize: 9,
                              //                                   height:
                              //                                       1.2),
                              //                           overflow:
                              //                               TextOverflow
                              //                                   .ellipsis,
                              //                           maxLines: 1,
                              //                         )),
                              //                     sizedboxheight(3.0),
                              //                     Container(
                              //                       width: deviceWidth(
                              //                           context, 0.4),
                              //                       child: Row(
                              //                         mainAxisAlignment:
                              //                             MainAxisAlignment
                              //                                 .spaceAround,
                              //                         children: [
                              //                           Container(
                              //                             width:
                              //                                 deviceWidth(
                              //                                     context,
                              //                                     0.28),
                              //                             child: Row(
                              //                               children: [
                              //                                 Expanded(
                              //                                     child:
                              //                                         Text(
                              //                                   'AED\n${categorydata[index].uprice == null ? '0' : categorydata[index].uprice}',
                              //                                   style: textstylesubtitle2(context)!.copyWith(
                              //                                       color:
                              //                                           colorblack,
                              //                                       fontWeight:
                              //                                           FontWeight
                              //                                               .bold,
                              //                                       height:
                              //                                           1.2),
                              //                                   overflow:
                              //                                       TextOverflow
                              //                                           .ellipsis,
                              //                                   maxLines: 2,
                              //                                 )),
                              //                                 Expanded(
                              //                                     child:
                              //                                         Text(
                              //                                   'AED\n${categorydata[index].price == null ? '0' : categorydata[index].price}',
                              //                                   style: textstylesubtitle2(context)!.copyWith(
                              //                                       fontSize:
                              //                                           9,
                              //                                       decoration:
                              //                                           TextDecoration
                              //                                               .lineThrough,
                              //                                       height:
                              //                                           1.2),
                              //                                   overflow:
                              //                                       TextOverflow
                              //                                           .ellipsis,
                              //                                   maxLines: 2,
                              //                                 )),
                              //                               ],
                              //                             ),
                              //                           ),
                              //                           Container(
                              //                             width:
                              //                                 deviceWidth(
                              //                                     context,
                              //                                     0.1),
                              //                             decoration:
                              //                                 BoxDecoration(
                              //                               borderRadius:
                              //                                   BorderRadius
                              //                                       .circular(
                              //                                           3),
                              //                               color:
                              //                                   colorgreen,
                              //                             ),
                              //                             child: Padding(
                              //                               padding:
                              //                                   const EdgeInsets
                              //                                           .all(
                              //                                       3.0),
                              //                               child: Center(
                              //                                   child: Text(
                              //                                 '${categorydata[index].discountPercent!.split(".")[0]}% off',
                              //                                 style: textstylesubtitle2(context)!.copyWith(
                              //                                     color:
                              //                                         colorWhite,
                              //                                     fontSize:
                              //                                         7,
                              //                                     height:
                              //                                         1.2),
                              //                                 overflow:
                              //                                     TextOverflow
                              //                                         .ellipsis,
                              //                                 maxLines: 2,
                              //                               )),
                              //                             ),
                              //                           )
                              //                         ],
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //                 sizedboxheight(3.0),
                              //                 Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceBetween,
                              //                   children: [
                              //                     InkWell(
                              //                       onTap: () {
                              //                         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProdectDetails(title: topsaleProducts[index].productName!,slug:topsaleProducts[index].slug!)));
                              //                         Get.to(() => ProdectDetails(
                              //                             title: categorydata[
                              //                                     index]
                              //                                 .productName!,
                              //                             slug:
                              //                                 categorydata[
                              //                                         index]
                              //                                     .slug!));
                              //                       },
                              //                       child: Container(
                              //                         width: deviceWidth(
                              //                             context, 0.25),
                              //                         height: 40,
                              //                         decoration:
                              //                             BoxDecoration(
                              //                           borderRadius:
                              //                               const BorderRadius
                              //                                   .only(
                              //                             topLeft: Radius
                              //                                 .circular(5),
                              //                             topRight: Radius
                              //                                 .circular(5),
                              //                           ),
                              //                           color: colorblue,
                              //                         ),
                              //                         child: Center(
                              //                           child: Text(
                              //                             'DETAIL VIEW',
                              //                             style: textstylesubtitle1(
                              //                                     context)!
                              //                                 .copyWith(
                              //                                     color:
                              //                                         colorWhite,
                              //                                     fontSize:
                              //                                         10,
                              //                                     height:
                              //                                         1.2),
                              //                             overflow:
                              //                                 TextOverflow
                              //                                     .ellipsis,
                              //                             maxLines: 2,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     //sizedboxwidth(20.0),
                              //                     Container(
                              //                       width: 40,
                              //                       height: 40,
                              //                       decoration:
                              //                           BoxDecoration(
                              //                         borderRadius:
                              //                             const BorderRadius
                              //                                 .only(
                              //                           bottomRight:
                              //                               Radius.circular(
                              //                                   5),
                              //                         ),
                              //                         color: colorblue,
                              //                       ),
                              //                       child: Padding(
                              //                         padding:
                              //                             const EdgeInsets
                              //                                 .all(10.0),
                              //                         child:
                              //                             SvgPicture.asset(
                              //                           'assets/slicing 2/shopping-cart.svg',
                              //                           height: 10,
                              //                           width: 10,
                              //                         ),
                              //                       ),
                              //                     )
                              //                   ],
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       );
                              //     }),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                        // future: postlist(),
                      ),
                      sizedboxheight(50.0),
                    ],
                  ),
                ),
              ),
            ),
            widget.hide != 2
                ? Positioned(
                bottom: 5,
                child: Container(
                  width: deviceWidth(context, 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: colorblue),
                              borderRadius: BorderRadius.circular(20)),
                          height: 45,
                          width: deviceWidth(context, 0.9),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    sortbybottomsheet(context);
                                  },
                                  child: Text(
                                    'SORT BY',
                                    style: TextStyle(color: colorblack),
                                  )),
                              Container(
                                height: 20,
                                color: colorblack,
                                width: 1,
                              ),
                              TextButton(
                                  onPressed: () {
                                    filterbybottomsheet(context);
                                  },
                                  child: Text(
                                    'FILTER BY',
                                    style: TextStyle(color: colorblack),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
                : Container(),
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
      );
    });


  }

  Widget serchbar() {
    return AllInputDesign(
      higthtextfield: 40.0,
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Search',
      fillColor: colorWhite,
      enabled: false,
      // controller: model.loginEmail,
      // autofillHints: [AutofillHints.email],
      textInputAction: TextInputAction.done,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.search,
          size: 25,
          color: colorgrey,
        ),
      ),
      keyBoardType: TextInputType.text,
      validatorFieldValue: 'Search',
    );
  }

  Widget trendingList() {
    return childCategoires.isEmpty?Container():Container(
      height: 110,
      width: deviceWidth(context, 1.0),
      child: ListView.builder(
          itemCount: childCategoires.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(

                children: [
                  InkWell(
                    onTap: () {

                        Get.to(() => ProdectListPage1(
                            title: childCategoires[index].categoryName,
                            slug: childCategoires[index].slug,
                            id: childCategoires[index].id));


                      // setState(() {
                      //   (context as Element).reassemble();
                      //   veiwalldatalist(childCategoires[index].slug!);
                      //   veiwallcategorydatalist(childCategoires[index].id!);
                      //   setState(() { childCategoires.length; });
                      // });
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: colorblue),
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                                image: NetworkImage(
                                    childCategoires[index].logo ?? '',
                                    scale: 7))),
                        width: 50, height: 50,

                        /// child: Image.network(categories[index].logo??'',scale:1.5,),
                      ),
                    ),
                  ),
                  sizedboxheight(5.0),
                  InkWell(
                    onTap: () {
                      setState(() {
                        veiwalldatalist(childCategoires[index].slug!);
                        veiwallcategorydatalist(childCategoires[index].id!);
                      });
                    },
                    child: Container(
                        width: deviceWidth(context, 0.2),
                        child: Text(
                          childCategoires[index].categoryName ?? '',
                          style: textstylesubtitle1(context)!
                              .copyWith(fontSize: 12, height: 1.2),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        )),
                  )
                ],
              ),
            );
          }),
    );
  }

  String _selectedGender = 'Default Sorting';

  Future sortbybottomsheet(context) {
    return showModalBottomSheet(
        isDismissible: true,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'SORT BY',
                    style: textstyleHeading2(context),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Default Sorting',
                                  style: textnormail(context),
                                ),
                                Radio<String>(
                                  value: 'Default Sorting',
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      Navigator.of(context);
                                      _selectedGender = value!;
                                      select_api = 0;
                                      veiwallcategorydatalist(widget.id!);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Product Name',
                                    style: textnormail(context)),
                                Radio<String>(
                                  value: 'Product Name',
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      Navigator.of(context);
                                      _selectedGender = value!;
                                      select_api = 1;
                                      APIURL = beasurl +
                                          'products?page=1&cat_id=${widget.id}&orderby=product_name&order=ASC';

                                      veiwallcategorydatalist(widget.id!);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Popular', style: textnormail(context)),
                                Radio<String>(
                                  value: 'Popular',
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      Navigator.of(context);
                                      _selectedGender = value!;
                                      select_api = 1;
                                      APIURL = beasurl +
                                          'products?page=1&cat_id=${widget.id}&orderby=topsales&order=DESC';

                                      veiwallcategorydatalist(widget.id!);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Latest', style: textnormail(context)),
                                Radio<String>(
                                  value: 'Latest',
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      Navigator.of(context);
                                      _selectedGender = value!;
                                      select_api = 1;
                                      APIURL = beasurl +
                                          'products?page=1&cat_id=${widget.id}&orderby=id&order=DESC';

                                      veiwallcategorydatalist(widget.id!);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Price: High to Low',
                                    style: textnormail(context)),
                                Radio<String>(
                                  value: 'Price: High to Low',
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      Navigator.of(context);
                                      _selectedGender = value!;
                                      select_api = 1;
                                      APIURL = beasurl +
                                          'products?page=1&cat_id=${widget.id}&orderby=price&order=DESC';

                                      veiwallcategorydatalist(widget.id!);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Price: Low to High',
                                    style: textnormail(context)),
                                Radio<String>(
                                  value: 'Price: Low to High',
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      Navigator.of(context);
                                      _selectedGender = value!;
                                      select_api = 1;
                                      APIURL = beasurl +
                                          'products?page=1&cat_id=${widget.id}orderby=price&order=ASC';
                                      veiwallcategorydatalist(widget.id!);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            );
          });
        });
  }

  int _groupValue = -1;
  var _select_category_id = 0;
  var _select_category_sluge;

  List<PopularBrands> popularBrandsSelected = [];

  List<PriceInAED>? priceInAEDSelected = [];
  List<Brands>? brandsSelected = [];
  List<Discount>? discountSelected = [];

  Future filterbybottomsheet(context) {
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        context: context,
        builder: (context) {
          return FutureBuilder(
            future: _future2,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  height: deviceheight(context,0.9),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50,bottom: 50,left: 20,right: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'FILTER BY',
                                style: textstyleHeading3(context)!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          sizedboxheight(10.0),

                          // sizedboxheight(10.0),
                          // Text(
                          //   'POPULAR BRANDS',
                          //   style: textstylesubtitle1(context)!
                          //       .copyWith(fontWeight: FontWeight.bold),
                          // ),
                          // Wrap(
                          //   direction: Axis.horizontal,
                          //   alignment: WrapAlignment.start,
                          //   spacing: 3.0,
                          //   runAlignment: WrapAlignment.start,
                          //   runSpacing: 3.0,
                          //   crossAxisAlignment: WrapCrossAlignment.start,
                          //   textDirection: TextDirection.ltr,
                          //   verticalDirection: VerticalDirection.down,
                          //   children: [
                          //     for (int i = 0; i < popularBrands!.length; i++)
                          //       //chekeboxcard(popularBrands![i].name ,popularBrands![i].isSelected!, popularBrands![i]),
                          //       StatefulBuilder(builder: (BuildContext context,
                          //           StateSetter
                          //               setState /*You can rename this!*/) {
                          //         return Container(
                          //           height: 30,
                          //           child: Row(
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: [
                          //               Checkbox(
                          //                   value: popularBrands![i].isSelected!,
                          //                   activeColor: colorblue,
                          //                   onChanged: (newValue) {
                          //                     setState(() {
                          //                       popularBrands![i].isSelected =
                          //                           newValue!;
                          //                       setState(() {
                          //                         popularBrands![i].isSelected =
                          //                             newValue;
                          //                         if (popularBrandsSelected
                          //                             .contains(
                          //                                 popularBrands![i])) {
                          //                           popularBrandsSelected.remove(
                          //                               popularBrands![i]);
                          //                         } else {
                          //                           popularBrandsSelected
                          //                               .add(popularBrands![i]);
                          //                         }
                          //                       });
                          //                       print(
                          //                           popularBrandsSelected.length);
                          //                     });
                          //                   }),
                          //               Text(
                          //                 popularBrands![i].name.toString(),
                          //                 style: textstylesubtitle2(context)!
                          //                     .copyWith(color: colorblack),
                          //                 overflow: TextOverflow.ellipsis,
                          //                 maxLines: 1,
                          //               ),
                          //             ],
                          //           ),
                          //         );
                          //       })
                          //   ],
                          // ),
                          //
                          // Divider(
                          //   thickness: 0.5,
                          //   color: colorblack,
                          // ),
                          Text(
                            'CATEGORY',
                            style: textstylesubtitle1(context)!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            spacing: 2.0,
                            runAlignment: WrapAlignment.start,
                            runSpacing: 2.0,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            textDirection: TextDirection.ltr,
                            verticalDirection: VerticalDirection.down,
                            children: [
                              for (int i = 0; i < category!.length; i++)
                                //chekeboxcard(category![i].name,false),
                                Container(
                                  height: 30,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio(
                                        value: category![i].id!,
                                        groupValue: _groupValue,
                                        onChanged: (int? newValue) {
                                          setState(() {
                                            (context as Element).reassemble();
                                            _groupValue = newValue!;
                                            _select_category_id = newValue;
                                            _select_category_sluge =
                                                category![i].slug;

                                            (context as Element).reassemble();
                                          });
                                        },
                                      ),
                                      Text(category![i].name.toString())
                                    ],
                                  ),
                                )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: colorblack,
                          ),
                          Text(
                            'FILTER BY PRICE',
                            style: textstylesubtitle1(context)!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            spacing: 2.0,
                            runAlignment: WrapAlignment.start,
                            runSpacing: 2.0,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            textDirection: TextDirection.ltr,
                            verticalDirection: VerticalDirection.down,
                            children: [
                              for (int i = 0; i < priceInAED!.length; i++)
                                //chekeboxcard(priceInAED![i].name,priceInAED![i].isSelected!,priceInAED![i]),
                                StatefulBuilder(builder: (BuildContext context,
                                    StateSetter
                                        setState /*You can rename this!*/) {
                                  return Container(
                                    height: 30,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                            value: priceInAED![i].isSelected!,
                                            activeColor: colorblue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                priceInAED![i].isSelected =
                                                    newValue!;
                                                setState(() {
                                                  priceInAED![i].isSelected =
                                                      newValue;
                                                  if (priceInAEDSelected!
                                                      .contains(priceInAED![i])) {
                                                    priceInAEDSelected!
                                                        .remove(priceInAED![i]);
                                                  } else {
                                                    priceInAEDSelected!
                                                        .add(priceInAED![i]);
                                                  }
                                                });
                                                print(priceInAEDSelected!.length);
                                              });
                                            }),
                                        Text(
                                          priceInAED![i].name.toString(),
                                          style: textstylesubtitle2(context)!
                                              .copyWith(color: colorblack),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                })
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: colorblack,
                          ),
                          Text(
                            'BRANDS',
                            style: textstylesubtitle1(context)!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            spacing: 2.0,
                            runAlignment: WrapAlignment.start,
                            runSpacing: 2.0,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            textDirection: TextDirection.ltr,
                            verticalDirection: VerticalDirection.down,
                            children: [
                              for (int i = 0; i < brands!.length; i++)
                                //chekeboxcard(brands![i].name,brands![i].isSelected! ,brands![i]),
                                StatefulBuilder(builder: (BuildContext context,
                                    StateSetter
                                        setState /*You can rename this!*/) {
                                  return Container(
                                    height: 30,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                            value: brands![i].isSelected!,
                                            activeColor: colorblue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                brands![i].isSelected = newValue!;
                                                setState(() {
                                                  brands![i].isSelected =
                                                      newValue;
                                                  if (brandsSelected!
                                                      .contains(brands![i])) {
                                                    brandsSelected!
                                                        .remove(brands![i]);
                                                  } else {
                                                    brandsSelected!
                                                        .add(brands![i]);
                                                  }
                                                });
                                                print(brandsSelected!.length);
                                              });
                                            }),
                                        Text(
                                          brands![i].name.toString(),
                                          style: textstylesubtitle2(context)!
                                              .copyWith(color: colorblack),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                })
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: colorblack,
                          ),
                          Text(
                            'DISCOUNT',
                            style: textstylesubtitle1(context)!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            spacing: 2.0,
                            runAlignment: WrapAlignment.start,
                            runSpacing: 2.0,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            textDirection: TextDirection.ltr,
                            verticalDirection: VerticalDirection.down,
                            children: [
                              for (int i = 0; i < discount!.length; i++)
                                //chekeboxcard(discount![i].name,discount![i].isSelected!,discount![i]),
                                StatefulBuilder(builder: (BuildContext context,
                                    StateSetter
                                        setState /*You can rename this!*/) {
                                  return Container(
                                    height: 30,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                            value: discount![i].isSelected!,
                                            activeColor: colorblue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                discount![i].isSelected =
                                                    newValue!;
                                                setState(() {
                                                  discount![i].isSelected =
                                                      newValue;
                                                  if (discountSelected!
                                                      .contains(discount![i])) {
                                                    discountSelected!
                                                        .remove(discount![i]);
                                                  } else {
                                                    discountSelected!
                                                        .add(discount![i]);
                                                  }
                                                });
                                                print(brandsSelected!.length);
                                              });
                                            }),
                                        Text(
                                          discount![i].name.toString(),
                                          style: textstylesubtitle2(context)!
                                              .copyWith(color: colorblack),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                })
                            ],
                          ),
                          sizedboxheight(10.0),
                          // Divider(thickness:  0.5,color: colorblack,),
                          // Text('BADGES',style: textstylesubtitle1(context)!.copyWith(fontWeight: FontWeight.bold),),
                          // Wrap(
                          //   direction: Axis.horizontal,
                          //   alignment: WrapAlignment.start,
                          //   spacing:2.0,
                          //   runAlignment:WrapAlignment.start,
                          //   runSpacing: 2.0,
                          //   crossAxisAlignment: WrapCrossAlignment.start,
                          //   textDirection: TextDirection.ltr,
                          //   verticalDirection: VerticalDirection.down,
                          //   children: [
                          //     chekeboxcard('Best Seller'),
                          //     chekeboxcard('Best Deal'),
                          //     chekeboxcard('Fast Delivery'),
                          //   ],
                          // ),
                          // Divider(thickness:  0.5,color: colorblack,),
                          // Text('AVAILABILITY',style: textstylesubtitle1(context)!.copyWith(fontWeight: FontWeight.bold),),
                          // chekeboxcard('Show in stock only'),
                          // Divider(thickness:  0.5,color: colorblack,),
                          applybut(context)
                        ],
                      ),
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
          );
        });
  }

  List multipleSelected = [];
  Widget chekeboxcard(titel, bool checkBoxValue, popularBrands) {
    return StatefulBuilder(builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      return Container(
        height: 30,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
                value: checkBoxValue,
                activeColor: colorblue,
                onChanged: (newValue) {
                  setState(() {
                    checkBoxValue = newValue!;
                    setState(() {
                      checkBoxValue = newValue;
                      if (multipleSelected.contains(popularBrands)) {
                        multipleSelected.remove(popularBrands);
                      } else {
                        multipleSelected.add(popularBrands);
                      }
                    });
                    print(multipleSelected.length);
                  });
                }),
            Text(
              titel,
              style: textstylesubtitle2(context)!.copyWith(color: colorblack),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      );
    });
  }

  Widget applybut(context) {
    return Button(
      buttonName: 'APPLY',
      btnstyle: textstylesubtitle1(context)!
          .copyWith(color: colorWhite, fontSize: 12),
      //btnWidth: deviceWidth(context,0.5),
      key: Key('apply'),
      borderRadius: BorderRadius.circular(5),
      onPressed: () {
        select_api = 0;
        String popularBrandslist = '';
        for (int i = 0; i < popularBrandsSelected.length; i++) {
          popularBrandslist =
              popularBrandslist + popularBrandsSelected[i].id.toString() + ',';
          // print(a);
        }

        String priceInAEDlist = '';
        if (priceInAEDSelected!.length == 0) {
          priceInAEDlist = '&prices[]=';
        }
        for (int j = 0; j < priceInAEDSelected!.length; j++) {
          priceInAEDlist =
              priceInAEDlist + '&prices[]=' + priceInAEDSelected![j].value!;
        }

        String brandslist = '';
        for (int k = 0; k < brandsSelected!.length; k++) {
          brandslist = brandslist + brandsSelected![k].id.toString() + ',';
        }

        String discountlist = '';
        if (discountSelected!.length == 0) {
          discountlist = "&discounts[]=";
        }
        for (int l = 0; l < discountSelected!.length; l++) {
          discountlist =
              discountlist + "&discounts[]=" + discountSelected![l].value!;
        }
        if (_select_category_id != 0) {
          print('_select_category_id${_select_category_id}');
          veiwalldatalist(_select_category_sluge.toString());
          Navigator.pop(context);
        }

        _select_category_id =
            (_select_category_id == 0 ? widget.id : _select_category_id)!;
        select_api = 2;
        // APIURL = beasurl+'products?page=1&cat_id=${widget.id}&orderby=product_name&order=ASC';
        //APIURL = beasurl+'products?page=1&cat_id=${_select_category_id}&brand_ids=1&prices[]=5001,10000&discounts[]=11,20';
        APIURL = beasurl +
            'products?page=1&cat_id=${_select_category_id}&brand_ids=${brandslist}${priceInAEDlist}${discountlist}';
        print('filtter data api${APIURL}');
        //APIURL = beasurl+'products?page=1&cat_id=${widget.id}&brand_ids=&prices[]=&discounts[]=';
        veiwallcategorydatalist(widget.id!);
        // _showCupertinoDialog(context);
      },
    );
  }
}
