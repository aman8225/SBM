import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sbm/common/appbar/appbarpage.dart';
import 'package:sbm/common/styles/const.dart';

class ImageScreen extends StatefulWidget {
  List<String>? sliderimage ;
   ImageScreen(this.sliderimage);
  @override
  _MyImageScreen createState() => _MyImageScreen( sliderimage!);
}

class _MyImageScreen extends State<ImageScreen> {
  List<String>? sliderimage;
  _MyImageScreen(this.sliderimage);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbarbackbtnonly(context),
        body: PhotoViewGallery.builder(
          itemCount: sliderimage!.length,
          backgroundDecoration: BoxDecoration(
              color: colorWhite
          ),
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(
                sliderimage![index],
              ),

            );
          },
          scrollPhysics: BouncingScrollPhysics(),

        ));
    // body: Image.network(url, width: double.infinity));
  }
}
