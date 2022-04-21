// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, avoid_print

import 'package:fanboos/Controller/Tab/IT/assetByDepartemen.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fanboos/Controller/Tab/IT/asset.dart';

List dtArray = [];

class WidgetIT extends StatefulWidget {
  @override
  _WidgetITState createState() => _WidgetITState();
}

class _WidgetITState extends State<WidgetIT> {
  var loading = false;
  var count = 0;
  List<String> category = ['All'];
  var selectedCategory = 'All';

  @override
  void initState() {
    super.initState();

    getdataCategoryFromAPI();
  }

  void getdataCategoryFromAPI() async {
    String _url = alamaturl + "/w_asset_it";
    Dio _dio = Dio();
    Response response;

    setState(() {
      // print('getdataCategoryFromAPI loading = true ');
      loading = true;
    });
    try {
      response = await _dio.get(_url,
          options: Options(headers: {"Authorization": "Bearer $mytoken"}));

      if (response.data['response'] == 1) {
        setState(() {
          loading = false;
          // print(response.data['category']);
          for (var word in response.data['category']) {
            category.add(word['name'].toString());
          }
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
    // ignore: unused_local_variable
    var hScreen = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var wScreen = MediaQuery.of(context).size.width;
    return Column(children: [
      Container(
        width: wScreen,
        margin: EdgeInsets.fromLTRB(1.0, 5, 1.0, 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              color: Colors.grey,
              blurRadius: 1.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Container(
                  // color: Colors.blue,
                  margin: EdgeInsets.only(left: 20),
                  child: Text('Asset'),
                ),
                Spacer(),
                Container(
                  // color: Colors.yellow,
                  width: wScreen * 0.4,
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: DropDownCategory(hScreen),
                ),
              ],
            ),
            Container(
                color: Colors.yellow[50],
                // height: hScreen * 0.3,
                width: wScreen * 0.9,
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: selectedCategory == 'All'
                    ? AssetIT()
                    : AssetITByDepartemen())
          ],
        ),
      )
    ]);
  }

  // ignore: non_constant_identifier_names
  DropdownButton<String> DropDownCategory(double hScreen) {
    return DropdownButton(
      menuMaxHeight: hScreen * 0.6,
      isExpanded: true,
      value: selectedCategory,
      hint: Text('Pilih Category'),
      onChanged: (value) {
        setState(() {
          selectedCategory = value.toString();

          selectedCategory == 'All'
              ? categoryDiRubah = false
              : categoryAsset != selectedCategory
                  ? categoryDiRubah = true
                  : categoryDiRubah = false;

          categoryAsset = selectedCategory;

        });
      },
      items: category.map((items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
    );
  }

}
