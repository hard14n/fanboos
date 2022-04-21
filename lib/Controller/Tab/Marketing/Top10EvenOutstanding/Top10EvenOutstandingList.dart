// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, sized_box_for_whitespace, non_constant_identifier_names, avoid_unnecessary_containers, avoid_print, file_names, unused_element

import 'package:fanboos/Controller/Tab/Marketing/Top10EvenOutstanding/Model/top10EvenOutstanding.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

var loading = false;
int count = 0;
List<Top10EvenOutstandingModel> myListData = [];

class Top10EvenOutstandingList extends StatefulWidget {
  String myArea;
  String myBrand;
  int dataawal;

  Top10EvenOutstandingList({
    required this.myArea,
    required this.myBrand,
    required this.dataawal,
  });

  @override
  State<Top10EvenOutstandingList> createState() =>
      _Top10EvenOutstandingListState();
}

class _Top10EvenOutstandingListState extends State<Top10EvenOutstandingList> {
  @override
  void initState() {
    super.initState();
    getdataFromAPIwDIO();
  }

  void getdataFromAPIwDIO() async {
    String _url = alamaturl +
        "w_topten_event_outstanding?area=" +
        widget.myArea +
        "&brand=" +
        widget.myBrand;

    Dio _dio = Dio();
    Response response;

    try {
      response = await _dio.get(_url,
          options: Options(headers: {"Authorization": "Bearer $mytoken"}));

      if (response.data['respon'] == 1) {
        setState(() {
          myListData =
              Top10EvenOutstandingModel.listFromJson(response.data['data']);
          loading = true;
          count = myListData.length;
          widget.dataawal = 1;
        });
      } else {
        setState(() {
          loading = false;
          myListData = [];
          count = 0;
          print('Tidak Respon');
        });
      }
    } on Exception catch (_) {
      print("throwing new error");
      throw Exception("Error on server");
    }
  }

  Future<void> _onRefresh() async {
    myListData.clear();
    count = 0;

    getdataFromAPIwDIO();

    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var hScreen = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var wScreen = MediaQuery.of(context).size.width;

    if (widget.dataawal == 0) {
      setState(() {
        getdataFromAPIwDIO();
      });
    }

    return Container(
      height: hScreen * 0.55,
      width: wScreen,
      child: myListData.isEmpty && count == 0
          ? const CircularProgressIndicator()
          : ListTop10EvenOutstanding(context, hScreen, wScreen),
    );
  }

  Container ListTop10EvenOutstanding(context, hScreen, wScreen) {
    return Container(
      child: ListView(
        children: myListData
            .map(
              (e) => Container(
                child: listData(context, e),
              ),
            )
            .toList(),
      ),
    );
  }

  InkWell listData(BuildContext context, Top10EvenOutstandingModel e) {
    return InkWell(
      child: Column(
        children: [
          Container(
              alignment: Alignment.topLeft,
              height: 60,
              margin: const EdgeInsets.fromLTRB(2.0, 2.0, 5.0, 0.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                      color: Colors.grey, width: 1, style: BorderStyle.solid),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    child: Row(children: [
                      Text(
                        'No.Prop ' + e.no_proposal,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.date_range,
                        size: 18,
                      ),
                      Text(
                        ' - ' + e.tgl_proposal,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      // const Icon(
                      //   Icons.access_time,
                      //   size: 18,
                      // ),
                      Text(
                        'Due - ' + e.od,
                        style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.red),
                      ),
                    ]),
                  ),
                  Container(
                    child: Row(children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                      ),
                      const Text(' - '),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            e.nama_kegiatan,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    child: Row(children: [
                      const Icon(
                        Icons.add_location,
                        size: 18,
                      ),
                      const Text(' - '),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            e.tempat,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  
                ],
              )),
        ],
      ),
    );
  }
}
