// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, avoid_print, unnecessary_import
import 'dart:ui';
import 'package:fanboos/Controller/Tab/General/ToDoPribadi/Model/toDoListModel.dart';
import 'package:fanboos/Controller/Tab/General/ToDoPribadi/toDoListDetail.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// import 'package:get/get.dart' hide Response;

List<TodoList> dtArray = [];
bool loading = false;
int count = 0;

class WidgetToDoListPribadi extends StatefulWidget {
  @override
  _WidgetToDoListPribadiState createState() => _WidgetToDoListPribadiState();
}

class _WidgetToDoListPribadiState extends State<WidgetToDoListPribadi>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    getdataFromAPIwDIO();
  }

  void getdataFromAPIwDIO() async {
    String _url = alamaturl + "/w_todolist_pribadi?id_user=" + userID;
    Dio _dio = Dio();
    Response response;
    try {
      response = await _dio.get(_url,
          options: Options(headers: {"Authorization": "Bearer $mytoken"}));
      
      // print(response.data['data']);

      if (response.statusCode == invalidTokenStatusCode) {
        // login ulang
        setState(() {
          loading = false;
          count = 0;
        });
      } else {
        if (response.data['respon'] == 1) {
          dtArray.clear();

          dtArray = TodoList.listFromJson(response.data['data']);

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

  Future<void> _onRefresh() async {
    dtArray.clear();
    count = 0;

    getdataFromAPIwDIO();

    return Future.delayed(Duration(seconds: 1));
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
      color: Colors.white,
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            // height: 30,
            alignment: Alignment.centerLeft,
            child: Text(
              'Todo List Pribadi',
              style: TextStyle(
                  fontSize: 15,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          dtArray.isEmpty && count == 0
              ? CircularProgressIndicator()
              : RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: _onRefresh,
                  child: Container(
                    margin: const EdgeInsets.only(top: 2),
                    height: hScreen - 230,
                    // color: Colors.green,
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
                ),
        ],
      ),
    );
  }

  InkWell listData(BuildContext context, TodoList e) {
    DateTime dueDate = DateTime.parse(e.due_date);
    String duedateNamaBulan = getNamaBulan(dueDate.month);

    return InkWell(
      onTap: () {
        // ignore: unused_local_variable
        setState(() {
          formActive = '2DOPribadi';
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ToDoListDetail(
              idLaporan: e.id_laporan_detail,
              topik: e.deskripsi_topik,
              uraianTopik: e.uraian_tindakan,
              followUp: e.follow_up,
              pic: userID,
              dueDate: dueDate,
            ),
          ),
        );
      },
      child: Container(
        height: 60,
        margin: const EdgeInsets.fromLTRB(2.0, 1.0, 2.0, 1.0),
        decoration: BoxDecoration(
          // color: Colors.grey[50],
          border: Border(
            bottom: BorderSide(
                color: Colors.grey, width: 1, style: BorderStyle.solid),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 35,
              color: Colors.blue[50],
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    width: MediaQuery.of(context).size.width * 0.85,
                    // color: Colors.blue,
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
                  SizedBox(width: 5),
                ],
              ),
            ),
            Container(
              // height: 54,
              width: double.infinity,
              // color: Colors.grey[50],
              margin: const EdgeInsets.only(left: 5),
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  children: [
                    Container(
                      width: 85,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            size: 17,
                          ),
                          Text(
                            ' Due.' +
                                dueDate.day.toString() +
                                ' ' +
                                duedateNamaBulan,
                            style: TextStyle(
                                color: getColors(e.due_date),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
