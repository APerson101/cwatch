import 'package:cwatch/website/productpage/widgets/apiinfo.dart';
import 'package:cwatch/website/productpage/widgets/appInfo.dart';
import 'package:cwatch/website/productpage/widgets/appResonsive.dart';
import 'package:cwatch/website/productpage/widgets/case.dart';
import 'package:cwatch/website/productpage/widgets/storagepower.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/productviewlanding.dart';

class ProductView extends StatelessWidget {
  ProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
            child: Column(
              children: [
                Container(
                    height: Get.height - 49,
                    width: Get.width,
                    child: ProductPageLanding()),
                Container(
                    height: Get.height,
                    width: Get.width,
                    child: StoragePowerView()),
                Container(
                    height: Get.height, width: Get.width, child: CaseView()),
                Container(
                    height: Get.height, width: Get.width, child: AppInfo()),
                Container(
                    height: Get.height,
                    width: Get.width,
                    child: AppResponsiveView()),
                Container(
                    height: Get.height, width: Get.width, child: APIInfo())
              ],
            )),
      ),
    );
  }
}
