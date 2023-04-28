import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/screens/all%20cotegories/my%20cart/my_card_page.dart';
import 'appbarmodelpage.dart';

Text appbartitlewidget(title, context) {
  return Text(
    title,
    style: textstyleHeading6(context),
  );
}

Future<bool> backdb(model) async {
  if (model.bottombarzindex != 2) {
    model.togglebottomindexreset();
  }
  return false;
}

IconButton backbtnappbar(context) => IconButton(
    icon:  Icon(Icons.arrow_back_ios, color: colorblack54),
    onPressed: () {
      Get.back();
      notificationactionWidget(context);
    });
IconButton homebackbtnappbar(model, context) => IconButton(
    icon: new Icon(Icons.arrow_back_ios, color: colorblack54),
    onPressed: () {
      model.bottombarzindex == 2 ? Get.back() : backdb(model);
      notificationactionWidget(context);
    });

IconButton backbtnappbarWhite() => IconButton(
    onPressed: () {
      Get.back();
    },
    icon: Icon(
      Icons.arrow_back,
      color: colorWhite,
    ));
var cartitemlength;
Future<void> abc(context) async {
  (context as Element).reassemble();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  cartitemlength = prefs.getString('cart_item_length');
  cartitemlength = cartitemlength!.replaceAll('"', '');
  //print("cartitemlength??????${cartitemlength}");
  (context as Element).reassemble();
}

Widget notificationactionWidget(context) {
  return StatefulBuilder(builder: (context, setState) {
    abc(context);
    return Row(
      children: [
        InkWell(
          onTap: () async {
            Get.to(() => MyCardPage());
            //  await appbarmodal.counterreset();
            // Get.to(() => NotificationPage());
          },
          child: SizedBox(
            width: 45,
            height: 45,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/icons/Group 59@3x.png',
                  ),
                ),
                Positioned(
                  top: 3,
                  right: 5,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: colorblue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Center(
                      child: Text(
                        cartitemlength==null?"0":cartitemlength.toString(),
                        // '${appbarmodal.itemsdata.length == null ? "0" : appbarmodal.itemsdata.length}',
                        style: TextStyle(
                          color: colorWhite,
                          fontSize: 9,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  });
}

Widget favactionWidget(context) {
  // final appbarmodal = Provider.of<AppbarmodalPage>(context, listen: false);
  return Row(
    children: [
      InkWell(
        onTap: () async {
          //  await appbarmodal.counterreset();
          // Get.to(() => NotificationPage());
        },
        child: SizedBox(
          width: 35,
          height: 35,
          child: Stack(
            children: <Widget>[
              Center(
                child: Icon(
                  Icons.favorite,
                  color: colorWhite,
                  size: 23,
                ),
              ),
              // appbarmodal.counter != 0
              //     ? Positioned(
              //         top: 2,
              //         right: 2,
              //         child: Container(
              //           padding: EdgeInsets.all(2),
              //           decoration: BoxDecoration(
              //             color: Colors.black,
              //             borderRadius: BorderRadius.circular(6),
              //           ),
              //           constraints: BoxConstraints(
              //             minWidth: 14,
              //             minHeight: 14,
              //           ),
              //           child: Center(
              //             child: Text(
              //               '${appbarmodal.counter}',
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 9,
              //               ),
              //               textAlign: TextAlign.center,
              //             ),
              //           ),
              //         ),
              //       )
              //     : Container()
            ],
          ),
        ),
      ),
    ],
  );
}

Widget appbCartWidget(context) {
  // var appbarmodal = Provider.of<AppbarmodalPage>(context, listen: false);
  return Row(
    children: [
      InkWell(
        onTap: () async {
          //  await appbarmodal.counterreset();
          // Get.to(() => MyCart());
        },
        child: SizedBox(
          width: 35,
          height: 35,
          child: Stack(
            children: <Widget>[
              Center(
                child: Icon(
                  Icons.shopping_cart_rounded,
                  color: colorWhite,
                  size: 23,
                ),
              ),
              // appbarmodal.counter != 0
              //     ? Positioned(
              //         top: 2,
              //         right: 2,
              //         child: Container(
              //           padding: EdgeInsets.all(2),
              //           decoration: BoxDecoration(
              //             color: Colors.black,
              //             borderRadius: BorderRadius.circular(6),
              //           ),
              //           constraints: BoxConstraints(
              //             minWidth: 14,
              //             minHeight: 14,
              //           ),
              //           child: Center(
              //             child: Text(
              //               '${appbarmodal.counter}',
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 9,
              //               ),
              //               textAlign: TextAlign.center,
              //             ),
              //           ),
              //         ),
              //       )
              //     : Container()
            ],
          ),
        ),
      ),
    ],
  );
}

Widget appbSearchWidget() {
  return Icon(
    Icons.search,
    color: colorWhite,
    size: 23,
  );
}
