import 'package:cwatch/app/authenticationController.dart';
import 'package:cwatch/website/MainSiteController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../mainsite.dart';

class MenuBar extends StatefulWidget {
  MenuBar({Key? key, required this.onPageSelected}) : super(key: key);
  final Function(PageType t) onPageSelected;

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  AuthenticationController _auth = Get.find();
  MainSiteController _mainSiteController = Get.find();
  void _handlePageSelected(PageType pageType) =>
      widget.onPageSelected.call(pageType);
  @override
  Widget build(BuildContext context) {
    String buttonText = _auth.loggedInUser.value == null ? "Log In" : "Console";
    return Container(
      child: Row(
        children: [
          FlutterLogo(size: 30).paddingOnly(left: 40, right: 40),
          Expanded(child: Container()),
          TextButton(
                  onPressed: () => _handlePageSelected(PageType.Home),
                  child: Text('Home'))
              .paddingOnly(left: 25, right: 25),
          TextButton(
                  onPressed: () => _handlePageSelected(PageType.About),
                  child: Text('About Us'))
              .paddingOnly(left: 25, right: 25),
          TextButton(
                  onPressed: () => _handlePageSelected(PageType.Product),
                  child: Text('Product'))
              .paddingOnly(left: 25, right: 25),
          ElevatedButton(
                  onPressed: () => _handlePageSelected(PageType.Login),
                  child: Text(buttonText))
              .paddingOnly(left: 35, right: 40)
        ],
      ),
    );
  }
}
