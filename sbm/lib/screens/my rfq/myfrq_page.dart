import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:http/http.dart' as http;
import 'package:sbm/model/rfq_model/rfq_model.dart';

class MyRFQ_Page extends StatefulWidget {
  const MyRFQ_Page({Key? key}) : super(key: key);

  @override
  _MyRFQ_PageState createState() => _MyRFQ_PageState();
}

class _MyRFQ_PageState extends State<MyRFQ_Page> {
  Future? _future;
  var tokanget;

  ProgressDialog? progressDialog;
  var success, message, data;
  List<RFQModelResponse> rfqdatalist = [];
  Future<RFQModelMassege> myrfqdata() async {
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
    var response = await http.get(Uri.parse('${beasurl}rfq'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    print(response.body);
    progressDialog!.dismiss();
    success = (RFQModelMassege.fromJson(json.decode(response.body)).success);
    message = (RFQModelMassege.fromJson(json.decode(response.body)).message);

    progressDialog!.dismiss();
    if (success == true) {
      progressDialog!.dismiss();
      data = (RFQModelMassege.fromJson(json.decode(response.body)).data);
      rfqdatalist =
          (RFQModelMassege.fromJson(json.decode(response.body)).data)!;
    } else {
      print('else==============');
      progressDialog!.dismiss();
    }
    return RFQModelMassege.fromJson(json.decode(response.body));
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
  void initState() {
    super.initState();
    _future = myrfqdata();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {

      return Scaffold(
        appBar: appbarnotifav(context, 'MY RFQ(2)'),
        body: Stack(
          children: [
            Container(
              width: deviceWidth(context, 0.2),
              height: deviceheight(context, 1.0),
              color: colorskyeblue,
            ),
            FutureBuilder(
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
                      : Container(
                    child: ListView.builder(
                        itemCount: rfqdatalist.length,
                        itemBuilder: ((itemBuilder, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: colorgrey)),
                              child: ExpansionTile(
                                trailing: const SizedBox(),
                                title: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'RFQ Id :',
                                      style: textstylesubtitle1(context)!
                                          .copyWith(height: 1.5),
                                    ),
                                    Text(
                                      '${rfqdatalist[index].orderId}   |  ${rfqdatalist[index].items!.length}item  |  Placed on ${rfqdatalist[index].placedOn}',
                                      style: TextStyle(
                                          height: 1.5, color: colorblack),
                                    ),
                                  ],
                                ),
                                children: <Widget>[
                                  ListTile(
                                      title: Container(
                                        //height: rfqdatalist[index].items!.length*120,
                                        child: ListView.builder(
                                            physics:
                                            const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: rfqdatalist[index]
                                                .items!
                                                .length,
                                            itemBuilder: ((itemBuilder, int i) {
                                              return Container(
                                                height: 100,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: deviceWidth(
                                                          context, 1.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: deviceWidth(
                                                                context, 0.35),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Product: ',
                                                                  style: textstylesubtitle1(
                                                                      context),
                                                                ),
                                                                Text(rfqdatalist[
                                                                index]
                                                                    .items![i]
                                                                    .productOrCategoryDetails!),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: deviceWidth(
                                                                context, 0.35),
                                                            child: Row(
                                                              children: [
                                                                Text('Qty: ',
                                                                    style: textstylesubtitle1(
                                                                        context)),
                                                                Text(rfqdatalist[index]
                                                                    .items![
                                                                i]
                                                                    .quantity ==
                                                                    null
                                                                    ? ''
                                                                    : rfqdatalist[
                                                                index]
                                                                    .items![
                                                                i]
                                                                    .quantity!),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    sizedboxheight(5.0),
                                                    Text('AED',
                                                        style:
                                                        textstylesubtitle1(
                                                            context)),
                                                    sizedboxheight(5.0),
                                                    // Container(
                                                    //   width: deviceWidth(context,1.0),
                                                    //   child: Row(
                                                    //     children: [
                                                    //       Container(
                                                    //         width: deviceWidth(context,0.35),
                                                    //         child: Row(
                                                    //           children: [
                                                    //             Text('Brand: ',style: textstylesubtitle1(context),),
                                                    //             Text(rfqdatalist[index].items![i].brand!),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //       Container(
                                                    //         width: deviceWidth(context,0.35),
                                                    //         child: Row(
                                                    //           children: [
                                                    //             Text('Size: ',style: textstylesubtitle1(context)),
                                                    //             Text(rfqdatalist[index].items![i].brand!),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //     ],),
                                                    // ),

                                                    Text(
                                                      "CREATED",
                                                      style: textstylesubtitle1(
                                                          context)!
                                                          .copyWith(
                                                          color: colorblue),
                                                    ),
                                                    const Divider(
                                                      thickness: 2,
                                                    )
                                                  ],
                                                ),
                                              );
                                            })),
                                      )),
                                ],
                              ),
                            ),
                          );
                        })),
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


    // return Scaffold(
    //   appBar: appbarnotifav(context, 'MY RFQ(2)'),
    //   body: Stack(
    //     children: [
    //       Container(
    //         width: deviceWidth(context, 0.2),
    //         height: deviceheight(context, 1.0),
    //         color: colorskyeblue,
    //       ),
    //       FutureBuilder(
    //         future: _future,
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData) {
    //             return success == false
    //                 ? Container(
    //                     width: deviceWidth(context, 1.0),
    //                     height: deviceheight(context, 1.0),
    //                     child: Center(
    //                       child: Text('No Data'),
    //                     ),
    //                   )
    //                 : Container(
    //                     child: ListView.builder(
    //                         physics: const NeverScrollableScrollPhysics(),
    //                         shrinkWrap: true,
    //                         itemCount: rfqdatalist.length,
    //                         itemBuilder: ((itemBuilder, int index) {
    //                           return Padding(
    //                             padding: EdgeInsets.only(
    //                                 bottom: 10, left: 10, right: 10),
    //                             child: Container(
    //                               decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.circular(5),
    //                                   border: Border.all(color: colorgrey)),
    //                               child: ExpansionTile(
    //                                 trailing: const SizedBox(),
    //                                 title: Column(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.start,
    //                                   children: [
    //                                     Text(
    //                                       'RFQ Id :',
    //                                       style: textstylesubtitle1(context)!
    //                                           .copyWith(height: 1.5),
    //                                     ),
    //                                     Text(
    //                                       '${rfqdatalist[index].orderId}   |  ${rfqdatalist[index].items!.length}item  |  Placed on ${rfqdatalist[index].placedOn}',
    //                                       style: TextStyle(
    //                                           height: 1.5, color: colorblack),
    //                                     ),
    //                                   ],
    //                                 ),
    //                                 children: <Widget>[
    //                                   ListTile(
    //                                       title: Container(
    //                                     //height: rfqdatalist[index].items!.length*120,
    //                                     child: ListView.builder(
    //                                         physics:
    //                                             const NeverScrollableScrollPhysics(),
    //                                         shrinkWrap: true,
    //                                         itemCount: rfqdatalist[index]
    //                                             .items!
    //                                             .length,
    //                                         itemBuilder: ((itemBuilder, int i) {
    //                                           return Container(
    //                                             height: 100,
    //                                             child: Column(
    //                                               crossAxisAlignment:
    //                                                   CrossAxisAlignment.start,
    //                                               children: [
    //                                                 Container(
    //                                                   width: deviceWidth(
    //                                                       context, 1.0),
    //                                                   child: Row(
    //                                                     children: [
    //                                                       Container(
    //                                                         width: deviceWidth(
    //                                                             context, 0.35),
    //                                                         child: Row(
    //                                                           children: [
    //                                                             Text(
    //                                                               'Product: ',
    //                                                               style: textstylesubtitle1(
    //                                                                   context),
    //                                                             ),
    //                                                             Text(rfqdatalist[
    //                                                                     index]
    //                                                                 .items![i]
    //                                                                 .productOrCategoryDetails!),
    //                                                           ],
    //                                                         ),
    //                                                       ),
    //                                                       Container(
    //                                                         width: deviceWidth(
    //                                                             context, 0.35),
    //                                                         child: Row(
    //                                                           children: [
    //                                                             Text('Qty: ',
    //                                                                 style: textstylesubtitle1(
    //                                                                     context)),
    //                                                             Text(rfqdatalist[index]
    //                                                                         .items![
    //                                                                             i]
    //                                                                         .quantity ==
    //                                                                     null
    //                                                                 ? ''
    //                                                                 : rfqdatalist[
    //                                                                         index]
    //                                                                     .items![
    //                                                                         i]
    //                                                                     .quantity!),
    //                                                           ],
    //                                                         ),
    //                                                       ),
    //                                                     ],
    //                                                   ),
    //                                                 ),
    //                                                 sizedboxheight(5.0),
    //                                                 Text('AED',
    //                                                     style:
    //                                                         textstylesubtitle1(
    //                                                             context)),
    //                                                 sizedboxheight(5.0),
    //                                                 // Container(
    //                                                 //   width: deviceWidth(context,1.0),
    //                                                 //   child: Row(
    //                                                 //     children: [
    //                                                 //       Container(
    //                                                 //         width: deviceWidth(context,0.35),
    //                                                 //         child: Row(
    //                                                 //           children: [
    //                                                 //             Text('Brand: ',style: textstylesubtitle1(context),),
    //                                                 //             Text(rfqdatalist[index].items![i].brand!),
    //                                                 //           ],
    //                                                 //         ),
    //                                                 //       ),
    //                                                 //       Container(
    //                                                 //         width: deviceWidth(context,0.35),
    //                                                 //         child: Row(
    //                                                 //           children: [
    //                                                 //             Text('Size: ',style: textstylesubtitle1(context)),
    //                                                 //             Text(rfqdatalist[index].items![i].brand!),
    //                                                 //           ],
    //                                                 //         ),
    //                                                 //       ),
    //                                                 //     ],),
    //                                                 // ),
    //
    //                                                 Text(
    //                                                   rfqdatalist[index]
    //                                                       .items![i]
    //                                                       .status!,
    //                                                   style: textstylesubtitle1(
    //                                                           context)!
    //                                                       .copyWith(
    //                                                           color: colorblue),
    //                                                 ),
    //                                                 const Divider(
    //                                                   thickness: 2,
    //                                                 )
    //                                               ],
    //                                             ),
    //                                           );
    //                                         })),
    //                                   )),
    //                                 ],
    //                               ),
    //                             ),
    //                           );
    //                         })),
    //                   );
    //           } else {
    //             return const Center(
    //               child: CircularProgressIndicator(),
    //             );
    //           }
    //         },
    //         // future: postlist(),
    //       ),
    //     ],
    //   ),
    // );
  }

  // Widget createdcarditam() {
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //     elevation: 3,
  //     child: Container(
  //       width: deviceWidth(context, 1.0),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           border: Border.all(color: colorblue)),
  //       padding: EdgeInsets.all(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             width: deviceWidth(context, 1.0),
  //             child: Row(
  //               children: [
  //                 Container(
  //                   width: deviceWidth(context, 0.35),
  //                   child: Row(
  //                     children: [
  //                       Text(
  //                         'Product: ',
  //                         style: textstylesubtitle1(context),
  //                       ),
  //                       Text('safety'),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                   width: deviceWidth(context, 0.35),
  //                   child: Row(
  //                     children: [
  //                       Text('Qty: ', style: textstylesubtitle1(context)),
  //                       Text('1'),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           sizedboxheight(10.0),
  //           Container(
  //             width: deviceWidth(context, 1.0),
  //             child: Row(
  //               children: [
  //                 Container(
  //                   width: deviceWidth(context, 0.35),
  //                   child: Row(
  //                     children: [
  //                       Text(
  //                         'Brand: ',
  //                         style: textstylesubtitle1(context),
  //                       ),
  //                       Text('1'),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                   width: deviceWidth(context, 0.35),
  //                   child: Row(
  //                     children: [
  //                       Text('Size: ', style: textstylesubtitle1(context)),
  //                       Text('36'),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           sizedboxheight(10.0),
  //           Text(
  //             'CREATED',
  //             style: textstylesubtitle1(context)!.copyWith(color: colorblue),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget carditam() {
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //     elevation: 1,
  //     child: Container(
  //       width: deviceWidth(context, 1.0),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           border: Border.all(color: colorblack54)),
  //       padding: EdgeInsets.all(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('RFQ id:'),
  //           Text(
  //             '23422   |  2item  |  Placed on 12/21/2020',
  //             style: textstylesubtitle1(context)!.copyWith(height: 1.5),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
