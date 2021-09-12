import 'dart:ui';

import 'package:cwatch/app/Visualizer/defaultGraph.dart';
import 'package:cwatch/app/Visualizer/visualizerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:styled_widget/styled_widget.dart';

class VisualizerView extends StatelessWidget {
  VisualizerView({Key? key}) : super(key: key);
  final VisualizerController controller = Get.put(VisualizerController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Data vizualiser"),
          actions: [
            IconButton(
                onPressed: () {
                  controller.graphsWidgets
                      .add(_default(controller.graphsWidgets.length));
                  controller.addGraph();
                },
                icon: Icon(Icons.add)),
            Obx(() {
              var opacity = controller.numberOfGraphs.value;
              return Row(
                children: [
                  Text("number per row: "),
                  DropdownButton<int>(
                      underline: Container(),
                      value: controller.numberPerRow.value,
                      onChanged: (newValue) =>
                          controller.numberPerRow.value = newValue!,
                      items: [1, 2, 3].map((e) {
                        return DropdownMenuItem(
                            value: e, child: Text(e.toString()));
                      }).toList())
                ],
              ).opacity(
                opacity == 0 ? 0 : 1,
              );
            })
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 10),
            child: Center(
                child: Stack(children: [
              _gridView(),
              ...[
                Obx(() {
                  if (controller.expandImage.value)
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(color: Colors.black.withOpacity(0.6)),
                    );
                  return Container();
                }),
                _preview(),
              ]
            ]))),
      ),
    );
  }

  Widget _preview() {
    return Container(
      child: Center(child: Obx(() {
        if (controller.expandImage.value)
          return Stack(
            clipBehavior: Clip.none,
            children: [
              controller.graphsWidgets[controller.longpressegraph.value]
                  .constrained(width: 500, height: 500),
              IconButton(
                      onPressed: () => controller.expandImage.value = false,
                      icon: Icon(Icons.cancel))
                  .positioned(top: 0, right: 0),
            ],
          );
        return Container();
      })),
    );
  }

  _gridView() {
    return Obx(() {
      int number = controller.numberOfGraphs.value;
      if (number == 0)
        return Container(
          child: Center(
            child: Text(" press the + button to add graph"),
          ),
        );
      // var mainAxisExtent, maxCrossAxisExtent;
      // if (number == 1 || number == 2) {
      //   mainAxisExtent = Get.height - 60;
      //   if (number == 1) maxCrossAxisExtent = Get.width;
      //   if (number == 2) maxCrossAxisExtent = Get.width / 2;
      // }
      // if (number > 2) {
      //   mainAxisExtent = (Get.height - 60) / 2;
      //   maxCrossAxisExtent = Get.width / 2;
      // }

      return GridView.count(
        crossAxisCount: controller.numberPerRow.value,
        crossAxisSpacing: 20,
        childAspectRatio: 1.7,
        mainAxisSpacing: 20,
        children: _gridchildren(),
      );
    });
  }

  List<Widget> _gridchildren() {
    return controller.graphsWidgets;
  }

  TestWidget _default(int int) {
    return TestWidget(
      index: int.obs,
      detector: GestureDetector(
          onDoubleTap: () {
            if (controller.expandImage.value) return;
            print('double tap initiated');
            controller.expandImage.value = true;
            controller.longpressegraph.value = int;
          },
          child: Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            // child: SingleChildScrollView(
            //   child: Column(
            //     children: [
            //       Text(randomBetween(0, 10).toString()),
            //       FlutterLogo(),
            //     ],
            //   ),
            // ),
            child: DefaultGraph(index: int.obs),
            // width: 200,
            // height: 200,
            // color: Colors.green
          )
          // .constrained(maxWidth: Get.height - 50),
          ),
    );
  }
}

class TestWidget extends StatelessWidget {
  TestWidget({Key? key, required this.detector, required this.index})
      : super(key: key);
  RxInt index;
  GestureDetector detector;
  @override
  Widget build(BuildContext context) {
    return detector;
  }
}
