// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, avoid_print

import 'package:fanboos/Controller/Tab/Sales/SalesTrend/GraphSalesTrend.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

List dtArray = [];

// ignore: camel_case_types
class w_sales_Trend extends StatefulWidget {
  @override
  _w_sales_TrendState createState() => _w_sales_TrendState();
}

// ignore: camel_case_types
class _w_sales_TrendState extends State<w_sales_Trend> {
  var loading = false;
  var count = 0;
  List<String> category = ['Company'];
  var selectedCategory = 'Company';

  @override
  void initState() {
    super.initState();

    getdataCategoryFromAPI();
  }

  void getdataCategoryFromAPI() async {
    // var uri = Uri.parse(alamaturl + "/w_sales_trend/get_category");
    String _url = alamaturl + "/w_sales_trend/get_category";
    Dio _dio = Dio();
    Response response;

    setState(() {
      // print('getdataCategoryFromAPI loading = true ');
      loading = true;
    });
    try {
      response = await _dio.get(_url,
          options: Options(headers: {"Authorization": "Bearer $mytoken"}));

      if (response.data['respon'] == 1) {
        setState(() {
          loading = false;
          category.clear();
          for (String sName in response.data['data']) {
            category.add(sName);
          }
          count = 1;
        });
      } else {
        setState(
          () {
            // print('getdataCategoryFromAPI loading = False ');
            loading = false;
            dtArray = [];
            count = 1;
          },
        );
      }
    } on Exception catch (_) {
      print("throwing new error");
      throw Exception("Error on server");
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    var hScreen = mediaQueryData.size.height;
    var wScreen = mediaQueryData.size.width;
    return Column(children: [
      Container(
        // color: Colors.lightBlue,
        // height: hScreen * 0.27,
        width: wScreen,
        // margin: EdgeInsets.fromLTRB(1.0, 5, 1.0, 1.0),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(5),
        //   color: Colors.white,
        //   boxShadow: [
        //     BoxShadow(
        //       spreadRadius: 1,
        //       color: Colors.grey,
        //       blurRadius: 1.0,
        //       offset: Offset(0.0, 0.0),
        //     ),
        //   ],
        // ),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Container(
                  // color: Colors.blue,
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    'Sales Trend',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Container(
                  // color: Colors.yellow,
                  width: wScreen * 0.4,
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: DropdownButton(
                    menuMaxHeight: hScreen * 0.6,
                    isExpanded: true,
                    value: selectedCategory,
                    hint: Text('Pilih Category'),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value.toString();

                        categoryAsset != selectedCategory
                            ? categoryDiRubah = true
                            : categoryDiRubah = false;

                        categoryAsset = selectedCategory;

                        loading_Form = true;
                        // print(selectedCategory);
                      });
                    },
                    items: category.map((items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.white30,
              height: hScreen * 0.195,
              width: wScreen * 0.9,
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: GraphSalesTrend(
                mycategory: selectedCategory,
                mycompany: 'FS Cikupa',
              ),
              // Text(selectedCategory),
            )
          ],
        ),
      )
    ]);
  }
}
