import 'package:cwatch/website/MainSiteController.dart';
import 'package:cwatch/website/mainsite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductLanding extends StatelessWidget {
  ProductLanding({Key? key}) : super(key: key);
  final MainSiteController siteController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: context.isPhone
          ? Column(children: getChildren())
          : Row(children: getChildren()),
    );
  }

  List<Expanded> getChildren() {
    return [
      Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Bridging the gap between Africa and the rest of the world in Air quality research."),
              Text(
                  "Soft Air is a platform that provides air quality data in  sub-Saharan African countries and derive insights from the data by using state of the art machine learning algorithms.Our devices are currently available in Nigeria, Ghana and Ivory Coast with more countries to be added."),
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      siteController.changePage(PageType.Login);
                    },
                    child: Text('Sign In'),
                  ),
                  ElevatedButton(
                    onPressed: () => siteController.changePage(PageType.About),
                    child: Text('Learn more'),
                  ),
                ],
              )
            ],
          )),
      Expanded(
          flex: 2, child: Container(child: FlutterLogo(size: double.maxFinite)))
    ];
  }
}
