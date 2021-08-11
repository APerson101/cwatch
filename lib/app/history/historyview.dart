import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

import 'package:cwatch/app/history/historyController.dart';

class HistoryView extends StatelessWidget {
  HistoryView({Key? key}) : super(key: key);
  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.currentStatus.value == historyLoadingStatus.loading)
          return CircularProgressIndicator();
        if (controller.currentStatus.value == historyLoadingStatus.success)
          return table(context);
        return Container(
            child: Center(
          child: Text("Error"),
        ));
      },
    );
  }

  table(context) {
    return Container(
        child: Column(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() {
                    var locations = ['Abuja', 'Accra', 'bla'];
                    return DropdownButton(
                        value: controller.currentLocation.value,
                        onChanged: (int? newvalue) =>
                            controller.currentLocation.value = newvalue!,
                        items: locations
                            .map((e) => DropdownMenuItem<int>(
                                  child: Text(e),
                                  value: locations.indexOf(e),
                                ))
                            .toList());
                  }),
                  Obx(() {
                    return ElevatedButton(
                        onPressed: () {
                          //date picker
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2021, 8, 1),
                              maxTime: DateTime(2021, 9, 30),
                              currentTime: DateTime.now(),
                              onConfirm: (newDate) {
                            controller.selectedDate.value = newDate.toString();
                          });
                        },
                        child: Text(controller.selectedDate.value));
                  }),
                  ElevatedButton(onPressed: () {}, child: Text("download")),
                ],
              ),
            )),
        Expanded(flex: 4, child: SingleChildScrollView(child: tableView()))
      ],
    ));
  }

  tableView() {
    return Obx(() {
      List<FakeData> things = controller.historyData;
      return PaginatedDataTable(
          sortAscending: controller.sortAscending.value,
          header: Text('Historical Data'),
          sortColumnIndex: controller.sortIndex.value,
          columns: [
            DataColumn(
              label: Text('Temperature'),
              onSort: (index, ascending) {
                if (index == controller.sortIndex.value) {
                  controller.sortAscending.value =
                      !controller.sortAscending.value;
                  if (controller.sortAscending.value) {
                    things.sort((a, b) {
                      print('sorting in asceind');
                      return int.parse(a.temperature)
                          .compareTo(int.parse(b.temperature));
                    });
                  } else {
                    print('sorting in desc');
                    controller.historyData.value = things.reversed.toList();
                  }
                } else {
                  things.sort((a, b) {
                    print('sorting in asceind');

                    return double.parse(a.temperature)
                        .compareTo(double.parse(b.temperature));
                  });
                }
                controller.sortIndex.value = index;
              },
            ),
            DataColumn(
              label: Text('Humidity'),
              onSort: (index, ascending) {
                if (index == controller.sortIndex.value) {
                  controller.sortAscending.value =
                      !controller.sortAscending.value;
                  if (controller.sortAscending.value) {
                    things.sort((a, b) {
                      return double.parse(a.humidity)
                          .compareTo(double.parse(b.humidity));
                    });
                  } else {
                    controller.historyData.value = things.reversed.toList();
                  }
                } else {
                  things.sort((a, b) {
                    return double.parse(a.humidity)
                        .compareTo(double.parse(b.humidity));
                  });
                }
                controller.sortIndex.value = index;
              },
            ),
            DataColumn(
              onSort: (index, ascending) {
                if (index == controller.sortIndex.value) {
                  controller.sortAscending.value =
                      !controller.sortAscending.value;
                  if (controller.sortAscending.value) {
                    things.sort((a, b) {
                      return double.parse(a.pm).compareTo(double.parse(b.pm));
                    });
                  } else {
                    controller.historyData.value = things.reversed.toList();
                  }
                } else {
                  things.sort((a, b) {
                    return double.parse(a.pm).compareTo(double.parse(b.pm));
                  });
                }
                controller.sortIndex.value = index;
              },
              label: Text('PM 2.5'),
            ),
            DataColumn(
              onSort: (index, ascending) {
                if (index == controller.sortIndex.value) {
                  controller.sortAscending.value =
                      !controller.sortAscending.value;
                  if (controller.sortAscending.value) {
                    things.sort((a, b) {
                      return double.parse(a.ozone)
                          .compareTo(double.parse(b.ozone));
                    });
                  } else {
                    controller.historyData.value = things.reversed.toList();
                  }
                } else {
                  things.sort((a, b) {
                    return double.parse(a.ozone)
                        .compareTo(double.parse(b.ozone));
                  });
                }
                controller.sortIndex.value = index;
              },
              label: Text('Ozone'),
            ),
            DataColumn(
              label: Text('Pressure'),
              onSort: (index, ascending) {
                if (index == controller.sortIndex.value) {
                  controller.sortAscending.value =
                      !controller.sortAscending.value;
                  if (controller.sortAscending.value) {
                    things.sort((a, b) {
                      return double.parse(a.pressure)
                          .compareTo(double.parse(b.pressure));
                    });
                  } else {
                    controller.historyData.value = things.reversed.toList();
                  }
                } else {
                  things.sort((a, b) {
                    return double.parse(a.pressure)
                        .compareTo(double.parse(b.pressure));
                  });
                }
                controller.sortIndex.value = index;
              },
            ),
            DataColumn(
              label: Text('Gas'),
              onSort: (index, ascending) {
                if (index == controller.sortIndex.value) {
                  controller.sortAscending.value =
                      !controller.sortAscending.value;
                  if (controller.sortAscending.value) {
                    things.sort((a, b) {
                      return double.parse(a.gas).compareTo(double.parse(b.gas));
                    });
                  } else {
                    controller.historyData.value = things.reversed.toList();
                  }
                } else {
                  things.sort((a, b) {
                    return double.parse(a.gas).compareTo(double.parse(b.gas));
                  });
                }
                controller.sortIndex.value = index;
              },
            ),
            DataColumn(
              label: Text('Time'),
              onSort: (index, ascending) {
                if (index == controller.sortIndex.value) {
                  controller.sortAscending.value =
                      !controller.sortAscending.value;
                  if (controller.sortAscending.value) {
                    things.sort((a, b) {
                      return int.parse(a.time.split(':')[0])
                          .compareTo(int.parse(b.time.split(':')[0]));
                    });
                  } else {
                    controller.historyData.value = things.reversed.toList();
                  }
                } else {
                  things.sort((a, b) {
                    return double.parse(a.time.split(':')[0])
                        .compareTo(double.parse(b.time.split(':')[0]));
                  });
                }
                controller.sortIndex.value = index;
              },
            )
          ],
          actions: [
            //this is where the sort and filter would go
          ],
          showCheckboxColumn: false,
          source: Stuffs(allData: things));
    });
  }
}

class Stuffs extends DataTableSource {
  List<FakeData> allData;
  Stuffs({required this.allData});
  @override
  DataRow? getRow(int index) {
    List<DataCell> currentRow = [];
    var currencyCell = DataCell(Text(allData[index].temperature));
    var amountCell = DataCell(Text(allData[index].humidity.toString()));
    var created_atCell = DataCell(Text(allData[index].pm.toString()));
    var type = DataCell(Text(allData[index].ozone));
    var statusCell = DataCell(Text(allData[index].pressure));
    var gas = DataCell(Text(allData[index].gas));
    var time = DataCell(Text(allData[index].time));
    currentRow.add(currencyCell);
    currentRow.add(amountCell);
    currentRow.add(type);
    currentRow.add(created_atCell);
    currentRow.add(statusCell);
    currentRow.add(gas);
    currentRow.add(time);

    return DataRow(
      cells: currentRow,
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => allData.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}

class FakeData {
  String temperature;
  String ozone;
  String pressure;
  String humidity;
  String pm;
  String gas;
  String time = '00.00';
  FakeData(
      {required this.temperature,
      required this.humidity,
      required this.pm,
      required this.ozone,
      required this.pressure,
      required this.gas,
      this.time = '00.00'});

  //pm 27
  //temp 24C
  //humidity: 70%
  //ozone 5-5.3
  //pressure: 142

  @override
  String toString() {
    return 'FakeData(temperature: $temperature, ozone: $ozone, pressure: $pressure, humidity: $humidity, pm: $pm, gas: $gas, time: $time)';
  }

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'ozone': ozone,
      'pressure': pressure,
      'humidity': humidity,
      'pm': pm,
      'gas': gas,
      'time': time,
    };
  }

  String toJson() => json.encode(toMap());
}
