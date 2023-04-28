import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/prodectdetelsmodel/Data.dart';

class DescriptionCardPage extends StatelessWidget {
  final Data discriptiondata;
  const DescriptionCardPage({Key? key, required this.discriptiondata})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: deviceheight(context, 1.0),
        width: deviceWidth(context, 1.0),
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              discriptiondata.productIcons!.length == 0
                  ? Container()
                  : Container(
                      height: 120,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: discriptiondata.productIcons!.length,
                          itemBuilder: ((itemBuilder, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  discriptiondata.productIcons![index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          })),
                    ),

              sizedboxheight(8.0),
              RichText(
                text: TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text:  'Product Name: ',
                      style: TextStyle(fontWeight: FontWeight.bold ,color: colorblack),
                    ),
                    TextSpan(
                      text: discriptiondata.productName == null
                          ? ''
                          : discriptiondata.productName!.trim(),
                      style: TextStyle( fontSize: 12,color: colorblack),
                    )
                  ],
                ),
              ),


              sizedboxheight(8.0),
              Row(
                children: [
                  Text(
                    'SKU: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    discriptiondata.sku == null
                        ? ''
                        : discriptiondata.sku!.trim(),
                    style: textnormail(context)!.copyWith(fontSize: 14),
                  ),
                ],
              ),
              sizedboxheight(8.0),
              discriptiondata.description == null
                  ? Container()
                  : Text(
                      'Product Description:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
              //discriptiondata.description==null?Container():  sizedboxheight(8.0),
              discriptiondata.description == null
                  ? Container()
                  :  Html(
                      data:
                "${discriptiondata.description == null ? '' : discriptiondata.description!.trim()}"
                ,
                      style: {
                        "body": Style(
                          fontSize: FontSize(14.0),
                          fontWeight: FontWeight.normal,
                        ),
                      },
                    ),
              // Text(deccriptiondata.description==null?'':deccriptiondata.description!,style: textnormail(context),),
              sizedboxheight(8.0),
              discriptiondata.features == null
                  ? Container()
                  : Text(
                      'Features',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
              // discriptiondata.features==null?Container():  sizedboxheight(8.0),
              discriptiondata.features == null
                  ? Container()
                  : Html(
                      data: """
                ${discriptiondata.features == null ? '' : discriptiondata.features!}
                """,
                      style: {
                        "body": Style(
                          fontSize: FontSize(14.0),
                          fontWeight: FontWeight.normal,
                        ),
                      },
                    ),
              // Text(deccriptiondata.features==null?'':deccriptiondata.features!,style: textstylesubtitle1(context),),
              //  sizedboxheight(8.0),
              //  deccriptiondata.packagingDeliveryDescr==null?Container(): Text('Widely Used Industries:',style: textstyleHeading6(context),),
              //  deccriptiondata.packagingDeliveryDescr==null?Container():  sizedboxheight(8.0),
              //  deccriptiondata.packagingDeliveryDescr==null?Container(): Html(
              //    data: """
              //    ${deccriptiondata.packagingDeliveryDescr==null?'':deccriptiondata.packagingDeliveryDescr!}
              //    """,
              //  ),
              sizedboxheight(8.0),
              discriptiondata.packagingDeliveryDescr == null
                  ? Container()
                  : Text(
                      'Packaging & Delivery',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
              // discriptiondata.packagingDeliveryDescr==null?Container():  sizedboxheight(8.0),
              discriptiondata.packagingDeliveryDescr == null
                  ? Container()
                  : Html(
                      data: """
                ${discriptiondata.packagingDeliveryDescr == null ? '' : discriptiondata.packagingDeliveryDescr!}
                """,
                    ),
              //Text(deccriptiondata.packagingDeliveryDescr==null?'':deccriptiondata.packagingDeliveryDescr!,style: textstylesubtitle1(context),),
              sizedboxheight(10.0),
            ],
          ),
        ),
      ),
    );
  }
}
