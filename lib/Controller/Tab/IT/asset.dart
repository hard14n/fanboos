// ignore_for_file: avoid_print, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fanboos/Controller/Tab/IT/model/AssetModel.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

List<AssetModel> dtArray = [];

class AssetIT extends StatefulWidget {
  const AssetIT({Key? key}) : super(key: key);

  @override
  _AssetITState createState() => _AssetITState();
}

class _AssetITState extends State<AssetIT> {
  var loading = false;
  var count = 0;

  @override
  void initState() {
    super.initState();
    getdataAssetFromAPI();
  }

  void getdataAssetFromAPI() async {
    String _url = alamaturl + "/w_asset_it";
    Dio _dio = Dio();
    Response response;
    setState(() {
      loading = true;
    });
    try {
      response = await _dio.get(_url,
          options: Options(headers: {"Authorization": "Bearer $mytoken"}));
      if (response.data['response'] == 1) {
        setState(() {
          loading = false;
          // print(response.data['data']);
          dtArray = AssetModel.listFromJson(response.data['data']);

          count = 1;
        });
      } else {
        setState(() {
          loading = false;
          dtArray = [];
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
    // ignore: unused_local_variable
    var hScreen = mediaQueryData.size.height;
    // ignore: unused_local_variable
    var wScreen = mediaQueryData.size.width;

    dtArray.isEmpty && count == 0
        ? getdataAssetFromAPI()
        : print('Data OK');

    return Container(
      height: hScreen * 0.35,
      child: dtArray.isEmpty && count == 0
          ? const CircularProgressIndicator()
          : graphAllAsset(context, hScreen, wScreen),
    );
  }

  Container graphAllAsset(context, hScreen, wScreen) {
    // print(dtArray);
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: wScreen,
              margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: dtArray.isEmpty
                  ? dataKosong(wScreen)
                  : dataAsset(wScreen, hScreen),
            ),
          ],
        ),
      ),
    );
  }

  Container dataAsset(wScreen, hScreen) {
    var series = [
      charts.Series(
        id: 'Asset',
        data: dtArray,
        domainFn: (AssetModel sales, _) => sales.jenis_asset,
        measureFn: (AssetModel sales, _) => sales.jumlah_asset,
        labelAccessorFn: (AssetModel sales, _) => sales.jumlah_asset.toString(),
      ),
    ];

    var barchart = charts.BarChart(
      series,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
    );

    return Container(
        height: hScreen * 0.35,
        alignment: Alignment.topCenter,
        child: barchart);
  }

  Container dataKosong(wScreen) {
    return Container(
      alignment: Alignment.topCenter,
      child: const Text('Data Asset tidak ada'),
    );
  }
}
