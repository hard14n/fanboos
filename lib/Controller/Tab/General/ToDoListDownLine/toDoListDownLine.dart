// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, avoid_print

import 'package:fanboos/Controller/Tab/General/ToDoListDownLine/Model/todoListDownlineModel.dart';
import 'package:fanboos/Controller/Tab/General/ToDoPribadi/toDoListDetail.dart';
import 'package:flutter/material.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:dio/dio.dart';

List<TodoListDownline> dtArray = [];
bool loading = false;
int count = 0;

class ToDoListDownLine extends StatefulWidget {
  @override
  _ToDoListDownLineState createState() => _ToDoListDownLineState();
}

class _ToDoListDownLineState extends State<ToDoListDownLine> {
  @override
  void initState() {
    super.initState();
    getdataFromAPIwDIO();
  }

  void getdataFromAPIwDIO() async {
    String _url = alamaturl + "/w_todolist_downline";
    Dio _dio = Dio();
    Response response;

    try {
      response = await _dio.get(_url,
          options: Options(headers: {"Authorization": "Bearer $mytoken"}));

      if (response.statusCode == invalidTokenStatusCode) {
        // login ulang
        setState(() {
          loading = false;
          count = 0;
        });
      } else {
        if (response.data['respon'] == 1) {
          dtArray.clear();

          dtArray = TodoListDownline.listFromJson(response.data['data']);

          setState(() {
            loading = true;
            count = 1;
          });
        } else {
          //
          setState(() {
            loading = false;
            count = 0;
          });
        }
      }
    } on DioError catch (dioError) {
      print(dioError.response!.data);
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

    if (dtArray.isEmpty && count == 0) {
      setState(() {
        getdataFromAPIwDIO();
      });
    }
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            height: 30,
            alignment: Alignment.centerLeft,
            child: Text(
              'Todo List Downline',
              style: TextStyle(
                  fontSize: 15,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          dtArray.isEmpty && count == 0
              ? CircularProgressIndicator()
              : Container(
                  height: hScreen * 0.58,
                  width: wScreen * 0.98,
                  color: Colors.white,
                  // margin: EdgeInsets.all(2),
                  child: ListView(
                    children: dtArray
                        .map(
                          (e) => Container(
                            child: listData(context, e),
                          ),
                        )
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }

  InkWell listData(BuildContext context, TodoListDownline e) {
    DateTime dueDate = DateTime.parse(e.due_date);
    String duedateNamaBulan = getNamaBulan(dueDate.month);
    return InkWell(
      onTap: () {
        // print(e.pic);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ToDoListDetail(
              idLaporan: e.id_laporan_detail,
              topik: e.deskripsi_topik,
              uraianTopik: e.uraian_tindakan,
              followUp: e.follow_up,
              pic: e.nama_lengkap,
              dueDate: dueDate,
            ),
          ),
        );
      },
      child: Container(
        height: 105,
        margin: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: Colors.grey, width: 1, style: BorderStyle.solid),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 25,
              color: Colors.blue[50],
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    width: 58,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: getColors(e.due_date),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 1,
                          color: Colors.white,
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          size: 17,
                        ),
                        Text(
                          dueDate.day.toString() + ' ' + duedateNamaBulan,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    width: MediaQuery.of(context).size.width * 0.73,
                    child: new SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        e.deskripsi_topik,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 15,
                    width: 15,
                    alignment: Alignment.center,
                    // color: Colors.amber[200],
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 1,
                          color: Colors.grey,
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                    child: Text(e.follow_up),
                  ),
                  SizedBox(width: 5)
                ],
              ),
            ),
            Container(
              height: 20,
              margin: const EdgeInsets.only(top: 5),
              color: Colors.white,
              width: double.infinity,
              child: Text('PIC : ' + e.nama_lengkap,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Container(
              height: 54,
              width: double.infinity,
              color: Colors.white,
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  e.uraian_tindakan,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color getColors(String dueDate) {
    Color barColor;

    DateTime parsedDate = DateTime.parse(dueDate);
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(now.year, now.month, now.day - 6);

    barColor = Colors.black;

    if (parsedDate.isAfter(now)) {
      barColor = Colors.blue;
    } else {
      if (parsedDate.isAfter(yesterday) && parsedDate.isBefore(now)) {
        barColor = Colors.yellow;
      } else {
        if (parsedDate.isBefore(yesterday)) {
          barColor = Colors.red;
        }
      }
    }
    return barColor;
  }

  String getNamaBulan(int mon) {
    String bulan = '';
    List months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec'
    ];

    bulan = months[mon];

    // print(bulan);

    return bulan;
  }
}
