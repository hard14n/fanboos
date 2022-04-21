// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, avoid_print
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
String currCategory = '';

// ignore: must_be_immutable
class GraphSalesTrend extends StatefulWidget {
  String mycompany;
  String mycategory;

  GraphSalesTrend({
    required this.mycompany,
    required this.mycategory,
  });

  @override
  _GraphSalesTrendState createState() => _GraphSalesTrendState();
}

class _GraphSalesTrendState extends State<GraphSalesTrend> {
  final List<ExpenseData> chartData = [];

  @override
  void initState() {
    super.initState();
    currCategory = widget.mycategory;
    getdataAssetFromAPI();
  }

  void getdataAssetFromAPI() async {
    // ignore: unused_local_variable, non_constant_identifier_names
    double s2 = 0.0;
    // ignore: unused_local_variable, non_constant_identifier_names
    double s1 = 0.0;
    // ignore: unused_local_variable, non_constant_identifier_names
    double s0 = 0.0;
    // ignore: unused_local_variable, non_constant_identifier_names
    String bulan = '';

    String _url = alamaturl +
        "/w_sales_trend/?company=" +
        widget.mycompany +
        '&category=' +
        widget.mycategory;

    Dio _dio = Dio();

    Response response;

    setState(() {
      chartData.clear();
    });

    try {
      response = await _dio.get(_url,
          options: Options(headers: {
            'Authorization': 'Bearer $mytoken',
            'User-Agent': 'flutter-format',
          }));

      if (response.data['respon'] == 1) {
        setState(() {
          // print(response.data['data']);
          for (var ii = 0; ii < response.data['data'].length; ii++) {
            // print(response.data['data'][ii]);
            bulan = response.data['data'][ii][0].toString();

            s2 = double.parse(response.data['data'][ii][1]) == 0
                ? 0.0
                : double.parse(response.data['data'][ii][1]) / 1000000;

            s1 = double.parse(response.data['data'][ii][2]) == 0
                ? 0.0
                : double.parse(response.data['data'][ii][2]) / 1000000;

            s0 = double.parse(response.data['data'][ii][3]) == 0
                ? 0.0
                : double.parse(response.data['data'][ii][3]) / 1000000;

            chartData.add(new ExpenseData(bulan, s2, s1, s0));
          }
          // print(chartData);
          categoryDiRubah = false;
        });
      } else {
        setState(() {
          chartData.clear();
        });
      }
    } on Exception catch (_) {
      print("throwing new error");
      throw Exception("Error on server");
    }
  }

  final displayNumber = createDisplay(
    separator: ',',
    length: 10,
    decimal: 2,
  );

  @override
  Widget build(BuildContext context) {
    // var hScreen = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var wScreen = MediaQuery.of(context).size.width;

    if (currCategory != widget.mycategory && loading_Form == true) {
      currCategory = widget.mycategory;
      getdataAssetFromAPI();
    }

    return Container(
      child: SafeArea(
        child: Container(
          // color: Colors.blueAccent,
          child: SfCartesianChart(
            legend: Legend(
              isVisible: true,
              toggleSeriesVisibility: true,
              overflowMode: LegendItemOverflowMode.wrap,
              alignment: ChartAlignment.center,
              position: LegendPosition.bottom,
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              shared: true,
              activationMode: ActivationMode.singleTap,
              decimalPlaces: 2,
            ),
            enableSideBySideSeriesPlacement: true,
            crosshairBehavior: CrosshairBehavior(
              lineType: CrosshairLineType.horizontal,
              enable: true,
              shouldAlwaysShow: false,
              activationMode: ActivationMode.singleTap,
            ),
            selectionType: SelectionType.series,
            isTransposed: false,
            selectionGesture: ActivationMode.singleTap,
            primaryXAxis: CategoryAxis(
              isVisible: true,
              opposedPosition: false,
              isInversed: false,
              edgeLabelPlacement: EdgeLabelPlacement.shift,
            ),
            primaryYAxis: NumericAxis(
                axisLine: AxisLine(width: 0),
                labelFormat: '{value}',
                numberFormat: NumberFormat.simpleCurrency(
                    locale: 'IDR', decimalDigits: 2),
                majorTickLines: MajorTickLines(size: 0)),
            series: <SplineSeries>[
              SplineSeries<ExpenseData, String>(
                name: (DateTime.now().year - 2).toString(),
                color: Colors.green,
                dataSource: chartData,
                xValueMapper: (ExpenseData exp, _) => exp.bulan,
                yValueMapper: (ExpenseData exp, _) => exp.sale_min_2,
                dataLabelSettings: DataLabelSettings(isVisible: false),
                markerSettings:
                    MarkerSettings(isVisible: true, height: 4, width: 4),
              ),
              SplineSeries<ExpenseData, String>(
                name: (DateTime.now().year - 1).toString(),
                color: Colors.blue,
                dataSource: chartData,
                xValueMapper: (ExpenseData exp, _) => exp.bulan,
                yValueMapper: (ExpenseData exp, _) => exp.sale_min_1,
                dataLabelSettings: DataLabelSettings(isVisible: false),
                markerSettings:
                    MarkerSettings(isVisible: true, height: 4, width: 4),
              ),
              SplineSeries<ExpenseData, String>(
                name: DateTime.now().year.toString(),
                color: Colors.purple,
                dataSource: chartData,
                xValueMapper: (ExpenseData exp, _) => exp.bulan,
                yValueMapper: (ExpenseData exp, _) => exp.sale_min_Now,
                dataLabelSettings: DataLabelSettings(isVisible: false),
                markerSettings:
                    MarkerSettings(isVisible: true, height: 4, width: 4),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseData {
  final String bulan;
  // ignore: non_constant_identifier_names
  final num sale_min_2;
  // ignore: non_constant_identifier_names
  final num sale_min_1;
  // ignore: non_constant_identifier_names
  final num sale_min_Now;

  ExpenseData(this.bulan, this.sale_min_2, this.sale_min_1, this.sale_min_Now);
}
