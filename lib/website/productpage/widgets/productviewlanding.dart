import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductPageLanding extends StatelessWidget {
  const ProductPageLanding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: sensorSuite(context));
  }

  sensorSuite(BuildContext context) {
    return Container(
        child: context.isPhone
            ? Column(
                children: _getChildren(),
              )
            : Row(
                children: _getChildren(),
              ));
  }

  _getChildren() {
    return [
      Expanded(
          flex: 1,
          child: Text(
              "Air1 has a sensor suite that measures: humidity, pressure, ozone, gas, temperature, PM. Air1 is always on and is constantly measuring the air. Users can also set the interval the require when trying to get information from the app.")),
      Expanded(flex: 2, child: FlutterLogo(size: double.maxFinite)),
    ];
  }
}
