import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../mainsite.dart';

class SideMenu extends StatefulWidget {
  SideMenu({Key? key, required this.onPageSelected}) : super(key: key);
  final Function(PageType t) onPageSelected;

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<SideMenu> {
  void _handlePageSelected(PageType pageType) =>
      widget.onPageSelected.call(pageType);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          child: ListView(
        children: [
          DrawerHeader(child: FlutterLogo()
              // Image.asset("assets/images/logo.png"),
              ),
          DrawerListTile(
            title: "Home",
            press: () => _handlePageSelected(PageType.Home),
          ),
          DrawerListTile(
            title: "About Us",
            press: () => _handlePageSelected(PageType.About),
          ),
          DrawerListTile(
            title: "Partners",
            press: () => _handlePageSelected(PageType.Partners),
          ),
          DrawerListTile(
            title: "Product",
            press: () => _handlePageSelected(PageType.Product),
          ),
          ElevatedButton(
              onPressed: () => Get.changeTheme(
                  Get.isDarkMode ? ThemeData.light() : ThemeData.dark()),
              child: Text('Theme')),

          /// logout
          SizedBox(height: 15),
          ElevatedButton(onPressed: () => {}, child: Text('Login')),
        ],
      )),
    ).constrained(maxWidth: 280);
  }
}

class DrawerListTile extends StatelessWidget {
  DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  String? svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      title: Text(
        title,
      ),
    );
  }
}
