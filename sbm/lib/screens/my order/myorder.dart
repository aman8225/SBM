import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/myordermodel/myordermodel.dart';
import 'package:sbm/screens/accept%20orderpage/accepteorderpage.dart';
import 'package:http/http.dart' as http;

class MyOrder extends StatefulWidget {
  const MyOrder({Key? key}) : super(key: key);

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future? _future;
  var tokanget;

  ProgressDialog? progressDialog;
  var success, message, data;
  List<Orders> orderdata = [];
  Future<MyOrderModelMessege> myOrderdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(const Text("Loading...."));
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
    var response = await http.get(Uri.parse('${beasurl}orders'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });

    progressDialog!.dismiss();
    success =
        (MyOrderModelMessege.fromJson(json.decode(response.body)).success);
    message =
        (MyOrderModelMessege.fromJson(json.decode(response.body)).message);
    progressDialog!.dismiss();
    if (success == true) {
      progressDialog!.dismiss();
      data = (MyOrderModelMessege.fromJson(json.decode(response.body)).data);
      orderdata = (MyOrderModelMessege.fromJson(json.decode(response.body))
          .data!
          .orders)!;
    } else {
      progressDialog!.dismiss();
    }
    return MyOrderModelMessege.fromJson(json.decode(response.body));
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
    _future = myOrderdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: appbarnotifav(context, 'My Order'),
      body: Stack(
        children: [
          Container(
            width: deviceWidth(context, 0.2),
            height: deviceheight(context, 1.0),
            color: colorskyeblue,
          ),
          Container(
            height: deviceheight(context, 1.0),
            width: deviceWidth(context, 1.0),
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return orderdata.length == null
                      ? Container(
                    child: const Center(
                      child: Text('No Data'),
                    ),
                  )
                      : ListView.builder(
                      itemCount: orderdata.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 2,
                          child: Container(
                            width: deviceWidth(context, 1.0),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: deviceWidth(context, 0.6),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Order ID: ${orderdata[index].id ?? ''}',
                                            style:
                                            textstyleHeading3(context),
                                          ),
                                          Text(
                                            'Payment Mode: ${orderdata[index].paymentMethod ?? ''}',
                                            style:
                                            textstylesubtitle2(context)!
                                                .copyWith(
                                                color: colorblue,
                                                height: 1.5),
                                          ),
                                          Text(
                                            'Order Date : ${(orderdata[index].datePurchased!.split(" ")[0]) ?? ''}',
                                            style:
                                            textstylesubtitle2(context)!
                                                .copyWith(height: 1.5),
                                          ),
                                          Text(
                                            'Your order is currently being processed. Your Order Estimate Delivery',
                                            style:
                                            textstylesubtitle2(context)!
                                                .copyWith(height: 1.5),
                                          ),

                                          Text(
                                            'Total Price: AED ${orderdata[index].orderPrice ?? ''}',
                                            style:
                                            textstylesubtitle1(context)!
                                                .copyWith(
                                                color: colorblue,
                                                height: 1.5),
                                          ),
                                          sizedboxheight(8.0),
                                          InkWell(
                                            onTap: () {
                                              Get.to(() => AcceptOrderPage(
                                                  ID: orderdata[index]
                                                      .id!));
                                              // Navigator.push(context, MaterialPageRoute(builder: (_)=>))
                                            },
                                            child: Container(
                                              color: colorblue,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Text(
                                                  'VIEW FULL ORDER',
                                                  style: textstylesubtitle2(
                                                      context)!
                                                      .copyWith(
                                                      color:
                                                      colorWhite),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: deviceWidth(context, 0.25),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icons/Group 2050@3x.png',
                                            height: 30,
                                            width: 30,
                                          ),
                                          Text(
                                            '${orderdata[index].status}??',
                                            style:
                                            textstylesubtitle2(context)!
                                                .copyWith(
                                              height: 1.3,
                                              color: colorblue,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Status',
                                            style:
                                            textstylesubtitle2(context)!
                                                .copyWith(height: 1.5),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),

                                // Container(
                                //   height: deviceheight(context,0.2),
                                //   width: deviceWidth(context,1.0),
                                //   child: GridView.builder(
                                //
                                //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                //           maxCrossAxisExtent: 120,
                                //           childAspectRatio: 3/ 2,
                                //           crossAxisSpacing: 20,
                                //           mainAxisSpacing: 5),
                                //       itemCount: 5,
                                //       itemBuilder: (BuildContext ctx, index) {
                                //         return Card(
                                //           shape: RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.circular(8.0),
                                //           ),
                                //           elevation: 5,
                                //           child: InkWell(
                                //             onTap: () async {
                                //               Get.to(() => AcceptOrderPage());
                                //             },
                                //             child: Container(
                                //               decoration: BoxDecoration(
                                //                 borderRadius: BorderRadius.circular(8)
                                //               ),
                                //               alignment: Alignment.center,
                                //               child: Column(
                                //
                                //                 mainAxisAlignment: MainAxisAlignment.center,
                                //                 children: [
                                //                   Text('ACCEPTED',style: textstylesubtitle2(context)!.copyWith(color: colorblue,fontWeight: FontWeight.bold,height: 1.5),),
                                //                Text('Dec-12-2020',style: textstylesubtitle2(context),)
                                //                 ],
                                //               ),
                                //
                                //             ),
                                //           ),
                                //         );
                                //       }),
                                // ),
                              ],
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
            ),
          ),
        ],
      ),
      // floatingActionButton:  FloatingActionButton(
      //   onPressed: () {
      //     model.togglebottomindexreset();
      //     Get.to(BottomNavBarPage());
      //   },
      //   tooltip: 'Increment',
      //   child: SvgPicture.asset(
      //     'assets/slicing 2/home (10).svg',
      //     width: 25,
      //     height: 25,
      //     color: colorWhite,
      //   ),
      //   elevation: 2.0,
      // ),
      // bottomNavigationBar: bottomNavBarPagewidget(context, model),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );

    // return Scaffold(
    //   key: _scaffoldKey,
    //   appBar: appbarnotifav(context, 'My Order'),
    //   body: Stack(
    //     children: [
    //       Container(
    //         width: deviceWidth(context, 0.2),
    //         height: deviceheight(context, 1.0),
    //         color: colorskyeblue,
    //       ),
    //       Container(
    //         height: deviceheight(context, 1.0),
    //         width: deviceWidth(context, 1.0),
    //         padding: const EdgeInsets.all(10.0),
    //         child: FutureBuilder(
    //           future: _future,
    //           builder: (context, snapshot) {
    //             if (snapshot.hasData) {
    //               return orderdata.length == null
    //                   ? Container(
    //                       child: Center(
    //                         child: Text('No Data'),
    //                       ),
    //                     )
    //                   : ListView.builder(
    //                       itemCount: orderdata.length,
    //                       scrollDirection: Axis.vertical,
    //                       itemBuilder: (BuildContext context, int index) {
    //                         return Card(
    //                           elevation: 2,
    //                           child: Container(
    //                             width: deviceWidth(context, 1.0),
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Column(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                                 Row(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.center,
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.spaceBetween,
    //                                   children: [
    //                                     Container(
    //                                       width: deviceWidth(context, 0.6),
    //                                       child: Column(
    //                                         crossAxisAlignment:
    //                                             CrossAxisAlignment.start,
    //                                         children: [
    //                                           Text(
    //                                             'Order ID: ${orderdata[index].id ?? ''}',
    //                                             style:
    //                                                 textstyleHeading3(context),
    //                                           ),
    //                                           Text(
    //                                             'Payment Mode: ${orderdata[index].paymentMethod ?? ''}',
    //                                             style:
    //                                                 textstylesubtitle2(context)!
    //                                                     .copyWith(
    //                                                         color: colorblue,
    //                                                         height: 1.5),
    //                                           ),
    //                                           Text(
    //                                             'Your order is currently being processed. Your Order'
    //                                             'Estimate Delivery 15 December,2020',
    //                                             style:
    //                                                 textstylesubtitle2(context)!
    //                                                     .copyWith(height: 1.5),
    //                                           ),
    //                                           Text(
    //                                             'Total Price: AED ${orderdata[index].orderPrice ?? ''}',
    //                                             style:
    //                                                 textstylesubtitle1(context)!
    //                                                     .copyWith(
    //                                                         color: colorblue,
    //                                                         height: 1.5),
    //                                           ),
    //                                           sizedboxheight(8.0),
    //                                           InkWell(
    //                                             onTap: () {
    //                                               Get.to(() => AcceptOrderPage(
    //                                                   ID: orderdata[index]
    //                                                       .id!));
    //                                               // Navigator.push(context, MaterialPageRoute(builder: (_)=>))
    //                                             },
    //                                             child: Container(
    //                                               color: colorblue,
    //                                               child: Padding(
    //                                                 padding:
    //                                                     const EdgeInsets.only(
    //                                                         left: 15,
    //                                                         right: 15,
    //                                                         top: 8,
    //                                                         bottom: 8),
    //                                                 child: Text(
    //                                                   'VIEW FULL ORDER',
    //                                                   style: textstylesubtitle2(
    //                                                           context)!
    //                                                       .copyWith(
    //                                                           color:
    //                                                               colorWhite),
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                           )
    //                                         ],
    //                                       ),
    //                                     ),
    //                                     Container(
    //                                       width: deviceWidth(context, 0.25),
    //                                       child: Column(
    //                                         crossAxisAlignment:
    //                                             CrossAxisAlignment.center,
    //                                         children: [
    //                                           Image.asset(
    //                                             'assets/icons/Group 2050@3x.png',
    //                                             height: 30,
    //                                             width: 30,
    //                                           ),
    //                                           Text(
    //                                             '${orderdata[index].status}??',
    //                                             style:
    //                                                 textstylesubtitle2(context)!
    //                                                     .copyWith(
    //                                               height: 1.3,
    //                                               color: colorblue,
    //                                             ),
    //                                             textAlign: TextAlign.center,
    //                                           ),
    //                                           Text(
    //                                             'Status',
    //                                             style:
    //                                                 textstylesubtitle2(context)!
    //                                                     .copyWith(height: 1.5),
    //                                           ),
    //                                         ],
    //                                       ),
    //                                     )
    //                                   ],
    //                                 ),
    //
    //                                 // Container(
    //                                 //   height: deviceheight(context,0.2),
    //                                 //   width: deviceWidth(context,1.0),
    //                                 //   child: GridView.builder(
    //                                 //
    //                                 //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    //                                 //           maxCrossAxisExtent: 120,
    //                                 //           childAspectRatio: 3/ 2,
    //                                 //           crossAxisSpacing: 20,
    //                                 //           mainAxisSpacing: 5),
    //                                 //       itemCount: 5,
    //                                 //       itemBuilder: (BuildContext ctx, index) {
    //                                 //         return Card(
    //                                 //           shape: RoundedRectangleBorder(
    //                                 //             borderRadius: BorderRadius.circular(8.0),
    //                                 //           ),
    //                                 //           elevation: 5,
    //                                 //           child: InkWell(
    //                                 //             onTap: () async {
    //                                 //               Get.to(() => AcceptOrderPage());
    //                                 //             },
    //                                 //             child: Container(
    //                                 //               decoration: BoxDecoration(
    //                                 //                 borderRadius: BorderRadius.circular(8)
    //                                 //               ),
    //                                 //               alignment: Alignment.center,
    //                                 //               child: Column(
    //                                 //
    //                                 //                 mainAxisAlignment: MainAxisAlignment.center,
    //                                 //                 children: [
    //                                 //                   Text('ACCEPTED',style: textstylesubtitle2(context)!.copyWith(color: colorblue,fontWeight: FontWeight.bold,height: 1.5),),
    //                                 //                Text('Dec-12-2020',style: textstylesubtitle2(context),)
    //                                 //                 ],
    //                                 //               ),
    //                                 //
    //                                 //             ),
    //                                 //           ),
    //                                 //         );
    //                                 //       }),
    //                                 // ),
    //                               ],
    //                             ),
    //                           ),
    //                         );
    //                       });
    //             } else {
    //               return const Center(
    //                 child: CircularProgressIndicator(),
    //               );
    //             }
    //           },
    //           // future: postlist(),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
// Widget Carditam(context){
//   return Padding(
//     padding: const EdgeInsets.all(10.0),
//     child: Card(
//       elevation: 8,
//       child: Container(
//         width: deviceWidth(context,1.0),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     width: deviceWidth(context,0.6),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Order Id: 3032243',style: textstyleHeading3(context),),
//                         Text('Payment Mode:Cash On Delivery',style: textstylesubtitle2(context)!.copyWith(color: colorblue,height: 1.5),),
//                         Text('Your order is curentlu being processed Your'
//                             ' Order Estimate Delivery 15 Decenber 2020.',style: textstylesubtitle2(context)!.copyWith(height: 1.5),),
//                         Text('Total Price: AED 5000',style: textstylesubtitle1(context)!.copyWith(color: colorblue,height: 1.5),),
//                     sizedboxheight(8.0),
//                      InkWell(
//                        onTap: (){
//                          Get.to(() => const AcceptOrderPage());
//                        },
//                        child: Container(
//                          color: colorblue,
//                          child: Padding(
//                            padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
//                            child: Text('VIEW FULL ORDER',style: textstylesubtitle2(context)!.copyWith(color: colorWhite),),
//                          ),
//                        ),
//                      )
//                       ],
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Image.asset('assets/icons/Group 2050@3x.png',height: 30,width: 30,),
//                       Text('Processed',style: textstylesubtitle2(context)!.copyWith(height: 1.5,color: colorblue),),
//                       Text('Status',style: textstylesubtitle2(context)!.copyWith(height: 1.5),),
//                     ],
//                   )
//                 ],
//               ),
//               sizedboxheight(10.0),
//               // Container(
//               //   height: deviceheight(context,0.2),
//               //   width: deviceWidth(context,1.0),
//               //   child: GridView.builder(
//               //
//               //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//               //           maxCrossAxisExtent: 120,
//               //           childAspectRatio: 3/ 2,
//               //           crossAxisSpacing: 20,
//               //           mainAxisSpacing: 5),
//               //       itemCount: 5,
//               //       itemBuilder: (BuildContext ctx, index) {
//               //         return Card(
//               //           shape: RoundedRectangleBorder(
//               //             borderRadius: BorderRadius.circular(8.0),
//               //           ),
//               //           elevation: 5,
//               //           child: InkWell(
//               //             onTap: () async {
//               //               Get.to(() => AcceptOrderPage());
//               //             },
//               //             child: Container(
//               //               decoration: BoxDecoration(
//               //                 borderRadius: BorderRadius.circular(8)
//               //               ),
//               //               alignment: Alignment.center,
//               //               child: Column(
//               //
//               //                 mainAxisAlignment: MainAxisAlignment.center,
//               //                 children: [
//               //                   Text('ACCEPTED',style: textstylesubtitle2(context)!.copyWith(color: colorblue,fontWeight: FontWeight.bold,height: 1.5),),
//               //                Text('Dec-12-2020',style: textstylesubtitle2(context),)
//               //                 ],
//               //               ),
//               //
//               //             ),
//               //           ),
//               //         );
//               //       }),
//               // ),
//
//
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
}
