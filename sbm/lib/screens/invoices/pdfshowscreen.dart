import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:internet_file/internet_file.dart';
import 'package:universal_platform/universal_platform.dart';
import '../../common/appbar/appbarwidgetpage.dart';
import '../../common/styles/const.dart';

class viewscreen extends StatefulWidget {
  var link;
   viewscreen({Key? key,  this.link}) : super(key: key);

  @override
  State<viewscreen> createState() => _viewscreenState();
}
enum DocShown { sample, tutorial, hello, password }
class _viewscreenState extends State<viewscreen> {

  DocShown _showing = DocShown.sample;

  static const int _initialPage = 1;
  late PdfControllerPinch _pdfControllerPinch;

  @override
  void initState() {
    _pdfControllerPinch = PdfControllerPinch(
      document: PdfDocument.openData(
        InternetFile.get(
          widget.link.toString(),
        ),
      ),
      initialPage: _initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfControllerPinch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: colorskyeblue,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(left: deviceWidth(context, 0.2)),
          child: Container(
            color: colorWhite,
          ),
        ),

        leading: backbtnappbar(context),
        actions: <Widget>[
          IconButton(
            icon:  Icon(Icons.navigate_before,color: colorblack54,),
            onPressed: () {
              _pdfControllerPinch.previousPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          PdfPageNumber(
            controller: _pdfControllerPinch,
            builder: (_, loadingState, page, pagesCount) => Container(
              alignment: Alignment.center,
              child: Text(
                '$page/${pagesCount ?? 0}',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          IconButton(
            icon:  Icon(Icons.navigate_next, color: colorblack54) ,
            onPressed: () {
              _pdfControllerPinch.nextPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),

        ],
      ),
body: PdfViewPinch(
  builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
    options: const DefaultBuilderOptions(),
    documentLoaderBuilder: (_) =>
    const Center(child: CircularProgressIndicator()),
    pageLoaderBuilder: (_) =>
    const Center(child: CircularProgressIndicator()),
    errorBuilder: (_, error) => Center(child: Text(error.toString())),
  ),
  controller: _pdfControllerPinch,
),
    );
  }
}



