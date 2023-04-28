import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/appbar/appbarwidgetpage.dart';
import 'package:sbm/common/formtextfield/mytextfield.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/cartmodel/cartsmodel.dart';
import 'package:sbm/model/homemodel/Brands.dart';
import 'package:sbm/model/homemodel/CatProductsList.dart';
import 'package:sbm/model/homemodel/CatProductsList1.dart';
import 'package:sbm/model/homemodel/Categories.dart';
import 'package:sbm/model/homemodel/Products.dart';
import 'package:sbm/model/homemodel/Sliders.dart';
import 'package:sbm/model/homemodel/TopsaleProducts.dart';
import 'package:sbm/model/homemodel/homedatamodel.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20details/prodect_details.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20list/prodect_list.dart';
import 'package:ndialog/ndialog.dart';

import 'package:http/http.dart' as http;
import 'package:sbm/screens/brands/barand.dart';
import 'package:sbm/screens/home/searchbarscreen.dart';

import '../../model/cartmodel/SerchBar/serch_bar_model.dart';
import '../all cotegories/add_to_card_screen/add_to_card_screen.dart';
import '../invoices/pdfshowscreen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future? _future;
  TextEditingController txt_searchbar = TextEditingController();
  ProgressDialog? progressDialog;

  var success, message, data;

  var alldata;
  List<Categories> categories = [];
  List<CatProductsList> catProductsList = [];
  List<CatProductsList1> catProductsList1 = [];
  List<Products> products = [];
  var topOffer;

  List<Sliders> slider = [];
  List<TopsaleProducts> topsaleProducts = [];
  List<Brands> brands = [];
  var tokanget, username;

  Future<homedatamodel> homepagedata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget!.replaceAll('"', '');
    });
    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(Text("Loading...."));
        //   progressDialog?.show();

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
      print(beasurl + 'homeapp');
    var response = await http.get(Uri.parse(beasurl + 'homeapp'), headers: {
      'Authorization': 'Bearer $tokanget',
    });
    progressDialog!.dismiss();
    print('homeweb response 11111${response.body}');
    // var a = json.decode(response.body);
    // var b = a['message'];
    // if (b != 'Home page Details') {
    //   Navigator.pop(context);
    // }
    print('homeweb success success success${homedatamodel.fromJson(json.decode(response.body)).success}');
    success = (homedatamodel.fromJson(json.decode(response.body)).success);
    message = (homedatamodel.fromJson(json.decode(response.body)).message);
    print('homeweb success success success${success}');
    if (success == true) {
      progressDialog!.dismiss();
      categories = (homedatamodel
          .fromJson(json.decode(response.body))
          .data!
          .categories)!;
      topsaleProducts = (homedatamodel
          .fromJson(json.decode(response.body))
          .data!
          .topsaleProducts)!;
      catProductsList = (homedatamodel
          .fromJson(json.decode(response.body))
          .data!
          .catProductsList)!;
      brands =
          (homedatamodel.fromJson(json.decode(response.body)).data!.brands)!;
      slider =
          (homedatamodel.fromJson(json.decode(response.body)).data!.slider)!;
      catProductsList1 = (homedatamodel
          .fromJson(json.decode(response.body))
          .data!
          .catProductsList1)!;
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
    return homedatamodel.fromJson(json.decode(response.body));
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

  //////////////// add card /////////

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
    _future = homepagedata();
    notificationactionWidget(context);
  }
  Future<void> abc(context) async {
    (context as Element).reassemble();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    cartitemlength = prefs.getString('cart_item_length');
    cartitemlength = cartitemlength!.replaceAll('"', '');
    print("cartitemlength??????${cartitemlength}");
    //(context as Element).reassemble();
  }
  @override
  void dispose() {
    super.dispose();
    txt_searchbar.dispose();
  }

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
        Container(
          width: deviceWidth(context, 1.0),
          height: deviceheight(context, 1.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                        onTap: () {
                          Get.to(() => SearchBar());
                        },
                        child: serchbar()),
                  ),
                  sizedboxheight(10.0),
                  hedingbar('Trending Categories', '', 1),
                  sizedboxheight(5.0),
                  FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return trendingList();
                      } else {
                        return const Center();
                      }
                    },
                  ),
                  topbenercard(),
                  sizedboxheight(8.0),
                  hedingbar('Best Selling Products', '', 1),
                  sizedboxheight(10.0),
                  bestsellingproductList(),
                  sizedboxheight(10.0),
                  FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              //physics: NeverScrollableScrollPhysics(),
                              itemCount: catProductsList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    children: [
                                      hedingbar(
                                          catProductsList[index].categoryName,
                                          catProductsList[index].slug,
                                          catProductsList[index].id),
                                      sizedboxheight(10.0),
                                      FutureBuilder(
                                        future: _future,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return catProductsList[index]
                                                    .products!
                                                    .isNotEmpty
                                                ? Container(
                                                    height: 250,
                                                    width: deviceWidth(
                                                        context, 1.0),
                                                    child: ListView.builder(
                                                        itemCount: catProductsList[
                                                                        index]
                                                                    .products!
                                                                    .length >
                                                                10
                                                            ? 10
                                                            : catProductsList[
                                                                    index]
                                                                .products!
                                                                .length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int i) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 5),
                                                            child: Card(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Get.to(() => ProdectDetails(
                                                                      title: catProductsList[index].products![i].productName!,
                                                                      slug: catProductsList[index].products![i].slug!));
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              colorgrey,
                                                                          width:
                                                                              0.5),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                  // width: deviceWidth(context,0.43),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    top: 8,
                                                                    left: 8,
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Image
                                                                          .network(
                                                                        catProductsList[index]
                                                                            .products![i]
                                                                            .mainImage!,
                                                                        width: deviceWidth(
                                                                            context,
                                                                            0.32),
                                                                        height: deviceheight(
                                                                            context,
                                                                            0.12),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      sizedboxheight(
                                                                          3.0),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                deviceWidth(context, 0.4),
                                                                            child:
                                                                                Text(
                                                                              catProductsList[index].products![i].productName!,
                                                                              style: textstylesubtitle2(context)!.copyWith(color: colorblack, fontWeight: FontWeight.bold, height: 1.2),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 2,
                                                                            ),
                                                                          ),
                                                                          sizedboxheight(
                                                                              3.0),
                                                                          Container(
                                                                              width: deviceWidth(context, 0.4),
                                                                              child: Text(
                                                                                'SKU:${catProductsList[index].products![i].sku!}',
                                                                                style: textstylesubtitle2(context)!.copyWith(fontSize: 9),
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 1,
                                                                              )),
                                                                          sizedboxheight(
                                                                              3.0),
                                                                          Container(
                                                                            width:
                                                                                deviceWidth(context, 0.4),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: deviceWidth(context, 0.35),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                          child: Text(
                                                                                        'AED\n${catProductsList[index].products![i].uprice == null ? '0' : catProductsList[index].products![i].uprice} ',
                                                                                        style: textstylesubtitle2(context)!.copyWith(color: colorblack, fontWeight: FontWeight.bold, height: 1.2),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        maxLines: 2,
                                                                                      )),
                                                                                      Expanded(
                                                                                          child: Text(
                                                                                        'AED\n${catProductsList[index].products![i].price == null ? '0' : catProductsList[index].products![i].price}  ',
                                                                                        style: textstylesubtitle2(context)!.copyWith(fontSize: 9, decoration: TextDecoration.lineThrough, height: 1.2),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        maxLines: 2,
                                                                                      )),
                                                                                    ],
                                                                                  ),
                                                                                ),

                                                                                // Container(
                                                                                //   width: deviceWidth(context,0.1),
                                                                                //   decoration: BoxDecoration(
                                                                                //     borderRadius: BorderRadius.circular(3),
                                                                                //     color: colorgreen,
                                                                                //   ),
                                                                                //   child:  Padding(
                                                                                //     padding: const EdgeInsets.all(3.0),
                                                                                //     child: Center(child: Text('20% off',style: textstylesubtitle2(context)!.copyWith(color: colorWhite,fontSize: 7,height: 1.2),overflow: TextOverflow.ellipsis,maxLines: 2,)),
                                                                                //   ),
                                                                                // )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      sizedboxheight(
                                                                          3.0),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Get.to(() => ProdectDetails(title: catProductsList[index].products![i].productName!, slug: catProductsList[index].products![i].slug!));
                                                                            },
                                                                            child:
                                                                                Container(
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
                                                                                  style: textstylesubtitle1(context)!.copyWith(color: colorWhite, fontSize: 10, height: 1.2),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 2,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          sizedboxwidth(
                                                                              20.0),
                                                                          InkWell(
                                                                            onTap: () {
                                                                              if(catProductsList[index].products![i].sku != null){
                                                                                searchproductdata(catProductsList[index].products![i].sku);
                                                                              }
                                                                            },
                                                                            child: Container(
                                                                              width:
                                                                                  40,
                                                                              height:
                                                                                  40,
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                borderRadius: const BorderRadius.only(
                                                                                  bottomRight: Radius.circular(5),
                                                                                ),
                                                                                color: colorblue,
                                                                              ),
                                                                              child:
                                                                                  Padding(
                                                                                padding: const EdgeInsets.all(10.0),
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
                                                          );
                                                        }),
                                                  )
                                                : Container(
                                                    height: deviceheight(
                                                        context, 0.3),
                                                    child: const Center(
                                                      child: Text(
                                                          'No Data Found.'),
                                                    ),
                                                  );
                                          } else {
                                            return const Center();
                                          }
                                        },
                                        // future: postlist(),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        );
                      } else {
                        return const Center();
                      }
                    },
                    // future: postlist(),
                  ),
                  sizedboxheight(20.0),
                  hedingbar('Our Top Brands', '', 1),
                  sizedboxheight(10.0),
                  // FutureBuilder(
                  //   future: _future,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       return topbrandList();
                  //     } else {
                  //       return const Center();
                  //     }
                  //   },
                  //   // future: postlist(),
                  // ),
                  FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: catProductsList1.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    children: [
                                      hedingbar(
                                          catProductsList1[index].categoryName,
                                          catProductsList1[index].slug,
                                          catProductsList1[index].id),
                                      sizedboxheight(10.0),
                                      FutureBuilder(
                                        future: _future,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return catProductsList1[index]
                                                    .products!
                                                    .isNotEmpty
                                                ? Container(
                                                    height: 250,
                                                    width: deviceWidth(
                                                        context, 1.0),
                                                    child: ListView.builder(
                                                        itemCount: catProductsList1[
                                                                        index]
                                                                    .products!
                                                                    .length >
                                                                10
                                                            ? 10
                                                            : catProductsList1[
                                                                    index]
                                                                .products!
                                                                .length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int i) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 5),
                                                            child: Card(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Get.to(() => ProdectDetails(
                                                                      title: catProductsList1[
                                                                              index]
                                                                          .products![
                                                                              i]
                                                                          .productName!,
                                                                      slug: catProductsList1[
                                                                              index]
                                                                          .products![
                                                                              i]
                                                                          .slug!));
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              colorgrey,
                                                                          width:
                                                                              0.5),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                  //width: deviceWidth(context,0.43),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    top: 8,
                                                                    left: 8,
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Image
                                                                          .network(
                                                                        catProductsList1[index]
                                                                            .products![i]
                                                                            .mainImage!,
                                                                        width: deviceWidth(
                                                                            context,
                                                                            0.32),
                                                                        height: deviceheight(
                                                                            context,
                                                                            0.12),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      sizedboxheight(
                                                                          3.0),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                deviceWidth(context, 0.4),
                                                                            child:
                                                                                Text(
                                                                              catProductsList1[index].products![i].productName!,
                                                                              style: textstylesubtitle2(context)!.copyWith(color: colorblack, fontWeight: FontWeight.bold, height: 1.2),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 2,
                                                                            ),
                                                                          ),
                                                                          sizedboxheight(
                                                                              3.0),
                                                                          Container(
                                                                              width: deviceWidth(context, 0.4),
                                                                              child: Text(
                                                                                'SKU:${catProductsList1[index].products![i].sku!}',
                                                                                style: textstylesubtitle2(context)!.copyWith(fontSize: 9),
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 1,
                                                                              )),
                                                                          sizedboxheight(
                                                                              3.0),
                                                                          Container(
                                                                            width:
                                                                                deviceWidth(context, 0.4),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: deviceWidth(context, 0.35),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                          child: Text(
                                                                                        'AED\n${catProductsList1[index].products![i].uprice} ',
                                                                                        style: textstylesubtitle2(context)!.copyWith(color: colorblack, fontWeight: FontWeight.bold, height: 1.2),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        maxLines: 2,
                                                                                      )),
                                                                                      Expanded(
                                                                                          child: Text(
                                                                                        'AED\n${catProductsList1[index].products![i].price}  ',
                                                                                        style: textstylesubtitle2(context)!.copyWith(fontSize: 9, decoration: TextDecoration.lineThrough, height: 1.2),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        maxLines: 2,
                                                                                      )),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      sizedboxheight(
                                                                          3.0),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Get.to(() => ProdectDetails(title: catProductsList1[index].products![i].productName!, slug: catProductsList1[index].products![i].slug!));
                                                                            },
                                                                            child:
                                                                                Container(
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
                                                                                  style: textstylesubtitle1(context)!.copyWith(color: colorWhite, fontSize: 10, height: 1.2),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 2,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          sizedboxwidth(
                                                                              20.0),
                                                                          InkWell(
                                                                            onTap: () {
                                                                              if(catProductsList1[index].products![i].sku != null){
                                                                                searchproductdata(catProductsList1[index].products![i].sku);
                                                                              }
                                                                            },
                                                                            child: Container(
                                                                              width:
                                                                                  40,
                                                                              height:
                                                                                  40,
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                borderRadius: const BorderRadius.only(
                                                                                  bottomRight: Radius.circular(5),
                                                                                ),
                                                                                color: colorblue,
                                                                              ),
                                                                              child:
                                                                                  Padding(
                                                                                padding: const EdgeInsets.all(10.0),
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
                                                          );
                                                        }),
                                                  )
                                                : Container(
                                                    height: deviceheight(
                                                        context, 0.3),
                                                    child: const Center(
                                                      child: Text(
                                                          'No Data Found.'),
                                                    ),
                                                  );
                                          } else {
                                            return const Center();
                                          }
                                        },
                                        // future: postlist(),
                                      )
                                    ],
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
                  ),
                  sizedboxheight(20.0),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
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
              Get.to(() => SearchBar());
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

  Widget hedingbar(titel, slug, id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: deviceWidth(context, 0.6),
                child: Text(
                  ' ${titel}'.toUpperCase(),
                  style: textheding(context),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )),
            if (titel != 'Trending Categories' &&
                titel != 'Best Selling Products' )
              Container(
                width: deviceWidth(context, 0.3),
                child: InkWell(
                    onTap: () {
                      if(titel == 'Our Top Brands'){
                        Get.to(() => Brand());
                      }
                      else{
                        Get.to(() => ProdectListPage(title: titel, slug: slug, id: id));
                      }

                    },
                    child: Container(
                        height: 30,
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          'View All',
                          style:
                              textheding(context)!.copyWith(color: colorblue),
                          textAlign: TextAlign.end,
                        ))),
              )
            else
              Container(
                width: deviceWidth(context, 0.1),
                height: 30,
              )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Container(
            color: colorblue,
            width: 60,
            height: 2,
          ),
        )
      ],
    );
  }

  Widget trendingList() {
    return Container(
      height: 125,
      width: deviceWidth(context, 1.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: categories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => ProdectListPage(
                          title: categories[index].categoryName,
                          slug: categories[index].slug,
                          id: categories[index].id));
                    },
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: colorgrey, width: 0.5),
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              image: NetworkImage(categories[index].logo ?? ''),
                              fit: BoxFit.cover,
                            )),
                        width: 65, height: 65,

                        /// child: Image.network(categories[index].logo??'',scale:1.5,),
                      ),
                    ),
                  ),
                  sizedboxheight(5.0),
                  InkWell(
                    onTap: () {
                      Get.to(() => ProdectListPage(
                          title: categories[index].categoryName,
                          slug: categories[index].slug,
                          id: categories[index].id));
                    },
                    child: Container(
                        width: deviceWidth(context, 0.2),
                        child: Text(
                          categories[index].categoryName ?? '',
                          style: textbold(context)!.copyWith(
                              fontSize: 12, color: Colors.black54, height: 1.1),
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


  List sliderimage = [
    "assets/sliderimage/rsz_1b3.jpg",
    "assets/sliderimage/rsz_b1.jpg",
    "assets/sliderimage/rsz_b2.jpg",
    "assets/sliderimage/rsz_b4_1.jpg",
  ];

  Widget topbenercard() {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    autoPlay: true,
                  ),
                  items: slider
                      .map((item) => Container(
                            child: Center(
                                // child: Image.network(
                                //   item.image!,
                                //   loadingBuilder: (context, child, loadingProgress) {
                                //     return Center(
                                //       child: CircularProgressIndicator(
                                //         value: (loadingProgress != null)
                                //             ? (loadingProgress.cumulativeBytesLoaded /
                                //             loadingProgress.expectedTotalBytes!)
                                //             : 0,
                                //       ),
                                //     );
                                //   },
                                //   errorBuilder: (context, error, stackTrace) {
                                //     return Column(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         Image.asset('assets/img_8.png', fit: BoxFit.fill, height: 200,)
                                //       ],
                                //     );
                                //   },
                                // ),
                                // child: Image.asset('assets/img_8.png', fit: BoxFit.fill, height: 200,filterQuality: FilterQuality.medium,)
                                child: Image.network(
                              item.image!,
                              fit: BoxFit.fill,
                              height: 200,
                              filterQuality: FilterQuality.low,
                            )),
                          ))
                      .toList(),
                ),
              ),
            ),
          );
        } else {
          return const Center();
        }
      },
      // future: postlist(),
    );
  }

  Widget bestsellingproductList() {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 250,
            width: deviceWidth(context, 1.0),
            child: ListView.builder(
                itemCount: topsaleProducts.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProdectDetails(title: topsaleProducts[index].productName!,slug:topsaleProducts[index].slug!)));
                          Get.to(() => ProdectDetails(
                              title: topsaleProducts[index].productName!,
                              slug: topsaleProducts[index].slug!));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: colorgrey, width: 0.5),
                              borderRadius: BorderRadius.circular(6)),
                          //width: deviceWidth(context,0.43),
                          padding: const EdgeInsets.only(
                            top: 8,
                            left: 8,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                topsaleProducts[index].mainImage!,
                                width: deviceWidth(context, 0.32),
                                height: deviceheight(context, 0.12),
                                fit: BoxFit.cover,
                              ),
                              sizedboxheight(3.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: deviceWidth(context, 0.4),
                                    child: Text(
                                      topsaleProducts[index].productName!,
                                      style: textstylesubtitle2(context)!
                                          .copyWith(
                                              color: colorblack,
                                              fontWeight: FontWeight.bold,
                                              height: 1.2),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  sizedboxheight(3.0),
                                  Container(
                                      width: deviceWidth(context, 0.4),
                                      child: Text(
                                        'SKU:${topsaleProducts[index].sku!}',
                                        style: textstylesubtitle2(context)!
                                            .copyWith(fontSize: 9),
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
                                          //width: deviceWidth(context,0.28),
                                          width: deviceWidth(context, 0.35),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                'AED\n${topsaleProducts[index].uprice == null ? '0' : topsaleProducts[index].uprice}',
                                                style:
                                                    textstylesubtitle2(context)!
                                                        .copyWith(
                                                            color: colorblack,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            height: 1.2),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              )),
                                              Expanded(
                                                  child: Text(
                                                'AED\n${topsaleProducts[index].price == null ? '0' : topsaleProducts[index].price}',
                                                style: textstylesubtitle2(
                                                        context)!
                                                    .copyWith(
                                                        fontSize: 9,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        height: 1.2),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              )),
                                            ],
                                          ),
                                        ),

                                        // Container(
                                        //   width: deviceWidth(context,0.1),
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(3),
                                        //     color: colorgreen,
                                        //   ),
                                        //   child:  Padding(
                                        //     padding: const EdgeInsets.all(3.0),
                                        //     child: Center(child: Text('20% off',style: textstylesubtitle2(context)!.copyWith(color: colorWhite,fontSize: 7,height: 1.2),overflow: TextOverflow.ellipsis,maxLines: 2,)),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              sizedboxheight(3.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProdectDetails(title: topsaleProducts[index].productName!,slug:topsaleProducts[index].slug!)));
                                      Get.to(() => ProdectDetails(
                                          title: topsaleProducts[index]
                                              .productName!,
                                          slug: topsaleProducts[index].slug!));
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
                                          style: textstylesubtitle1(context)!
                                              .copyWith(
                                                  color: colorWhite,
                                                  fontSize: 10,
                                                  height: 1.2),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  sizedboxwidth(20.0),
                                  InkWell(
                                  onTap: () {
                                    if(topsaleProducts[index].sku != null){
                                    searchproductdata(topsaleProducts[index].sku);
                                   }
                                  },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(5),
                                        ),
                                        color: colorblue,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
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
                  );
                }),
          );
        } else {
          return const Center();
        }
      },
      // future: postlist(),
    );
  }

  Widget topbrandList() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 2,
      child: Container(
        height: 125,
        width: deviceWidth(context, 1.0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: brands.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: colorblue),
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                                image: NetworkImage(brands[index].brandLogo!,
                                    scale: 5))),
                        width: 55, height: 55,
                        // child: Image.network(brands[index].brandLogo??'',scale:2.5,),
                      ),
                    ),
                    sizedboxheight(5.0),
                    Container(
                        width: deviceWidth(context, 0.2),
                        child: Text(
                          brands[index].brandName ?? '',
                          style: textbold(context)!.copyWith(
                              fontSize: 12, color: Colors.black54, height: 1.2),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ))
                  ],
                ),
              );
            }),
      ),
    );
  }
// Widget cetproductList(){
//   return FutureBuilder(
//     future: _future,
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         return
//           Container(
//             height: deviceheight(context,0.3),
//             width: deviceWidth(context,1.0),
//             child: ListView.builder(
//                 itemCount: catProductsList1.length,
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (BuildContext context,int index){
//                   return InkWell(
//                     onTap: (){
//                       Get.to(() => ProdectDetails(title: 'Safety Shoes'));
//                     },
//                     child: Card(
//                       elevation: 10,
//                       child: Container(
//                         width: deviceWidth(context,0.43),
//                         padding: const EdgeInsets.only(top: 8,left: 8,),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Image.network(catProductsList1[index].categoryName!,height: deviceheight(context,0.12),),
//                             sizedboxheight(3.0),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   width: deviceWidth(context,0.4),
//                                   child: Text(catProductsList1[index].products<Products>,style: textstylesubtitle2(context)!.copyWith(color: colorblack,fontWeight: FontWeight.bold),
//                                     overflow: TextOverflow.ellipsis,maxLines: 2,),
//                                 ),
//                                 sizedboxheight(3.0),
//                                 Container( width: deviceWidth(context,0.4),
//                                     child: Text('SKU:${topsaleProducts[index].sku!}',style: textstylesubtitle2(context)!.copyWith(fontSize: 9),overflow: TextOverflow.ellipsis,maxLines: 1,)),
//                                 sizedboxheight(3.0),
//                                 Container(
//                                   width: deviceWidth(context,0.4),
//                                   child: Row(
//
//                                     children: [
//                                       Container(
//                                         width: deviceWidth(context,0.28),
//                                         child: Row(
//                                           children: [
//                                             Expanded(
//                                                 child: Text('AED ${topsaleProducts[index].uprice} ',style: textstylesubtitle2(context)!.copyWith(color: colorblack,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 2,)),
//                                             Expanded(
//                                                 child: Text('AED ${topsaleProducts[index].regularPrice}  ',style: textstylesubtitle2(context)!.copyWith(fontSize: 9),overflow: TextOverflow.ellipsis,maxLines: 2,)),
//
//                                           ],
//                                         ),
//                                       ),
//
//                                       Container(
//                                         width: deviceWidth(context,0.1),
//
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(3),
//                                           color: colorgreen,
//                                         ),
//                                         child:  Padding(
//                                           padding: const EdgeInsets.all(2.0),
//                                           child: Text('20% off',style: textstylesubtitle2(context)!.copyWith(color: colorWhite,fontSize: 9),overflow: TextOverflow.ellipsis,maxLines: 2,),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             sizedboxheight(3.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   width:deviceWidth(context,0.25) ,
//                                   height: 40,
//
//                                   decoration: BoxDecoration(
//                                     borderRadius: const BorderRadius.only(
//                                       topLeft: Radius.circular(5),
//                                       topRight:  Radius.circular(5),
//                                     ),
//                                     color: colorblue,
//                                   ),
//                                   child:Center(
//                                     child: Text('DETAIL VIEW',
//                                       style: textstylesubtitle1(context)!.copyWith(color: colorWhite,fontSize: 10,),overflow: TextOverflow.ellipsis,maxLines: 2,),
//                                   ),
//                                 ),
//                                 sizedboxwidth(5.0),
//                                 Container(
//                                   width: 40,height: 40,
//
//                                   decoration: BoxDecoration(
//                                     borderRadius: const BorderRadius.only(
//
//                                       bottomRight:  Radius.circular(5),
//                                     ),
//                                     color: colorblue,
//                                   ),
//                                   child:Padding(
//                                     padding: const EdgeInsets.all(10.0),
//                                     child: Image.asset('assets/icons/Group 2060@3x.png',color: colorWhite,),
//                                   ),
//                                 )
//                               ],
//                             ),
//
//
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//             ),
//           );
//       }else
//       {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       }},
//     // future: postlist(),
//   );
// }
}
