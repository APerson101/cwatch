import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AfricaMap extends StatelessWidget {
  const AfricaMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: context.isPhone
            ? Column(
                children: _getChildren(),
              )
            : Row(children: _getChildren()));
  }

  _getChildren() {
    return [
      Expanded(
        flex: 2,
        child: FlutterLogo(size: double.maxFinite),
      ),
      Expanded(
          flex: 1,
          child: Text(
              "Our devices are currently available in Nigeria, Ghana and Ivory Coast with more countries to be added."))
    ];
  }
}
