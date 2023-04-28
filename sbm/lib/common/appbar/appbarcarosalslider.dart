// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:sbm/common/styles/const.dart';


bool favclick = false;
Widget appbarcarosolslider() {
  return Padding(
    padding: EdgeInsets.only(top: 0, left: 15, right: 15),
    child: 
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            height: 33,
            width: 33,
            child: Center(
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.keyboard_backspace_sharp,size: 20,)),
            ),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                 
                      favclick = !favclick;
                  
                  },
                  icon:favclick?Icon(Icons.favorite,color: colorblue,): Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                    color: Colors.white,
                  )),
            ],
          )
        ],
      )
   
  );
}
