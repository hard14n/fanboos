// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, avoid_unnecessary_containers, unused_import

import 'package:fanboos/Controller/Tab/Marketing/Top10EvenOutstanding/Top10EvenOutstandingList.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

List dtArray = [];
List dtBrand = [];

class Top10eventOutstanding extends StatefulWidget {
  const Top10eventOutstanding({Key? key}) : super(key: key);

  @override
  State<Top10eventOutstanding> createState() => _Top10eventOutstandingState();
}

class _Top10eventOutstandingState extends State<Top10eventOutstanding> {
  var loading = false;
  var count = 0;

  List<String> ListArea = [];
  var selectedListArea = 'ALL';

  List<String> ListBrand = [];
  var selectedListBrand = 'ALL';

  @override
  void initState() {
    super.initState();
    getdataAreaFromAPI();
    getdataBrandFromAPI();
  }

  void getdataAreaFromAPI() async {
    String _url = alamaturl + "/area/list_widget";
    Dio _dio = Dio();
    Response response;

    setState(() {
      // print('getdataAreaFromAPI loading = true ');
      loading = true;
    });
    try {
      response = await _dio.get(_url,
          options: Options(headers: {"Authorization": "Bearer $mytoken"}));

      if (response.data['respon'] == 1) {
        setState(() {
          loading = false;
          for (var word in response.data['data']) {
            ListArea.add(word.toString());
          }
          count = 1;

          // print(ListArea);
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

  void getdataBrandFromAPI() async {
    String _url = alamaturl + "/brand/list_widget";
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
          for (var word in response.data['data']) {
            ListBrand.add(word.toString());
          }
          count = 1;
        });
      } else {
        setState(() {
          loading = false;
          dtBrand = [];
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
    return Column(
      children: [
        Container(
          width: wScreen,
          margin: const EdgeInsets.fromLTRB(1.0, 5, 1.0, 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
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
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 10.0),
                child: const Text(
                  'Top 10 Event Outstanding',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                ),
              ),
              Container(
                color: Colors.blue[100],
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
                      child: const Text('Area   : '),
                    ),
                    Container(
                      // color: Colors.yellow,
                      width: wScreen * 0.5,
                      height: 30,
                      margin: const EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 0.0),
                      child: DropDownArea(hScreen),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.blue[100],
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
                      child: const Text('Brand : '),
                    ),
                    Container(
                      // color: Colors.yellow,
                      width: wScreen * 0.5,
                      height: 30,
                      margin: const EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 0.0),
                      child: DropDownBrand(hScreen),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.yellow[50],
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
                // child: const Text('data'),
                child: Top10EvenOutstandingList(
                  myArea: selectedListArea,
                  myBrand: selectedListBrand,
                  dataawal: 0,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  DropdownButton<String> DropDownArea(double hScreen) {
    // print(selectedListArea);
    return DropdownButton(
      menuMaxHeight: hScreen * 0.45,
      isExpanded: true,
      value: selectedListArea,
      hint: const Text('Area'),
      onChanged: (value) {
        setState(() {
          selectedListArea = value.toString();

          selectedListArea == 'ALL'
              ? categoryDiRubah = false
              : categoryAsset != selectedListArea
                  ? categoryDiRubah = true
                  : categoryDiRubah = false;

          categoryAsset = selectedListArea;
        });
      },
      items: ListArea.map((items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
    );
  }

  DropdownButton<String> DropDownBrand(double hScreen) {
    return DropdownButton(
      menuMaxHeight: hScreen * 0.6,
      isExpanded: true,
      value: selectedListBrand,
      hint: const Text('Brand'),
      onChanged: (value) {
        setState(() {
          selectedListBrand = value.toString();

          selectedListBrand == 'ALL'
              ? categoryDiRubah = false
              : categoryAsset != selectedListBrand
                  ? categoryDiRubah = true
                  : categoryDiRubah = false;

          categoryAsset = selectedListBrand;
        });
      },
      items: ListBrand.map((items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
    );
  }
}
