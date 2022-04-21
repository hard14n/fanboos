// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, avoid_print, camel_case_types, unnecessary_string_interpolations, unused_local_variable, type_init_formals

import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:charts_flutter/flutter.dart';

import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

final List<SlsTrend> dtArray = [];

// ignore: must_be_immutable
class YTD_Sales_Growth extends StatefulWidget {
  String mycompany;
  String mycategory;
  String dateCutoff;

  YTD_Sales_Growth(
      {required this.mycompany,
      required this.mycategory,
      required this.dateCutoff});

  @override
  _YTD_Sales_GrowthState createState() => _YTD_Sales_GrowthState();
}

class _YTD_Sales_GrowthState extends State<YTD_Sales_Growth> {
  var loading = false;
  var count = 0;

  @override
  void initState() {
    super.initState();
    categoryDiRubah = true;
  }

  // ignore: override_on_non_overriding_member
  void getdataAssetFromAPI() async {
    String _url = alamaturl +
        "/w_ytd_sales_growth?company=" +
        myCompany +
        '&bywhat=' +
        widget.mycategory +
        '&cutoff=' +
        widget.dateCutoff;
    Dio _dio = Dio();
    Response response;

    // print(_url);

    setState(() {
      loading = true;
      dtArray.clear();
    });
    try {
      response = await _dio.get(_url,
          options: Options(headers: {"Authorization": "Bearer $mytoken"}));

      // print(response.data['data']);
      if (response.data['respon'] == 1) {
        // print(response.data['data'][0]['data']);
        setState(() {
          loading = false;
          int descData;
          double totSales;
          for (var ii = 0; ii < response.data['data'][0]['data'].length; ii++) {
            descData = response.data['data'][0]['data'][ii][0];
            totSales = response.data['data'][0]['data'][ii][1];

            dtArray.add(new SlsTrend(descData.toString(), totSales));
          }
          categoryDiRubah = false;
          count = 1;
        });
      } else {
        setState(() {
          loading = false;
          dtArray.clear();
          categoryDiRubah = false;
          count = 1;
        });
      }
    } on Exception catch (_) {
      print("throwing new error");
      throw Exception("Error on server");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    var mediaQueryData = MediaQuery.of(context);
    var hScreen = mediaQueryData.size.height;
    var wScreen = mediaQueryData.size.width;

    setState(() {
      if (categoryDiRubah == true) {
        getdataAssetFromAPI();
      }
    });

    return Container(
      child: dtArray.isEmpty && count == 0
          ? CircularProgressIndicator()
          : graphAllAsset(context, hScreen, wScreen),
    );
  }

  Container graphAllAsset(context, hScreen, wScreen) {
    var series = [
      charts.Series(
        domainFn: (SlsTrend asset, _) => asset.tahun,
        measureFn: (SlsTrend asset, _) => asset.slsValue,
        id: 'Assets',
        data: dtArray,
        labelAccessorFn: (SlsTrend asset, _) => displayNumber(asset.slsValue),
      )
    ];

    var grapik = charts.BarChart(
      series,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      animate: true,
    );

    var grapik2 = charts.PieChart(
      series,
      animationDuration: Duration(milliseconds: 100),
       defaultInteractions:true ,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
        arcRendererDecorators: [charts.ArcLabelDecorator()],
      ),

    );

    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Row(
          children: [
            Container(
              // color: Colors.purple,
              width: wScreen * 0.5,
              alignment: Alignment.centerLeft,
              // width: wScreen,
              margin: EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
              child: dtArray.isEmpty ? dataKosongMethod(wScreen) : grapik,
            ),
            Container(
              // color: Colors.blue[100],
              width: wScreen * 0.35,
              height: hScreen * 0.2,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
              child: dtArray.isEmpty
                  ? dataKosongMethod(wScreen)
                  : Center(child: grapik2),
            ),
          ],
        ),
      ),
    );
  }

  Container dataKosongMethod(wScreen) {
    return Container(
      alignment: Alignment.topCenter,
      child: Text('Data Asset tidak ada'),
    );
  }
}

class SlsTrend {
  final String tahun;
  final double slsValue;

  SlsTrend(this.tahun, this.slsValue);
}
