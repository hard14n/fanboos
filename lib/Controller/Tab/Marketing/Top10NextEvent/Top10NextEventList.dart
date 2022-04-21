// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, sized_box_for_whitespace, non_constant_identifier_names, avoid_unnecessary_containers, avoid_print, file_names, unused_element

import 'package:fanboos/Controller/Tab/Marketing/Top10NextEvent/Model/top10NextEventModel.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

var loading = false;
int count = 0;
List<top10NextEventModel> myListData = [];

class Top10NextEventList extends StatefulWidget {
  String myArea;
  String myBrand;
  int dataawal;

  Top10NextEventList({
    required this.myArea,
    required this.myBrand,
    required this.dataawal,
  });

  @override
  State<Top10NextEventList> createState() => _Top10NextEventListState();
}

class _Top10NextEventListState extends State<Top10NextEventList> {
  @override
  void initState() {
    super.initState();
    getdataFromAPIwDIO();
  }

  void getdataFromAPIwDIO() async {
    String _url = alamaturl +
        "w_topten_next_event?area=" +
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
          myListData = top10NextEventModel.listFromJson(response.data['data']);
          loading = true;
          count = myListData.length;
          widget.dataawal = 1;

          // print(myListData);
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
          : ListTop10NextEvent(context, hScreen, wScreen),
    );
  }

  Container ListTop10NextEvent(context, hScreen, wScreen) {
    return Container(
      child: ListView(
        scrollDirection: Axis.vertical,
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

  InkWell listData(BuildContext context, top10NextEventModel e) {
    return InkWell(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            height: 80,
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
                  child: Row(
                    children: [
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
                        ' ' + e.tgl_mulai,
                      ),
                      const Text(
                        " s/d ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        e.tgl_selesai,
                      ),
                    ],
                  ),
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
                    Text(e.kode_area),
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
                Container(
                  child: Row(children: [
                    const Icon(
                      Icons.attach_money_outlined,
                      size: 18,
                    ),
                    const Text(' - Total Biaya = Rp. '),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          e.total_biaya,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
