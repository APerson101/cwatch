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
          DrawerHeader(child: FlutterLogo()
              // Image.asset("assets/images/logo.png"),
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
            title: "Notifications",
            press: () => _handlePageSelected(AppPages.Notifications),
          ),
          DrawerListTile(
            title: "Settings",
            press: () => _handlePageSelected(AppPages.Settings),
          ),
          // DrawerListTile(
          //   title: "Profile",
          //   press: () => _handlePageSelected(AppPages.Profile),
          // ),
          DrawerListTile(
            title: "About",
            press: () => _handlePageSelected(AppPages.About),
          ),
          ElevatedButton(
              onPressed: () => Get.changeTheme(
                  Get.isDarkMode ? ThemeData.light() : ThemeData.dark()),
              child: Text('Theme')),

          /// logout
          SizedBox(height: 15),
          ElevatedButton(
              onPressed: () {
                appController.logOut();
              },
              child: Text('Logout')),
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
