import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sbm/screens/invoices/pdfshowscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar_modelpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbarwidget.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sbm/model/invoice_data_model/get_outstanding_invoice_model/get_outstanding_invoice_model.dart';
import 'package:sbm/model/invoice_data_model/invoice_data_model.dart';
import 'package:dio/dio.dart';

import '../../model/invoice_data_model/pdflinckgenretarmodal.dart';


class Invoices extends StatefulWidget {
  const Invoices({Key? key}) : super(key: key);

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
   int page = 1;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  List users = [];


  Future? _future;
  Future? _future1;
  var tokanget;

  ProgressDialog? progressDialog;
  var success1;
  List<InvoiceDataModelResponse>? invoicedatalist;
  List<InvoiceDataModelResponse>? invoicedatalist1;

  // var search = 1;
  // var endpoint;
  // Future<InvoiceDataModelMassege> myitamlistdata(search) async {
  //   // showLoaderDialog(context);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   tokanget = prefs.getString('login_user_token');
  //   tokanget = tokanget!.replaceAll('"', '');
  //
  //   check().then((intenet) {
  //     if (intenet != null && intenet) {
  //       progressDialog = ProgressDialog(context, dismissable: false);
  //       progressDialog?.setMessage(Text("Loading...."));
  //       progressDialog?.show();
  //
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
  //   if(search==1){
  //      endpoint = 'GetInvDetailsApi?CustomerCode=S04454&FromDate=&ToDate=';
  //   }
  //   else{
  //     endpoint = 'GetInvDetailsApi?CustomerCode=S04454&FromDate=${fromdateinput.text.replaceAll("-", "")}&ToDate=${todateinput.text.replaceAll("-", "")}';
  //   }
  //   print('endpoint${endpoint}+${search}');
  //   var response = await http.get(Uri.parse(beasurl+endpoint),
  //   // var response = await http.get(Uri.parse(beasurl+'GetInvoiceDetails?CustomerCode=S04454&FromDate=2020-02-01&ToDate=2022-05-20'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $tokanget',
  //       });
  //   print('endpoint${endpoint}+${response.body}');
  //   success1 = (InvoiceDataModelMassege.fromJson(json.decode(response.body)).success);
  //   progressDialog!.dismiss();
  //   if(success1==true){
  //     setState(() {
  //       invoicedatalist = (InvoiceDataModelMassege.fromJson(json.decode(response.body)).data);
  //       print('endpoint${endpoint}+${response.body}');
  //     });
  //     progressDialog!.dismiss();
  //   }else{
  //     // Navigator.pop(context);
  //     print('else==============');
  //     progressDialog!.dismiss();
  //
  //   }
  //   return InvoiceDataModelMassege.fromJson(json.decode(response.body));
  // }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

   ///////////////////// setOutstandingInvoices ///////////

  TextEditingController fromdateinput = TextEditingController();
  TextEditingController todateinput = TextEditingController();

  var success, message;
  var entry = 1;
  var data;
  var emptydata;
   var invoicedata;
   bool? success11 ;
  GetOutstandingInvoiceModelResponse? GetOutstandingInvoicedatalist;
  List<Data>? currentpagedatalist;


  Future<GetOutstandingInvoiceModelMassege> setOutstandingInvoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');

    check().then((intenet) {
      if (intenet != null && intenet) {
        if (ontapindex == 1) {
          showLoaderDialog(context, "Set Get Outstanding Invoices");
        }
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
      map["FromDate"] = fromdateinput.text.replaceAll("-", "").toString();
      map["ToDate"] = todateinput.text.replaceAll("-", "").toString();
      return map;
    }

    print(toMap());
    var response = await http.post(
        Uri.parse('${beasurl}getOutstandingInvoices?page=1'),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
        });
    data = json.decode(response.body);
    emptydata = data['data'];

    success =
        (GetOutstandingInvoiceModelMassege.fromJson(json.decode(response.body))
            .success);
    message =
        (GetOutstandingInvoiceModelMassege.fromJson(json.decode(response.body))
            .message);
    if (ontapindex == 1) Navigator.pop(context);
    if (success == true) {
      setState(() {
        GetOutstandingInvoicedatalist =
            (GetOutstandingInvoiceModelMassege.fromJson(
                    json.decode(response.body))
                .data);
        currentpagedatalist = (GetOutstandingInvoiceModelMassege.fromJson(
                json.decode(response.body))
            .data!
            .data);
      });
      if (ontapindex == 1) Navigator.pop(context);
    } else {
      if (ontapindex == 1) Navigator.pop(context);
      print('else==============');
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return GetOutstandingInvoiceModelMassege.fromJson(
        json.decode(response.body));
  }

  showLoaderDialog(BuildContext context, text) {
    AlertDialog alert = AlertDialog(
      content:  Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 7), child: Text(text)),
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


   ///////////////////// _getMoreDataAPI  ///////////
   bool dilogbox = false;
   Dio dio = Dio();
   double? progress = 0;
   double progress1 = 0;
   void startDownloading(url) async {
     var status = await Permission.storage.status;
     if (!status.isGranted) {
       print("Start Download");
       await Permission.storage.request();
     }
     Directory? downloadsDirectory;
     try {
       downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
     } on PlatformException {
       print('Could not get the downloads directory');
     }
     String tempPath = downloadsDirectory!.path;
     var filePath = '$tempPath/${DateTime.now()}.png';
     await dio.download(
       url,
       filePath,
       onReceiveProgress: (recivedBytes, totalBytes) {
         setState(() {
           dilogbox = true;
           progress = ((recivedBytes / totalBytes) * 100);
           progress1 = ((recivedBytes / totalBytes) * 1);
           print(progress);
           if(progress == 100){
             dilogbox = false;
             progress = 0;
             progress1 = 0;
             Fluttertoast.showToast(
                 msg: "Data File Downloads",
                 toastLength: Toast.LENGTH_SHORT,
                 gravity: ToastGravity.CENTER,
                 timeInSecForIosWeb: 1,
                 backgroundColor: Colors.white,
                 textColor: Colors.blue,
                 fontSize: 16.0
             );
           }
         });
       },
       deleteOnError: true,
     ).then((_) {
       print("Then Here $_");
     }).catchError((_a) {
       print("Error Show $_a");
     });
   }

   void _getMoreData(int index, allinvoiceentry) async {
     if (!isLoading) {
       setState(() {
         isLoading = true;
       });
       check().then((intenet) {
         if (intenet != null && intenet) {
           if (ontapindex == 0) showLoaderDialog(context, "Set All Invoices");
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
       SharedPreferences prefs = await SharedPreferences.getInstance();
       tokanget = prefs.getString('login_user_token');
       tokanget = tokanget!.replaceAll('"', '');
       var url =
           "https://sbmmarketplace.com/backend/public/api/getAllInvoices?page=${index}";
       FormData formData1 = FormData.fromMap({
         "FromDate": fromdateinput.text.replaceAll("-", "").toString(),
         "ToDate": todateinput.text.replaceAll("-", "").toString(),
       });

       FormData formData2 = FormData.fromMap({
         "FromDate": '',
         "ToDate": '',
       });
       final response = await dio.post(url,
           data: allinvoiceentry == 0 ? formData2 : formData1,
           options: Options(
               followRedirects: false,
               // will not throw errors
               validateStatus: (status) => true,
               headers: {
                 'Authorization': 'Bearer ${tokanget}',
               }));
       setState((){
         success11 = response.data["success"];
       });

       print("response");
       print(success11);
       print("response");
       Navigator.pop(context);
       setState(() {
         invoicedata = response.data;
         print(invoicedata);
         var listdata = invoicedata['data']['data'];
         List tList = [];
         for (int i = 0; i < listdata.length; i++) {
           setState(() {
             tList.add(listdata[i]);
           });
         }
         setState(() {
           isLoading = false;
           users.addAll(tList);
           page++;
         });
       });
     }
   }
   var vendorCode;
   Widget _buildProgressIndicator() {
     return  Padding(
       padding: const EdgeInsets.all(8.0),
       child:  Center(
         child:  Opacity(
           opacity: isLoading ? 1.0 : 00,
           child:  CircularProgressIndicator(),
         ),
       ),
     );
   }

   ///////////////////// saveInvoiceDataAPI ///////////

   void saveInvoiceDataApi() async {
     print('>>>>>>>>>>>>>>>>>>>>saveInvoiceDataApi');
     SharedPreferences prefs = await SharedPreferences.getInstance();
     tokanget = prefs.getString('login_user_token');
     tokanget = tokanget!.replaceAll('"', '');
     vendorCode = prefs.getString('login_user_vendorCode');
     vendorCode = vendorCode!.replaceAll('"', '');
     print('>>>>>>>>>>>>>>>>>>>>vendorCode');
     print(vendorCode.toString());
     print('>>>>>>>>>>>>>>>>>>>>vendorCode');
     var response = await http.get(Uri.parse('${beasurl}saveInvoiceData/${vendorCode}'), headers: {
       'Content-Type': 'application/json',
       'Accept': 'application/json',
       'Authorization': 'Bearer $tokanget',
     });
     print(json.decode(response.body));
     var aaa = json.decode(response.body);
     print('>>>>>>>>>>>>>>>>>>>>aaa');
     print(aaa);
     print('>>>>>>>>>>>>>>>>>>>>aaa');
   }

   /////////////// invicepdflinkgenretdata //////////

   Future<pdflinckgenretarmodal> invicepdflinkgenretdata(docnumber) async {

     SharedPreferences prefs = await SharedPreferences.getInstance();
     tokanget = prefs.getString('login_user_token');
     tokanget = tokanget!.replaceAll('"', '');

     check().then((intenet) {
       if (intenet != null && intenet) {
         progressDialog = ProgressDialog(context, dismissable: false);
         progressDialog?.setMessage(const Text("Loading...."));
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
     var response = await http.get(Uri.parse('${beasurl}getInvoicePDF_link/${docnumber}'), headers: {
       'Content-Type': 'application/json',
       'Accept': 'application/json',
       'Authorization': 'Bearer $tokanget',
     });
     print('aman home${response.body}');

     success = (pdflinckgenretarmodal.fromJson(json.decode(response.body)).success);
     message = (pdflinckgenretarmodal.fromJson(json.decode(response.body)).message);
     data = (pdflinckgenretarmodal.fromJson(json.decode(response.body)).url);

     progressDialog!.dismiss();
     if (success == true) {
       Get.to(() => viewscreen(link:data));
       progressDialog!.dismiss();
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
     return pdflinckgenretarmodal.fromJson(json.decode(response.body));
   }

  var allinvoiceentry = 0;
  @override
  void initState() {
    allinvoiceentry = 0;
    this._getMoreData(page, allinvoiceentry);
    super.initState();
    saveInvoiceDataApi();
    _future1 = setOutstandingInvoices();
    fromdateinput.text = "";
    todateinput.text = "";
    isSelected = [true, false];
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page, allinvoiceentry);
      }
    });

  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }
  // DateFormat dateFormate = DateFormat("MMMM dd, yyyy") ;

  late List<bool> isSelected;
  bool Paid = true;
  var ontapindex = 0;

  @override
  Widget build(BuildContext context) {

    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: appbarnotifav(context, 'Invoices'),
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
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'From date :',
                                          style: textstylesubtitle1(context),
                                        ),
                                        sizedboxheight(8.0),
                                        fromdatefield(),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'To date :',
                                          style: textstylesubtitle1(context),
                                        ),
                                        sizedboxheight(8.0),
                                        todatefield(),

                                      ],
                                    ),

                                  ],
                                ),
                                sizedboxheight(12.0),
                                searchBtn(context),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                          child: Container(
                            height: deviceheight(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.only(left: 15,right: 15,bottom: 50),
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 40,
                                    child: TabBar(
                                      unselectedLabelColor: colorblack,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      labelColor: colorblue,
                                      tabs: const [
                                        Tab(
                                          child: Text('All Invoices'),
                                        ),
                                        Tab(
                                          child: Text('Outstanding Invoices'),
                                        ),
                                      ],
                                      onTap: (t) {
                                        ontapindex = t;
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: deviceheight(context),
                                    child: TabBarView(
                                      children: [
                                        success11 == false  ? DataTable(
                                          dataRowHeight: 40,
                                          columnSpacing: 8,
                                          dividerThickness: 0,
                                          horizontalMargin: 1.0,
                                          dataTextStyle:
                                          textnormail(context)!
                                              .copyWith(
                                              fontSize: 10),
                                          columns: <DataColumn>[
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Number',
                                                  style:
                                                  textbold(context),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Date',
                                                  style:
                                                  textbold(context),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Total Amount',
                                                  style:
                                                  textbold(context),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'View',
                                                  style:
                                                  textbold(context),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Action',
                                                  style:
                                                  textbold(context),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows: const <DataRow>[
                                            DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text('')),
                                                DataCell(Text('')),
                                                DataCell(Text('')),
                                                DataCell(Text('')),
                                                DataCell(Text('')),
                                              ],
                                            ),
                                          ],
                                        ):  Container(
                                          width: deviceWidth(context),
                                          //  height: deviceheight(context, 0.6),
                                          child: SingleChildScrollView(
                                            physics: NeverScrollableScrollPhysics(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: deviceWidth(context),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Number',
                                                          style: textbold(context),
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'Date',
                                                          style: textbold(context),
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'Total Amount',
                                                          style: textbold(context),
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'View',
                                                          style: textbold(context),
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'Action',
                                                          style: textbold(context),
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                _buildList(),

                                              ],
                                            ),
                                          ),
                                        ),
                                        FutureBuilder(
                                          future: _future1,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return emptydata == false
                                                  ? DataTable(
                                                dataRowHeight: 40,
                                                columnSpacing: 8,
                                                dividerThickness: 0,
                                                horizontalMargin: 1.0,
                                                dataTextStyle:
                                                textnormail(context)!
                                                    .copyWith(
                                                    fontSize: 10),
                                                columns: <DataColumn>[
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Number',
                                                        style:
                                                        textbold(context),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Date',
                                                        style:
                                                        textbold(context),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Total Amount',
                                                        style:
                                                        textbold(context),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'View',
                                                        style:
                                                        textbold(context),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Action',
                                                        style:
                                                        textbold(context),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                rows: const <DataRow>[
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Text('')),
                                                      DataCell(Text('')),
                                                      DataCell(Text('')),
                                                      DataCell(Text('')),
                                                    ],
                                                  ),
                                                ],
                                              )
                                                  : DataTable(
                                                dataRowHeight: 40,
                                                columnSpacing: 8,
                                                dividerThickness: 0,
                                                horizontalMargin: 1.0,
                                                dataTextStyle:
                                                textnormail(context)!
                                                    .copyWith(
                                                    fontSize: 10),
                                                columns: <DataColumn>[
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Number',
                                                        style:
                                                        textbold(context),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Date',
                                                        style:
                                                        textbold(context),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Total Amount',
                                                        style:
                                                        textbold(context),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'View',
                                                        style:
                                                        textbold(context),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Action',
                                                        style:
                                                        textbold(context),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                rows: currentpagedatalist!
                                                    .map(
                                                  ((element) => DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Text(
                                                          element
                                                              .docNum
                                                              .toString())),
                                                      DataCell(Text(element
                                                          .docDate!
                                                          .split(
                                                          ' ')[0]
                                                          .toString())),
                                                      DataCell(Text(
                                                          "AED ${element.totalAmount.toString()}")),
                                                      DataCell(
                                                          InkWell(
                                                            onTap: (){
                                                              invicepdflinkgenretdata(element.docNum.toString());

                                                                print(element.invoiceLink);
                                                              // if(element.invoiceLink != null){
                                                              //   startDownloading(element.invoiceLink);
                                                              // }
                                                              //
                                                              // else{
                                                              // Fluttertoast.showToast(
                                                              // msg: "No Data File",
                                                              // toastLength: Toast.LENGTH_SHORT,
                                                              // gravity: ToastGravity.CENTER,
                                                              // timeInSecForIosWeb: 1,
                                                              // backgroundColor: Colors.white,
                                                              // textColor: Colors.blue,
                                                              // fontSize: 16.0
                                                              // );
                                                              // }
                                                            },
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/slicing 2/file-pdf.svg',
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              height: 18,
                                                              width: 18,
                                                            ),
                                                          )),
                                                      DataCell(
                                                          Container(
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                  colorblue,
                                                                  borderRadius: BorderRadius.circular(
                                                                      5)),
                                                              child:
                                                              Padding(
                                                                padding: const EdgeInsets.only(
                                                                    left: 8,
                                                                    right: 8,
                                                                    top: 2,
                                                                    bottom: 2),
                                                                child:
                                                                Text(
                                                                  'Payayment',
                                                                  style:
                                                                  textnormail(context)!.copyWith(fontSize: 10, color: colorWhite),
                                                                ),
                                                              ))),
                                                    ],
                                                  )),
                                                )
                                                    .toList(),
                                              );
                                            } else {
                                              return Center();
                                            }
                                          },
                                          // future: postlist(),
                                        ),
                                      ],
                                    ),
                                  )
                                  //     FutureBuilder(
                                  //       future: _future,
                                  //       builder: (context, snapshot) {
                                  //
                                  //         if (snapshot.hasData) {
                                  //           return
                                  //             Container(
                                  //               height: invoicedatalist!.length*50,
                                  //               child: TabBarView(
                                  //                 children: [
                                  //                   DataTable(
                                  //                     dataRowHeight: 40,
                                  //                     columnSpacing: 8,
                                  //                     dividerThickness: 0,
                                  //                     horizontalMargin: 1.0,
                                  //                     dataTextStyle: textnormail(context)!.copyWith(fontSize: 10),
                                  //                     columns:  <DataColumn>[
                                  //                       DataColumn(
                                  //                         label: Expanded(
                                  //                           child: Text(
                                  //                             'Number',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       DataColumn(
                                  //                         label: Expanded(
                                  //                           child: Text(
                                  //                             'Date',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       DataColumn(
                                  //                         label: Expanded(
                                  //                           child: Text(
                                  //                             'Total Amount',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       DataColumn(
                                  //                         label: Expanded(
                                  //                           child: Text(
                                  //                             'View',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       DataColumn(
                                  //                         label: Expanded(
                                  //                           child: Text(
                                  //                             'Action',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //
                                  //                     rows:
                                  //                     invoicedatalist! .map(
                                  //                       ((element) => DataRow(
                                  //                         cells: <DataCell>[
                                  //
                                  //                           DataCell(Text(element.docNum.toString())),
                                  //                           DataCell(Text((element.docDate!.split('T')[0].toString()))),
                                  //                           DataCell(Text("AED ${element.totalAmount.toString()}")),
                                  //                           DataCell(SvgPicture.asset(
                                  //                             'assets/slicing 2/file-pdf.svg',
                                  //                             fit: BoxFit.fitHeight,
                                  //                             height: 18,width: 18,
                                  //                           )),
                                  //                           DataCell(
                                  //                               element.docStatus != "O"?  Container(
                                  //                                   decoration: BoxDecoration(
                                  //                                       color: colorgreen,
                                  //                                       borderRadius: BorderRadius.circular(5)
                                  //                                   ),
                                  //                                   child: Padding(
                                  //                                     padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                                  //                                     child: Text('Paid',style: textnormail(context)!.copyWith(fontSize: 10,color: colorWhite),),
                                  //                                   )):Container(
                                  //                                   decoration: BoxDecoration(
                                  //                                       color: colorblue,
                                  //                                       borderRadius: BorderRadius.circular(5)
                                  //                                   ),
                                  //                                   child: Padding(
                                  //                                     padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                                  //                                     child: Text('Payayment',style: textnormail(context)!.copyWith(fontSize: 10,color: colorWhite),),
                                  //                                   ))
                                  //                           ),
                                  //                         ],
                                  //                       )),
                                  //                     )
                                  //                         .toList(),
                                  //
                                  //                   ),
                                  //                   DataTable(
                                  //                     dataRowHeight: 40,
                                  //                     columnSpacing: 8,
                                  //                     dividerThickness: 0,
                                  //                     horizontalMargin: 1.0,
                                  //                     dataTextStyle: textnormail(context)!.copyWith(fontSize: 10),
                                  //                     columns:  <DataColumn>[
                                  //                       DataColumn(
                                  //                         label: Expanded(
                                  //                           child: Text(
                                  //                             'Number',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       DataColumn(
                                  //                         label: Expanded(
                                  //                           child: Text(
                                  //                             'Date',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       DataColumn(
                                  //                         label: Expanded(
                                  //                           child: Text(
                                  //                             'Total Amount',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       DataColumn(
                                  //                         label: Expanded(
                                  //                           child: Text(
                                  //                             'View',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       DataColumn(
                                  //                         label: Expanded(
                                  //                           child: Text(
                                  //                             'Action',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //
                                  //                       rows:
                                  //                       currentpagedatalist! .map(
                                  //                       ((element) => DataRow(
                                  //                         cells: <DataCell>[
                                  //                           DataCell(Text(element.docNum.toString())),
                                  //                           DataCell(Text(element.docDate!.split('T')[0].toString())),
                                  //                           DataCell(Text("AED ${element.totalAmount.toString()}")),
                                  //                           DataCell(SvgPicture.asset(
                                  //                             'assets/slicing 2/file-pdf.svg',
                                  //                             fit: BoxFit.fitHeight,
                                  //                             height: 18,width: 18,
                                  //                           )),
                                  //                            DataCell(
                                  //                                Container(
                                  //                                   decoration: BoxDecoration(
                                  //                                       color: colorblue,
                                  //                                       borderRadius: BorderRadius.circular(5)
                                  //                                   ),
                                  //                                   child: Padding(
                                  //                                     padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                                  //                                     child: Text('Payayment',style: textnormail(context)!.copyWith(fontSize: 10,color: colorWhite),),
                                  //                                   ))
                                  //                           ),
                                  //                         ],
                                  //                       )
                                  //                       ),
                                  //                     )
                                  //                         .toList(),
                                  //
                                  //                   )
                                  //
                                  //
                                  //                 ],
                                  //               ),
                                  //             );
                                  //         }else
                                  //         {
                                  //           return Center(
                                  //
                                  //           );
                                  //         }},
                                  //       // future: postlist(),
                                  //     ),
                                  //
                                  // FutureBuilder(
                                  //       future: _future,
                                  //       builder: (context, snapshot) {
                                  //         if (snapshot.hasData) {
                                  //           return
                                  //             DataTable(
                                  //               dataRowHeight: 40,
                                  //               columnSpacing: 8,
                                  //               dividerThickness: 0,
                                  //               horizontalMargin: 1.0,
                                  //               dataTextStyle: textnormail(context)!.copyWith(fontSize: 10),
                                  //               columns:  <DataColumn>[
                                  //                 DataColumn(
                                  //                   label: Expanded(
                                  //                     child: Text(
                                  //                       'Number',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //                 DataColumn(
                                  //                   label: Expanded(
                                  //                     child: Text(
                                  //                       'Date',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //                 DataColumn(
                                  //                   label: Expanded(
                                  //                     child: Text(
                                  //                       'Total Amount',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //                 DataColumn(
                                  //                   label: Expanded(
                                  //                     child: Text(
                                  //                       'View',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //                 DataColumn(
                                  //                   label: Expanded(
                                  //                     child: Text(
                                  //                       'Action',style: textbold(context),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //
                                  //               rows:
                                  //              invoicedatalist! .map(
                                  //                 ((element) => DataRow(
                                  //                   cells: <DataCell>[
                                  //                     DataCell(Text(element.docNum.toString())),
                                  //                     DataCell(Text(element.docDate!.split('T')[0].toString())),
                                  //                     DataCell(Text("AED ${element.totalAmount.toString()}")),
                                  //                     DataCell(SvgPicture.asset(
                                  //                       'assets/slicing 2/file-pdf.svg',
                                  //                       fit: BoxFit.fitHeight,
                                  //                       height: 18,width: 18,
                                  //                     )),
                                  //                     DataCell(
                                  //                         element.docStatus != "O"?  Container(
                                  //                         decoration: BoxDecoration(
                                  //                             color: colorgreen,
                                  //                             borderRadius: BorderRadius.circular(5)
                                  //                         ),
                                  //                         child: Padding(
                                  //                           padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                                  //                           child: Text('Paid',style: textnormail(context)!.copyWith(fontSize: 10,color: colorWhite),),
                                  //                         )):Container(
                                  //                             decoration: BoxDecoration(
                                  //                                 color: colorblue,
                                  //                                 borderRadius: BorderRadius.circular(5)
                                  //                             ),
                                  //                             child: Padding(
                                  //                               padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                                  //                               child: Text('Payayment',style: textnormail(context)!.copyWith(fontSize: 10,color: colorWhite),),
                                  //                             ))
                                  //                     ),
                                  //                   ],
                                  //                 )),
                                  //               )
                                  //                   .toList(),
                                  //
                                  //             );
                                  //         }else
                                  //         {
                                  //           return Center(
                                  //
                                  //           );
                                  //         }},
                                  //       // future: postlist(),
                                  //     ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              dilogbox? Center(
                child: Container(

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularPercentIndicator(
                      radius: 40.0,
                      animation: false,
                      animationDuration: 1200,
                      lineWidth:10.0,
                      percent: progress1,
                      center:  Text(
                        progress!.toStringAsFixed(2),
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0,color: colorblue),
                      ),
                      circularStrokeCap: CircularStrokeCap.butt,
                      backgroundColor: colorWhite,
                      progressColor: colorblue,
                    ),
                  ),
                ),
              ):Container(),
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
        ),
      );
    });


  }

  Widget fromdatefield() {
    return Container(
      width: deviceWidth(context, 0.4),
      height: 40,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        controller: fromdateinput,
        style: textbold(context)!.copyWith(color: colorblack ,fontSize: 9 , overflow: TextOverflow.ellipsis,),//editing controller of this TextField
        maxLines: 1,
        decoration: InputDecoration(
          hintText: 'Select Date',
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              'assets/slicing 2/calendar-days.svg',
              fit: BoxFit.fitHeight,
              height: 8,
              width: 8,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorgrey, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorgrey, width: 0.8),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorgrey, width: 0.5),
          ),
        ),
        readOnly: true,
        //set it true, so that user will not able to edit text
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2101),

          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            setState(() {
              fromdateinput.text =
                  formattedDate; //set output date to TextField value.
            });
          } else {
            print("Date is not selected");
          }
        },
      ),
    );
  }

  Widget todatefield() {
    return Container(
      width: deviceWidth(context, 0.4),
      height: 40,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        controller: todateinput,
        style: textbold(context)!.copyWith(color: colorblack,fontSize: 9 , overflow: TextOverflow.ellipsis,),//editing controller of this TextField
        maxLines: 1,//editing controller of this TextField
        decoration: InputDecoration(

          hintText: 'Select Date',
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              'assets/slicing 2/calendar-days.svg',
              fit: BoxFit.fitHeight,
              height: 10,
              width: 10,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorgrey, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorgrey, width: 0.8),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorgrey, width: 0.5),
          ),
        ),
        readOnly: true,
        //set it true, so that user will not able to edit text
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(
                  2000), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2101));
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            setState(() {
              todateinput.text =
                  formattedDate; //set output date to TextField value.
            });
          } else {
            print("Date is not selected");
          }
        },
      ),
    );
  }

  Widget searchBtn(context) {
    return Button(
      btnHeight: 35,
      buttonName: 'SEARCH',
      // btnstyle: textstylesubtitle2(context)!.copyWith(color: colorWhite),
      borderRadius: BorderRadius.circular(5),

      onPressed: () {

        if (ontapindex == 0) {
          setState(() {
            users.clear();
            allinvoiceentry = 1;
            _getMoreData(1, allinvoiceentry);

            print("page??????${allinvoiceentry}");
          });
        } else {
          setState(() {
            setOutstandingInvoices();
          });
        }
      },
    );
  }

  Widget _buildList() {
    return   Container(
      height: deviceheight(context),
      child: ListView.builder(
        itemCount: users.length + 1,
        padding: const EdgeInsets.symmetric(vertical: 8.0),

        itemBuilder: (BuildContext context, int index) {
          if (index == users.length) {
            return _buildProgressIndicator();
          } else {

            return Container(
              width: deviceWidth(context, 1.0),
              height: 45,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 1,
                      child: Text(
                        users[index]['doc_num'].toString(),
                        style: textnormail(context),
                      )),
                  Expanded(
                      flex: 2,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                              users[index]['doc_date'].split(" ")[0].toString(),
                              style: textnormail(context)))),
                  Expanded(
                      flex: 1,
                      child: Text("${users[index]['total_amount']}",
                          style: textnormail(context))),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        invicepdflinkgenretdata(users[index]['doc_num']);

                       //  if(users[index]['invoice_link'] !=null){
                       //    startDownloading(users[index]['invoice_link']);
                       //  }
                       // else{
                       //    Fluttertoast.showToast(
                       //        msg: "No Data File",
                       //        toastLength: Toast.LENGTH_SHORT,
                       //        gravity: ToastGravity.CENTER,
                       //        timeInSecForIosWeb: 1,
                       //        backgroundColor: Colors.white,
                       //        textColor: Colors.blue,
                       //        fontSize: 16.0
                       //    );
                       //  }
                      },
                      child: SvgPicture.asset(
                        'assets/slicing 2/file-pdf.svg',
                        fit: BoxFit.fitHeight,
                        height: 18,
                        width: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: users[index]['doc_date'] != "O"
                        ? Align(
                            alignment: Alignment.center,
                            child: Container(
                                width: 60,
                                decoration: BoxDecoration(
                                    color: colorgreen,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 2, bottom: 2),
                                  child: Text(
                                    'Paid',
                                    style: textnormail(context)!.copyWith(
                                        fontSize: 10, color: colorWhite),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: Container(
                                width: 120,
                                decoration: BoxDecoration(
                                    color: colorblue,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 2, bottom: 2),
                                  child: Text(
                                    'Payayment',
                                    style: textnormail(context)!.copyWith(
                                        fontSize: 10, color: colorWhite),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                          ),
                  ),
                ],
              ),
            );
          }
        },
        controller: _sc,
      ),
    );
  }


}
