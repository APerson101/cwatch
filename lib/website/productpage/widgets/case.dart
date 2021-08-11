import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaseView extends StatelessWidget {
  const CaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: context.isPhone
          ? Column(children: _getChildren())
          : Row(
              children: _getChildren(),
            ),
    );
  }

  _getChildren() {
    return [
      Expanded(
          flex: 1,
          child: Text(
              "Our device is enclosed in a hard metal material which can withstand the harsh weather which is found in sub saharan Africa")),
      Expanded(
          flex: 2,
          child: FlutterLogo(
            size: double.maxFinite,
          ))
    ];
  }
}
