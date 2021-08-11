import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoragePowerView extends StatelessWidget {
  const StoragePowerView({Key? key}) : super(key: key);

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
        flex: 1,
        child: Text(
            "Air1 runs on solar power which constantly charges the battery attached which runs the device. Data is stored on the onboards SDCard and is occasionally sent to the cloud using the SIM Card module. There is also a  WIFI card on the board and a bluetooth module which enables remote acccess and maintainance "),
      ),
      Expanded(flex: 2, child: FlutterLogo(size: double.maxFinite))
    ];
  }
}
