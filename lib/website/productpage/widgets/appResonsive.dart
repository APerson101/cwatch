import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppResponsiveView extends StatelessWidget {
  const AppResponsiveView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: context.isPhone
            ? Column(children: _getChildren())
            : Row(
                children: _getChildren(),
              ));
  }

  _getChildren() {
    return [
      Expanded(
        flex: 1,
        child: Column(
          children: [
            Text(
                "Cross-platform syncing:Start an experiment on web and continue on your phone. Our app is accessible and syncs beautifully on:Web, Android, IOS, harmonyOS."),
            ButtonBar(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.ac_unit)),
                IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
                IconButton(onPressed: () {}, icon: Icon(Icons.handyman_rounded))
              ],
            ),
          ],
        ),
      ),
      Expanded(flex: 2, child: FlutterLogo(size: double.maxFinite))
    ];
  }
}
