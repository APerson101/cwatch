import 'package:flutter/material.dart';
import 'package:get/get.dart';

class APIInfo extends StatelessWidget {
  const APIInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: context.isPhone
          ? Column(children: _getChildren())
          : Row(children: _getChildren()),
    );
  }

  _getChildren() {
    return [
      Expanded(flex: 1, child: Text("something about API and data access")),
      Expanded(flex: 2, child: FlutterLogo(size: double.maxFinite))
    ];
  }
}
