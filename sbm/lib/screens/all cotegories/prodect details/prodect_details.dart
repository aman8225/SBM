import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20details/xmlvideo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbar_modelpage.dart';
import 'package:sbm/common/bottomnavbar/bottomnavbarwidget.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/server_url.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/cartmodel/SerchBar/serch_bar_model.dart';
import 'package:sbm/model/prodectdetelsmodel/Data.dart';
import 'package:sbm/model/prodectdetelsmodel/DeleteWishlistModel/DeleteWishlistMode.dart';
import 'package:sbm/model/prodectdetelsmodel/addwhishlistmodel/addwhishlistmodel.dart';
import 'package:sbm/model/prodectdetelsmodel/prodectdetelsmodel.dart';
import 'package:sbm/model/prodectdetelsmodel/related_product_data_model/related_product_data_model.dart';
import 'package:sbm/model/prodectdetelsmodel/videodownlodemodel/videodownlodemodel.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20details/imagescreen.dart';
import 'package:sbm/screens/all%20cotegories/add_to_card_screen/add_to_card_screen.dart';
import 'package:sbm/screens/all%20cotegories/my%20cart/my_card_page.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20details/tabpages/add_feedback_card.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20details/tabpages/description_card.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20details/tabpages/document_card.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20details/tabpages/faqs.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20details/tabpages/features_video_card.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20details/tabpages/speces_card.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20details/tabpages/training_video_card.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import 'package:share_plus/share_plus.dart';


class ProdectDetails extends StatefulWidget {
  String? title;
  String? slug;
  ProdectDetails({Key? key, this.title, this.slug}) : super(key: key);

  @override
  _ProdectDetailsState createState() => _ProdectDetailsState();
}

class _ProdectDetailsState extends State<ProdectDetails>
    with SingleTickerProviderStateMixin {
  var productId;
  @override
  Future? _future;
  Future? _future1;



  void _shareContent() {
    Share.share(pageUrl);
  }

  ProgressDialog? progressDialog;
  var success, message, rotateImagePath;
  Data? discriptiondata;

  List<String> sliderimage = [];
  var tokanget;
  bool? wishlist;
  var sku;
  var pageUrl ;
  var threesixty_images ;
  String? playvideo;
  Future<prodectdetelsmodelmessege> veiwalldatalist() async {
    // showLoaderDialog(context);
    print("CLICKED 123 ==veiwalldatalist");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        progressDialog = ProgressDialog(context, dismissable: false);
        progressDialog?.setMessage(Text("Loading ...."));
        //  progressDialog?.show();
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
    print(beasurl + 'productweb_new/' + "${widget.slug}");
    // print(beasurl+'productweb/'+widget.slug!);
    var response = await http
        //.get(Uri.parse('${beasurl}productweb/${widget.slug!}'), headers: {
        .get(Uri.parse('${beasurl}productweb_new/${widget.slug!}'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokanget',
    });
     print("???????????????????");
     print(json.decode(response.body));
    print("???????????????????");
     print(prodectdetelsmodelmessege.fromJson(json.decode(response.body)).success);
    print("???????????????????");
    success = (prodectdetelsmodelmessege
        .fromJson(json.decode(response.body))
        .success);
    message = (prodectdetelsmodelmessege
        .fromJson(json.decode(response.body))
        .message);

    setState(() {
      discriptiondata =
          (prodectdetelsmodelmessege.fromJson(json.decode(response.body)).data);
      sliderimage = (prodectdetelsmodelmessege
          .fromJson(json.decode(response.body))
          .data!
          .gallery)!;
      print("???????0${sliderimage}");
      productId = (prodectdetelsmodelmessege
          .fromJson(json.decode(response.body))
          .data!
          .id);
      wishlist = (prodectdetelsmodelmessege
          .fromJson(json.decode(response.body))
          .data!
          .wishlist);
      print("???????1${wishlist}");
      sku = (prodectdetelsmodelmessege
          .fromJson(json.decode(response.body))
          .data!
          .sku);
      print("???????2${sku}");
      rotateImagePath = (prodectdetelsmodelmessege
          .fromJson(json.decode(response.body))
          .data!
          .rotateImagePath);
      print("???????3${rotateImagePath}");
      playvideo = (prodectdetelsmodelmessege
          .fromJson(json.decode(response.body))
          .data!
          .videoUrl);
      print("???????4${playvideo}");
      pageUrl = (prodectdetelsmodelmessege
          .fromJson(json.decode(response.body))
          .data!
          .pageUrl);
      print("???????5${pageUrl}");
      threesixty_images = (prodectdetelsmodelmessege
          .fromJson(json.decode(response.body))
          .data!
          .mobile360);
      print("???????6${threesixty_images}");

    });
    if (success == true) {

        // progressDialog?.dismiss();
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: colorblue,
            textColor: Colors.white,
            fontSize: 16.0);

    } else {
      // Navigator.pop(context);
      // progressDialog?.dismiss();
      print('else==============');
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: colorblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return prodectdetelsmodelmessege.fromJson(json.decode(response.body));
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

  var success1, message1;
  List<RelatedProductDataResponse> relatedeproductdata = [];
  Future<RelatedProductDataModelMassege> relatetproductdatalist() async {
    // showLoaderDialog(context);
    print("CLICKED 123 ==relatetproductdatalist");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
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
    // var response = await http.get(Uri.parse(beasurl+'getProductsBySKU?order=DESC&limit=4&&sku='+widget.slug));
    var response = await http.get(
        Uri.parse('${beasurl}getProductsBySKU?order=DESC&limit=4&sku=${widget.slug!}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokanget',
        });

    setState(() {
      success1 =
          (RelatedProductDataModelMassege.fromJson(json.decode(response.body))
              .success);
      message1 =
          (RelatedProductDataModelMassege.fromJson(json.decode(response.body))
              .message);
      relatedeproductdata =
          (RelatedProductDataModelMassege.fromJson(json.decode(response.body))
              .data)!;
    });
    if (success1 == true) {
      if (success1 == true) {
        progressDialog?.dismiss();
        Fluttertoast.showToast(
            msg: message1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: colorblue,
            textColor: Colors.white,
            fontSize: 16.0);
      }
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
    return RelatedProductDataModelMassege.fromJson(json.decode(response.body));
  }


  @override
  void initState() {
    super.initState();
    _future = veiwalldatalist();
    _future1 = relatetproductdatalist();


  }

  Future<VideoDownlodeModelMassege> downloadvideofuction() async {
    print("addfeedback${productId}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        showLoaderDialog(context, 'Downloade Video...');
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
      map["product_id"] = productId.toString();

      return map;
    }

    var response = await http.post(
        Uri.parse('${beasurl}createProductVideoRequest'),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
        });

    print(response.body);
    success = (VideoDownlodeModelMassege.fromJson(json.decode(response.body))
        .success);
    message = (VideoDownlodeModelMassege.fromJson(json.decode(response.body))
        .message);

    print("success 123 ==$success");
    if (success == true) {
      if (success == true) {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: colorblue,
            textColor: Colors.white,
            fontSize: 16.0);
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
    return VideoDownlodeModelMassege.fromJson(json.decode(response.body));
  }

  Future<AddWhishListModelMassege> addwishlist(slug) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        showLoaderDialog(context, 'Add Wishlist');
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
      map["product_id"] = productId.toString();

      return map;
    }

    var response = await http
        .post(Uri.parse('${beasurl}addToWishlist'), body: toMap(), headers: {
      'Authorization': 'Bearer $tokanget',
    });

    print(response.body);
    success =
        (AddWhishListModelMassege.fromJson(json.decode(response.body)).success);
    message =
        (AddWhishListModelMassege.fromJson(json.decode(response.body)).message);

    print("success 123 ==$success");
    if (success == true) {
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
          wishlist = false;
          veiwalldatalist();
        });
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
    return AddWhishListModelMassege.fromJson(json.decode(response.body));
  }

  Future<DeleteWishlistModelMassege> deletewishlist(slug) async {
    print("addwishlist$productId");
    print("deletewishlistwishlist$wishlist");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokanget = prefs.getString('login_user_token');
    tokanget = tokanget!.replaceAll('"', '');
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        showLoaderDialog(context, 'Add Wishlist');
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
      map["product_id"] = productId.toString();

      return map;
    }

    var response = await http.post(Uri.parse('${beasurl}RemoveFromwishlist'),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
        });

    print(response.body);
    success = (DeleteWishlistModelMassege.fromJson(json.decode(response.body))
        .success);
    message = (DeleteWishlistModelMassege.fromJson(json.decode(response.body))
        .message);

    print("success 123 ==$success");
    if (success == true) {
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
          wishlist = true;
          veiwalldatalist();
        });
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
    return DeleteWishlistModelMassege.fromJson(json.decode(response.body));
  }

  showLoaderDialog(BuildContext context, String massege) {
    AlertDialog alert = AlertDialog(
      content:  Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7), child: Text(massege)),
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> get _localPath async {
    var dir = await getExternalStorageDirectory();

    return dir!.path;
  }
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
      // downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
      downloadsDirectory = Platform.isAndroid?await getExternalStorageDirectory():await getTemporaryDirectory();
    } on PlatformException {
      print('Could not get the downloads directory');
    }
    String tempPath = downloadsDirectory!.path;
    var filePath = '$tempPath/${DateTime.now()}.png';
    print(filePath);
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
    var response = await http.get(Uri.parse('${beasurl}productSearchBySKU?sku=$search'), headers: {
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
  Widget build(BuildContext context) {

    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {
      return Scaffold(
        appBar: appbarnotifav(context, widget.title ?? ''),
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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sliderimage.isEmpty
                          ? Card(
                            child: Container(
                         height: deviceheight(context, 0.45),
                         width: deviceWidth(context),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // color: colorgreen,
                              ),
                      ),
                          )
                          : Card(
                        elevation: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // color: colorgreen,
                          ),
                          // height: deviceheight(context,0.5),
                          child: Container(
                            child: Stack(
                              children: [
                                topbenercard(),
                                // discriptiondata != null
                                //     ? _rightSideButtonsWidgets(
                                //     discriptiondata!.slug)
                                //     : Container(),
                              ],
                            ),
                          ),
                          // PageView.builder(
                          //   scrollDirection: Axis.horizontal,
                          //   itemCount: 1,
                          //   itemBuilder: (BuildContext context, int index) {
                          //     return Stack(
                          //       children: <Widget>[
                          //
                          //         topbenercard(),
                          //         _rightSideButtonsWidgets(),
                          //
                          //       ],
                          //     );
                          //   },
                          // ),
                        ),
                      ),
                     Container(
                       height: 40,
                       width: deviceWidth(context, 1),
                       child:  discriptiondata != null
                           ? _rightSideButtonsWidgets(
                           discriptiondata!.slug)
                           : Container( height: 50,),
                     ),
                      FutureBuilder(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, left: 8, right: 8),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: deviceWidth(context, 1.0),
                                        child: Text(
                                          discriptiondata!.productName == null
                                              ? ' '
                                              : discriptiondata!.productName!
                                              .toUpperCase(),
                                          style: textstyleHeading3(context)!
                                              .copyWith(height: 1.2),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    Container(
                                        width: deviceWidth(context, 1.0),
                                        height: 20,
                                        child: Text(
                                          'SKU: ${discriptiondata!.sku == null ? '' : discriptiondata!.sku!}',
                                          style:
                                          textstylesubtitle2(context),
                                        )),
                                    Container(
                                        width: deviceWidth(context, 1.0),
                                        child: RichText(
                                          text: TextSpan(
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text:  'Available Size:  ',
                                                  style: textbold(context),
                                                ),
                                                for (var string in discriptiondata!.productsAttributes!)...[
                                                  TextSpan(
                                                      text: "${(string.itemCode!.contains("-"))?(string.itemCode!.split("-")[1]):(string.itemCode)}, ",
                                                      style: textnormail(context)!.copyWith(
                                                          color: colorblue,
                                                          fontWeight: FontWeight.bold)),
                                                ]
                                              ]),
                                        )),
                                     Container(
                                        width: deviceWidth(context, 1.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                child: Text(
                                                  'Brand:  ',
                                                  style: textbold(context),
                                                )),
                                            discriptiondata!
                                                .productBrand==null?Container(): Container(
                                              width: deviceWidth(
                                                  context, 0.55),
                                              child: Text(
                                                  discriptiondata!.productBrand!.brandName == null?"": discriptiondata!.productBrand!.brandName!,
                                                  style: textstylesubtitle1(
                                                      context)!
                                                      .copyWith(
                                                      color: colorblue,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),

                                              // RichText(
                                              //   text: TextSpan(children: <InlineSpan>[
                                              //     for (var string in discriptiondata!.productsAttributes!)
                                              //       TextSpan(text: "${string.itemCode!.split("-")[1]}, ", style: textnormail(context)!.copyWith(color: colorblue)),
                                              //   ]),
                                              // ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        width: deviceWidth(context, 1.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'PRICE: ',
                                              style: textbold(context)!
                                                  .copyWith(
                                                  fontSize: 13,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            Text(
                                              'AED ${discriptiondata!.uprice == null ? '0.00' : discriptiondata!.uprice!} ',
                                              style: textstyleHeading2(
                                                  context)!
                                                  .copyWith(
                                                  color: colorblue,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            Text(
                                              'AED ${discriptiondata!.regularPrice == null ? '0.00' : discriptiondata!.regularPrice!}',
                                              style: textstylesubtitle2(
                                                  context)!
                                                  .copyWith(
                                                  decoration:
                                                  TextDecoration
                                                      .lineThrough),
                                            ),
                                          ],
                                        )),
                                    sizedboxheight(8.0),
                                    discriptiondata!.downloadDatasheet ==
                                        null
                                        ? Container()
                                        : InkWell(
                                      onTap: () async {

                                        startDownloading(
                                            discriptiondata!
                                                .downloadDatasheet??"");


                                      },

                                      child: Container(

                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                5),
                                            border: Border.all(
                                                color: colorblue)),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              5.0),
                                          child: Row(
                                            mainAxisSize:MainAxisSize.min ,
                                            children: [
                                              Image.asset(
                                                'assets/icons/icon-4@3x.png',
                                                scale: 1,
                                              ),
                                              Text(
                                                '  DOWNLOAD DATASHEET',
                                                style: textstylesubtitle1(context)!.copyWith(
                                                    color: colorblue,
                                                    fontSize: 12),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    sizedboxheight(20.0),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        discriptiondata!.uprice == null
                                            ? Container(
                                          child: Button(
                                            btnColor: colorgrey,
                                            imageAsset:
                                            SvgPicture.asset(
                                              'assets/slicing 2/shopping-cart.svg',
                                              height: 20,
                                              width: 20,
                                              color: colorWhite,
                                            ),
                                            buttonName: 'ADD TO CART',
                                            btnstyle:
                                            textstylesubtitle1(
                                                context)!
                                                .copyWith(
                                                color:
                                                colorWhite,
                                                fontSize: 12),
                                            btnWidth: deviceWidth(
                                                context, 0.5),
                                            key: Key('ADD TO CART'),
                                            borderRadius:
                                            BorderRadius.circular(
                                                5),
                                            onPressed: () {
                                              Fluttertoast.showToast(
                                                  msg: "Price 0.00",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: colorblue,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            },
                                          ),
                                        )
                                            : addbut(context),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              //  child: CircularProgressIndicator(),
                            );
                          }
                        },
                        // future: postlist(),
                      ),

                      FutureBuilder(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            int i = 0;
                            int itamlenth = 3;
                            if (true) {
                              discriptiondata!.techDocuments != null ? i++ : i;
                              (discriptiondata!.faqDetails!.length != 0&&discriptiondata!.faqDetails!.length != null) ? i++ : i;
                              (discriptiondata!.tranningVideos!.length != 0&&discriptiondata!.tranningVideos!.length != null)
                                  ? i++
                                  : i;
                              (discriptiondata!.featurevideos!.length != 0&&discriptiondata!.featurevideos!.length != 0)
                                  ? i++
                                  : i;
                              itamlenth = itamlenth + i;
                            }
                            return DefaultTabController(
                              length: itamlenth,
                              child: Card(
                                elevation: 1,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      constraints:
                                      const BoxConstraints.expand(height: 30),
                                      child: TabBar(
                                        unselectedLabelColor: colorblack,
                                        indicatorSize: TabBarIndicatorSize.label,
                                        labelColor: colorblue,
                                        isScrollable: true,
                                        tabs: [
                                          const Tab(
                                            child: Text(
                                              'Description',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                          const Tab(
                                            child: Text('Specs',
                                                style: TextStyle(fontSize: 13)),
                                          ),
                                          const Tab(
                                            child: Text('Add Feedback',
                                                style: TextStyle(fontSize: 13)),
                                          ),
                                          if (discriptiondata!.techDocuments !=
                                              null)
                                            const Tab(
                                              child: Text('Tech Document',
                                                  style: TextStyle(fontSize: 13)),
                                            ),
                                          if (discriptiondata!.faqDetails!.isNotEmpty&&discriptiondata!.faqDetails!.length != null)
                                            const Tab(
                                              child: Text('FAQ',
                                                  style: TextStyle(fontSize: 13)),
                                            ),
                                          if (discriptiondata!.tranningVideos!.isNotEmpty&&discriptiondata!.tranningVideos!.length != null)
                                            const Tab(
                                              child: Text('Training Videos ',
                                                  style: TextStyle(fontSize: 13)),
                                            ),
                                          if (discriptiondata!.featurevideos!.isNotEmpty&&discriptiondata!.featurevideos!.length != 0)
                                            const Tab(
                                              child: Text('Features Videos',
                                                  style: TextStyle(fontSize: 13)),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 0.5,
                                      color: colorblack,
                                    ),
                                    Container(
                                      height: deviceheight(context,0.5),
                                      child: TabBarView(
                                        children: [
                                          DescriptionCardPage(
                                              discriptiondata: discriptiondata!),
                                          SpecesCardPage(
                                              discriptiondata: discriptiondata!),
                                          AddFeedbackCardPage(
                                              ID: discriptiondata!.id),
                                          if (discriptiondata!.techDocuments != null)
                                            DocumentCardPage(
                                                discriptiondata:
                                                discriptiondata!),
                                          if (discriptiondata!
                                              .faqDetails!.isNotEmpty)
                                            FAQsCardPage(
                                                discriptiondata:
                                                discriptiondata!),
                                          if (discriptiondata!
                                              .tranningVideos!.isNotEmpty)
                                            TrainingVideoCardPage(
                                                tvideo: discriptiondata!
                                                    .tranningVideos!),
                                          if (discriptiondata!
                                              .featurevideos!.isNotEmpty)
                                            FeaturesVideoCardPage(
                                                fvideo: discriptiondata!
                                                    .featurevideos!),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              //child: CircularProgressIndicator(),
                            );
                          }
                        },
                        // future: postlist(),
                      ),

                      relatedeproductdata.length == 0
                          ? Container()
                          : hedingbar('Related Products'),

                      relatedeproductdata.length == 0
                          ? Container()
                          : bestsellingproductList(),
                      sizedboxheight(40.0),
                      // hedingbar('Recently Viewed Products'),
                      //
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     itemcard(),
                      //     itemcard()
                      //   ],
                      // ),
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
      );
    });
  }

  Widget addbut(context) {
    return Button(
      imageAsset: SvgPicture.asset(
        'assets/slicing 2/shopping-cart.svg',
        height: 20,
        width: 20,
      ),
      buttonName: 'ADD TO CART',
      btnstyle: textstylesubtitle1(context)!
          .copyWith(color: colorWhite, fontSize: 12),
      btnWidth: deviceWidth(context, 0.5),
      key: Key('ADD TO CART'),
      borderRadius: BorderRadius.circular(5),
      onPressed: () {
        //  _showCupertinoDialog(context);
        if(discriptiondata!.sku != null){
          searchproductdata(discriptiondata!.sku);
        }

        // if (formKey1.currentState.validate()) {
        //   //  model.changepasswordsubmit(context, userid);
        //   // Get.to(() => BottomNavBarPage());
        // } else {
        //   // model.toggleautovalidate();
        // }
      },
    );
  }

  Widget hedingbar(titel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: deviceWidth(context, 0.65),
            child: Text(
              titel,
              style: textstyleHeading3(context)!.copyWith(color: colorblack),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )),
        Container(
            width: deviceWidth(context, 0.25),
            height: 40,
            // child: TextButton(
            //   onPressed: () {},
            //   child: Text(
            //     'view All',
            //     style: textstyleHeading3(context)!.copyWith(color: colorblue),
            //     overflow: TextOverflow.ellipsis,
            //     maxLines: 2,
            //   ),
            // )
        )
      ],
    );
  }

  Widget bestsellingproductList() {
    return FutureBuilder(
      future: _future1,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return relatedeproductdata.length == 0
              ? Container()
              : Container(
                  height: 280,
                  width: deviceWidth(context, 1.0),
                  child: ListView.builder(
                      itemCount: relatedeproductdata.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              (context as Element).reassemble();
                              widget.title =
                                  (relatedeproductdata[index].productName)!;
                              widget.slug = relatedeproductdata[index].slug!;
                              veiwalldatalist();
                              relatetproductdatalist();
                            });
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProdectDetails(title: topsaleProducts[index].productName!,slug:topsaleProducts[index].slug!)));
                            // Get.to(() => ProdectDetails(title: relatedeproductdata[index].productName!,slug:relatedeproductdata[index].slug!));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Card(
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
                                      relatedeproductdata[index].mainImage!??'',
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
                                          child: Text(
                                            relatedeproductdata[index]
                                                .productName!??"",
                                            style: textstylesubtitle2(context)!
                                                .copyWith(
                                                    color: colorblack,
                                                    fontWeight:
                                                        FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        sizedboxheight(3.0),
                                        Container(
                                            width: deviceWidth(context, 0.4),
                                            child: Text(
                                              'SKU:${relatedeproductdata[index].sku!??""}',
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
                                                width:
                                                    deviceWidth(context, 0.28),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      'AED ${relatedeproductdata[index].uprice == null ? '0' : relatedeproductdata[index].uprice}',
                                                      style: textstylesubtitle2(
                                                              context)!
                                                          .copyWith(
                                                              color: colorblack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    )),
                                                    Expanded(
                                                        child: Text(
                                                      'AED ${relatedeproductdata[index].regularPrice ?? '0'}',
                                                      style: textstylesubtitle2(
                                                              context)!
                                                          .copyWith(
                                                              fontSize: 9,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              (int.fromEnvironment(relatedeproductdata[index].discountPercent!) >= 0) ?
                                              Container(
                                                width:
                                                    deviceWidth(context, 0.1),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  color: colorgreen,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Center(
                                                      child: Text(
                                                    '${relatedeproductdata[index].discountPercent!.split(".")[0]}% off',
                                                    style: textstylesubtitle2(
                                                            context)!
                                                        .copyWith(
                                                            color: colorWhite,
                                                            fontSize: 7),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  )),
                                                ),
                                              ):
                                                  Container( width: deviceWidth(context, 0.1),)
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
                                            setState(() {
                                              (context as Element).reassemble();
                                              widget.title =
                                                  (relatedeproductdata[index]
                                                      .productName)!;
                                              widget.slug =
                                                  relatedeproductdata[index]
                                                      .slug!;
                                              veiwalldatalist();
                                              relatetproductdatalist();
                                            });
                                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProdectDetails(title: topsaleProducts[index].productName!,slug:topsaleProducts[index].slug!)));
                                            // Get.to(() => ProdectDetails(title: relatedeproductdata[index].productName!,slug:relatedeproductdata[index].slug!));
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
                                                style:
                                                    textstylesubtitle1(context)!
                                                        .copyWith(
                                                  color: colorWhite,
                                                  fontSize: 10,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                        sizedboxwidth(20.0),
                                        InkWell(
                                          onTap: (){
                                            if(relatedeproductdata[index].sku != null){
                                              searchproductdata(relatedeproductdata[index].sku);
                                            }
                                          },
                                          child: Container(
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
          return const Center(
              // child: CircularProgressIndicator(),
              );
        }
      },
      // future: postlist(),
    );
  }

  // Widget itemcard(){
  //   return InkWell(
  //     onTap: (){
  //       Get.to(() => ProdectDetails(title: 'Safety Shoes'));
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
  //                     child: SvgPicture.asset(
  //                       'assets/slicing 2/shopping-cart.svg',
  //
  //                       height: 10,width: 10,
  //                     ),
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
  // Widget confirmorder(context) {
  //   return Button(
  //     buttonName: 'CONFIRM ORDER',
  //     btnstyle: textstylesubtitle1(context)!.copyWith(color: colorWhite,fontSize: 12),
  //     btnWidth: deviceWidth(context,0.5),
  //     key: Key('CONFIRM ORDER'),
  //     borderRadius: BorderRadius.circular(5),
  //
  //     onPressed: () {
  //       Navigator.pop(context);
  //         Get.to(() => MyCardPage());
  //     },
  //   );
  //
  // }
  Widget topbenercard() {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(

            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                height: deviceheight(context, 0.45),
                autoPlay: true,
              ),
              items: sliderimage
                  .map((item) => Container(
                child: Center(
                    child: GestureDetector(
                        child: Image.network(
                          item,
                          fit: BoxFit.fill,
                          width: deviceWidth(context, 1.0),
                          height: deviceheight(context, 1.0),
                        ),
                        onTap: () {
                          Navigator.push<Widget>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageScreen(sliderimage),
                            ),
                          );
                        })
                  // child: Image.network(slider[itemIndex].image!,fit: BoxFit.fill,)
                ),
              ))
                  .toList(),
            ),
          );
            // CarouselSlider.builder(
            //   options: CarouselOptions(
            //     height: 200.0,
            //     autoPlay: true,
            //
            //   ),
            //   itemCount: slider.length,
            //   itemBuilder: (context, itemIndex, realIndex)
            //   {
            //     return Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child:Container(
            //             width: deviceWidth(context,1.0),
            //             child: Image.asset('assets/img_8.png',fit: BoxFit.fill,))
            //              //  child: Image.network('https://images.pexels.com/photos/1643409/pexels-photo-1643409.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',fit: BoxFit.fill,))
            //            // child: Image.network(slider[itemIndex].image!,fit: BoxFit.fill,))
            //            //  child: CachedNetworkImage(
            //            //   // imageUrl: 'https://sbmmarketplace.com/backend/public/uploads/2021/10/b1.png',
            //            //    imageUrl: 'https://images.pexels.com/photos/1643409/pexels-photo-1643409.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
            //            //    fit: BoxFit.fill,
            //            //    placeholder: (context, url) => Padding(
            //            //      padding: EdgeInsets.all(18.0),
            //            //      child: CircularProgressIndicator(
            //            //          strokeWidth: 2, color: colorblue),
            //            //    ),
            //            //    errorWidget: (context, url, error) =>
            //            //        Icon(Icons.person, color: colorblue),
            //            //  )
            //          // ,)
            //
            //
            //     );
            //   },
            // ),

        } else {
          return  const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      // future: postlist(),
    );
  }

  Widget _rightSideButtonsWidgets(slug) {
    return Padding(
      padding: const EdgeInsets.only(top: 10,right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          threesixty_images == null?Container(): InkWell(
            onTap: (){
              Get.to(() => XmlVideo(video:threesixty_images??''));
            },
            child: Container(
              height: 25,width: 25,
              child:SvgPicture.asset(
                'assets/slicing 2/360icon.svg',
                fit: BoxFit.fitHeight,

                color: colorblue,
              )
              // Icon(Icons.reply, size: 25,color: colorblue,)
              ,),
          ),
          threesixty_images == null?Container():  sizedboxwidth(20.0),
          playvideo==null?Container(): InkWell(
            onTap: (){

              setState(() {
                showDialog(
                  context: context,
                  builder: (ctx) =>  AlertDialog(
                    content: VideoWidgetFeatuer(
                      play: true,
                      url: (playvideo ?? ""),
                    )


                  ),
                );
              });
            },
            child: Container(
              height: 25,width: 25,
              child: Image.asset(
                'assets/image.png',
                color: colorblue,
                height: 25,width: 25,
              )
              // Icon(Icons.reply, size: 25,color: colorblue,)
              ,),
          ),
          playvideo==null?Container():  sizedboxwidth(20.0),
          InkWell(
            onTap: () {
              print('share');
              _shareContent();
            },
            child: Container(
              height: 20,
              width: 20,
              child: Image.asset('assets/icons/share (10)@3x.png')
              // Icon(Icons.reply, size: 25,color: colorblue,)
              ,
            ),
          ),
          sizedboxwidth(20.0),
          InkWell(
            onTap: () {
              setState(() {
                wishlist == false ? addwishlist(slug) : deletewishlist(slug);
                wishlist = !wishlist!;
              });
            },
            child: Container(
              height: 20,
              width: 20,
              child: wishlist == false
                  ? Image.asset('assets/icons/like (7)@3x.png')
                  : SvgPicture.asset(
                      'assets/slicing 2/whishlist.svg',
                      color: colorblue,
                      height: 20,
                      width: 20,
                    ),
               ),
          ),
          sizedboxwidth(20.0),
          InkWell(
            onTap: () {
              downloadvideofuction();
            },
            child: Container(
              height: 20,
              width: 20,
              child: Image.asset('assets/icons/Group 2029@3x.png')
              // Icon(Icons.reply, size: 25,color: colorblue,)
              ,
            ),
          ),
          // sizedboxwidth(20.0),
          // Container(
          //   height: 20,
          //   width: 20,
          //   child: Image.asset('assets/icons/Path 2719@3x.png')
          //   // Icon(Icons.reply, size: 25,color: colorblue,)
          //   ,
          // ),
        ],
      ),
    );
  }
}
