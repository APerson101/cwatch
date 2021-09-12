import 'package:cwatch/apithings/APIHandler.dart';
import 'package:cwatch/app/Visualizer/visualizer.dart';
import 'package:cwatch/app/about/aboutView.dart';
import 'package:cwatch/app/apikey/apikey.dart';
import 'package:cwatch/app/appcontroller.dart';
import 'package:cwatch/app/history/historyview.dart';
import 'package:cwatch/app/notifications/notificationsView.dart';
import 'package:cwatch/app/settings/settingsView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

import 'Profile/profileView.dart';
import 'appsideMenu.dart';
import 'config.dart';
import 'dashboard/dashboardView.dart';
import 'responsive.dart';

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);
  AppController _appController = Get.find();
  Future<void> trySetCurrentPage(AppPages newPage) async {
    _appController.changePage(newPage);
  }

  List<AppPages> mobilePages = [
    AppPages.Dashboard,
    AppPages.Visualizer,
    AppPages.History,
  ];

  @override
  Widget build(BuildContext context) {
    bool showDrawerMenu = Responsive.isTablet(context);

    double leftMenuWidth = !showDrawerMenu ? 0 : Sizes.sideBarSm;
    if (context.widthPx >= Responsive.desktopSize) {
      leftMenuWidth = Sizes.sideBarLg;
    } else if (context.widthPx >= 850 && context.widthPx < 1100) {
      leftMenuWidth = Sizes.sideBarMed;
    }
    double leftContentOffset = !showDrawerMenu ? leftMenuWidth : Insets.mGutter;
    Widget sideMenu = AppSideMenu(
      onPageSelected: trySetCurrentPage,
    )
        .animatedPanelX(
          closeX: -leftMenuWidth,
          // Rely on the animatedPanel to toggle visibility of this when it's hidden. It renders an empty Container() when closed
          isClosed: showDrawerMenu,
        ) // Styling, pin to left, fixed width
        .positioned(
            left: 0, top: 0, width: leftMenuWidth, bottom: 0, animate: false);
    return Scaffold(
      appBar: Responsive.isTablet(context)
          ? AppBar(title: Center(child: Text("CWatch")))
          : null,
      drawer: Responsive.isTablet(context)
          ? AppSideMenu(onPageSelected: trySetCurrentPage)
          : null,
      body: ObxValue(
              (Rx<AppPages> page) =>
                  getContent(sideMenu, page, leftContentOffset),
              _appController.currentPage)
          .paddingAll(12),
      bottomNavigationBar: Responsive.isMobile(context) ? appBottomNav() : null,
    );
  }

  Widget getContent(Widget sideMenu, Object? page, double leftContentOffset) {
    return Stack(children: [
      Stack(children: [sideMenu]),
      getCurrentView(page, leftContentOffset)
    ]);
  }

  APIHandler _handler = APIHandler();
  getCurrentView(page, double leftContentOffset) {
    Widget view;
    switch (page.value) {
      case AppPages.Dashboard:
        view = DashboardView();
        break;
      case AppPages.History:
        view = HistoryView();
        break;
      case AppPages.Settings:
        view = SettingsView();
        break;
      case AppPages.Visualizer:
        view = VisualizerView();
        break;

      case AppPages.About:
        view = AboutView();
        break;
      default:
        view = CircularProgressIndicator();
    }

    return view.positioned(
        left: leftContentOffset, right: 0, bottom: 0, top: 0, animate: false);
  }

  Widget appBottomNav() {
    return ObxValue(
        (Rx<AppPages> data) => BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard), label: 'Dashboard'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.auto_graph), label: 'Visualizer'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.history), label: 'History')
              ],
              currentIndex: mobilePages.indexOf(data.value),
              selectedItemColor: Colors.amber,
              onTap: (index) => trySetCurrentPage(mobilePages[index]),
            ),
        _appController.currentPage);
  }
}
