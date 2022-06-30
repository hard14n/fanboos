// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, avoid_print, camel_case_types, dead_code, void_checks

import 'package:fanboos/Controller/Tab/Sales/YTD_Sales_Growth/G_YTD_Sales_Growth.dart';
// import 'package:fanboos/Controller/Tab/Sales/YTD_Sales_Growth/graph_YTD_Sales_Growth.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

List dtArray = [];

class Widget_YTD_Sales_Growth extends StatefulWidget {
  @override
  _Widget_YTD_Sales_GrowthState createState() =>
      _Widget_YTD_Sales_GrowthState();
}

class _Widget_YTD_Sales_GrowthState extends State<Widget_YTD_Sales_Growth> {
  var loading = false;
  var count = 0;
  List<String> category = ['Company'];
  var selectedCategory = 'Company';
  String selecteddateCut = '';
  DateTime changeDueDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    getdataCategoryFromAPI();

    selecteddateCut = changeDueDate.year.toString() +
        '-' +
        changeDueDate.month.toString() +
        '-' +
        changeDueDate.day.toString();

    // print(selecteddateCut);
  }

  void getdataCategoryFromAPI() async {
    // var uri = Uri.parse(alamaturl + "/w_sales_trend/get_category");
    String _url = alamaturl + "/w_sales_trend/get_category";
    Dio _dio = Dio();
    Response response;

    setState(() {
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
        // color: Colors.lightBlue,
        height: hScreen * 0.27,
        width: wScreen,
        // margin: EdgeInsets.fromLTRB(1.0, 0, 1.0, 1.0),
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
            // Container(
            //   // color: Colors.blue,
            //   alignment: Alignment.topLeft,
            //   margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
            //   child: Text(
            //     'YTD Sales Growth',
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //   ),
            // ),
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050))
                        .then((valueDate) {
                      if (valueDate == null) {
                        print('Cancel');
                      } else {
                        setState(() {
                          // print(changeDueDate);
                          // print(valueDate);

                          changeDueDate != valueDate
                              ? categoryDiRubah = true
                              : categoryDiRubah = false;

                          changeDueDate = valueDate;

                          selecteddateCut = valueDate.year.toString() +
                              '-' +
                              valueDate.month.toString() +
                              '-' +
                              valueDate.day.toString();
                        });
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text('Sale <= ' + selecteddateCut + ' '),
                      ),
                      Container(
                        child: Icon(
                          Icons.watch_later_outlined,
                          size: 18,
                          // color: getColors(changeDueDate.toString()),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  // color: Colors.yellow,
                  width: wScreen * 0.4,
                  margin: EdgeInsets.only(right: 10.0),
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
                child: graphContainer())
          ],
        ),
      )
    ]);
  }

  Container graphContainer() {
    // print('===================================================');
    // print(selectedCategory);
    // print(selecteddateCut);
    // print(myCompany);
    // print(categoryDiRubah);
    // print('===================================================');

    return Container(
      child: YTD_S_Growth(
        mycategory: selectedCategory,
        mycompany: myCompany,
        dateCutoff: selecteddateCut,
      ),
    );
  }
}
