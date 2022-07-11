// ignore_for_file: file_names, constant_identifier_names, avoid_print, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'Model/todoListDownlineModel.dart';
import 'package:http/http.dart' as http;

import 'ToDoListDetail/toDoListDetail.dart';

List<TodoListDownline> dtArray = [];

bool loading = false;
int count = 0;

int jumlahdata = 0;

String selectedPIC = '';

class ToDoListDownline extends StatefulWidget {
  const ToDoListDownline({Key? key}) : super(key: key);
  static const String TAG = '/WidgetToDoListDownline';
  @override
  State<ToDoListDownline> createState() => _ToDoListDownlineState();
}

class _ToDoListDownlineState extends State<ToDoListDownline> {
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
      _listpic.add(const DropdownMenuItem(value: '0', child: Text('All')));
    });

    if (listpic['respon'] == 1) {
      for (var datapic in listpic['data']) {
        setState(() {
          _listpic.add(DropdownMenuItem(
              value: datapic['id_user'].toString(),
              child: Text(datapic['nama_lengkap'].toString())));
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

  // ignore: unused_element
  Future<void> _onRefresh() async {
    dtArray.clear();
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

    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          color: Colors.blue[100],
          height: 25,
          child: Row(
            children: const [
              Text(
                'Todo List Downline',
                style: TextStyle(
                    fontSize: 15,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          height: 40,
          alignment: Alignment.centerLeft,
          // color: Colors.blue[100],
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                  color: Colors.grey, width: 1, style: BorderStyle.solid),
            ),
          ),
          child: Row(
            children: [
              const Text(
                'PIC : ',
                style: TextStyle(
                    fontSize: 15,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
              DropDownCategory(hScreen),
              const Spacer(),
              Text(
                'Jumlah : ' + jumlahdata.toString() + ' To Do List',
                style: const TextStyle(
                    fontSize: 15,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        dtArray.isEmpty && count == 0
            ? const CircularProgressIndicator()
            : Container(
                width: wScreen * 0.98,
                margin: const EdgeInsets.only(top: 2),
                height: hScreen - 278,
                // color: Colors.green,
                child: RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: _onRefresh,
                  child: viewDataToDOList(hScreen, wScreen, context),
                ),
              ),
      ],
    );
  }

  DropdownButton<String> DropDownCategory(double hScreen) {
    return DropdownButton(
      // menuMaxHeight: hScreen * 0.3,
      value: selectedPIC,
      hint: const Text('Pilih PIC'),
      onChanged: (selectedValue) {
        setState(() {
          selectedPIC = selectedValue.toString();
          getdataFromAPIwDIO();
        });
      },
      items: _listpic,
    );
  }

  Container viewDataToDOList(
      double hScreen, double wScreen, BuildContext context) {
    return Container(
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
          border: const Border(
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        e.deskripsi_topik,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 15,
                    width: 15,
                    alignment: Alignment.center,
                    // color: Colors.amber[200],
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          spreadRadius: 1,
                          color: Colors.grey,
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                    child: Text(e.follow_up),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
            Container(
              // height: 54,
              width: double.infinity,
              // color: Colors.grey[50],
              margin: const EdgeInsets.only(left: 5),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Row(
                    children: [
                      Container(
                        // width: 85,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Icon(
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
                            const Text('  '),
                            const Icon(
                              Icons.people_alt_outlined,
                              size: 17,
                            ),
                            Text(' ' + e.nama_lengkap,
                                style:
                                    const TextStyle(color: Colors.blueAccent)),
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
