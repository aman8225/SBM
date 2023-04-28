import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbm/common/styles/const.dart';

class Demo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new DemoState();
}

class DemoState extends State<Demo> {
  static int page = 1;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  List users = [];
  final dio = new Dio();
  @override
  void initState() {
    this._getMoreData(page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: deviceWidth(context),
        height: deviceheight(context),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 50,
                width: deviceWidth(context),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Number',
                        style: textbold(context),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Date',
                        style: textbold(context),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Total Amount',
                        style: textbold(context),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'View',
                        style: textbold(context),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Action',
                        style: textbold(context),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: deviceheight(context, 0.8),
                child: _buildList(),
              ),
            ],
          ),
        ),
      ),
      // resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: users.length + 1, // Add one more item for progress indicator
      padding: EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == users.length) {
          return _buildProgressIndicator();
        } else {
          return Container(
            width: deviceWidth(context, 1.0),
            height: 60,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(users[index]['doc_num'].toString())),
                Expanded(
                    child: Text(
                        users[index]['doc_date'].split(" ")[0].toString())),
                Expanded(
                  child: SvgPicture.asset(
                    'assets/slicing 2/file-pdf.svg',
                    fit: BoxFit.fitHeight,
                    height: 18,
                    width: 18,
                  ),
                ),
                Expanded(
                  child: users[index]['doc_date'] == "O"
                      ? Container(
                          width: 60,
                          decoration: BoxDecoration(
                              color: colorgreen,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 2, bottom: 2),
                            child: Text(
                              'Paid',
                              style: textnormail(context)!
                                  .copyWith(fontSize: 10, color: colorWhite),
                            ),
                          ))
                      : Container(
                          width: 120,
                          decoration: BoxDecoration(
                              color: colorblue,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 2, bottom: 2),
                            child: Text(
                              'Payayment',
                              style: textnormail(context)!
                                  .copyWith(fontSize: 10, color: colorWhite),
                            ),
                          )),
                ),
              ],
            ),
          );
        }
      },
      controller: _sc,
    );
  }

  void _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var url =
          "https://sbmmarketplace.com/backend/public/api/getAllInvoices?page=${index}";
      print(url);
      FormData formData = new FormData.fromMap({
        "FromDate": '20220101',
        "ToDate": '20220621',
      });
      final response = await dio.post(url,
          data: formData,
          options: Options(headers: {
            'Authorization':
                'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZjE4NDRhNTY3MjA4ODhlOGEzMGZlMWQ1NTczM2RhZTIwNDQ3MmUxNjI1MjUxM2Q2ZmJhNTk3NjQxYmVmYzA1YzM0Zjg3NmNlODU5NGEzZTQiLCJpYXQiOjE2NTYwNTg2NjUuMTk1MTU2LCJuYmYiOjE2NTYwNTg2NjUuMTk1MTU5LCJleHAiOjE2ODc1OTQ2NjUuMTY2MTYxLCJzdWIiOiIyMDA5NyIsInNjb3BlcyI6W119.UWxhMwsaQqQmNGqtNEIOLNaC-AqqnFMkldxqxl7G3LRwl3Ucl5rNnzyxeUw3lXZVQQaYq4DCMuGBetjrL2lnrAyX8qCLgF3e9LL59-S9QI2v3h-KRKAr9PC0oep9AoKq6EB3zvufLQNN5quOl2JVlnHLluO3Rtizkovo45Fn4-5faoPFZISL04S6lSkby0PU7S9kofskAFKG0lo8MIUhpuDGuJZ8fwOuo3p7Hdp_FdnJFDFRA-I0DGq0Ia8-dVSVktZq7wcW24Xi0bh1ouHRflC-2NPrXe-9JBjZfBgj69b7cPSCS7_tzpUI6N0OSOLfgMemrgUSjweplrPH9SkUijguzX8II0T1Ycl4ZLDp_66OR9_w5Di9R_IVAGFvbIVwEN_Ua3dvAcMXwPjgLrS4aZ8u_JqNPJxuXLp4UYnevLeAViN2BDZ6-Ur1AChNtYwfgO1BMyUOwV-y0f3EFkHhsBXka8T3OMjLcICxj5Mvk3jTr7dGX0ZaKeg9mGmf5zp9-6ug4jraWJtllObKcVSO1b561p8fo5rsU5pNRWYUrlcLgtVKDArn8gDHjWiXOyFfIs-tcwkbnpZIT5aVpE2QbwRZT-3Z5SUs9Co-7DomOBbTTnuYXXNiAiKdla6P_Zgzckc20Yy-ItUIO_VOkLgq4xjN7GceepGh9EDkLcvLPkw',
          }));
      print(response.data);
      var data = response.data;
      var listdata = data['data']['data'];
      List tList = [];
      for (int i = 0; i < listdata.length; i++) {
        tList.add(listdata[i]);
      }
      setState(() {
        isLoading = false;
        users.addAll(tList);
        page++;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'dart:math';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:ndialog/ndialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:http/http.dart' as http;
// import 'common/server_url.dart';
// import 'common/styles/const.dart';
// import 'model/invoice_data_model/invoice_data_model.dart';
//
// class LoadMoreInfiniteScrollingDemo extends StatefulWidget {
//   LoadMoreInfiniteScrollingDemo({Key? key}) : super(key: key);
//
//   @override
//   _LoadMoreInfiniteScrollingDemoState createState() =>
//       _LoadMoreInfiniteScrollingDemoState();
// }
//
// class _LoadMoreInfiniteScrollingDemoState
//     extends State<LoadMoreInfiniteScrollingDemo> {
//   List<Employee> _employees = <Employee>[];
//   late EmployeeDataSource _employeeDataSource;
//
//
//   Future? _future;
//   var tokanget;
//
//
//   ProgressDialog? progressDialog;
//   var success1;
//   List<InvoiceDataModelResponse>? invoicedatalist ;
//
//
//   var search = 1;
//   var endpoint;
//
//   Future<InvoiceDataModelMassege> myitamlistdata(search) async {
//     // showLoaderDialog(context);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     tokanget = prefs.getString('login_user_token');
//     tokanget = tokanget!.replaceAll('"', '');
//
//     check().then((intenet) {
//       if (intenet != null && intenet) {
//         progressDialog = ProgressDialog(context, dismissable: false);
//         progressDialog?.setMessage(Text("Loading...."));
//        /// progressDialog?.show();
//
//       }else{
//         Fluttertoast.showToast(
//             msg: "Please check your Internet connection!!!!",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: colorblue,
//             textColor: Colors.white,
//             fontSize: 16.0);
//       }
//     });
//     if(search==1){
//       endpoint = 'GetInvDetailsApi?CustomerCode=S04454&FromDate=&ToDate=';
//     }
//     else{
//       endpoint = 'GetInvDetailsApi?CustomerCode=S04454&FromDate=&ToDate=';
//     }
//
//     var response = await http.get(Uri.parse(beasurl+'GetInvDetailsApi?CustomerCode=S04454&FromDate=&ToDate='),
//         // var response = await http.get(Uri.parse(beasurl+'GetInvoiceDetails?CustomerCode=S04454&FromDate=2020-02-01&ToDate=2022-05-20'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $tokanget',
//         });
//
//     success1 = (InvoiceDataModelMassege.fromJson(json.decode(response.body)).success);
//     progressDialog!.dismiss();
//     if(success1==true){
//       setState(() {
//         invoicedatalist = (InvoiceDataModelMassege.fromJson(json.decode(response.body)).data);
//         print('endpoint${invoicedatalist!.length}');
//
//       });
//       progressDialog!.dismiss();
//     }else{
//        Navigator.pop(context);
//       print('else==============');
//       progressDialog!.dismiss();
//     }
//     return InvoiceDataModelMassege.fromJson(json.decode(response.body));
//   }
//
//   Future<bool> check() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       return true;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       return true;
//     }
//     return false;
//   }
//
//   @override
//   void initState() {
//     _future = myitamlistdata(1);
//     _populateEmployeeData(20);
//     _employeeDataSource = EmployeeDataSource(employees: _employees);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Syncfusion Flutter DataGrid')),
//       body: SfDataGrid(
//         source: _employeeDataSource,
//         loadMoreViewBuilder: (BuildContext context, LoadMoreRows loadMoreRows) {
//           Future<String> loadRows() async {
//             await loadMoreRows();
//             return Future<String>.value('Completed');
//           }
//
//           return FutureBuilder<String>(
//             initialData: 'loading',
//             future: loadRows(),
//             builder: (context, snapShot) {
//               if (snapShot.data == 'loading') {
//                 return Container(
//                     height: 60.0,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: BorderDirectional(
//                             top: BorderSide(
//                                 width: 1.0,
//                                 color: Color.fromRGBO(0, 0, 0, 0.26)))),
//                     alignment: Alignment.center,
//                     child: CircularProgressIndicator());
//               } else {
//                 return SizedBox.fromSize(size: Size.zero);
//               }
//             },
//           );
//         },
//         columns: <GridColumn>[
//           GridColumn(
//               columnName: 'id',
//               label: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   alignment: Alignment.center,
//                   child: Text(
//                     'ID',
//                   ))),
//           GridColumn(
//               columnName: 'name',
//               label: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   alignment: Alignment.center,
//                   child: Text('Name'))),
//           GridColumn(
//               width: 120.0,
//               columnName: 'designation',
//               label: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   alignment: Alignment.center,
//                   child: Text(
//                     'Designation',
//                     overflow: TextOverflow.ellipsis,
//                   ))),
//           GridColumn(
//               columnName: 'salary',
//               label: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   alignment: Alignment.center,
//                   child: Text('Salary'))),
//         ],
//       ),
//     );
//   }
//
//   void _populateEmployeeData(int count) {
//     final Random _random = Random();
//     int startIndex = _employees.isNotEmpty ? _employees.length : 0,
//         endIndex = startIndex + count;
//     for (int i = startIndex; i < endIndex; i++) {
//       _employees.add(Employee(
//         1000 + i,
//         _names[_random.nextInt(_names.length - 1)],
//         _designation[_random.nextInt(_designation.length - 1)],
//         10000 + _random.nextInt(10000),
//       ));
//     }
//   }
// }
//
// final List<String> _names = <String>[
//   'Welli',
//   'Blonp',
//   'Folko',
//   'Furip',
//   'Folig',
//   'Picco',
//   'Frans',
//   'Warth',
//   'Linod',
//   'Simop',
//   'Merep',
//   'Riscu',
//   'Seves',
//   'Vaffe',
//   'Alfki'
// ];
//
// final List<String> _designation = <String>[
//   'Project Lead',
//   'Developer',
//   'Manager',
//   'Designer',
//   'System Analyst',
//   'CEO'
// ];
//
// class Employee {
//   Employee(this.id, this.name, this.designation, this.salary);
//
//   final int id;
//
//   final String name;
//
//   final String designation;
//
//   final int salary;
// }
//
// class EmployeeDataSource extends DataGridSource {
//   EmployeeDataSource({required List<Employee> employees}) {
//     _employeeData = employees
//         .map<DataGridRow>((e) => DataGridRow(cells: [
//       DataGridCell<int>(columnName: 'id', value: e.id),
//       DataGridCell<String>(columnName: 'name', value: e.name),
//       DataGridCell<String>(
//           columnName: 'designation', value: e.designation),
//       DataGridCell<int>(columnName: 'salary', value: e.salary),
//     ]))
//         .toList();
//   }
//
//   List<DataGridRow> _employeeData = [];
//
//   @override
//   List<DataGridRow> get rows => _employeeData;
//
//   void _addMoreRows(int count) {
//     final Random _random = Random();
//     int startIndex = _employeeData.isNotEmpty ? _employeeData.length : 0,
//         endIndex = startIndex + count;
//     for (int i = startIndex; i < endIndex; i++) {
//       _employeeData.add(DataGridRow(cells: [
//         DataGridCell<int>(columnName: 'id', value: 1000 + i),
//         DataGridCell<String>(
//             columnName: 'name',
//             value: _names[_random.nextInt(_names.length - 1)]),
//         DataGridCell<String>(
//             columnName: 'designation',
//             value: _designation[_random.nextInt(_designation.length - 1)]),
//         DataGridCell<int>(
//             columnName: 'salary', value: 10000 + _random.nextInt(10000)),
//       ]));
//     }
//   }
//
//   @override
//   Future<void> handleLoadMoreRows() async {
//     await Future.delayed(Duration(seconds: 5));
//     _addMoreRows(10);
//     notifyListeners();
//   }
//
//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((e) {
//           return Container(
//             alignment: Alignment.center,
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(e.value.toString()),
//           );
//         }).toList());
//   }
// }
