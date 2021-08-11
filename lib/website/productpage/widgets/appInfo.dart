import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: context.isPhone
            ? Column(children: _getChildren())
            : Row(children: _getChildren()));
  }

  _getChildren() {
    return [
      Expanded(
          flex: 1,
          child: Text(
              "Our beautiful App is built with for everyone with a beautiful User Interface that is welcoming and encouraging. Users have the Ability to use voice command in multiple languages to set notifications and get data.set custom notifications pertaining to your conditions or certain situations.")),
      Expanded(flex: 2, child: FlutterLogo(size: double.maxFinite))
    ];
  }
}
