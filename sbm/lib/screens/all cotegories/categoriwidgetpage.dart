// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/screens/all%20cotegories/prodect%20list/prodect_list.dart';
import 'package:sbm/screens/auth/forgetpassword.dart';

Widget filterbtnscolumn(context, model) {
  return Container(
    width: deviceWidth(context, 0.3),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
             // reverse: true,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: model.filterkeybtnname.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [colorskyeblue, colorWhite]),
                        color: model.showFilterValues == index ? colorskyeblue : colorWhite,
                      ),
                  padding: EdgeInsets.only(left: 5),
                  child: InkWell(
                      onTap: () async {
                        await model.filterbtnkeyTap(index);
                      },
                      child: Card(
                        elevation: 1,
                        child: Container(
                          height: 90,
                          width: 90,
                          color: model.showFilterValues == index ? colorskyeblue : colorWhite,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Image.asset(model.filterkeybtnimage[index],scale: 6.5,),
                              // Image.asset('assets/icons/icon-1@3x.png',scale: 6.5,),
                              Image.network(
                                model.filterkeybtnname[index].logo,
                                height: 40,
                              ),
                              sizedboxheight(3.0),
                              Text(
                                model.filterkeybtnname[index].categoryName,
                                style: textstylesubtitle1(context)!.copyWith(
                                    fontSize: 10,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      )
                      // Container(
                      //     height: 48,
                      //     padding: EdgeInsets.only(left: 10),
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Text(
                      //           model.filterkeybtnname[index],
                      //           maxLines: 2,
                      //           overflow: TextOverflow.ellipsis,
                      //           style: textstylesubtitle1(context)!.copyWith(fontWeight: fontWeight600),
                      //         ),
                      //       ],
                      //     ))
                      ),
                );
              }),
        ],
      ),
    ),
  );
}

//right side column ----- checkbox

Widget filterValuecolumn(context, model) {
  return Expanded(
    child: Container(
      color: colorWhite,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: deviceWidth(context, 0.65),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: deviceWidth(context, 0.5),
                      child: InkWell(
                        onTap: () {
                          print(model.filterkeybtnname[model.showFilterValues].categoryName.toString());
                          print(model.filterkeybtnname[model.showFilterValues].slug.toString());
                          print(model.filterkeybtnname[model.showFilterValues].id);
                          Get.to(() => ProdectListPage(
                              title:  model.filterkeybtnname[model.showFilterValues].categoryName.toString(),
                              slug:  model.filterkeybtnname[model.showFilterValues].slug.toString(),
                              id:  model.filterkeybtnname[model.showFilterValues].id));
                        },
                        child: Text(
                          model.filterkeybtnname[model.showFilterValues].categoryName.toUpperCase().toString(),
                          style: textstylesubtitle1(context)!.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(2, 2),
                                    blurRadius: 2),
                              ]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () {
                        print(model.filterkeybtnname[model.showFilterValues].categoryName.toString());
                        print(model.filterkeybtnname[model.showFilterValues].slug.toString());
                        print(model.filterkeybtnname[model.showFilterValues].id);
                        Get.to(() => ProdectListPage(
                            title:  model.filterkeybtnname[model.showFilterValues].categoryName.toString(),
                            slug:  model.filterkeybtnname[model.showFilterValues].slug.toString(),
                            id:  model.filterkeybtnname[model.showFilterValues].id));
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: colorblue,
                        size: 20,
                      ),
                    ),
                    // child: Image.asset('assets/icons/smartphone (4).png',scale: 8,color: colorblue,),
                  ),
                  // Image.asset('assets/icons/smartphone (4).png',scale: 9,color: colorblue,),
                ],
              ),
            ),
            if (model.showFilterValues == model.showFilterValues) ...[
              checkboxFilterPrice(
                context,
                model,
                model.filterkeybtnname[model.showFilterValues].childCat,
              ),
            ]
          ],
        ),
      ),
    ),
  );
}
bool b = false;
Widget checkboxFilterPrice(context, model, valueList) {
  return ListView.builder(
      itemCount: valueList.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Card(
            child: Container(
              // color: Colors.redAccent,
              width: deviceWidth(context, 0.65),
              child:
                  ExpansionTile(
                  trailing:valueList[index].subchildcat.length==0? SizedBox():Icon(Icons.keyboard_arrow_down,color: colorblack,size: 20,),
                  iconColor: colorblack,
                  collapsedIconColor: colorblack,
                  title: InkWell(
                    onTap: (){
                      Get.to(() => ProdectListPage(
                          title: valueList[index].categoryName.toString(),
                          slug: valueList[index].slug.toString(),
                          id: valueList[index].id,
                         ));
                    },
                    child: Text(
                    valueList[index].categoryName,
                    style: textstylesubtitle1(context)!.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                ),
                  ),
                children: <Widget>[
                  Container(
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: valueList[index].subchildcat.length,
                        itemBuilder: ((context, ind) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => ProdectListPage(
                                  title: valueList[index].categoryName,
                                  slug:
                                      valueList[index].subchildcat[ind].slug,
                                  id: valueList[index].subchildcat[ind].id,
                                  hide: 1));
                              //Get.to(() => ProdectListPage(title:categories[index].categoryName,slug:categories[index].slug,id:categories[index].id));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: colorgrey, width: 0.8)),
                                height: 45,
                                width: deviceWidth(context, 0.6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: deviceWidth(context, 0.5),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, top: 5),
                                          child: Text(
                                            " ${valueList[index].subchildcat[ind].categoryName}",
                                            style:
                                                textstylesubtitle1(context)!
                                                    .copyWith(fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        )),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: colorblue,
                                        size: 20,
                                      ),
                                      // child: Image.asset('assets/icons/smartphone (4).png',scale: 9,color: colorblue,),
                                    ),
                                    // Image.asset('assets/icons/smartphone (4).png',scale: 9,color: colorblue,),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
                  )
                  // ListTile(title: Text(valueList[index].categoryName,style: textstylesubtitle1(context)!.copyWith(fontSize: 12),
                  //           overflow: TextOverflow.ellipsis,maxLines: 1,)),
                ],
              ),
            ),
          ),
        );

        //   Row(
        //   children: [
        //
        //     SizedBox(
        //       child: Text(
        //        valueList[index].title,
        //         overflow: TextOverflow.ellipsis,
        //         maxLines: 2,
        //         style: textstylesubtitle1(context),
        //       ),
        //     ),
        //   ],
        // );
      });
}
