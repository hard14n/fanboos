// ignore_for_file: file_names, camel_case_types, use_key_in_widget_constructors, must_be_immutable, unnecessary_new, avoid_print, avoid_unnecessary_containers, deprecated_member_use, prefer_adjacent_string_concatenation, sized_box_for_whitespace
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class YTD_S_Growth extends StatefulWidget {
  String mycompany;
  String mycategory;
  String dateCutoff;

  YTD_S_Growth(
      {required this.mycompany,
      required this.mycategory,
      required this.dateCutoff});

  @override
  _YTD_S_GrowthState createState() => _YTD_S_GrowthState();
}

class _YTD_S_GrowthState extends State<YTD_S_Growth> {
  final List<SlsTrend> dtArray = [];

  @override
  void initState() {
    super.initState();
    categoryDiRubah = true;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var hScreen = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var wScreen = MediaQuery.of(context).size.width;

    if (categoryDiRubah == true) {
      getdataAssetFromAPI();
    }

    var series = [
      charts.Series(
        domainFn: (SlsTrend asset, _) => asset.tahun,
        measureFn: (SlsTrend asset, _) => asset.slsValue,
        id: 'Assets',
        data: dtArray,
        labelAccessorFn: (SlsTrend asset, _) => displayNumber(asset.slsValue),
      )
    ];

    // ignore: unused_local_variable
    var grapik = charts.BarChart(
      series,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      animate: true,
    );

    return SizedBox(
        child: SafeArea(
      child: Row(
        children: [
          Container(
            // color: Colors.blue[100],
            // width: wScreen * 0.5,
            child: dtArray.isEmpty ? dataKosongMethod(wScreen) : barChart(),
          ),
          // Container(
          //   // color: Colors.green[100],
          //   width: wScreen * 0.4,
          //   child: dtArray.isEmpty ? dataKosongMethod(wScreen) : pieChart(),
          // ),
        ],
      ),
    ));
  }

  SfCartesianChart barChart() {
    // print(dtArray);
    return SfCartesianChart(
      series: <ChartSeries>[
        BarSeries<SlsTrend, String>(
          dataSource: dtArray,
          xValueMapper: (SlsTrend dtsale, _) => dtsale.tahun,
          yValueMapper: (SlsTrend dtsale, _) => dtsale.slsValue,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        numberFormat:
            NumberFormat.simpleCurrency(decimalDigits: 0, name: 'IDR'),
      ),
    );
  }

  SfCircularChart pieChart() {
    return SfCircularChart(
      tooltipBehavior: TooltipBehavior(
          enable: true, decimalPlaces: 2, format: 'Rp.' + 'point.y'),
      series: <CircularSeries>[
        PieSeries<SlsTrend, String>(
          dataSource: dtArray,
          xValueMapper: (SlsTrend dtsale, _) => dtsale.tahun,
          yValueMapper: (SlsTrend dtsale, _) => dtsale.slsValue,
          // enableSmartLabels: true,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.inside,
          ),
        ),
      ],
    );
  }

  Container dataKosongMethod(wScreen) {
    return Container(
      alignment: Alignment.topCenter,
      child: const Text('Data Asset tidak ada'),
    );
  }

  // ignore: override_on_non_overriding_member
  void getdataAssetFromAPI() async {
    String descData;
    int totSales;

    String _url = alamaturl +
        "/w_ytd_sales_growth?company=" +
        myCompany +
        '&bywhat=' +
        widget.mycategory +
        '&cutoff=' +
        widget.dateCutoff;
    Dio _dio = Dio();
    Response response;

    setState(() {
      dtArray.clear();
    });
    try {
      response = await _dio.get(_url,
          options: Options(headers: {"Authorization": "Bearer $mytoken"}));

      if (response.data['respon'] == 1) {
        setState(() {
          for (var ii = 0; ii < response.data['data'][0]['data'].length; ii++) {
            descData = response.data['data'][0]['data'][ii][0].toString();
            totSales = response.data['data'][0]['data'][ii][1];

            dtArray.add(new SlsTrend(descData, totSales));
          }
          categoryDiRubah = false;
        });
      } else {
        setState(() {
          dtArray.clear();
          categoryDiRubah = false;
        });
      }
    } on Exception catch (_) {
      print("throwing new error");
      throw Exception("Error on server");
    }
  }
}

class SlsTrend {
  final String tahun;
  final int slsValue;

  SlsTrend(this.tahun, this.slsValue);
}
