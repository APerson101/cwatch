import 'package:cwatch/website/aboutus/widgets/ousolution.dart';
import 'package:cwatch/website/aboutus/widgets/problem.dart';
import 'package:cwatch/website/aboutus/widgets/whoarewe.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),

                // slivers: [
                //   SliverFillRemaining(
                //       hasScrollBody: false,
                child: Column(children: _getChildren()))
            // ],
            // ),
            ));
  }

  _getChildren() {
    return [
      Container(height: Get.height - 49, width: Get.width, child: WhoAreWe()),
      Container(height: Get.height, width: Get.width, child: ProblemWeSaw()),
      Container(height: Get.height, width: Get.width, child: OurSolution())
    ];
  }
}
