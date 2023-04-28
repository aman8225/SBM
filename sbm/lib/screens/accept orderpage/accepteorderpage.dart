import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
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
import 'package:http/http.dart' as http;
import 'package:sbm/model/order_card_full_details_model/order_card_full_details_model.dart';

import '../all cotegories/prodect details/prodect_details.dart';
import '../all cotegories/prodect list/prodect_list.dart';

class AcceptOrderPage extends StatefulWidget {
  final int ID;
  const AcceptOrderPage({Key? key, required this.ID}) : super(key: key);

  @override
  _AcceptOrderPageState createState() => _AcceptOrderPageState();
}

class _AcceptOrderPageState extends State<AcceptOrderPage> {
  Future? _future;
  var tokanget;

  ProgressDialog? progressDialog;
  var success, message;
  OrderCardFullDetailsModelResponse? data;
  Future<OrderCardFullDetailsModelMassege> myOrderdata() async {
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
    var response = await http
        .get(Uri.parse(beasurl + 'viewOrder/' + widget.ID.toString()), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    print(response.body);
    success =
        (OrderCardFullDetailsModelMassege.fromJson(json.decode(response.body))
            .success);
    message =
        (OrderCardFullDetailsModelMassege.fromJson(json.decode(response.body))
            .message);
    progressDialog!.dismiss();
    if (success == true) {
      progressDialog!.dismiss();
      data =
          (OrderCardFullDetailsModelMassege.fromJson(json.decode(response.body))
              .data);
    } else {
      progressDialog!.dismiss();
    }
    return OrderCardFullDetailsModelMassege.fromJson(
        json.decode(response.body));
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
    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {
       return Scaffold(
      appBar: appbarnotifav(context, 'My Order'),
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
            child:  FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
      if (snapshot.hasData) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: deviceWidth(context, 1.0),
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration:
              BoxDecoration(border: Border.all(color: colorblue)),
              child: Column(
                children: [
                  sizedboxheight(5.0),
                  Text(
                    'ORDER DATE',
                    style: textstylesubtitle1(context)!.copyWith(
                        color: colorblue,
                        fontWeight: FontWeight.bold,
                        height: 1.5),
                  ),
                  Text(data!.datePurchased.toString().split("T")[0], style: textstylesubtitle2(context)),
                  sizedboxheight(5.0),
                ],
              ),
            ),
            sizedboxheight(8.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Order No.${data!.id ?? ''}',
                          style: textstyleHeading3(context),
                        ),
                      ],
                    ),
                    sizedboxheight(8.0),
                    Container(
                      child: ListView.builder(
                          physics:
                          const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data!.products!.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context,
                              int index) {
                            return InkWell(
                              onTap: () {


                                Get.to(() => ProdectDetails(
                                    title: data!.products![index].productName,
                                    slug: data!.products![index].slug)

                                );

                              },
                              child: Card(
                                elevation: 2,
                                child: Container(
                                  width:
                                  deviceWidth(context, 1.0),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .center,
                                      children: [
                                        Image.network(
                                          data!.products![index]
                                              .thumbnailImage!,
                                          width: deviceWidth(
                                              context, 0.18),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Container(
                                                width:
                                                deviceWidth(
                                                    context,
                                                    0.65),
                                                child: Text(
                                                  data!.products![index].productName ==
                                                      null
                                                      ? ''
                                                      : data!
                                                      .products![
                                                  index]
                                                      .productName!,
                                                  style: textstylesubtitle1(
                                                      context),
                                                  overflow:
                                                  TextOverflow
                                                      .ellipsis,
                                                  maxLines: 2,
                                                )),
                                            Container(
                                              width:
                                              deviceWidth(
                                                  context,
                                                  0.65),
                                              child: RichText(
                                                text: TextSpan(
                                                    children: <
                                                        InlineSpan>[
                                                      for (var string in data!
                                                          .products![
                                                      index]
                                                          .productCategories!)
                                                        TextSpan(
                                                            text:
                                                            "${string.categoryName}, ",
                                                            style:
                                                            TextStyle(
                                                              color: colorblue,
                                                            )),
                                                    ]),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width:
                                                  deviceWidth(
                                                      context,
                                                      0.45),
                                                  child:
                                                  DataTable(
                                                    columnSpacing:
                                                    8,
                                                    dataRowHeight:
                                                    22,
                                                    dividerThickness:
                                                    0,
                                                    headingRowHeight:
                                                    22,
                                                    columns: const <
                                                        DataColumn>[
                                                      DataColumn(
                                                        label:
                                                        Text(
                                                          'Size',
                                                          style:
                                                          TextStyle(color: Colors.black),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label:
                                                        Text(
                                                          'Qty',
                                                          style:
                                                          TextStyle(color: Colors.black),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label:
                                                        Text(
                                                          'Price',
                                                          style:
                                                          TextStyle(color: Colors.black),
                                                        ),
                                                      ),
                                                    ],

                                                    rows: data!
                                                        .products![
                                                    index]
                                                        .productsAttributes! // Loops through dataColumnText, each iteration assigning the value to element
                                                        .map(
                                                      ((element) =>
                                                          DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(Text(
                                                                element.itemCode == null ? '' : element.itemCode!.split('-')[1],
                                                                style: const TextStyle(fontSize: 11),
                                                              )),
                                                              DataCell(Text(
                                                                element.quantity == null ? '' : element.quantity.toString(),
                                                                style: const TextStyle(fontSize: 11),
                                                              )),
                                                              DataCell(Text(
                                                                'AED ${element.productPrice == null ? '00' : element.productPrice.toString()}',
                                                                style: const TextStyle(fontSize: 11, color: Colors.lightBlue, fontWeight: FontWeight.bold),
                                                              )),
                                                            ],
                                                          )),
                                                    )
                                                        .toList(),

                                                    // const <DataRow>[
                                                    //   DataRow(
                                                    //     cells: <DataCell>[
                                                    //       DataCell(Text('38',style: TextStyle(fontSize: 11),)),
                                                    //       DataCell(Text('01',style: TextStyle(fontSize: 11),)),
                                                    //       DataCell(Text('AED 120',style: TextStyle(fontSize: 11 ,color: Colors.lightBlue,fontWeight: FontWeight.bold),)),
                                                    //     ],
                                                    //   ),
                                                    // ],
                                                  ),
                                                ),
                                                Container(
                                                  width:
                                                  deviceWidth(
                                                      context,
                                                      0.2),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      const Text('price:'),
                                                      Text(
                                                        'AED ${data!.products![index].subtotal == null ? '00' : data!.products![index].subtotal!}',
                                                        style: textstylesubtitle1(context)!.copyWith(
                                                            color:
                                                            colorblue,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),

                    sizedboxheight(8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Total + Vat: AED ${data!.orderPrice ?? ''}',
                          style: textstyleHeading3(context),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      );
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

  Widget Carditam(context) {
    return Card(
      elevation: 8,
      child: Container(
        width: deviceWidth(context, 1.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                'assets/img_2.png',
                width: 60,
                height: 60,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: deviceWidth(context, 0.65),
                      child: Text(
                        'Style No:LSA/(SSP Standard)',
                        style: textstylesubtitle1(context),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )),
                  Row(
                    children: [
                      Container(
                        width: deviceWidth(context, 0.45),
                        child: DataTable(
                          columnSpacing: 8,
                          dataRowHeight: 22,
                          dividerThickness: 0,
                          headingRowHeight: 22,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'Size',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Qty',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Price',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                          rows: const <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  '38',
                                  style: TextStyle(fontSize: 11),
                                )),
                                DataCell(Text(
                                  '01',
                                  style: TextStyle(fontSize: 11),
                                )),
                                DataCell(Text(
                                  '120 Dirtham',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.bold),
                                )),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  '38',
                                  style: TextStyle(fontSize: 11),
                                )),
                                DataCell(Text(
                                  '01',
                                  style: TextStyle(fontSize: 11),
                                )),
                                DataCell(Text(
                                  '120 Dirtham',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.bold),
                                )),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  '38',
                                  style: TextStyle(fontSize: 11),
                                )),
                                DataCell(Text(
                                  '01',
                                  style: TextStyle(fontSize: 11),
                                )),
                                DataCell(Text(
                                  '120 Dirtham',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.bold),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: deviceWidth(context, 0.2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('price:'),
                            Text(
                              'AED 420',
                              style: textstylesubtitle1(context)!.copyWith(
                                  color: colorblue,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
