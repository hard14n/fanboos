// import 'dart:convert';
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
// ignore: unused_import
import 'package:fanboos/Controller/Tab/General/Model/PIC_Model.dart';
import 'package:fanboos/Controller/Tab/General/ToDoListDownLine/Model/todoListDownlineModel.dart';
import 'package:fanboos/Controller/Tab/General/ToDoPribadi/toDoListDetail.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

List<TodoListDownline> dtArray = [];

bool loading = false;
int count = 0;

int jumlahdata = 0;

var selectedPIC;

class WidgetToDoListDownline extends StatefulWidget {
  // ignore: non_constant_identifier_names
  static const String TAG = '/WidgetToDoListDownline';
  @override
  _WidgetToDoListDownlineState createState() => _WidgetToDoListDownlineState();
}

class _WidgetToDoListDownlineState extends State<WidgetToDoListDownline> {
  @override

  // late List<DropdownMenuItem<String>> _dropDownMenuItems;
  // ignore: override_on_non_overriding_member

  // ignore: override_on_non_overriding_member
  final List<DropdownMenuItem<String>> _listpic = [];

  @override
  void initState() {
    super.initState();
    selectedPIC = '0';
    dtArray.clear();
    getpic();
    getdataFromAPIwDIO();
  }

  void getpic() async {
    final uri = Uri.parse(alamaturl + "/w_todolist_downline/list_user");

    // print(uri);
    _listpic.clear();

    final response =
        await http.get(uri, headers: {"Authorization": "Bearer $mytoken"});

    var listpic = jsonDecode(response.body);
    // Map<String, dynamic> map = listpic;

    setState(() {
      _listpic.add(new DropdownMenuItem(value: '0', child: new Text('All')));
    });

    if (listpic['respon'] == 1) {
      for (var datapic in listpic['data']) {
        setState(() {
          _listpic.add(new DropdownMenuItem(
              value: datapic['id_user'].toString(),
              child: new Text(datapic['nama_lengkap'].toString())));
        });
      }
    }
  }

  void getdataFromAPIwDIO() async {
    String _url = alamaturl + "/w_todolist_downline";

    if (selectedPIC != '0') {
      // ignore: unused_local_variable
      _url = alamaturl + "/w_todolist_pribadi?id_user=" + selectedPIC;
    }

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
          jumlahdata = 0;
        });
      } else {
        if (response.data['respon'] == 1) {
          dtArray.clear();

          dtArray = TodoListDownline.listFromJson(response.data['data']);

          // print(response.data['data']);

          setState(() {
            loading = true;
            count = 1;
            jumlahdata = dtArray.length;
          });
          // print(jumlahdata);
        } else {
          //
          setState(() {
            loading = false;
            count = 0;
            jumlahdata = 0;
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

    // listpicname.clear();
    // selectedPIC = 'All';
    // getdataPICDownline();

    // print('masuk');

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
            height: 30,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  'Todo List Downline',
                  style: TextStyle(
                      fontSize: 15,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  'Jumlah : ' + jumlahdata.toString() + ' To Do List',
                  style: TextStyle(
                      fontSize: 15,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            alignment: Alignment.centerLeft,
            color: Colors.blue[100],
            child: Row(
              children: [
                Text(
                  'PIC : ',
                  style: TextStyle(
                      fontSize: 15,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
                DropDownCategory(hScreen),
              ],
            ),
          ),
          dtArray.isEmpty && count == 0
              ? CircularProgressIndicator()
              : RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: _onRefresh,
                  child: viewDataToDOList(hScreen, wScreen, context),
                ),
        ],
      ),
    );
  }

  Container viewDataToDOList(
      double hScreen, double wScreen, BuildContext context) {
    return Container(
      height: hScreen * 0.4,
      width: wScreen * 0.98,
      // color: Colors.grey[50],
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
    );
  }

  // ignore: non_constant_identifier_names
  DropdownButton<String> DropDownCategory(double hScreen) {
    return DropdownButton(
      menuMaxHeight: hScreen * 0.6,
      value: selectedPIC,
      hint: Text('Pilih PIC'),
      onChanged: (selectedValue) {
        setState(() {
          selectedPIC = selectedValue.toString();
          getdataFromAPIwDIO();
        });
      },
      items: _listpic,
    );
  }

  InkWell listData(BuildContext context, TodoListDownline e) {
    DateTime dueDate = DateTime.parse(e.due_date);
    String duedateNamaBulan = getNamaBulan(dueDate.month);

    return InkWell(
      onTap: () {
        // ignore: unused_local_variable
        // print(e.pic);
        setState(() {
          formActive = '2DODetail';
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ToDoListDetail(
              idLaporan: e.id_laporan_detail,
              topik: e.deskripsi_topik,
              uraianTopik: e.uraian_tindakan,
              followUp: e.follow_up,
              pic: e.pic,
              dueDate: dueDate,
            ),
          ),
        );
      },
      child: Container(
        height: 60,
        margin: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
        decoration: BoxDecoration(
          color: Colors.grey[50],
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
                        // width: 85,
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
                            Text('  '),
                            Icon(
                              Icons.people_alt_outlined,
                              size: 17,
                            ),
                            Text(' ' + e.nama_lengkap,
                                style: TextStyle(color: Colors.blueAccent)),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
