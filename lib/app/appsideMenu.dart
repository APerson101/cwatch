import 'package:cwatch/app/appcontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

enum AppPages {
  Dashboard,
  History,
  Profile,
  Notifications,
  Visualizer,
  Settings,
  API,
  About
}

class AppSideMenu extends StatefulWidget {
  AppSideMenu({Key? key, required this.onPageSelected}) : super(key: key);
  final Function(AppPages t) onPageSelected;

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<AppSideMenu> {
  void _handlePageSelected(AppPages pageType) =>
      widget.onPageSelected.call(pageType);
  AppController appController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("images/climate-change.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            press: () => _handlePageSelected(AppPages.Dashboard),
          ),
          DrawerListTile(
            title: "Visualizer",
            press: () => _handlePageSelected(AppPages.Visualizer),
          ),
          DrawerListTile(
            title: "History",
            press: () => _handlePageSelected(AppPages.History),
          ),

          DrawerListTile(
            title: "About",
            press: () => _handlePageSelected(AppPages.About),
          ),
          SizedBox(height: 100),
          ElevatedButton(
              onPressed: () {
                Get.changeThemeMode(
                    Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                print("changing theme");
              },
              child: Text('Change Theme'))

          /// logout
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
