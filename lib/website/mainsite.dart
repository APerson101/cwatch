import 'package:cwatch/app/login/loginView.dart';
import 'package:cwatch/website/MainSiteController.dart';
import 'package:cwatch/website/aboutus/aboutusview.dart';
import 'package:cwatch/website/homepage/homepageview.dart';
import 'package:cwatch/website/partnerspage/partnersview.dart';
import 'package:cwatch/website/productpage/productview.dart';
import 'package:cwatch/website/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'widgets/menubar.dart';

enum PageType { About, Home, Product, Partners, Login }

class MainSite extends StatelessWidget {
  MainSite({Key? key}) : super(key: key);
  MainSiteController _mainSiteController = Get.find();
  Future<void> trySetCurrentPage(PageType newPage) async {
    _mainSiteController.changePage(newPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:
          context.isPhone ? SideMenu(onPageSelected: trySetCurrentPage) : null,
      body: websiteContent(context.isPhone),
    );
  }

  Widget websiteContent(bool phone) {
    return Column(
      children: [
        phone ? Container() : Expanded(flex: 1, child: menubar()),
        Expanded(flex: 13, child: content())
      ],
    );
  }

  Widget menubar() {
    return MenuBar(onPageSelected: trySetCurrentPage);
  }

  Widget content() {
    return ObxValue((Rx<PageType> data) {
      switch (data.value) {
        case PageType.Home:
          return HomePageView();
        case PageType.About:
          return AboutUs();
        case PageType.Product:
          return ProductView();
        case PageType.Partners:
          return PartnersView();
        case PageType.Login:
          return LoginView();
        default:
          return Container(child: Center(child: Text("error")));
      }
    }, _mainSiteController.currentPage);
  }
}
