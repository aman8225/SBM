import 'package:flutter/material.dart';
import 'package:sbm/model/homemodel/BottomOffer.dart';
import 'package:sbm/model/homemodel/Brands.dart';
import 'package:sbm/model/homemodel/CatProductsList.dart';
import 'package:sbm/model/homemodel/CatProductsList1.dart';
import 'package:sbm/model/homemodel/Categories.dart';
import 'package:sbm/model/homemodel/Sliders.dart';
import 'package:sbm/model/homemodel/TopOffer.dart';
import 'package:sbm/model/homemodel/TopsaleProducts.dart';

class Data {
  List<Sliders>? slider;
  List<Categories>? categories;
  List<CatProductsList>? catProductsList;
  List<CatProductsList1>? catProductsList1;
  List<Brands>? brands;
  List<TopsaleProducts>? topsaleProducts;

  Data(
      {this.slider,
        this.categories,
        this.catProductsList,
        this.catProductsList1,
        this.brands,
        this.topsaleProducts});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['slider'] != null) {
      slider = <Sliders>[];
      json['slider'].forEach((v) {
        slider!.add(new Sliders.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    if (json['catProductsList'] != null) {
      catProductsList = <CatProductsList>[];
      json['catProductsList'].forEach((v) {
        catProductsList!.add(new CatProductsList.fromJson(v));
      });
    }
    if (json['catProductsList1'] != null) {
      catProductsList1 = <CatProductsList1>[];
      json['catProductsList1'].forEach((v) {
        catProductsList1!.add(new CatProductsList1.fromJson(v));
      });
    }
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(new Brands.fromJson(v));
      });
    }
    if (json['topsaleProducts'] != null) {
      topsaleProducts = <TopsaleProducts>[];
      json['topsaleProducts'].forEach((v) {
        topsaleProducts!.add(new TopsaleProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.slider != null) {
      data['slider'] = this.slider!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.catProductsList != null) {
      data['catProductsList'] =
          this.catProductsList!.map((v) => v.toJson()).toList();
    }
    if (this.catProductsList1 != null) {
      data['catProductsList1'] =
          this.catProductsList1!.map((v) => v.toJson()).toList();
    }
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    if (this.topsaleProducts != null) {
      data['topsaleProducts'] =
          this.topsaleProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}