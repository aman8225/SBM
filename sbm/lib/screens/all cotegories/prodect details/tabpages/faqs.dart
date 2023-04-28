import 'package:flutter/material.dart';
import 'package:sbm/common/styles/const.dart';
import 'package:sbm/model/prodectdetelsmodel/Data.dart';

class FAQsCardPage extends StatefulWidget {
  final Data discriptiondata;
  const FAQsCardPage({Key? key, required this.discriptiondata})
      : super(key: key);

  @override
  State<FAQsCardPage> createState() => _FAQsCardPageState();
}

class _FAQsCardPageState extends State<FAQsCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.discriptiondata.faqDetails == null
          ? Container()
          : Container(
              //height: deviceheight(context,0.99),
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Most Frequently asked questions:',
                      style: textstyleHeading6(context)!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    sizedboxheight(10.0),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.discriptiondata.faqDetails!.length,
                        itemBuilder: ((itemBuilder, int index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: colorgrey)),
                              child: ExpansionTile(
                                title: Text(widget
                                    .discriptiondata.faqDetails![index].title!),
                                children: <Widget>[
                                  ListTile(
                                      title: Text(widget.discriptiondata
                                          .faqDetails![index].description!)),
                                ],
                              ),
                            ),
                          );
                        })),
                  ],
                ),
              ),
            ),
    );
  }
}
