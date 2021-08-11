import 'package:cwatch/app/models/latestdatamodel.dart';

class DashboardGraphModel {
  LatestDataModel value;
  DateTime time;
  String source;
  DashboardGraphModel({
    required this.value,
    required this.time,
    required this.source,
  });
}
