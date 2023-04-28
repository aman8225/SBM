// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/commonwidgets/button.dart';
import 'package:sbm/common/styles/const.dart';

import 'categoriesmodelpage.dart';
import 'categoriwidgetpage.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  @override
  void initState() {
    super.initState();
    setState(() {
      var list = Provider.of<CategoriModelPage>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await list.categoriesdata(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriModelPage>(builder: (context, model, _) {
      return Scaffold(
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
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      filterbtnscolumn(context, model),
                      filterValuecolumn(context, model),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ));
    });
  }
}
