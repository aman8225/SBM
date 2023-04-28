import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar_modelpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbarwidget.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/whishlistmodel/whishlistdatamodel.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20details/prodect_details.dart';
import 'package:http/http.dart' as http;

import '../../model/cartmodel/SerchBar/serch_bar_model.dart';
import '../all cotegories/add_to_card_screen/add_to_card_screen.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future? _future;
  var tokanget;

  ProgressDialog? progressDialog;
  var success, message, data;
  List<CardData> whishcarddata = [];
  Future<WhishListDataMessege> whishlistdata() async {
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
    var response = await http.get(Uri.parse(beasurl + 'wishlist'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    progressDialog!.dismiss();
    success =
        (WhishListDataMessege.fromJson(json.decode(response.body)).success);
    message =
        (WhishListDataMessege.fromJson(json.decode(response.body)).message);
    progressDialog!.dismiss();
    if (success == true) {
      progressDialog!.dismiss();
      data = (WhishListDataMessege.fromJson(json.decode(response.body)).data);
      whishcarddata = (WhishListDataMessege.fromJson(json.decode(response.body))
          .data!
          .data)!;
    } else {
      print('else==============');
      progressDialog!.dismiss();
    }
    return WhishListDataMessege.fromJson(json.decode(response.body));
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
    print(beasurl + 'productSearchBySKU?sku=$search');
    var response =
    await http.get(Uri.parse(beasurl + 'productSearchBySKU?sku=$search'), headers: {
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
    _future = whishlistdata();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {

      return Scaffold(
        appBar: appbarnotifav(context, 'WishList'),
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
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return success == false
                            ? Container(
                          width: deviceWidth(context, 1.0),
                          height: deviceheight(context, 1.0),
                          child: const Center(
                            child: Text('No Data'),
                          ),
                        )
                            : SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                children: [
                                  for (int index = 0;
                                  index < whishcarddata.length;
                                  index++) ...[
                                    Card(
                                      child: InkWell(
                                        onTap: () {
                                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProdectDetails(title: topsaleProducts[index].productName!,slug:topsaleProducts[index].slug!)));
                                          Get.to(() => ProdectDetails(
                                              title: whishcarddata[index]
                                                  .productName!,
                                              slug: whishcarddata[index]
                                                  .slug!));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: colorgrey,
                                                  width: 0.5),
                                              borderRadius:
                                              BorderRadius.circular(6)),
                                          width: deviceWidth(context, 0.43),
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                            left: 8,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Image.network(
                                                whishcarddata[index]
                                                    .mediumImage!,
                                                width: deviceWidth(
                                                    context, 0.32),
                                                height: deviceheight(
                                                    context, 0.12),
                                                fit: BoxFit.cover,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    width: deviceWidth(
                                                        context, 0.4),
                                                    height: 30,
                                                    child: Text(
                                                      whishcarddata[index]
                                                          .productName!,
                                                      style: textstylesubtitle2(
                                                          context)!
                                                          .copyWith(
                                                          color:
                                                          colorblack,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          height: 1.2),
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  sizedboxheight(3.0),
                                                  Container(
                                                      width: deviceWidth(
                                                          context, 0.4),
                                                      child: Text(
                                                        'SKU:${whishcarddata[index].sku!}',
                                                        style:
                                                        textstylesubtitle2(
                                                            context)!
                                                            .copyWith(
                                                            fontSize:
                                                            9),
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      )),
                                                  sizedboxheight(3.0),
                                                  Container(
                                                    width: deviceWidth(
                                                        context, 0.4),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                      children: [
                                                        Container(
                                                          width:
                                                          deviceWidth(
                                                              context,
                                                              0.28),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child:
                                                                  Text(
                                                                    'AED\n${whishcarddata[index].uprice == null ? '0' : whishcarddata[index].uprice}',
                                                                    style: textstylesubtitle2(context)!.copyWith(
                                                                        color:
                                                                        colorblack,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        height:
                                                                        1.2),
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                    maxLines: 2,
                                                                  )),
                                                              Expanded(
                                                                  child:
                                                                  Text(
                                                                    'AED\n${whishcarddata[index].regularPrice == null ? '0' : whishcarddata[index].regularPrice}',
                                                                    style: textstylesubtitle2(context)!.copyWith(
                                                                        fontSize:
                                                                        9,
                                                                        decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                        height:
                                                                        1.2),
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                    maxLines: 2,
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        (int.fromEnvironment(whishcarddata[index].discountPercent!) >= 0)?
                                                        Container(
                                                          width:
                                                          deviceWidth(
                                                              context,
                                                              0.1),
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                3),
                                                            color:
                                                            colorgreen,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                3.0),
                                                            child: Center(
                                                                child: Text(
                                                                  '${whishcarddata[index].discountPercent!.split(".")[0]}% off',
                                                                  style: textstylesubtitle2(context)!.copyWith(
                                                                      color:
                                                                      colorWhite,
                                                                      fontSize:
                                                                      7,
                                                                      height:
                                                                      1.2),
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  maxLines: 2,
                                                                )),
                                                          ),
                                                        ):Container(width: deviceWidth(
                                                            context,
                                                            0.1),)
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              sizedboxheight(3.0),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProdectDetails(title: topsaleProducts[index].productName!,slug:topsaleProducts[index].slug!)));
                                                      Get.to(() => ProdectDetails(
                                                          title: whishcarddata[
                                                          index]
                                                              .productName!,
                                                          slug:
                                                          whishcarddata[
                                                          index]
                                                              .slug!));
                                                    },
                                                    child: Container(
                                                      width: deviceWidth(
                                                          context, 0.25),
                                                      height: 40,
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        const BorderRadius
                                                            .only(
                                                          topLeft: Radius
                                                              .circular(5),
                                                          topRight: Radius
                                                              .circular(5),
                                                        ),
                                                        color: colorblue,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'DETAIL VIEW',
                                                          style: textstylesubtitle1(
                                                              context)!
                                                              .copyWith(
                                                              color:
                                                              colorWhite,
                                                              fontSize:
                                                              10,
                                                              height:
                                                              1.2),
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if(whishcarddata[index].sku != null){
                                                        searchproductdata(whishcarddata[index].sku);
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        const BorderRadius
                                                            .only(
                                                          bottomRight:
                                                          Radius.circular(
                                                              5),
                                                        ),
                                                        color: colorblue,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(10.0),
                                                        child:
                                                        SvgPicture.asset(
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
                                    )
                                  ]
                                ],
                              )
                            ],
                          ),
                        );

                        GridView.builder(
                            gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 2 / 2.8,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5),
                            itemCount: whishcarddata.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return Card(
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProdectDetails(title: topsaleProducts[index].productName!,slug:topsaleProducts[index].slug!)));
                                    Get.to(() => ProdectDetails(
                                        title: whishcarddata[index].productName!,
                                        slug: whishcarddata[index].slug!));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: colorgrey, width: 0.5),
                                        borderRadius: BorderRadius.circular(6)),
                                    // width: deviceWidth(context,0.43),
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      left: 8,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.network(
                                          whishcarddata[index].mediumImage!,
                                          width: deviceWidth(context, 0.32),
                                          height: deviceheight(context, 0.12),
                                          fit: BoxFit.cover,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: deviceWidth(context, 0.4),
                                              child: Text(
                                                whishcarddata[index].productName!,
                                                style:
                                                textstylesubtitle2(context)!
                                                    .copyWith(
                                                    color: colorblack,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    height: 1.2),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                            sizedboxheight(3.0),
                                            Container(
                                                width: deviceWidth(context, 0.4),
                                                child: Text(
                                                  'SKU:${whishcarddata[index].sku!}',
                                                  style:
                                                  textstylesubtitle2(context)!
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
                                                    width: deviceWidth(
                                                        context, 0.28),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                              'AED\n${whishcarddata[index].uprice == null ? '0' : whishcarddata[index].uprice}',
                                                              style: textstylesubtitle2(
                                                                  context)!
                                                                  .copyWith(
                                                                  color:
                                                                  colorblack,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  height: 1.2),
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              maxLines: 2,
                                                            )),
                                                        Expanded(
                                                            child: Text(
                                                              'AED\n${whishcarddata[index].regularPrice == null ? '0' : whishcarddata[index].regularPrice}',
                                                              style: textstylesubtitle2(
                                                                  context)!
                                                                  .copyWith(
                                                                  fontSize: 9,
                                                                  decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                                  height: 1.2),
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              maxLines: 2,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                    deviceWidth(context, 0.1),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          3),
                                                      color: colorgreen,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          3.0),
                                                      child: Center(
                                                          child: Text(
                                                            '${whishcarddata[index].discountPercent!.split(".")[0]}% off',
                                                            style: textstylesubtitle2(
                                                                context)!
                                                                .copyWith(
                                                                color: colorWhite,
                                                                fontSize: 7,
                                                                height: 1.2),
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                          )),
                                                    ),
                                                  )
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
                                                    title: whishcarddata[index]
                                                        .productName!,
                                                    slug: whishcarddata[index]
                                                        .slug!));
                                              },
                                              child: Container(
                                                width: deviceWidth(context, 0.25),
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    topRight: Radius.circular(5),
                                                  ),
                                                  color: colorblue,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'DETAIL VIEW',
                                                    style: textstylesubtitle1(
                                                        context)!
                                                        .copyWith(
                                                        color: colorWhite,
                                                        fontSize: 10,
                                                        height: 1.2),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                const BorderRadius.only(
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
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    // future: postlist(),
                  )),
            ),
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



  }

//
// Widget itemcard(){
//   return InkWell(
//     onTap: (){
//       Get.to(() => ProdectDetails(title: 'Safety Shoes'));
//       Get.to(() => ProdectDetails(title: catProductsList[index].products![i].slug!,slug:catProductsList[index].products![i].slug!));
//     },
//     child: Card(
//       elevation: 10,
//       child: Container(
//         width: deviceWidth(context,0.43),
//         padding: const EdgeInsets.only(top: 8,left: 8,),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Image.asset('assets/img_2.png',height: deviceheight(context,0.12),),
//             sizedboxheight(3.0),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: deviceWidth(context,0.4),
//                   child: Text('sbm,SBP Breathable Leather Low Ankl Pro',style: textstylesubtitle2(context)!.copyWith(color: colorblack,fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.ellipsis,maxLines: 2,),
//                 ),
//                 sizedboxheight(3.0),
//                 Container( width: deviceWidth(context,0.4),
//                     child: Text('SKU: E23sd34',style: textstylesubtitle2(context)!.copyWith(fontSize: 9),overflow: TextOverflow.ellipsis,maxLines: 1,)),
//                 sizedboxheight(3.0),
//                 Container(
//                   width: deviceWidth(context,0.4),
//                   child: Row(
//
//                     children: [
//                       Container(
//                         width: deviceWidth(context,0.28),
//                         child: Row(
//                           children: [
//                             Expanded(
//                                 child: Text('AED 199 ',style: textstylesubtitle2(context)!.copyWith(color: colorblack,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 2,)),
//                             Expanded(
//                                 child: Text('AED 199  ',style: textstylesubtitle2(context)!.copyWith(fontSize: 9),overflow: TextOverflow.ellipsis,maxLines: 2,)),
//
//                           ],
//                         ),
//                       ),
//
//                       Container(
//                         width: deviceWidth(context,0.1),
//
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(3),
//                           color: colorgreen,
//                         ),
//                         child:  Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: Text('20% off',style: textstylesubtitle2(context)!.copyWith(color: colorWhite,fontSize: 9),overflow: TextOverflow.ellipsis,maxLines: 2,),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             sizedboxheight(3.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   width:deviceWidth(context,0.25) ,
//                   height: 40,
//
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(5),
//                       topRight:  Radius.circular(5),
//                     ),
//                     color: colorblue,
//                   ),
//                   child:Center(
//                     child: Text('DETAIL VIEW',
//                       style: textstylesubtitle1(context)!.copyWith(color: colorWhite,fontSize: 10,),overflow: TextOverflow.ellipsis,maxLines: 2,),
//                   ),
//                 ),
//                 sizedboxwidth(5.0),
//                 Container(
//                   width: 40,height: 40,
//
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//
//                       bottomRight:  Radius.circular(5),
//                     ),
//                     color: colorblue,
//                   ),
//                   child:Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Image.asset('assets/icons/Group 2060@3x.png',color: colorWhite,),
//                   ),
//                 )
//               ],
//             ),
//
//
//           ],
//         ),
//       ),
//     ),
//   );
// }

}
