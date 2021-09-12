import 'dart:convert';

import 'package:cwatch/apithings/APIHandler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

import 'package:cwatch/app/history/historyController.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HistoryView extends StatelessWidget {
  HistoryView({Key? key}) : super(key: key);
  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return table(context);
  }

  table(context) {
    return SafeArea(
      child: Container(
          child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                // color: Colors.red,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() {
                        return DropdownButton(
                            underline: Container(),
                            value: controller.currentLocation.value,
                            onChanged: (AllActiveLocations? newvalue) =>
                                controller.currentLocation.value = newvalue!,
                            items: AllActiveLocations.values
                                .map(
                                    (e) => DropdownMenuItem<AllActiveLocations>(
                                          child: Text(describeEnum(e)),
                                          value: e,
                                        ))
                                .toList());
                      }),
                      ElevatedButton(
                          onPressed: () => dateSelector(),
                          child: Text("select date")),
                      ElevatedButton(
                          onPressed: () => controller.loadData(),
                          child: Text("view Data")),
                    ]),
              )),
          Expanded(flex: 4, child: SingleChildScrollView(child: tableView()))
        ],
      )),
    );
  }

  dateSelector() {
    return Get.defaultDialog(
        title: "Select Date",
        content: Container(
            child: SingleChildScrollView(
                child: Container(
          width: 300,
          height: 300,
          child: SfDateRangePicker(
            minDate: DateTime(2021, 07, 1),
            maxDate: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 1),
            view: DateRangePickerView.month,
            initialSelectedDate: DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day - 1),
            initialSelectedRanges: [
              PickerDateRange(
                  DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day - 2),
                  DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day - 1))
            ],
            selectionMode: DateRangePickerSelectionMode.single,
            onSelectionChanged: _onSelectionChanged,
          ),
        ))),
        onConfirm: () {
          Get.back();
        },
        onCancel: () => Get.back());
  }

  _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      final DateTime selectedDate = args.value;
      controller.userSelectedDate.value = selectedDate;
    }
  }

  tableView() {
    return Obx(() {
      if (controller.currentStatus.value == historyLoadingStatus.none)
        return Expanded(
            child: Container(
                child: Center(child: Text("Select date and location"))));
      if (controller.currentStatus.value == historyLoadingStatus.loading)
        return Expanded(
            child: Container(
                child: Center(child: CircularProgressIndicator.adaptive())));
      if (controller.currentStatus.value == historyLoadingStatus.error)
        return Center(child: Text("error"));
      if (controller.currentStatus.value == historyLoadingStatus.success) {
        List<DayHistory> things = controller.historyData;
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
                        return int.parse(a.data.temperature)
                            .compareTo(int.parse(b.data.temperature));
                      });
                    } else {
                      print('sorting in desc');
                      controller.historyData.value = things.reversed.toList();
                    }
                  } else {
                    things.sort((a, b) {
                      print('sorting in asceind');

                      return double.parse(a.data.temperature)
                          .compareTo(double.parse(b.data.temperature));
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
                        return double.parse(a.data.humidity)
                            .compareTo(double.parse(b.data.humidity));
                      });
                    } else {
                      controller.historyData.value = things.reversed.toList();
                    }
                  } else {
                    things.sort((a, b) {
                      return double.parse(a.data.humidity)
                          .compareTo(double.parse(b.data.humidity));
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
                        return double.parse(a.data.pm)
                            .compareTo(double.parse(b.data.pm));
                      });
                    } else {
                      controller.historyData.value = things.reversed.toList();
                    }
                  } else {
                    things.sort((a, b) {
                      return double.parse(a.data.pm)
                          .compareTo(double.parse(b.data.pm));
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
                        return double.parse(a.data.ozone)
                            .compareTo(double.parse(b.data.ozone));
                      });
                    } else {
                      controller.historyData.value = things.reversed.toList();
                    }
                  } else {
                    things.sort((a, b) {
                      return double.parse(a.data.ozone)
                          .compareTo(double.parse(b.data.ozone));
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
                        return double.parse(a.data.pressure)
                            .compareTo(double.parse(b.data.pressure));
                      });
                    } else {
                      controller.historyData.value = things.reversed.toList();
                    }
                  } else {
                    things.sort((a, b) {
                      return double.parse(a.data.pressure)
                          .compareTo(double.parse(b.data.pressure));
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
                        return double.parse(a.data.gas)
                            .compareTo(double.parse(b.data.gas));
                      });
                    } else {
                      controller.historyData.value = things.reversed.toList();
                    }
                  } else {
                    things.sort((a, b) {
                      return double.parse(a.data.gas)
                          .compareTo(double.parse(b.data.gas));
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
                        return DateTime.fromMicrosecondsSinceEpoch(
                                int.parse(a.date))
                            .hour
                            .compareTo(DateTime.fromMicrosecondsSinceEpoch(
                                    int.parse(b.date))
                                .hour);
                      });
                    } else {
                      controller.historyData.value = things.reversed.toList();
                    }
                  } else {
                    things.sort((a, b) {
                      return DateTime.fromMicrosecondsSinceEpoch(
                              int.parse(a.date))
                          .hour
                          .compareTo(DateTime.fromMicrosecondsSinceEpoch(
                                  int.parse(b.date))
                              .hour);
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
      }
      return Container(child: Center(child: Text("unknown error")));
    });
  }
}

class Stuffs extends DataTableSource {
  List<DayHistory> allData;
  Stuffs({required this.allData});
  @override
  DataRow? getRow(int index) {
    List<DataCell> currentRow = [];
    var currencyCell = DataCell(Text(allData[index].data.temperature));
    var amountCell = DataCell(Text(allData[index].data.humidity.toString()));
    var created_atCell = DataCell(Text(allData[index].data.pm.toString()));
    var type = DataCell(Text(allData[index].data.ozone));
    var statusCell = DataCell(Text(allData[index].data.pressure));
    var gas = DataCell(Text(allData[index].data.gas));
    var time = DataCell(Text(
        DateTime.fromMicrosecondsSinceEpoch(int.parse(allData[index].date))
            .toString()));
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
