// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, avoid_print, unnecessary_import
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fanboos/Controller/Tab/General/ToDoPribadi/Model/FollowUpModel.dart';
// import 'package:e_fansys/pages/widgets/w_general/ToDoPribadi/followUpToDoList.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

List<FollowUp> myData = [];
int count = 0;
int hitung = 0;
var loading = false;
bool statusSimpan = false;
String tanggalDue = '';

// ignore: must_be_immutable
class ToDoListDownlineDetail extends StatefulWidget {
  String idLaporan;
  String topik;
  String uraianTopik;
  String followUp;
  String pic;
  DateTime dueDate;

  ToDoListDownlineDetail({
    required this.idLaporan,
    required this.topik,
    required this.uraianTopik,
    required this.followUp,
    required this.pic,
    required this.dueDate,
  });

  @override
  _ToDoListDownlineDetailState createState() => _ToDoListDownlineDetailState();
}

class _ToDoListDownlineDetailState extends State<ToDoListDownlineDetail> {
  @override
  void initState() {
    super.initState();
    getdataFromAPIwDIO();
    statusfromdetail = true;
  }

  Future<dynamic> showAlert(String mytitle, String msg) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(mytitle),
            content: Text(msg),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  // print('Click');
                  Navigator.pop(context);
                },
                child: Text('OK'),
              )
            ],
          );
        });
  }

  void getdataFromAPIwDIO() async {
    String _url =
        alamaturl + "/w_todolist_pribadi/detail?id_laporan=" + widget.idLaporan;
    Dio _dio = Dio();
    Response response;

    setState(() {
      loading = true;
    });

    try {
      response = await _dio.get(_url,
          options: Options(headers: {"Authorization": "Bearer $mytoken"}));

      if (response.statusCode == invalidTokenStatusCode) {
        setState(() {
          loading = false;
          count = 0;
        });
      } else {
        if (response.data['respon'] == 1) {
          setState(() {
            myData = FollowUp.listFromJson(response.data['data']);
            loading = true;
            count = myData.length;
          });
        } else {
          setState(() {
            loading = false;
            myData = [];
            count = 0;
            print('Tidak Respon');
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
    var hScreen = MediaQuery.of(context).size.height;
    var wScreen = MediaQuery.of(context).size.width;
    String nmBulan = getNamaBulan(widget.dueDate.month).toString();
    hitung = 0;
    var dataSimpanFollowUp = TextEditingController();
    // ignore: unused_local_variable
    String addFollowup = '';
    // print('Nama Bulan >> ' + widget.dueDate.month.toString());

    tanggalDue = widget.dueDate.day.toString() +
        ' ' +
        nmBulan +
        ' ' +
        widget.dueDate.year.toString();

    // print(tanggalDue + '  << ' + widget.dueDate.month.toString());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: Text(
          'View/Add Follow Up To Do List',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          judulBox(hScreen, wScreen, context),
          followUpMethod(wScreen, hScreen),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: false,
            // isScrollControlled: true,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        child: new TextFormField(
                          autofocus: true,
                          controller: dataSimpanFollowUp,
                          onChanged: (value) {
                            setState(() {
                              addFollowup = value;
                            });
                          },
                          minLines: 1,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(fontSize: 14),

                          decoration: InputDecoration(
                            labelText: 'Follow Up',
                            hintText: 'Masukan Follow Up Baru Disini...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                          // ignore: non_constant_identifier_names
                          validator: (Value) {
                            return Value!.isNotEmpty ? null : 'Invalid Field';
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: wScreen * 0.75),
                        child: ElevatedButton(
                            onPressed: () {
                              print('Save >> ' + addFollowup);
                              Navigator.pop(context);
                              saveDataFollowUp(addFollowup, context);
                            },
                            child: Text('Save')),
                      ),
                      // SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        tooltip: 'Follow UP',
        child: Icon(Icons.add_task_outlined),
      ),
    );
  }

  Container judulBox(double hScreen, double wScreen, context) {
    DateTime changeDueDate = widget.dueDate;
    String tglDue = changeDueDate.year.toString() +
        ' ' +
        getNamaBulan(changeDueDate.month) +
        ' ' +
        changeDueDate.day.toString();
    // changeDueDate = DateTime.parse(widget.dueDate.toString());

    // print(changeDueDate);
    return Container(
      margin: const EdgeInsets.all(5),
      height: hScreen * 0.4,
      width: wScreen,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: Colors.grey,
            blurRadius: 1.0,
            offset: Offset(0.0, 1.0),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: hScreen * 0.06,
            // color: Colors.green,
            margin: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
            child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                widget.topik,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            alignment: Alignment.topLeft,
            child: Text(
              'Noted.',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          SizedBox(height: 2),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              // color: Colors.blue,
              border: Border(
                bottom: BorderSide(
                    color: Colors.grey, width: 1, style: BorderStyle.solid),
              ),
            ),
            height: hScreen * 0.14,
            child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                widget.uraianTopik,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 13,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            alignment: Alignment.topLeft,
            child: Text(
              'Pic. ' + widget.pic,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            alignment: Alignment.topLeft,
            child: Text('Due. ' + tglDue),
          ),
        ],
      ),
    );
  }

  void saveDataFollowUp(String keterangan, context) async {
    String _url = alamaturl + "/w_todolist_pribadi/detail";
    statusSimpan = false;
    Dio _dio = Dio();
    if (keterangan.isEmpty) {
      showAlert('Err. Save Message', 'Data yang ingin disimpan masih kosong');
      exit(context);
    } else {
      try {
        Response response;
        dynamic _data = {
          'id_laporan': widget.idLaporan,
          'keterangan': keterangan
        };
        FormData data = FormData.fromMap(_data);

        response = await _dio.post(
          _url,
          data: data,
          options: Options(
            headers: {"Authorization": "Bearer $mytoken"},
          ),
        );

        if (response.data['respon'] == 1) {
          showAlert('Information Messages', 'Proses Simpan Berhasil.');
          setState(() {
            getdataFromAPIwDIO();
            statusSimpan = true;
          });
        }

        print(response.data);

      } on DioError catch (dioError) {
        print(dioError.response);
      } catch (e) {
        print(e);
      }
    }
  }

  Container followUpMethod(double wScreen, double hScreen) {
    // getdataFromAPIwDIO();
    return Container(
      height: hScreen * 0.5,
      child: new SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 20,
              width: wScreen,
              margin: const EdgeInsets.fromLTRB(7.0, 10.0, 0.0, 0.0),
              // color: Colors.blue[200],
              child: Text(
                'Follow Up',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
            ),
            myData.isEmpty && count == 0
                ? widget.followUp == '0'
                    ? tidakAdaFollowUP(hScreen, wScreen)
                    : CircularProgressIndicator()
                : adaFollowUP(),
          ],
        ),
      ),
    );
  }

  Container adaFollowUP() {
    var hScreen = MediaQuery.of(context).size.height;
    var wScreen = MediaQuery.of(context).size.width;
    return Container(
      height: hScreen * 0.5,
      width: wScreen,
      color: Colors.grey[50],
      child: ListView(
        children: myData
            .map(
              (e) => Container(
                margin: const EdgeInsets.all(5),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.grey, width: 1, style: BorderStyle.solid),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.blue[50],
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(e.username),
                          ),
                          Spacer(),
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: Text(e.tglupdate),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            height: 63,
                            color: Colors.white,
                            child: Icon(
                              Icons.account_circle_outlined,
                              size: 50,
                            ),
                          ),
                          Container(
                            height: 63,
                            width: wScreen - 60,
                            color: Colors.white,
                            child: new SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                e.keterangan,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Container tidakAdaFollowUP(double hScreen, double wScreen) {
    return Container(
      height: hScreen * 0.15,
      width: wScreen,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: Colors.grey,
            blurRadius: 3.0,
            offset: Offset(0.0, 1.0),
          ),
        ],
      ),
      child: Text('Belum Ada Follow Up'),
    );
  }
}
