import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:sbm/common/appbar/appbarmodelpage.dart';
import 'package:sbm/screens/all%20cotegories/categoriesmodelpage.dart';
import 'package:sbm/splash.dart';
import 'common/bottomnavbar/bottomnavbar_modelpage.dart';
import 'common/styles/const.dart';
import 'demo.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => BottomnavbarModelPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => AppbarmodalPage(),
          ),
          ChangeNotifierProvider(
            create: (context) => CategoriModelPage(),
          ),
        ],
        child:
     const MyApp(),
      ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.0);
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
        );
      },
      theme: ThemeData(

        scaffoldBackgroundColor: colorWhite,
        primaryTextTheme: TextTheme(headline2: TextStyle(color: colorblack)),
        textTheme: TextTheme(
          headline1: TextStyle(
              color: colorblack,
              fontSize: fontsizeheading22,
              letterSpacing: 0.5,
              fontWeight: fontWeight900),
          headline2: TextStyle(
            color: colorblack,
            fontSize: fontsizeheading20,
            letterSpacing: 0.5,
            fontWeight: fontWeight500,
          ),
          headline3: TextStyle(
            color: colorblack,
            fontSize: fontsize16,
            letterSpacing: 0.5,
            fontWeight: fontWeight900,
          ),
          headline6: TextStyle(
              color: colorblack,
              fontSize: fontsize16,
              letterSpacing: 0.5,
              fontWeight: fontWeight500),
          headline5: TextStyle(
              color: colorblue,
              fontSize: fontsize15,
              letterSpacing: 0.5,
              fontWeight: fontWeight500),
          subtitle1: TextStyle(
            color: colorblack,
            letterSpacing: 0.5,
            fontWeight: fontWeight600,
            fontSize: fontsize14,
          ),
          subtitle2: TextStyle(
            color: colorgrey,
            letterSpacing: 0.5,
            fontSize: fontsize11,
          ),

        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: colorWhite,
          iconTheme: IconThemeData(color: colorblue, size: 27),
          elevation: 0,
          // textTheme: TextTheme(
          //     bodyText1: TextStyle(color: colorblack, fontSize: 50))
        ),
      ),
      initialRoute: '/',
      routes: {
        //'/': (context) => LoadMoreInfiniteScrollingDemo(),
        '/': (context) => Splash(),
       // '/': (context) => Demo(),
      },
    );
  }
}
