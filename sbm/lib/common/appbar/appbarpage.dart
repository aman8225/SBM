import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:provider/provider.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/screens/all%20cotegories/my%20cart/my_card_page.dart';
import 'appbarmodelpage.dart';
import 'appbarwidgetpage.dart';

@override
AppBar appbartitlebackbtn(context, title) {
  return AppBar(
    elevation: 0,
    backgroundColor: colorskyeblue,
    flexibleSpace: Padding(
      padding: EdgeInsets.only(left: deviceWidth(context, 0.2)),
      child: Container(
        color: colorWhite,
      ),
    ),
    leading: backbtnappbar(context),
    title: Text(
      title,
      style: textstyleHeading6(context),
    ),
  );
}

AppBar appbarbackbtnonly(context) {
  return AppBar(
    elevation: 0,
    backgroundColor: colorskyeblue,
    flexibleSpace: Padding(
      padding: EdgeInsets.only(left: deviceWidth(context, 0.2)),
      child: Container(
        color: colorWhite,
      ),
    ),
    leading: backbtnappbar(context),
  );
}

AppBar appbarbackbtn(context, title) {
  return AppBar(
    elevation: 0,
    backgroundColor: colorskyeblue,
    flexibleSpace: Padding(
      padding: EdgeInsets.only(left: deviceWidth(context, 0.2)),
      child: Container(
        color: colorWhite,
      ),
    ),
    leading: backbtnappbar(context),
    title: Text(
      title,
      style: textstyleHeading6(context),
    ),
  );
}

AppBar appbarnotifav(
  context,
  title,
) {
  // (context as Element).reassemble();
  // var list = Provider.of<AppbarmodalPage>(context, listen: false);
  // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
  //   await list.productdetacardlist(context);
  // });
  // (context as Element).reassemble();

  return AppBar(
    elevation: 0,
    backgroundColor: colorskyeblue,
    flexibleSpace: Padding(
      padding: EdgeInsets.only(left: deviceWidth(context, 0.2)),
      child: Container(
        color: colorWhite,
      ),
    ),
    leading: IconButton(
      icon: new Icon(Icons.arrow_back_ios, color: colorblack54),
      onPressed: () {
        (title == 'Checkout' ? Get.off(() => const MyCardPage()) : Get.back());
        notificationactionWidget(context);
      },
    ),
    title: Text(
      title.toUpperCase(),
      style: textstyleHeading6(context)!
          .copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
    ),
    actions: [
      notificationactionWidget(
        context,
      ),
    ],
  );
}

AppBar homeappbarnotifav(context, title, modal) {
  return AppBar(
    elevation: 0,
    backgroundColor: colorskyeblue,
    flexibleSpace: Padding(
      padding: EdgeInsets.only(left: deviceWidth(context, 0.2)),
      child: Container(
        color: colorWhite,
      ),
    ),
    leading: homebackbtnappbar(modal, context),
    title: Text(
      title.toUpperCase(),
      style: textstyleHeading6(context)!
          .copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
    ),
    actions: [
      notificationactionWidget(context),
    ],
  );
}
//
// AppBar appbarSearchFavCart(context, title) {
//   return AppBar(
//     elevation: 5,
//     leadingWidth: 30,
//     centerTitle: false,
//     backgroundColor: colorblue,
//     leading: backbtnappbarWhite(),
//     title: Text(
//       title,
//       style: textstyleHeading6(context)!.copyWith(color: colorWhite),
//     ),
//     actions: [
//       appbSearchWidget(),
//       favactionWidget(context),
//       appbCartWidget(context),
//     ],
//   );
// }
//
// AppBar apponlytitle(context, title) {
//   return AppBar(
//     elevation: 5,
//     backgroundColor: colorblue,
//     centerTitle: false,
//     leading: backbtnappbarWhite(),
//     title: Text(
//       title,
//       style: textstyleHeading6(context)!.copyWith(color: colorWhite),
//     ),
//   );
// }
//
// //appbar back black btn, center title
// AppBar appbartitlebackbtnfilter(context, title) {
//   return AppBar(
//     leading: backbtnappbar(),
//     elevation: 4,
//     centerTitle: false,
//     titleSpacing: 0,
//     title: appbartitlewidget(title, context),
//   );
// }
