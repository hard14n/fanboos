// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, avoid_print

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:fanboos/Controller/Tab/IT/model/assetByDepartemenModel.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

List myArray = [];

class AssetITByDepartemen extends StatefulWidget {
  @override
  _AssetITByDepartemenState createState() => _AssetITByDepartemenState();
}

class _AssetITByDepartemenState extends State<AssetITByDepartemen> {
  var loading = false;
  var count = 0;

  @override
  void initState() {
    super.initState();
  }

  void getdataAssetFromAPI() async {
    String _url = alamaturl +
        "/w_asset_it/asset_by_departemen?jenis_asset=" +
        categoryAsset;
    Dio _dio = Dio();
    Response response;

    setState(() {
      loading = true;
      myArray = [];
    });

    try {
      response = await _dio.get(_url,
          options: Options(headers: {"Authorization": "Bearer $mytoken"}));

      // print(response.data['data']);
      if (response.data['respon'] == 1) {
        setState(() {
          myArray = AssetByDepartemen.listFromJson(response.data['data']);

          // print(myArray);

          categoryDiRubah = false;
          count = 1;
        });
      } else {
        setState(() {
          loading = false;
          myArray = [];
          count = 0;
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

    setState(() {
      if (categoryDiRubah == true) {
        getdataAssetFromAPI();
      }
    });

    return Container(
      height: hScreen * 0.35,
      child: myArray.isEmpty && count == 0
          ? CircularProgressIndicator()
          : graphAllAsset(context, hScreen, wScreen),
    );
  }

  Container graphAllAsset(context, hScreen, wScreen) {
    List<Series<dynamic, String>> series = [
      charts.Series(
        domainFn: (asset, _) => asset.jenis_asset,
        measureFn: (asset, _) => asset.jumlah_asset,
        id: 'Assets',
        data: myArray,
        labelAccessorFn: (asset, _) => asset.jumlah_asset.toString(),
      )
    ];

    var grapik = charts.BarChart(
      series,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      animate: true,
    );

    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // color: Colors.purple,
              alignment: Alignment.centerLeft,
              width: wScreen,
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: myArray.isEmpty
                  ? dataKosongMethod(wScreen)
                  : Container(
                      height: hScreen * 0.35,
                      child: grapik,
                    ),
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
