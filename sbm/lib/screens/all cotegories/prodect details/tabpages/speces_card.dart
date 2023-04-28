import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/prodectdetelsmodel/Data.dart';

class SpecesCardPage extends StatelessWidget {
  final Data discriptiondata;
  const SpecesCardPage({Key? key, required this.discriptiondata})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              discriptiondata.specification == null
                  ? Container()
                  : const Text(
                      'Product Specification:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
              // discriptiondata.features==null?Container():  sizedboxheight(8.0),
              discriptiondata.specification == null
                  ? Container()
                  : Html(
                      data: """
                ${discriptiondata.specification == null ? '' : discriptiondata.specification!}
                """,
                    ),
              sizedboxheight(10.0),
            ],
          ),
        ),
      ),
    );
  }
}
