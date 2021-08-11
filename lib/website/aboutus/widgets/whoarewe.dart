import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhoAreWe extends StatelessWidget {
  const WhoAreWe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.blue,
        child: context.isPhone
            ? Column(children: _getChildren())
            : Row(children: _getChildren()));
  }

  _getChildren() {
    return [
      Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("WHO ARE WE"),
              Text("bunch of idiots to be honest"),
            ],
          )),
      Expanded(flex: 2, child: FlutterLogo(size: double.maxFinite))
    ];
  }
}
