import 'package:cwatch/website/homepage/widgets/contact.dart';
import 'package:cwatch/website/homepage/widgets/africamap.dart';
import 'package:cwatch/website/homepage/widgets/productinfo.dart';
import 'package:cwatch/website/homepage/widgets/quotescarousal.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:get/get.dart';

class HomePageView extends StatelessWidget {
  HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: homeViewContent()));
  }

  Widget homeViewContent() {
    // return tableView();
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
      child: Column(
        children: [
          Container(
            height: Get.height - 49,
            width: Get.width,
            child: ProductLanding(),
          ),
          Container(
              height: Get.height,
              width: Get.width,
              child: QuotesCarousal(
                carousalheight: Get.height - 49,
              )),
          Container(height: Get.height, width: Get.width, child: AfricaMap()),
          Container(
              height: Get.height / 4, width: Get.width, child: ContactUs())
        ],
      ),
    );
  }

  tableView() {
    List<FakeData> things = [];
    //pm 27
    //temp 24C
    //humidity: 70%
    //ozone 5-5.3
    //pressure: 142
    for (var i = 0; i < 20; i++) {
      things.add(FakeData(
          temperature: randomBetween(23, 25).toString(),
          humidity: randomBetween(68, 70).toString(),
          pm: randomBetween(25, 27).toString(),
          ozone: randomBetween(5, 6).toString(),
          pressure: randomBetween(143, 160).toString()));
    }
    Stuffs _transactiontable = Stuffs(allData: things);

    return PaginatedDataTable(
        header: Text('Live Data'),
        columns: [
          DataColumn(label: Text('temperature')),
          DataColumn(label: Text('humidity')),
          DataColumn(label: Text('pm')),
          DataColumn(label: Text('ozone')),
          DataColumn(label: Text('pressure'))
        ],
        actions: [
          //this is where the sort and filter would go
        ],
        showCheckboxColumn: false,
        source: _transactiontable);
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
    currentRow.add(currencyCell);
    currentRow.add(amountCell);
    currentRow.add(type);
    currentRow.add(created_atCell);
    currentRow.add(statusCell);

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
  String temperature, pm, ozone, pressure, humidity;
  FakeData({
    required this.temperature,
    required this.humidity,
    required this.pm,
    required this.ozone,
    required this.pressure,
  });

  //pm 27
  //temp 24C
  //humidity: 70%
  //ozone 5-5.3
  //pressure: 142
}
