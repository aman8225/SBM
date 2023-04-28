import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/screens/BulkOrder/bulkorder.dart';
import 'package:sbm/screens/change%20password/changepassword.dart';
import 'package:sbm/screens/invoices/invoices.dart';
import 'package:sbm/screens/my%20address/my_address.dart';
import 'package:sbm/screens/my%20items/myitems.dart';
import 'package:sbm/screens/my%20order/myorder.dart';
import 'package:sbm/screens/my%20rfq/myfrq_page.dart';

import 'package:sbm/screens/profile_update/profile_update.dart';
import 'package:sbm/screens/profile_update/view_profile/view_profile.dart';
import 'package:sbm/screens/videoscreen/videos_screen.dart';
import 'package:sbm/screens/wishlist/wishlist.dart';

import '../notification/notification.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appbarnotifav(context, 'My Account'),
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        child: Column(
                          children: [
                            sizedboxheight(10.0),
                            Carditam('assets/slicing 2/profile update.svg',
                                'Profile Update', ProfileDetails()),
                            const Divider(
                              thickness: 1,
                            ),
                            Carditam(
                                'assets/image.png', 'Invoices', Invoices()),
                            const Divider(
                              thickness: 1,
                            ),
                            // Carditam('assets/slicing 2/my order.svg',
                            //     'My Orders', MyOrder()),
                            // Divider(
                            //   thickness: 1,
                            // ),
                            // Carditam('assets/slicing 2/my item.svg', 'My Items',
                            //     MyItems()),
                            // Divider(
                            //   thickness: 1,
                            // ),
                            Carditam('assets/slicing 2/my RFQ.svg', 'My RFQ',
                                MyRFQ_Page()),
                            Divider(
                              thickness: 1,
                            ),
                            Carditam('assets/slicing 2/whishlist.svg',
                                'Whishlist', Wishlist()),
                            Divider(
                              thickness: 1,
                            ),
                            Carditam('assets/slicing 2/address.svg', 'Address',
                                MyAddress()),
                            Divider(
                              thickness: 1,
                            ),
                            Carditam('assets/slicing 2/pasword.svg', 'Password',
                                ChangePassword()),
                            Divider(
                              thickness: 1,
                            ),
                            Carditam('assets/image.png', 'Download Video',
                                VideosScreen()),
                            Divider(
                              thickness: 1,
                            ),
                            Carditam('assets/slicing 2/my item.svg',
                                'Bulk Order', BulkOrder()),
                            Divider(
                              thickness: 1,
                            ),
                            Carditam('assets/slicing 2/notifications (1).svg',
                                'Notification', Notification_screen()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Carditam(icon, titel, navigationpage) {
    return ListTile(
      leading: titel == 'Invoices' || titel == 'Download Video'
          ? Image.asset(
              icon,
              color: colorblue,
              scale: 1.2,
            )
          : SvgPicture.asset(
              icon,
              color: colorblue,
              width: 20,
              height: 20,
            ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 12,
      ),
      title: Text(titel),
      onTap: () async {
        Get.to(navigationpage);
      },
    );
  }
}
