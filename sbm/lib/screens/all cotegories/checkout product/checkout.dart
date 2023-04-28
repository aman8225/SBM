import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sbm/common/appbar/appbarmodelpage.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/appbar/appbarwidgetpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar_modelpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbarwidget.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/formtextfield/mytextfield.dart';
import 'package:sbm/common/formtextfield/validations_field.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/addressmodel/addressmodel.dart';
import 'package:sbm/model/addressmodel/delet_sddress_model/delet_address_model.dart';
import 'package:sbm/model/addressmodel/edit_address_model/edit_address_model.dart';
import 'package:sbm/model/addressmodel/setnewaddressmode/setnewaddressmodel.dart';
import 'package:sbm/model/cartmodel/card_data.dart';
import 'package:sbm/model/cartmodel/DeleteWishlistModel/DeleteWishlistModel.dart';
import 'package:sbm/model/cartmodel/cartsmodel.dart';
import 'package:sbm/model/checkoutmodel/chackout_data_model/chackout_data_model.dart';
import 'package:sbm/model/checkoutmodel/checkout_data_model.dart';
import 'package:sbm/model/checkoutmodel/user_data_model/user_data_model.dart';
import 'package:sbm/screens/all%20cotegories/checkout%20product/webscreen.dart';
import 'package:sbm/screens/all%20cotegories/my%20cart/my_card_page.dart';
import 'package:sbm/screens/all%20cotegories/my%20cart/update_card_model/update_card_model.dart';
import 'package:http/http.dart' as http;
import 'package:sbm/screens/invoices/invoices.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../order success/order_success_screen.dart';
import '../prodect details/prodect_details.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  TextEditingController txt_applycoopan = TextEditingController();
  TextEditingController txt_LPOnumber = TextEditingController();
  String initialCountry = 'AE';
  PhoneNumber number = PhoneNumber(isoCode: 'AE');

  bool? status;
  bool adddesscard = false;
  bool productcard = true;
  bool paymentcard = true;
  int cashvalue = 1;

  bool sinincard1 = true;
  bool adddesscard1 = false;
  bool productcard1 = false;

  Future? _future;
  var tokanget;
  int? selectaddressid ;

/////////////// upadetcartdata() /////////////

  chackoutDataModelResponse? data;
  var orderid;
  ProgressDialog? progressDialog;
  var success, message, grandTotal, vat, vatAmount;
  Future<chackoutDataModelMassege> checkoutdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        if (success != false) showLoaderDialog(context, 'Submit Order .');
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
      map["shipping_address"] = selectaddressid;
      map["payment_method"] = paymenttype.toString();
      map["coupon_code"] = null;
      map["total_amount"] = grandTotal.toString();
      map["discount"] = deiscountamount;
      map["vat"] = vat.toString();
      map["vat_cost"] = vatAmount.toString();
      map["payable_amount"] = amountPayable;
      map["items"] = ([
        for (int i = 0; i < itemsdata.length; i++)
          {
            "product_id": int.parse(itemsdata[i].id.toString()),
            "product_option": ([
              for (int j = 0; j < itemsdata[i].productsAttributes!.length; j++)
                {
                  "variant_id": itemsdata[i].productsAttributes![j].variantId,
                  "quantity": itemsdata[i].productsAttributes![j].quantity,
                }
            ]),
            "product_price": double.parse(itemsdata[i].price.toString()),
          }
      ]);
      map["lpo_number"] = txt_LPOnumber.text.toString();
      return map;
    }

    print(json.encode(toMap()));
    print('${beasurl}placeOrder');
    var response = await http.post(Uri.parse('${beasurl}placeOrder'),
        body: json.encode(toMap()),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Content-Type': 'application/json'
        });
    print("checkouts????${response.body}");
    success = (chackoutDataModelMassege.fromJson(json.decode(response.body)).success);
    message = (chackoutDataModelMassege.fromJson(json.decode(response.body)).message);
    data = (chackoutDataModelMassege.fromJson(json.decode(response.body)).data);
    orderid = (chackoutDataModelMassege.fromJson(json.decode(response.body)).data!.orderId);

    if (success == true) {

      print('${paymenttype}??????????????????');
      print('${data!.orderId}??????????????????');
       // Navigator.pop(context);
        paymenttype == 1?Get.off(()=>OrderSuccess(orderid:data!.orderId)) :Get.off(()=>WebScreen(link:data!.link! ));
       // urlluncher(data!.link);
        itemsdata.clear();


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
    return chackoutDataModelMassege.fromJson(json.decode(response.body));
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

/////////// addressesdata ////////
  var useremail;
  var username;
  Future? _future1;
  var setaddressid;
  List<AddAddressResponse> addressdatalist = [];
  Future<Addressmodelmessege> addressesdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    status = prefs.getBool('isLoggedIn') ?? false;
    useremail = prefs.getString('login_user_email');
    useremail = useremail!.replaceAll('"', '');
    username = prefs.getString('login_user_name');
    username = username!.replaceAll('"', '');
    if (status == true) {
      cashvalue = 1;
    }

    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(const Text("Loading...."));
        //progressDialog?.show();

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
    var response = await http.get(Uri.parse('${beasurl}addresses'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    print(response.body);
    success = (Addressmodelmessege.fromJson(json.decode(response.body)).success);
    message = (Addressmodelmessege.fromJson(json.decode(response.body)).message);

    if (success == true) {
      addressdatalist = (Addressmodelmessege.fromJson(json.decode(response.body)).data)!;
     setaddressid = (Addressmodelmessege.fromJson(json.decode(response.body)).data!.first.addressId);

      selectaddressid = setaddressid;

      progressDialog!.dismiss();
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
    return Addressmodelmessege.fromJson(json.decode(response.body));
  }

  TextEditingController txt_name = TextEditingController();
  TextEditingController txt_email = TextEditingController();
  TextEditingController txt_pincode = TextEditingController();
  TextEditingController txt_address = TextEditingController();
  TextEditingController txt_city = TextEditingController();
  TextEditingController txt_state = TextEditingController();
  TextEditingController txt_country = TextEditingController();
  TextEditingController txt_landmark = TextEditingController();

  Future<SetAddressModelMessege> addnewaddress() async {
    print("CLICKED 123 ==");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        showLoaderDialog(context, 'Add New Address...');
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
        .post(Uri.parse('${beasurl}addresses/add'), body: toMap(), headers: {
      'Authorization': 'Bearer $tokanget',
    });
    success =
        (SetAddressModelMessege.fromJson(json.decode(response.body)).success);
    message =
        (SetAddressModelMessege.fromJson(json.decode(response.body)).message);
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
        _future1 = addressesdata();
      });
      txt_email.clear();
      txt_name.clear();
      txt_pincode.clear();
      txt_address.clear();
      txt_city.clear();
      txt_country.clear();
      txt_state.clear();
      txt_landmark.clear();
      controller.clear();
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
    return SetAddressModelMessege.fromJson(json.decode(response.body));
  }

  ////////////// productdetacardlistdata ////////
   var cartond;
  Future? _future2;
  var amountPayable;
  List<Items> itemsdata = [];
  List<dynamic> list = [];
  List<dynamic> list1 = [];
  List<ProductsAttributes> productsAttributes = [];
  String? quantity;
  var deiscountamount;
  Future<CartsDataModelMassege> productdetacardlistdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(const Text("Loading...."));
        // if(show==1)
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
    var response = await http.get(Uri.parse('${beasurl}carts'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    var a = json.decode(response.body);
    var b = a['message'];
    if (b == 'You have no items in your shopping cart.') {
      Navigator.pop(context);
    }
    print('aman grandTotal${response.body}');
    success =
        (CartsDataModelMassege.fromJson(json.decode(response.body)).success);
    message = (CartsDataModelMassege.fromJson(json.decode(response.body))
        .message
        .toString());
    if (success == true) {
      setState(() {
        (context as Element).reassemble();
        grandTotal = (CartsDataModelMassege.fromJson(json.decode(response.body))
            .data!
            .grandTotal);
        vat = (CartsDataModelMassege.fromJson(json.decode(response.body))
            .data!
            .vat);
        vatAmount = (CartsDataModelMassege.fromJson(json.decode(response.body))
            .data!
            .vatAmount);
        amountPayable =
            (CartsDataModelMassege.fromJson(json.decode(response.body))
                .data!
                .amountPayable);
        itemsdata = (CartsDataModelMassege.fromJson(json.decode(response.body))
            .data!
            .items)!;
        productsAttributes =
            (CartsDataModelMassege.fromJson(json.decode(response.body))
                .data!
                .items![0]
                .productsAttributes)!;
        deiscountamount =
            (CartsDataModelMassege.fromJson(json.decode(response.body))
                .data!
                .totalDiscount);
        cartond = (CartsDataModelMassege.fromJson(json.decode(response.body)).data!.cartonsTotal)!;

        print('aman productsAttributes itemsdata${itemsdata.length}');
        notificationactionWidget(context);
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

//////////// applycopandata() //////////
//   var success1,message1,id,email;
//
//   int? deiscountamount = 0 ;
//   Future<ApplyCoopanModeMassege> applycopandata() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     tokanget = prefs.getString('login_user_token');
//     tokanget = tokanget!.replaceAll('"', '');
//     check().then((intenet) {
//       if (intenet != null && intenet) {
//         showLoaderDialog(context ,'Apply Coopan');
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
//     Map toMap() {
//       var map = new Map<String, dynamic>();
//       map["coupon_code"] = txt_applycoopan.text.toString();
//       return map;
//     }
//     var response = await http.post(Uri.parse(beasurl+'applyCoupon'), body: toMap(),
//         headers: {
//           'Authorization': 'Bearer $tokanget',
//         });
//     print("success 123 ==${response.body}");
//     success1 = (ApplyCoopanModeMassege.fromJson(json.decode(response.body)).success);
//     message1 = (ApplyCoopanModeMassege.fromJson(json.decode(response.body)).message);
//     print("success 123 ==${success1}");
//     if(success1==true){
//       deiscountamount = (ApplyCoopanModeMassege.fromJson(json.decode(response.body)).amount);
//       if(success1==true){
//         Navigator.pop(context);
//         Fluttertoast.showToast(
//             msg: message1,
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: colorblue,
//             textColor: Colors.white,
//             fontSize: 16.0);
//         productdetacardlistdata(2);
//       }
//     }else{
//       Navigator.pop(context);
//       print('else==============');
//       Fluttertoast.showToast(
//           msg: message1,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: colorblue,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }
//     return ApplyCoopanModeMassege.fromJson(json.decode(response.body));
//   }

  ////////////////// deletewishlist //////////////////

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
      var map = new Map<String, dynamic>();
      map["product_id"] = product_Id.toString();
      return map;
    }

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
    print("success 123 ==${success}");
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
        productdetacardlistdata();
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

    print(toMap());
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
      if (success == true) {
        setState(() {
          (context as Element).reassemble();
          productdetacardlistdata();
        });
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: colorblue,
            textColor: Colors.white,
            fontSize: 16.0);
        notificationactionWidget(context);
      }
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

  /////////// chakout /////////

  var success5, message5;
  SalesPerson? salesPerson;

  Future<checkoutDataModelMassege> chakout() async {
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
    var response = await http.get(Uri.parse('${beasurl}checkout'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    print("chakout${response.body}");
    success5 =
        (checkoutDataModelMassege.fromJson(json.decode(response.body)).success);
    message5 =
        (checkoutDataModelMassege.fromJson(json.decode(response.body)).message);

    if (success5 == true) {
      salesPerson = (checkoutDataModelMassege
          .fromJson(json.decode(response.body))
          .data!
          .salesPerson)!;
      progressDialog!.dismiss();
    } else {
      Navigator.pop(context);
      progressDialog!.dismiss();
      print('else==============');
      Fluttertoast.showToast(
          msg: message5,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return checkoutDataModelMassege.fromJson(json.decode(response.body));
  }

  /////////////  deleteaddress /////////

  Future<DeletAddressModelMassege> deleteaddress(int adress_Id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        showLoaderDialog(context, "Set Delete Address");
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
      map["address_id"] = adress_Id.toString();
      return map;
    }

    var response = await http
        .post(Uri.parse('${beasurl}addresses/delete'), body: toMap(), headers: {
      'Authorization': 'Bearer $tokanget',
    });

    print(response.body);
    success =
        (DeletAddressModelMassege.fromJson(json.decode(response.body)).success);
    message =
        (DeletAddressModelMassege.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success}");
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
        _future1 = addressesdata();
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
    return DeletAddressModelMassege.fromJson(json.decode(response.body));
  }

  Future<EditAddressModelMassege> editaddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        showLoaderDialog(context, "Set Delete Address");
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
      map["address_id"] = editaddressID.toString();
      map["name"] = txt_name.text.toString();
      map["email"] = txt_email.text.toString();
      map["phone_number"] = controller.text.toString();
      map["pincode"] = txt_pincode.text.toString();
      map["address"] = txt_address.text.toString();
      map["city"] = txt_city.text.toString();
      map["state"] = txt_state.text.toString();
      map["country"] = txt_country.text.toString();
      map["landmark"] = txt_landmark.text.toString();

      return map;
    }

    print(toMap());
    var response = await http
        .post(Uri.parse('${beasurl}addresses/update'), body: toMap(), headers: {
      'Authorization': 'Bearer $tokanget',
    });

    print(response.body);
    success =
        (EditAddressModelMassege.fromJson(json.decode(response.body)).success);
    message =
        (EditAddressModelMassege.fromJson(json.decode(response.body)).message);
    print("success 123  editaddress ==${response.body}");
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
        _future1 = addressesdata();
        txt_email.clear();
        txt_name.clear();
        txt_pincode.clear();
        txt_address.clear();
        txt_city.clear();
        txt_country.clear();
        txt_state.clear();
        txt_landmark.clear();
        controller.clear();
        editaddressID = null;
        editdataapi = 0;
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
    return EditAddressModelMassege.fromJson(json.decode(response.body));
  }

/////////////// userdata ///////////
  Future? _future3;
  var vendorCreditLimit;
  var success55 ,message55;
  UserDataModelResponse? userd;
  Future<UserDataModelMessage> userdata() async {
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
    var response = await http.get(Uri.parse('${beasurl}user'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
    print("chakout aman ${response.body}");
    success55 = (UserDataModelMessage.fromJson(json.decode(response.body)).success);
    message55 = (UserDataModelMessage.fromJson(json.decode(response.body)).message);

    setState(() {
      userd = (UserDataModelMessage.fromJson(json.decode(response.body)).data);
      vendorCreditLimit = (UserDataModelMessage.fromJson(json.decode(response.body)).data!.vendorCreditLimit);
    });

    if (success55 == true) {
      (context as Element).reassemble();
      vendorCreditLimit = (UserDataModelMessage.fromJson(json.decode(response.body)).data!.vendorCreditLimit)!;
      progressDialog!.dismiss();
    } else {
      Navigator.pop(context);
      progressDialog!.dismiss();
      print('else==============');
      Fluttertoast.showToast(
          msg: message55,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return UserDataModelMessage.fromJson(json.decode(response.body));
  }

  void urlluncher(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _future1 = addressesdata();
    _future2 = productdetacardlistdata();
    _future = chakout();
    _future3 = userdata();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {
      return WillPopScope(
        onWillPop: () async {
          Get.off(() => MyCardPage());
          return false;
        },
        child: Scaffold(
          backgroundColor: colorskyeblue,
          appBar: appbarnotifav(context, 'Checkout'),
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
                padding: const EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedboxheight(10.0),

                      status == true ? signinDonecard() : Container(),
                      adddesscard1 == true ? addressDonecard() : Container(),
                      productcard1 == true
                          ? productSummeryDonecard()
                          : Container(),

                      status == false ? logincard(context) : Container(),
                      adddesscard == false
                          ? seveaddresscard(context)
                          : Container(),
                      productcard == false
                          ? productsummarycard(context)
                          : Container(),
                      paymentcard == false
                          ? paymentmethodscard(context)
                          : Container(),

                      sizedboxheight(10.0),
                      paymentsummarycard(context),
                      // sizedboxheight(5.0),
                      // coopncard(context),
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

                      // sizedboxheight(10.0),
                      // continueBtn(context),
                      sizedboxheight(20.0),
                    ],
                  ),
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
        ),
      );});

    return WillPopScope(
      onWillPop: () async {
        Get.off(() => MyCardPage());
        return false;
      },
      child: Scaffold(
        backgroundColor: colorskyeblue,
        appBar: appbarnotifav(context, 'Checkout'),
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
              padding: EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedboxheight(10.0),

                    status == true ? signinDonecard() : Container(),
                    adddesscard1 == true ? addressDonecard() : Container(),
                    productcard1 == true
                        ? productSummeryDonecard()
                        : Container(),

                    status == false ? logincard(context) : Container(),
                    adddesscard == false
                        ? seveaddresscard(context)
                        : Container(),
                    productcard == false
                        ? productsummarycard(context)
                        : Container(),
                    paymentcard == false
                        ? paymentmethodscard(context)
                        : Container(),

                    sizedboxheight(10.0),
                    paymentsummarycard(context),
                    // sizedboxheight(5.0),
                    // coopncard(context),
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

                    // sizedboxheight(10.0),
                    // continueBtn(context),
                    sizedboxheight(20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentsummarycard(context) {
    return FutureBuilder(
      future: _future2,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
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
                                  child:  Text(
                                      'Products Your Shopping cart contains ',
                                      style: textstylesubtitle1(context)!
                                          .copyWith(fontWeight: FontWeight.bold,),
                                      textAlign: TextAlign.start)),
                              Expanded(
                                child:  Text(
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
                                  child: Text(cartond,
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

                        sizedboxheight(20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                width: deviceWidth(context, 0.4),
                                child: Text('Total Amount:',
                                    style: textstylesubtitle1(context))),
                            Container(
                                alignment: Alignment.centerRight,
                                width: deviceWidth(context, 0.4),
                                child: Text('AED ${grandTotal}',
                                    style: textstylesubtitle1(context)!.copyWith(
                                        color: colorblue,
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                        sizedboxheight(20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                width: deviceWidth(context, 0.4),
                                child: Text('Total Discount:',
                                    style: textstylesubtitle1(context))),
                            Container(
                                alignment: Alignment.centerRight,
                                width: deviceWidth(context, 0.4),
                                child: Text('AED ${deiscountamount}',
                                    style: textstylesubtitle1(context)!.copyWith(
                                        color: colorgreen,
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                        sizedboxheight(8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                width: deviceWidth(context, 0.4),
                                child: Text('VAT($vat):',
                                    style: textstylesubtitle1(context))),
                            Container(
                                alignment: Alignment.centerRight,
                                width: deviceWidth(context, 0.4),
                                child: Text('AED ${vatAmount}',
                                    style: textstylesubtitle1(context)!
                                        .copyWith(fontWeight: FontWeight.bold))),
                          ],
                        ),

                        sizedboxheight(20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                width: deviceWidth(context, 0.4),
                                child: Text('Amount Payable:',
                                    style: textstylesubtitle1(context)!
                                        .copyWith(fontWeight: FontWeight.bold))),
                            Container(
                                alignment: Alignment.centerRight,
                                width: deviceWidth(context, 0.4),
                                child: Text(
                                    'AED ${(amountPayable!).toStringAsFixed(2)}',
                                    style: textstylesubtitle1(context)!.copyWith(
                                        color: colorblue,
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                        sizedboxheight(20.0),
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
  //
  // Widget coopnfield(context) {
  //   return AllInputDesign(
  //     widthtextfield: deviceWidth(context,1.0),
  //     enabledBorderRadius: BorderRadius.circular(0),
  //     focusedBorderRadius: BorderRadius.circular(0),
  //     floatingLabelBehavior: FloatingLabelBehavior.never,
  //     hintText: 'Enter Promo Code Here',
  //     controller: txt_applycoopan,
  //     autofillHints: [AutofillHints.postalCode],
  //     textInputAction: TextInputAction.done,
  //     suffixIcon:applyBtn(context),
  //     keyBoardType: TextInputType.text,
  //     validatorFieldValue: 'promo_code',
  //     validator:  (value) {
  //       if (value.isEmpty) {
  //         return 'Required Promo Code.';
  //       }
  //
  //     },
  //   );
  // }
  //
  // Widget applyBtn(context) {
  //   return Button(
  //     buttonName: 'APPLY',
  //     btnWidth: deviceWidth(context,0.25),
  //     key: Key('apply'),
  //     btnColor: colorblack,
  //     borderRadius: BorderRadius.circular(0),
  //
  //     onPressed: () {
  //
  //       if(_formKey.currentState!.validate()){
  //         print(txt_applycoopan.text);
  //         if(txt_applycoopan.text.isNotEmpty){
  //           applycopandata();
  //         }
  //       }
  //
  //       //  applycopandata();
  //       // Get.to(() => BottomNavBarPage());
  //     },
  //   );
  // }

  /// LOGIN CARD ///

  Widget continueBtn(context ,color) {
    return Button(
      btnColor:color,
      buttonName: 'PLACE ORDER',
      key: const Key('place order'),
      borderRadius: BorderRadius.circular(0),
      btnWidth: deviceWidth(context, 0.6),
      onPressed: () {
        // Get.to(() => OrderSuccess(orderid:));
        if (selectaddressid != null) {
          if (itemsdata.length != null && itemsdata.isNotEmpty) {
            if (paymenttype != -1) {
              print(paymenttype);
              if(paymenttype==1){
                print('??????????????123${vendorCreditLimit}');
                if(vendorCreditLimit >= amountPayable){

                  print(vendorCreditLimit);
                  checkoutdata();
                }
                else{
                  Fluttertoast.showToast(
                      msg: "You do not have sufficient credit points.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: colorblue,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              }
              else{
                checkoutdata();
              }

            } else {
              Fluttertoast.showToast(
                  msg: "Please Select Paymenttype",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: colorblue,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          } else {
            Fluttertoast.showToast(
                msg: "itemsdata length 0",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: colorblue,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          Fluttertoast.showToast(
              msg: "Please Select Shipping Address",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: colorblue,
              textColor: Colors.white,
              fontSize: 16.0);
        }

        // switch(cashvalue) {
        //   case 1: {
        //     //statements;
        //     setState(() {
        //       status = false;
        //       adddesscard = true;
        //       productcard = false;
        //       paymentcard = false;
        //       cashvalue = 2;
        //
        //       sinincard1 = false;
        //       adddesscard1 = false;
        //       productcard1 = false;
        //
        //     });
        //   }
        //   break;
        //
        //   case 2: {
        //     //statements;
        //     setState(() {
        //       status = false;
        //       adddesscard = false;
        //       productcard = true;
        //       paymentcard = false;
        //       cashvalue = 3;
        //
        //       sinincard1 = false;
        //       adddesscard1 = true;
        //       productcard1 = false;
        //
        //     });
        //   }
        //   break;
        //
        //   case 3: {
        //     //statements;
        //     setState(() {
        //       status = false;
        //       adddesscard = false;
        //       productcard = false;
        //       paymentcard = true;
        //       cashvalue = 4;
        //
        //       sinincard1 = false;
        //       adddesscard1 = true;
        //       productcard1 = true;
        //
        //     });
        //   }
        //   break;
        //
        //   case 4: {
        //     //statements;
        //     setState(() {
        //       cashvalue = 5;
        //       print(cashvalue);
        //       Get.to(() => OrderSuccess());
        //     });
        //   }
        //   break;
        //
        // }
      },
    );
  }

  Widget logincard(context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: colorblue,
              width: deviceWidth(context, 1.0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Returning Customer? Click Here To Login',
                      style: textstylesubtitle1(context)!
                          .copyWith(color: colorWhite),
                    ),
                  ],
                ),
              ),
            ),
            sizedboxheight(10.0),
            Text(
              'Sign in',
              style: textstyleHeading2(context),
            ),
            sizedboxheight(20.0),

            Text(
              'Username*',
              style: textstylesubtitle1(context),
            ),
            loginemail(),
            sizedboxheight(10.0),
            Text(
              'Password*',
              style: textstylesubtitle1(context),
            ),
            loginPassword(context),
            sizedboxheight(10.0),
            forgetpassword(context),
            sizedboxheight(30.0),
            loginBtn(context),
            sizedboxheight(30.0),
            // Align(
            //     alignment: Alignment.center,
            //     child: Text('Sign in via Social',style: textstyleHeading6(context),)),
            // sizedboxheight(30.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     fbboxbtn1(),
            //     sizedboxwidth(20.0),
            //     //  Consumer<GoogleSignUpModelPage>(builder: (context,googlesignupmodel,_){
            //     //    return  googleboxbtn2(context,googlesignupmodel);
            //     //  }),
            //     googleboxbtn2(context),
            //     // sizedboxwidth(15.0),
            //     // boxbtn3(),
            //   ],
            // ),
            sizedboxheight(50.0),
            Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: deviceWidth(context, 0.45),
                        child: Text(
                          'Don\’t have an account?  ',
                          style: textstyleHeading6(context),
                        )),
                    Container(
                        width: deviceWidth(context, 0.35),
                        child: Text(
                          'SIGN UP NOW',
                          style: textstyleHeading6(context)!
                              .copyWith(color: colorblue),
                        )),
                  ],
                )),

            sizedboxheight(10.0),
          ],
        ),
      ),
    );
  }

  Widget loginemail() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Jone Doe',
      // controller: model.loginEmail,
      autofillHints: [AutofillHints.email],
      textInputAction: TextInputAction.next,

      suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20, top: 15, bottom: 15),
          child: SvgPicture.asset(
            'assets/icons/user_input.svg',
            height: 0,
            width: 0,
          )),
      keyBoardType: TextInputType.emailAddress,
      validatorFieldValue: 'email',
      validator: validateEmailField,
    );
  }

  Widget loginPassword(context) {
    return AllInputDesign(
      key: Key("password11"),

      hintText: 'Password',
      textInputAction: TextInputAction.done,
      autofillHints: [AutofillHints.password],
      obsecureText: true,
      // controller: model.loginPassword,
      // onEditingComplete: ()=>TextInput.finishAutofillContext(),
      // prefixIcon: Image(image: AssetImage('assets/icons/lock.png')),
      suffixIcon: TextButton(
          key: Key('password_visibility'),
          onPressed: () {
            // model.toggle();
          },
          // child: Icon(Icons.visibility, size: 20.0, color: true ? colorblack :colorgrey ),
          //  child:Icon( icon: Icon(Icons.visibility, size: 20.0, color: true ? colorblack :colorgrey )),
          child: true
              ? ImageIcon(
                  AssetImage('assets/icons/lock (3)@3x.png'),
                  color: colorblack,
                  size: 20,
                )
              : ImageIcon(
                  AssetImage('assets/icons/lock (3)@3x.png'),
                  color: colorblack54,
                )),
      validatorFieldValue: 'password',
      validator: validaterequired,
      keyBoardType: TextInputType.emailAddress,
    );
  }

  Widget forgetpassword(context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () async {
          // Get.to(() => Forgetpass());
        },
        child: Text(
          'Forget Password ?',
          style: textstylesubtitle1(context)!.copyWith(color: colorblue),
        ),
      ),
    );
  }

  Widget loginBtn(context) {
    return Button(
      buttonName: 'SIGN IN',
      key: Key('login_submi'),
      borderRadius: BorderRadius.circular(5),
      btnWidth: deviceWidth(context, 0.4),
      btnColor: colorblack,
      onPressed: () {
        // Get.to(() => BottomNavBarPage());

        // if (formKey1.currentState.validate()) {
        //   //  model.changepasswordsubmit(context, userid);
        //   // Get.to(() => BottomNavBarPage());
        // } else {
        //   // model.toggleautovalidate();
        // }
      },
    );
  }

  Widget fbboxbtn1() {
    return CircleAvatar(
      radius: 22,
      backgroundImage: AssetImage('assets/icons/Facebook@3x.png'),
    );
  }

  Widget googleboxbtn2(context) {
    return CircleAvatar(
      radius: 22,
      backgroundImage: AssetImage('assets/icons/Icon@3x.png'),
    );
  }

  Widget saveaddressBtn(
    context,
  ) {
    return Button(
      buttonName: 'SAVE ADDRESS',
      btnstyle: textstylesubtitle1(context)!.copyWith(fontSize: 13,color: colorWhite,overflow: TextOverflow.ellipsis),
      key: Key('save address'),
      borderRadius: BorderRadius.circular(5),
      btnWidth: deviceWidth(context, 0.45),
      onPressed: () {
        if (editdataapi == 1) {
          editaddress();
        } else {
          if (_formKey.currentState!.validate()) {
            print('aman1111');
            addnewaddress();
          } else {
            // model.toggleautovalidate();
          }
        }
      },
    );
  }

  Widget cancelbutton(context) {
    return Button(
      buttonName: 'CANCEL',
      btnstyle: textstylesubtitle1(context)!.copyWith(fontSize: 12,color: colorWhite,overflow: TextOverflow.ellipsis, ),
      borderRadius: BorderRadius.circular(5),
      btnWidth: deviceWidth(context, 0.25),
      btnColor: colorblack54,
      onPressed: () {
        setState(() {
          addnewaddresscard = false;
          txt_email.clear();
          txt_name.clear();
          txt_pincode.clear();
          txt_address.clear();
          txt_city.clear();
          txt_country.clear();
          txt_state.clear();
          txt_landmark.clear();
          controller.clear();
          editaddressID = null;
          editdataapi = 0;
        });
      },
    );
  }
  // Widget seveBtn(context) {
  //   return Button(
  //     buttonName:'SAVE ADDRESS',
  //     btnstyle: textstylesubtitle1(context)!.copyWith(color: colorWhite),
  //     key: Key('sign up'),
  //     borderRadius: BorderRadius.circular(5),
  //     btnColor: colorblack,
  //     btnWidth: deviceWidth(context,0.4),
  //     onPressed: () {
  //       if (_formKey.currentState!.validate()) {
  //         print('aman1111');
  //         addnewaddress();
  //       } else {
  //         // model.toggleautovalidate();
  //       }
  //       // Get.to(() => SelectCategry());
  //     },
  //   );
  // }
  // Widget signUpBtn(context) {
  //   return Button(
  //     buttonName: 'CANCEL',
  //     btnstyle: textstylesubtitle2(context)!.copyWith(color: colorblack),
  //     borderRadius: BorderRadius.circular(5),
  //
  //     btnWidth: 100,
  //     btnColor: colorWhite,
  //     borderColor: colorblack,
  //     onPressed: () {
  //       setState(() {
  //         addnewaddressset = false;
  //       });
  //
  //       // if (formKey1.currentState.validate()) {
  //       //   //  model.changepasswordsubmit(context, userid);
  //       //   // Get.to(() => BottomNavBarPage());
  //       // } else {
  //       //   // model.toggleautovalidate();
  //       // }
  //
  //
  //     },
  //   );
  // }

  /// ADDRESS CARD ///
  bool addnewaddressset = false;
  Widget seveaddresscard(context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: colorblue,
              width: deviceWidth(context, 1.0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      style: textstylesubtitle1(context)!
                          .copyWith(color: colorWhite),
                    ),
                  ],
                ),
              ),
            ),
            sizedboxheight(10.0),
            InkWell(
              onTap: () {
                setState(() {
                  addnewaddressset = true;
                });
              },
              child: InkWell(
                onTap: () {
                  setState(() {
                    addnewaddresscard = true;
                    txt_email.clear();
                    txt_name.clear();
                    txt_pincode.clear();
                    txt_address.clear();
                    txt_city.clear();
                    txt_country.clear();
                    txt_state.clear();
                    txt_landmark.clear();
                    controller.clear();
                    editaddressID = null;
                    editdataapi = 0;
                  });
                },
                child: Container(
                  //width: deviceWidth(context,0.6),
                  decoration: BoxDecoration(
                      border: Border.all(color: colorblue), color: colorWhite),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: colorblue,
                        ),
                        Container(
                            child: Text(
                          'ADD NEW DELIVERY ADDRESS',
                          style: textstylesubtitle1(context),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            sizedboxheight(10.0),
            FutureBuilder(
              future: _future1,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: addressdatalist.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, bottom: 20, left: 2, right: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Radio(
                                      value: addressdatalist[index].id,
                                      groupValue: selectaddressid,
                                      onChanged: (dynamic value) {
                                        setState(() {
                                          selectaddressid = value;
                                          print(selectaddressid);
                                        });
                                      }),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: deviceWidth(context, 0.58),
                                              child: Text(
                                                '${addressdatalist[index].name}  ${addressdatalist[index].phone}',
                                                style:
                                                    textstyleHeading3(context),
                                              )),
                                          popMenus(
                                            context: context,
                                            options: [
                                              {
                                                "menu": "Edit",
                                                "menu_id": 1,
                                                "address_id": addressdatalist[index].id,
                                                "index": index
                                              },
                                              {
                                                "menu": "Delete",
                                                "menu_id": 2,
                                                "address_id": addressdatalist[index].id,
                                              },
                                            ],
                                          )
                                        ],
                                      ),
                                      Container(
                                        width: deviceWidth(context, 0.58),
                                        child: Text(
                                          '${addressdatalist[index].address == null ? '' : addressdatalist[index].address}',
                                          style: textstylesubtitle2(context)!
                                              .copyWith(
                                                  height: 1.5, fontSize: 13),
                                          maxLines: 2,
                                        ),
                                      ),
                                      Container(
                                        width: deviceWidth(context, 0.58),
                                        child: Text(
                                          '${addressdatalist[index].city == null ? '' : addressdatalist[index].city},  ${addressdatalist[index].state == null ? '' : addressdatalist[index].state},  '
                                          '${addressdatalist[index].country}.',
                                          style: textstylesubtitle2(context)!
                                              .copyWith(
                                                  height: 1.5, fontSize: 13),
                                          maxLines: 2,
                                        ),
                                      ),
                                      Container(
                                        width: deviceWidth(context, 0.58),
                                        child: Text(
                                          '${addressdatalist[index].pincode == null ? '' : addressdatalist[index].pincode}',
                                          style: textstylesubtitle2(context)!
                                              .copyWith(
                                                  height: 1.5, fontSize: 13),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  //  Timer(
                  //   Duration(seconds: 3),
                  //       () {
                  //     // status ? Get.offAll(() => BottomNavBarPage()) : Get.offAll(() => IntroductionPage());
                  //         Center(
                  //               child: CircularProgressIndicator(),
                  //             );
                  //
                  //   },
                  // );

                  return Center(
                    child: Container(
                      child: Center(child: Text('No Data')),
                    ),
                  );
                }
              },
              // future: postlist(),
            ),
            sizedboxheight(10.0),
            addnewaddresscard
                ? Card(
                    elevation: 5,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Name*',
                              style: textstylesubtitle1(context),
                            ),
                            signupname(),
                            sizedboxheight(10.0),
                            Text(
                              'Email Address*',
                              style: textstylesubtitle1(context),
                            ),
                            signupemail(),
                            sizedboxheight(10.0),
                            Text(
                              'Phone Number*',
                              style: textstylesubtitle1(context),
                            ),
                            signupmobile(),
                           // signupphone(),
                            sizedboxheight(10.0),
                            Text(
                              'Pincode*',
                              style: textstylesubtitle1(context),
                            ),
                            pincode(),
                            sizedboxheight(10.0),
                            Text(
                              'Address*',
                              style: textstylesubtitle1(context),
                            ),
                            signupaddress(),
                            sizedboxheight(10.0),
                            Text(
                              'City/ Town/ District*',
                              style: textstylesubtitle1(context),
                            ),
                            signupcitytown(),
                            sizedboxheight(10.0),
                            Text(
                              'State*',
                              style: textstylesubtitle1(context),
                            ),
                            signupstate(),
                            sizedboxheight(10.0),
                            Text(
                              'Country*',
                              style: textstylesubtitle1(context),
                            ),
                            signupcountry(),
                            sizedboxheight(10.0),
                            Text(
                              'Landmark (Optional)',
                              style: textstylesubtitle1(context),
                            ),
                            signuplandmark(),
                            sizedboxheight(10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cancelbutton(context),
                                saveaddressBtn(context),
                                // seveBtn(context),
                                // signUpBtn(context ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            sizedboxheight(10.0),
            Align(
              alignment: Alignment.centerRight,
              child: Button(
                btnWidth: deviceWidth(context, 0.45),
                buttonName: 'CONTINUE',
                key: Key('continue'),
                borderRadius: BorderRadius.circular(5),
                onPressed: () {
                  // Get.to(() => OrderSuccess());
                  setState(() {
                    status = true;
                    adddesscard = true;
                    productcard = false;
                    paymentcard = true;
                    cashvalue = 2;

                    sinincard1 = true;
                    adddesscard1 = true;
                    productcard1 = false;
                  });
                },
              ),
            ),
            sizedboxheight(10.0),
          ],
        ),
      ),
    );
  }

  Widget signupname() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Jone Doe',
      controller: txt_name,
      autofillHints: [AutofillHints.name],
      textInputAction: TextInputAction.next,

      suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20, top: 15, bottom: 15),
          child: SvgPicture.asset(
            'assets/icons/user_input.svg',
            height: 0,
            width: 0,
          )),
      keyBoardType: TextInputType.name,
      validatorFieldValue: 'name',
      validator: validateName,
    );
  }

  Widget signupemail() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
      controller: txt_email,
      autofillHints: [AutofillHints.email],
      textInputAction: TextInputAction.next,
      suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20, top: 15, bottom: 15),
          child: SvgPicture.asset(
            'assets/slicing 2/mail.svg',
            height: 0,
            width: 0,
          )),
      keyBoardType: TextInputType.emailAddress,
      validatorFieldValue: 'email',
      validator: validateEmailField,
    );
  }
  Widget signupmobile() {
    return AllInputDesign(
      initialValue: controller,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: 'Phone Number',
      controller: controller,
      autofillHints: [AutofillHints.telephoneNumberDevice],
      textInputAction: TextInputAction.next,

      keyBoardType: TextInputType.number,
      validatorFieldValue: 'number',
      validator: validateMobile,
    );
  }
  // Widget signupphone() {
  //   return Container(
  //     decoration: BoxDecoration(
  //         border: Border.all(color: colorgrey),
  //         borderRadius: BorderRadius.circular(10)),
  //     padding: EdgeInsets.only(left: 5),
  //     child: InternationalPhoneNumberInput(
  //       spaceBetweenSelectorAndTextField: 0,
  //       textAlignVertical: TextAlignVertical.top,
  //       onInputChanged: (PhoneNumber number) {
  //         print(number.phoneNumber);
  //       },
  //       onInputValidated: (bool value) {
  //         print(value);
  //       },
  //       selectorConfig: SelectorConfig(
  //         selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
  //       ),
  //       ignoreBlank: false,
  //       autoValidateMode: AutovalidateMode.disabled,
  //       selectorTextStyle: TextStyle(color: Colors.black),
  //       initialValue: number,
  //       textFieldController: controller,
  //       formatInput: false,
  //       keyboardType:
  //           TextInputType.numberWithOptions(signed: true, decimal: true),
  //       inputBorder: InputBorder.none,
  //       onSaved: (PhoneNumber number) {
  //         print('On Saved: $number');
  //       },
  //     ),
  //   );
  // }

  Widget pincode() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
      controller: txt_pincode,
      autofillHints: [AutofillHints.addressCityAndState],
      textInputAction: TextInputAction.next,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.location_on_outlined,
          size: 25,
          color: colorgrey,
        ),
      ),

      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'pincode',
      validator: validatePromoCode,
    );
  }

  Widget signupaddress() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
      controller: txt_address,
      autofillHints: [AutofillHints.addressCityAndState],
      textInputAction: TextInputAction.next,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.location_on_outlined,
          size: 25,
          color: colorgrey,
        ),
      ),

      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'address',
      validator: validateAddressName,
    );
  }

  Widget signupcitytown() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
      controller: txt_city,
      autofillHints: [AutofillHints.addressCityAndState],
      textInputAction: TextInputAction.next,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.location_on_outlined,
          size: 25,
          color: colorgrey,
        ),
      ),

      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'city',
      validator: (value) {
        if (value.isEmpty) {
          return 'city Name is Required.';
        }
      },
    );
  }

  Widget signupcountry() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
      controller: txt_country,
      autofillHints: [AutofillHints.countryName],
      textInputAction: TextInputAction.next,

      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Image.asset(
          'assets/icons/smartphone (4).png',
          scale: 7,
          color: colorblue,
        ),
        // child: Icon(Icons.check_box_outline_blank,size: 20,color: colorblue,),
      ),
      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'country',
      validator: (value) {
        if (value.isEmpty) {
          return 'country Name is Required.';
        }
      },
    );
  }

  Widget signupstate() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
      controller: txt_state,
      autofillHints: [AutofillHints.countryName],
      textInputAction: TextInputAction.next,

      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Image.asset(
          'assets/icons/smartphone (4).png',
          scale: 7,
          color: colorblue,
        ),
        // child: Icon(Icons.check_box_outline_blank,size: 20,color: colorblue,),
      ),
      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'state',
      validator: (value) {
        if (value.isEmpty) {
          return 'state Name is Required.';
        }
      },
    );
  }

  Widget signuplandmark() {
    return AllInputDesign(
      // inputHeaderName: 'User Name',
      // key: Key("email1"),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: '',
      controller: txt_landmark,
      autofillHints: [AutofillHints.addressCity],
      textInputAction: TextInputAction.next,
      keyBoardType: TextInputType.streetAddress,
      validatorFieldValue: 'landmark',
      //  validator: validateAddressName,
    );
  }

  /// PRODUCT SUMMARY CARD  ///
  bool a = false;
  Widget productsummarycard(context) {
    return Card(
      elevation: 2,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: colorblue,
              width: deviceWidth(context, 1.0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Summary',
                      style: textstylesubtitle1(context)!
                          .copyWith(color: colorWhite),
                    ),
                  ],
                ),
              ),
            ),
            sizedboxheight(10.0),
            FutureBuilder(
              future: _future2,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: itemsdata.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 2,
                            ),
                            child: Card(
                              color: colorskyeblue,
                              elevation: 2,
                              child: Column(
                                children: [
                                  Container(
                                    width: deviceWidth(context, 1.0),
                                    color: colorWhite,
                                    padding:
                                        EdgeInsets.only(bottom: 5, right: 5),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: deviceWidth(context, 1.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.to(() => ProdectDetails(
                                                      title: itemsdata[index].productName!,
                                                      slug: itemsdata[index].slug!));
                                                },
                                                child: Container(
                                                    width:
                                                        deviceWidth(context, 0.8),
                                                    height: 75,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Image.network(
                                                              itemsdata[index]
                                                                  .thumbnailImage!,
                                                              width: deviceWidth(
                                                                  context, 0.15),
                                                              height: 60,
                                                            )),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            itemsdata[index]
                                                                .productName!,
                                                            style:
                                                                textstylesubtitle1(
                                                                    context),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                              Container(
                                                width:
                                                    deviceWidth(context, 0.05),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      deletewishlist(
                                                          itemsdata[index]
                                                              .id
                                                              .toString());
                                                    });
                                                  },
                                                  child: SvgPicture.asset(
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
                                            width: deviceWidth(context, 1.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 12),
                                              child: RichText(
                                                text: TextSpan(
                                                    children: <InlineSpan>[
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
                                        // Image.network(itemsdata[index].thumbnailImage!,width: deviceWidth(context,0.15),height: 60,),
                                        Row(
                                          children: [
                                            Container(
                                              width: deviceWidth(context, 0.9),
                                              child: DataTable(
                                                columnSpacing: 35,
                                                dataRowHeight: 30,
                                                headingRowHeight: 25,
                                                horizontalMargin: 10,
                                                dividerThickness: 0.0000000001,
                                                columns: <DataColumn>[
                                                  DataColumn(
                                                    label: Text(
                                                      'Size',
                                                      style: textbold(context),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Quantity',
                                                      style: textbold(context),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Cartons',
                                                      style: textbold(context),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Price',
                                                      style: textbold(context),
                                                    ),
                                                  ),
                                                ],
                                                rows: itemsdata[index]
                                                    .productsAttributes! // Loops through dataColumnText, each iteration assigning the value to element
                                                    .map(
                                                      ((element) => DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(Text(
                                                                '${element.itemCode}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        11),
                                                              )), //Extracting from Map element the value

                                                              DataCell(
                                                                FutureBuilder(
                                                                  future:
                                                                      _future2,
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                        .hasData) {
                                                                      return Container(
                                                                        decoration:
                                                                            BoxDecoration(border: Border.all(color: colorgrey)),
                                                                        height:
                                                                            30,
                                                                        child:
                                                                            TextFormField(
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                              textInputAction: TextInputAction.done,

                                                                              key: Key(element
                                                                              .quantity
                                                                              .toString()),
                                                                          style:
                                                                              TextStyle(fontSize: 11),
                                                                          initialValue:
                                                                              '${element == '0' ? 1 : element.quantity}',
                                                                          enableInteractiveSelection:
                                                                              false,
                                                                          textAlign:
                                                                              TextAlign.center,
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
                                                                              // hintText: '${itemsdata[index].quantity}',
                                                                              hintStyle: TextStyle(
                                                                                fontSize: 11,
                                                                                color: colorblack,
                                                                              )),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      return const Center(
                                                                          // child: CircularProgressIndicator(),
                                                                          );
                                                                    }
                                                                  },
                                                                  // future: postlist(),
                                                                ),
                                                              ),
                                                              // DataCell(Text('${element.quantity}',style: TextStyle(fontSize: 11),)),
                                                              DataCell(Text(
                                                                '${((int.parse(itemsdata[index].quantity.toString())) / (int.parse(itemsdata[index].uSCartQty.toString()))).toStringAsFixed(2)}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        11),
                                                              )),

                                                              DataCell(Text(
                                                                'AED ${itemsdata[index].price.toString()}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .lightBlue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )),
                                                            ],
                                                          )),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Price: ',
                                            style: textnormail(context),
                                          ),
                                          Text(
                                            'AED ${itemsdata[index].subtotal!}',
                                            style: textstylesubtitle1(context)!
                                                .copyWith(
                                                    color: colorblue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          )
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
                  //             );
                  //
                  //   },
                  // );

                  return Center(
                    child: Container(
                      child: Center(child: Text('No Data')),
                    ),
                  );
                }
              },
              // future: postlist(),
            ),
            sizedboxheight(10.0),
            const Padding(
              padding:
                  EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8),
              child: Text("LPO Number (Optional) :"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: AllInputDesign(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: 'LPO Number',
                controller: txt_LPOnumber,
                autofillHints: [AutofillHints.name],
                textInputAction: TextInputAction.done,
                keyBoardType: TextInputType.text,
                validatorFieldValue: 'LPO Number',
              ),
            ),
            sizedboxheight(10.0),
            Align(
              alignment: Alignment.centerRight,
              child: Button(
                btnWidth: deviceWidth(context, 0.45),
                buttonName: 'CONTINUE',
                key: const Key('continue'),
                borderRadius: BorderRadius.circular(5),
                onPressed: () {
                  for (int i = 0; i < itemsdata.length; i++) {
                    for (int j = 0;
                        j < itemsdata[i].productsAttributes!.length;
                        j++) {
                      if (itemsdata[i].productsAttributes![j].stock! <
                          itemsdata[i].productsAttributes![j].quantity) {
                        setState(() {
                          upadetcartdata(
                              itemsdata[i].id,
                              itemsdata[i].productsAttributes![j].variantId,
                              itemsdata[i].productsAttributes![j].stock);
                          list.add(itemsdata[i].productsAttributes![j].stock);
                          list1.add(
                              itemsdata[i].productsAttributes![j].quantity);

                          a = true;
                        });
                      } else if (a) {
                        setState(() {
                          status = true;
                          adddesscard = true;
                          productcard = false;
                          paymentcard = true;
                          cashvalue = 2;

                          sinincard1 = true;
                          adddesscard1 = true;
                          productcard1 = false;
                          a = true;
                        });
                      } else {
                        setState(() {
                          status = true;
                          adddesscard = true;
                          productcard = true;
                          paymentcard = false;
                          cashvalue = 2;
                          sinincard1 = true;
                          adddesscard1 = true;
                          productcard1 = true;
                        });
                      }
                    }
                  }
                  if (list.isNotEmpty && list1.isNotEmpty) {
                    print("LISTENTER");
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Cart Product Qty Update'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                for (int i = 0; i < list.length; i++) ...[
                                  ListTile(
                                    title: Text(
                                        'JSO quantity update form ${list1[i].toString()} to ${list[i].toString()}'),
                                    tileColor: Colors.redAccent.shade100,
                                  ),
                                  sizedboxheight(5.0),
                                ]

                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                list.clear();
                                list1.clear();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    print("ELSE");
                  }
                  a = false;

                },
              ),
            ),
            sizedboxheight(10.0),
          ],
        ),
      ),
    );
  }


  /// Payment methods CARD  ///

  int? paymenttype = -1;
  int? val = -1;

  bool cardvel = false;
  bool usecard = false;
  Widget paymentmethodscard(context) {
    return Card(
      elevation: 2,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: colorblue,
              width: deviceWidth(context, 1.0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        Get.off(() => BottomNavBarPage());
                      },
                      child: Text(
                        'Payment Methods',
                        style: textstylesubtitle1(context)!
                            .copyWith(color: colorWhite),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            sizedboxheight(10.0),
            // Row(
            //   children: [
            //     Checkbox(
            //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            //         value: usecard,
            //         activeColor: Colors.green,
            //         onChanged:(bool? newValue){
            //           setState(() {
            //             usecard = newValue!;
            //           });
            //           Text('Remember me');
            //         }),
            //     Text("Use Your Credit (50,000)",style: textbold(context),)              ],
            // ),

            Row(
              children: [
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: paymenttype,
                      onChanged: (value) {
                        setState(() {
                          paymenttype = value as int?;
                          print(paymenttype);
                          print(vendorCreditLimit);
                          print(double.parse(amountPayable.toString()));

                          print(vendorCreditLimit <= amountPayable);
                          if (vendorCreditLimit <= amountPayable) {
                            _showMyDialog();
                          }
                        });
                      },
                      activeColor: Colors.green,
                    ),
                    Text("Use Your Credit (${vendorCreditLimit ?? 0.00})",
                        style: textbold(context))
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 3,
                      groupValue: paymenttype,
                      onChanged: (value) {
                        setState(() {
                          paymenttype = value as int?;
                          print(paymenttype);
                        });
                      },
                      activeColor: Colors.green,
                    ),
                    Text(" Pay Online", style: textbold(context))
                  ],
                ),
              ],
            ),

            Padding(
                padding: const EdgeInsets.all(8.0),
                child:(paymenttype==1)?((vendorCreditLimit >= amountPayable)?continueBtn(context , colorblue):continueBtn(context , colorgrey)):(continueBtn(context ,colorblue))
                ),
            sizedboxheight(10.0),
          ],
        ),
      ),
    );
  }

  Widget signinDonecard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline_outlined,
                color: colorgreen,
                size: 20,
              ),
              sizedboxwidth(10.0),
              Container(
                width: deviceWidth(context, 0.65),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIGN IN',
                      style: textstyleHeading3(context),
                    ),
                    sizedboxheight(8.0),
                    Text(
                      useremail,
                      style: textstylesubtitle2(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addressDonecard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline_outlined,
                color: colorgreen,
                size: 20,
              ),
              sizedboxwidth(10.0),
              Container(
                width: deviceWidth(context, 0.65),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ADDRESS',
                      style: textstyleHeading3(context),
                    ),
                    sizedboxheight(8.0),
                    Text(
                      username.toString(),
                      style: textstylesubtitle2(context),
                    ),
                    Text(
                      'Mobile: ',
                      style: textstylesubtitle2(context),
                    ),
                  ],
                ),
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      status = true;
                      adddesscard = false;
                      productcard = true;
                      paymentcard = true;
                      cashvalue = 2;

                      sinincard1 = true;
                      adddesscard1 = false;
                      productcard1 = false;
                    });
                  },
                  child: Text(
                    'EDIT',
                    style:
                        textstylesubtitle1(context)!.copyWith(color: colorblue),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget productSummeryDonecard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline_outlined,
                color: colorgreen,
                size: 20,
              ),
              sizedboxwidth(10.0),
              Container(
                width: deviceWidth(context, 0.65),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PRODUCT SUMMARY',
                      style: textstyleHeading3(context),
                    ),
                    sizedboxheight(8.0),
                    Text(
                      'Your shopping cart has ${itemsdata.length} products.',
                      style: textstylesubtitle2(context),
                    ),
                  ],
                ),
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      status = true;
                      adddesscard = true;
                      productcard = false;
                      paymentcard = true;
                      cashvalue = 2;

                      sinincard1 = true;
                      adddesscard1 = true;
                      productcard1 = false;
                    });
                  },
                  child: Text(
                    'EDIT',
                    style:
                        textstylesubtitle1(context)!.copyWith(color: colorblue),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _salsepersonDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Container(
              // height: deviceheight(context,0.25),
              child: FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sales Person Details',
                              style: textstyleHeading6(context),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: colorblack,
                                  size: 16,
                                ))
                          ],
                        ),
                        sizedboxheight(10.0),
                        Divider(
                          thickness: 0.8,
                          color: colorblack54,
                        ),
                        sizedboxheight(10.0),
                        Text(
                          'Sales Person Name :',
                          style: textstyleHeading3(context),
                        ),
                        Text(
                          salesPerson!.firstName.toString(),
                          style: textstyleHeading6(context),
                        ),
                        sizedboxheight(10.0),
                        Text(
                          'Sales Person Email :',
                          style: textstyleHeading3(context),
                        ),
                        Text(
                          salesPerson!.email.toString(),
                          style: textstyleHeading6(context),
                        ),
                        sizedboxheight(10.0),
                        Divider(
                          thickness: 0.8,
                          color: colorblack54,
                        ),
                      ],
                    );
                  } else {
                    return Center();
                  }
                },
                // future: postlist(),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  cancelBtn(context),
                  okBtn(context),
                ],
              )
            ],
          );
        });
      },
    );
  }

  Widget okBtn(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Button(
        buttonName: 'OK',
        btnWidth: 60,
        btnColor: colorblue,
        key: Key('ok'),
        borderRadius: BorderRadius.circular(5),
        onPressed: () {
          // Navigator.pop(context);
          // Get.to(() => CheckoutPage());
        },
      ),
    );
  }

  Widget cancelBtn(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Button(
        buttonName: 'Cancel',
        key: Key('Cancel'),
        btnWidth: 100,
        btnstyle: textstylesubtitle1(context)!.copyWith(fontSize: 13,color: colorWhite,overflow: TextOverflow.ellipsis),
        btnColor: colorblack54,
        borderRadius: BorderRadius.circular(5),
        onPressed: () {
          Navigator.pop(context);
          // Get.to(() => CheckoutPage());
        },
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Column(
              children: [
                Container(
                  height: 50,
                  width: deviceWidth(context),
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/icons/icon-5@3x.png',
                            width: 40,
                            height: 40,
                          )),
                      Positioned(
                          right: 0,
                          top: 0,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                color: colorblack,
                              )))
                    ],
                  ),
                ),
                Text(
                  'You Exceed Your Credit Limit',
                  style: textstyleHeading3(context),
                ),
                sizedboxheight(10.0),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _salsepersonDialog();
                  },
                  child: Container(
                      color: colorblue,
                      width: deviceWidth(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text("Contact To Sales Person".toUpperCase(),
                                style: textnormail(context)!.copyWith(
                                  color: colorWhite,
                                ))),
                      )),
                ),
                sizedboxheight(10.0),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => Invoices());
                  },
                  child: Container(
                      color: colorblue,
                      width: deviceWidth(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                                "Make Payment Of Previous Invoice"
                                    .toUpperCase(),
                                style: textnormail(context)!
                                    .copyWith(color: colorWhite))),
                      )),
                ),
                // Row(
                //   children: [
                //     Radio(
                //       value: 2,
                //       groupValue: val,
                //       onChanged: (value) {
                //         setState(() {
                //           val = value as int?;
                //         });
                //       },
                //       activeColor: colorblue,
                //     ),
                //     Container(width: deviceWidth(context,0.4),
                //         child: Text("Sales Person Contact You",style: textbold(context)))
                //   ],
                // ),
                // Container(
                //   color: colorblue,
                //   child: Row(
                //     children: [
                //       Radio(
                //         value: 2,
                //         groupValue: val,
                //         onChanged: (value) {
                //           setState(() {
                //             val = value as int?;
                //           });
                //         },
                //         activeColor: colorblue,
                //       ),
                //       Container(width: deviceWidth(context,0.4),
                //           child: Text("Make Payment Of Previous Invoice",style: textbold(context)))
                //     ],
                //   ),
                // ),
              ],
            ),
            // content: Container(
            //  // height: deviceheight(context,0.25),
            //   child: SingleChildScrollView(
            //     child: Column(
            //       children: [
            //         Center(child: Image.asset('assets/icons/icon-5@3x.png',width: 40,height: 40,)),
            //
            //         Text('You Exceed Your Credit Limit',
            //         style: textstyleHeading3(context),),
            //         sizedboxheight(10.0),
            //         InkWell(
            //           onTap: (){
            //             Navigator.pop(context);
            //             _salsepersonDialog();
            //           },
            //           child: Container(
            //               color: colorblue,
            //               width: deviceWidth(context),
            //               child: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Center(child: Text("Contact To Sales Person".toUpperCase(),style: textnormail(context)!.copyWith(color: colorWhite,))),
            //               )),
            //         ),
            //         sizedboxheight(10.0),
            //         InkWell(
            //           onTap: (){
            //             Navigator.pop(context);
            //             Get.to(() => Invoices());
            //           },
            //           child: Container(
            //               color: colorblue,
            //               width: deviceWidth(context),
            //               child: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Center(child: Text("Make Payment Of Previous Invoice".toUpperCase(),style: textnormail(context)!.copyWith(color: colorWhite))),
            //               )),
            //         ),
            //         // Row(
            //         //   children: [
            //         //     Radio(
            //         //       value: 2,
            //         //       groupValue: val,
            //         //       onChanged: (value) {
            //         //         setState(() {
            //         //           val = value as int?;
            //         //         });
            //         //       },
            //         //       activeColor: colorblue,
            //         //     ),
            //         //     Container(width: deviceWidth(context,0.4),
            //         //         child: Text("Sales Person Contact You",style: textbold(context)))
            //         //   ],
            //         // ),
            //         // Container(
            //         //   color: colorblue,
            //         //   child: Row(
            //         //     children: [
            //         //       Radio(
            //         //         value: 2,
            //         //         groupValue: val,
            //         //         onChanged: (value) {
            //         //           setState(() {
            //         //             val = value as int?;
            //         //           });
            //         //         },
            //         //         activeColor: colorblue,
            //         //       ),
            //         //       Container(width: deviceWidth(context,0.4),
            //         //           child: Text("Make Payment Of Previous Invoice",style: textbold(context)))
            //         //     ],
            //         //   ),
            //         // ),
            //       ],
            //     ),
            //   ),
            // ),
            // actions: <Widget>[
            //   submitBtn(context)
            // ],
          );
        });
      },
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();

    map["name"] = txt_name.text.toString();
    map["email"] = txt_email.text.toString();
    map["phone_number"] = controller.text.toString();
    map["pincode"] = txt_pincode.text.toString();
    map["address"] = txt_address.text.toString();
    map["city"] = txt_city.text.toString();
    map["state"] = txt_state.text.toString();
    map["country"] = txt_country.text.toString();
    map["landmark"] = txt_landmark.text.toString();

    return map;
  }

  bool addnewaddresscard = false;
  var editaddressID;
  var editdataapi = 0;
  Widget popMenus({
    List<Map<String, dynamic>>? options,
    BuildContext? context,
  }) {
    return PopupMenuButton(

      iconSize: 24.0,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      icon: Icon(
        Icons.more_horiz_rounded,
        color: colorblack54,
        size: 24.0,
      ),
      offset: Offset(0, 10),
      itemBuilder: (BuildContext bc) {
        return options!
            .map(
              (selectedOption) => PopupMenuItem(
                onTap: (){

                  if (selectedOption['menu'] == "Edit") {
                    setState(() {
                      print(selectedOption['index']);
                      addnewaddresscard = true;
                      txt_name.text =
                      addressdatalist[selectedOption['index']].name ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .name!;
                      txt_email.text =
                      addressdatalist[selectedOption['index']]
                          .email ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .email!;
                      controller.text =
                      addressdatalist[selectedOption['index']]
                          .phone ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .phone!;
                      txt_pincode.text =
                      addressdatalist[selectedOption['index']]
                          .pincode ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .pincode!;
                      txt_address.text =
                      addressdatalist[selectedOption['index']]
                          .address ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .address!;
                      txt_city.text =
                      addressdatalist[selectedOption['index']].city ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .city!;
                      txt_state.text =
                      addressdatalist[selectedOption['index']]
                          .state ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .state!;
                      txt_country.text =
                      addressdatalist[selectedOption['index']]
                          .country ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .country!;
                      txt_landmark.text =
                      addressdatalist[selectedOption['index']]
                          .landmark ==
                          null
                          ? ''
                          : addressdatalist[selectedOption['index']]
                          .landmark!;
                      editaddressID = selectedOption['address_id'];
                      editdataapi = 1;
                    });
                  }
                  if (selectedOption['menu'] == "Delete") {
                    setState(() {
                      deleteaddress(selectedOption['address_id']);
                    });
                  }
                },
                height: 12.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        print(selectedOption['menu']);
                        print(selectedOption['address_id']);
                        Navigator.pop(context!);
                        if (selectedOption['menu'] == "Edit") {
                          setState(() {
                            print(selectedOption['index']);
                            addnewaddresscard = true;
                            txt_name.text =
                                addressdatalist[selectedOption['index']].name ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .name!;
                            txt_email.text =
                                addressdatalist[selectedOption['index']]
                                            .email ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .email!;
                            controller.text =
                                addressdatalist[selectedOption['index']]
                                            .phone ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .phone!;
                            txt_pincode.text =
                                addressdatalist[selectedOption['index']]
                                            .pincode ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .pincode!;
                            txt_address.text =
                                addressdatalist[selectedOption['index']]
                                            .address ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .address!;
                            txt_city.text =
                                addressdatalist[selectedOption['index']].city ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .city!;
                            txt_state.text =
                                addressdatalist[selectedOption['index']]
                                            .state ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .state!;
                            txt_country.text =
                                addressdatalist[selectedOption['index']]
                                            .country ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .country!;
                            txt_landmark.text =
                                addressdatalist[selectedOption['index']]
                                            .landmark ==
                                        null
                                    ? ''
                                    : addressdatalist[selectedOption['index']]
                                        .landmark!;
                            editaddressID = selectedOption['address_id'];
                            editdataapi = 1;
                          });
                        }
                        if (selectedOption['menu'] == "Delete") {
                          setState(() {
                            deleteaddress(selectedOption['address_id']);
                          });
                        }
                      },
                      child: Text(
                        selectedOption['menu'] ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          color: colorblack54,
                        ),
                      ),
                    ),
                    (options.length == (options.indexOf(selectedOption) + 1))
                        ? SizedBox(
                            width: 0.0,
                            height: 0.0,
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                          ),
                  ],
                ),
                value: selectedOption,
              ),
            )
            .toList();
      },
      onSelected: (value) async {},
    );
  }
}
