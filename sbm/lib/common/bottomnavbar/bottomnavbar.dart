import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:provider/provider.dart';
import 'package:sbm/screens/news%20uplodes/newsuplodes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sbm/common/appbar/appbarmodelpage.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/appbar/appbarwidgetpage.dart';
import 'package:sbm/common/commonwidgets/commonwidgets.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/screens/about%20as/about_us.dart';
import 'package:sbm/screens/all%20cotegories/categoriesmodelpage.dart';
import 'package:sbm/screens/all%20cotegories/my%20cart/my_card_page.dart';
import 'package:sbm/screens/auth/loginscreen.dart';
import 'package:sbm/screens/auth/signupscreen.dart';
import 'package:sbm/screens/brands/barand.dart';
import 'package:sbm/screens/contact%20us/contact_us.dart';
import 'package:sbm/screens/my%20items/myitems.dart';
import 'bottomnavbar_modelpage.dart';
import 'bottomnavbarwidget.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     importance: Importance.high,
//     playSound: true);

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('A bg message just showed up :  ${message.messageId}');
// }

class BottomNavBarPage extends StatefulWidget {
  BottomNavBarPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  String? username, useremail ,profilepic;
  void seyarprifrensdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('login_user_name');
      username = username!.replaceAll('"', '');
      useremail = prefs.getString('login_user_email');
      useremail = useremail!.replaceAll('"', '');
      // profilepic = prefs.getString('login_user_profilepic');
      // profilepic = profilepic!.replaceAll('"', '');
    });
  }

  @override
  void initState() {
    setState(() {
      var list = Provider.of<BottomnavbarModelPage>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await list.aboutusdata(context);
      });
    });
    setState(() {
      var list = Provider.of<BottomnavbarModelPage>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await list.productdetacardlistdata(context);
      });
    });
    setState(() {
      var list = Provider.of<CategoriModelPage>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await list.categoriesdata(context);
      });
    });

    super.initState();
    seyarprifrensdata();
  }

  // void initState() {
  //   super.initState();

  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if (notification != null && android != null) {
  //       print('demo1');
  //       flutterLocalNotificationsPlugin.show(
  //           notification.hashCode,
  //           notification.title,
  //           notification.body,
  //           NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               channel.id,
  //               channel.name,
  //               color: Colors.blue,
  //               playSound: true,
  //               icon: '@drawable/ic_launcher',
  //             ),
  //           ));
  //     }
  //   });
  //   FirebaseMessaging.instance
  //       .getInitialMessage()
  //       .then((RemoteMessage? message) {
  //     print('demo2');
  //     if (message != null) {
  //       showNotification();
  //     }
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('A new onMessageOpenedApp event was published!');
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if (notification != null && android != null) {
  //       print('demo3');
  //       showNotification();
  //     }
  //   });

  //   // name1();
  //   FirebaseMessaging.instance.getToken().then((value) {
  //     // ignore: unused_local_variable
  //     var tokan = value;
  //   });
  // }

  // void showNotification() {
  //   print('notification');
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => NotificationPage(),
  //     ),
  //   );
  // }

  Future<bool> backdb(model) async {
    if (model.bottombarzindex != 2) {
      model.togglebottomindexreset();
    }
    return false;
  }

  String? appbartitem;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Consumer<BottomnavbarModelPage>(builder: (context, model, _) {
      switch (model.bottombarzindex) {
        case 0:
          {
            appbartitem = 'My Account';
          }
          break;
        case 1:
          {
            appbartitem = 'All Categories';
          }
          break;
        case 3:
          {
            appbartitem = 'My Orders';
          }
          break;
        case 4:
          {
            appbartitem = 'My Items';
           // appbartitem = 'Notification';
            // appbartitem = 'Bulk Order';
          }
          break;
        default:
          {
            appbartitem = '';
          }
          break;
      }
      return WillPopScope(
        onWillPop: () {
          return model.bottombarzindex == 2
              ? onWillPop(context)
              : backdb(model);
        },
        child: Scaffold(
          key: _scaffoldKey,
          drawer: drower(model),
          appBar: model.bottombarzindex != 2
              ? homeappbarnotifav(context, appbartitem, model)
              : AppBar(
                  backgroundColor: colorskyeblue,
                  flexibleSpace: Padding(
                    padding: EdgeInsets.only(left: deviceWidth(context, 0.2)),
                    child: Container(
                      color: colorWhite,
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InkWell(
                      onTap: () => _scaffoldKey.currentState!.openDrawer(),
                      child: profilepic==null?CircleAvatar(
                        backgroundColor: colorgrey,

                         backgroundImage: const AssetImage('assets/profile_image.png'),
                      ): CircleAvatar(
                        backgroundColor: colorgrey,
                        backgroundImage:  NetworkImage(profilepic.toString()),
                       // backgroundImage: const AssetImage('assets/profile_image.png'),
                      ),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: deviceWidth(context, 0.25),
                          child: username == null
                              ? Text(
                                  'Hello,User'.toUpperCase(),
                                  style: textstylesubtitle1(context),
                                )
                              : Text(
                                  'Hello ${username}'.toUpperCase(),
                                  style: textstylesubtitle1(context)!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                )),
                      Image.asset(
                        'assets/sbm_icon.png',
                        scale: 28,
                      ),

                      // Image.asset('assets/icons/applogo.png',width: deviceWidth(context,0.25),),
                    ],
                  ),
                  actions: [notificationactionWidget(context)],
                ),
          floatingActionButton:  FloatingActionButton(
            onPressed: () {
              model.togglebottomindexreset();
              // Get.to(Home());
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
          body: model.bottombarScreens[model.bottombarzindex],
          bottomNavigationBar: bottomNavBarPagewidget(context, model),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      );
    });
  }

  Widget drower(model) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            width: deviceWidth(context, 0.2),
            height: deviceheight(context, 1.0),
            color: colorskyeblue,
          ),
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: deviceheight(context, 0.2),
                    child: DrawerHeader(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         profilepic==null? CircleAvatar(
                      radius: 25,
                        backgroundColor: colorgrey,
                      //  backgroundImage:  NetworkImage(profilepic.toString()),
                         backgroundImage:  AssetImage('assets/profile_image.png'),
                      ):CircleAvatar(
                            radius: 25,
                            backgroundColor: colorgrey,
                            backgroundImage:  NetworkImage(profilepic.toString()),
                           // backgroundImage:  AssetImage('assets/profile_image.png'),
                          ),
                          sizedboxwidth(10.0),
                          Container(
                            width: deviceWidth(context, 0.4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username??"",
                                  style: textstylesubtitle1(context)!
                                      .copyWith(color: colorblue),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  "useremail!",
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Card(
                      elevation: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        )),
                        //height: deviceheight(context,0.6),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            ListTile(
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: colorblack,
                              ),
                              leading: SvgPicture.asset(
                                'assets/slicing 2/home (10).svg',
                                color: colorblue,
                                width: 20,
                                height: 20,
                              ),
                              title: const Text("Home"),
                              onTap: () {
                                Navigator.of(context).pop();
                                //  Get.to(() => BottomNavBarPage());
                              },
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            ListTile(
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: colorblack,
                              ),
                              leading: SvgPicture.asset(
                                'assets/slicing 2/book (8).svg',
                                color: colorblue,
                                width: 20,
                                height: 20,
                              ),
                              title: const Text("About Us"),
                              onTap: () {
                                Navigator.of(context).pop();
                                Get.to(() => About_Us(
                                    aboutusdata: model.aboutusdatalist));
                              },
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            ListTile(
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: colorblack,
                              ),
                              leading: SvgPicture.asset(
                                'assets/slicing 2/shopping-bag.svg',
                                color: colorblue,
                                width: 20,
                                height: 20,
                              ),
                              title: const Text("All Categories"),
                              onTap: () {
                                Navigator.of(context).pop();

                                model.categoriespage();
                              },
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            ListTile(
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: colorblack,
                              ),
                              leading: SvgPicture.asset(
                                'assets/slicing 2/users (3).svg',
                                color: colorblue,
                                width: 20,
                                height: 20,
                              ),
                              title: const Text("All Brands"),
                              onTap: () {
                                Navigator.of(context).pop();
                                Get.to(() => Brand());
                              },
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            ListTile(
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: colorblack,
                              ),
                              leading: SvgPicture.asset(
                                'assets/slicing 2/users (3).svg',
                                color: colorblue,
                                width: 20,
                                height: 20,
                              ),
                              title: const Text("My Account"),
                              onTap: () {
                                Navigator.of(context).pop();
                                model.accountpage();
                              },
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            ListTile(
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: colorblack,
                              ),
                              leading: SvgPicture.asset(
                                'assets/slicing 2/file-text-1_blue.svg',
                                color: colorblue,
                                width: 20,
                                height: 20,
                              ),
                              title: const Text("News & Updates"),
                              onTap: () {
                                Navigator.of(context).pop();
                                Get.to(() => NewsUplodes());
                              },
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            ListTile(
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: colorblack,
                              ),
                              leading: SvgPicture.asset(
                                'assets/slicing 2/mail_blue.svg',
                                color: colorblue,
                                width: 15,
                                height: 15,
                              ),
                              title: const Text("Contact Us"),
                              onTap: () {
                                Navigator.of(context).pop();
                                Get.to(() => ContactUs());
                              },
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            ListTile(
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: colorblack,
                              ),
                              leading: SvgPicture.asset(
                                'assets/slicing 2/exit.svg',
                                color: colorblue,
                                width: 20,
                                height: 20,
                              ),
                              title: Text("Logout"),
                              onTap: () async {
                                Navigator.of(context).pop();
                                Get.off(() => LoginScreen());
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setBool("isLoggedIn", false);
                                prefs.remove("login_user_token");
                                prefs.remove("login_user_name");
                                prefs.remove("login_user_email");
                                prefs.remove("cart_item_length");
                              },
                            ),
                          ]),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
