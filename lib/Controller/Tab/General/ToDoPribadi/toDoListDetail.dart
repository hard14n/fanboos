// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, avoid_print, unnecessary_import

import 'dart:convert';
import 'dart:io';
// import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
// import 'package:e_fansys/pages/mainpage/menu_utama.dart';
// import 'package:e_fansys/pages/widgets/w_general/ToDoListDownLine/w_ToDoListDownline.dart';
import 'package:fanboos/Controller/Tab/General/ToDoPribadi/Model/toDoListDetailModel.dart';
// import 'package:e_fansys/pages/widgets/w_general/ToDoPribadi/followUpToDoList.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:get/get.dart' as GET;
import 'package:http/http.dart' as http;

List<FollowUp> myData = [];
int count = 0;
int hitung = 0;
var loading = false;
bool statusSimpan = false;
String tanggalDue = '';

// List<String> listpicname = [];
// ignore: prefer_typing_uninitialized_variables
var selectedPIC;

DateTime changeDueDate = DateTime.now();
String tglDue = changeDueDate.year.toString() +
    ' ' +
    getNamaBulan(changeDueDate.month) +
    ' ' +
    changeDueDate.day.toString();

// ignore: must_be_immutable
class ToDoListDetail extends StatefulWidget {
  String idLaporan;
  String topik;
  String uraianTopik;
  String followUp;
  String pic;
  DateTime dueDate;

  ToDoListDetail({
    required this.idLaporan,
    required this.topik,
    required this.uraianTopik,
    required this.followUp,
    required this.pic,
    required this.dueDate,
  });

  @override
  _ToDoListDetailState createState() => _ToDoListDetailState();
}

class _ToDoListDetailState extends State<ToDoListDetail> {
  @override

  // ignore: override_on_non_overriding_member
  final List<DropdownMenuItem<String>> _listpic = [];

  @override
  void initState() {
    super.initState();

    getdataFromAPIwDIO();

    statusfromdetail = true;

    changeDueDate = widget.dueDate;

    tglDue = changeDueDate.year.toString() +
        ' ' +
        getNamaBulan(changeDueDate.month) +
        ' ' +
        changeDueDate.day.toString();

    selectedPIC = widget.pic;

    getpic();
  }

  void closeLaporan(String idLaporan) async {
    final uri = Uri.parse(alamaturl +
        "/w_todolist_downline/close?id_laporan_detail=" +
        idLaporan);
    final response =
        await http.get(uri, headers: {"Authorization": "Bearer $mytoken"});
    var listpic = jsonDecode(response.body);

    if (listpic['respon'] == 1) {
      showAlert(context, "Close Laporan", listpic['message']);
    } else {
      showAlert(context, "Message", "Proses Close Laporan Bermasalah.");
    }
  }

  void _changeDueDate(String idLaporan, String _dueDate) async {
    final uri = Uri.parse(alamaturl +
        "/w_todolist_downline/change_deadline?id_laporan_detail=" +
        idLaporan +
        "&due_date=" +
        _dueDate);

    // print(uri);

    final response =
        await http.get(uri, headers: {"Authorization": "Bearer $mytoken"});
    var listpic = jsonDecode(response.body);

    if (listpic['respon'] == 1) {
      showAlert(context, "Change Due Date Laporan", listpic['message']);
    } else {
      showAlert(context, "Message", "Change Due Date Laporan Bermasalah.");
    }
  }

  void _changeNewPIC(String idLaporan, String _newPIC) async {
    final uri = Uri.parse(alamaturl +
        "/w_todolist_downline/change_pic?id_laporan_detail=" +
        idLaporan +
        "&id_user=" +
        _newPIC);

    final response =
        await http.get(uri, headers: {"Authorization": "Bearer $mytoken"});
    var listpic = jsonDecode(response.body);

    if (listpic['respon'] == 1) {
      showAlert(context, "Change PIC Laporan", listpic['message']);
    } else {
      showAlert(context, "Message", "Change PIC Laporan Bermasalah.");
    }
  }

  void getpic() async {
    final uri = Uri.parse(alamaturl + "/w_todolist_downline/list_user");

    _listpic.clear();

    final response =
        await http.get(uri, headers: {"Authorization": "Bearer $mytoken"});

    var listpic = jsonDecode(response.body);

    if (formActive == '2DOPribadi') {
      setState(() {
        _listpic.add(
            new DropdownMenuItem(value: userID, child: new Text(username)));
      });
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    var hScreen = MediaQuery.of(context).size.height;
    var wScreen = MediaQuery.of(context).size.width;
    String nmBulan = getNamaBulan(widget.dueDate.month).toString();
    hitung = 0;
    var dataSimpanFollowUp = TextEditingController();
    String addFollowup = '';

    tanggalDue = widget.dueDate.day.toString() +
        ' ' +
        nmBulan +
        ' ' +
        widget.dueDate.year.toString();

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
          judulBox(hScreen * 0.35, wScreen, context),
          followUpMethod(hScreen * 0.65, wScreen),
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
                  primary: true,
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
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)  ),
                                onPressed: () {
                                  print('Cancel >> ' + addFollowup);
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel', style: TextStyle(color: Colors.blue ,fontWeight: FontWeight.bold),) ,),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(right:20),
                            child: ElevatedButton(
                                onPressed: () {
                                  print('Save >> ' + addFollowup);
                                  Navigator.pop(context);
                                  saveDataFollowUp(addFollowup, context);
                                },
                                child: Text('Save', style: TextStyle(color: Colors.yellow ,fontWeight: FontWeight.bold),) ,),
                          ),
                        ],
                      )
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

  void getdataFromAPIwDIO() async {
    String _url =
        alamaturl + "/w_todolist_pribadi/detail?id_laporan=" + widget.idLaporan;
    // print(_url);

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
            // print(response.data['data']);

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

  void saveDataFollowUp(String keterangan, context) async {
    String _url = alamaturl + "/w_todolist_pribadi/detail";
    statusSimpan = false;
    Dio _dio = Dio();
    if (keterangan.isEmpty) {
      showAlert(context, 'Err. Save Message',
          'Data yang ingin disimpan masih kosong');
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
          showAlert(context, 'Information Messages', 'Proses Simpan Berhasil.');
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
    print('followUpMethod');
    print('myData.length >> ' + myData.length.toString());

    return Container(
      height: hScreen * 0.8,
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

  bool isLaporanisClose = true;

  void btnFunction() {
    setState(() {
      isLaporanisClose = false;
      // print('Click CLose Laporan');
    });
  }

  Container judulBox(double hScreen, double wScreen, context) {
    // print('judulBox');
    return Container(
      margin: const EdgeInsets.all(5),
      height: hScreen,
      width: wScreen,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
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
            width: double.infinity,
            height: hScreen * 0.3,
            // color: Colors.green,
            margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                widget.topik,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            alignment: Alignment.topLeft,
            // color: Colors.yellow,
            child: Text(
              'Noted.',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          // SizedBox(height: 2),
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
            height: hScreen * 0.3,
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
          // SizedBox(height: 5),
          Container(
            // color: Colors.pink,
            height: hScreen * 0.3,
            margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // color: Colors.green,
                      height: hScreen * 0.15,
                      width: wScreen * 0.65,
                      margin: const EdgeInsets.only(left: 2.0),
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.people_alt_outlined,
                            size: 18,
                          ),
                          Text(' '),
                          DropDownPic(hScreen),
                        ],
                      ),
                    ),
                    Container(
                      // color: Colors.blue,
                      height: hScreen * 0.14,
                      width: wScreen * 0.65,
                      margin: const EdgeInsets.only(left: 2.0),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (formActive == '2DOPribadi') {
                                showAlert(context, 'Change Due Date',
                                    'Anda tidak mendapat akses untuk mengganti Due Date To Do List');
                              } else {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2050))
                                    .then((valueDate) {
                                  if (valueDate == null) {
                                    print('Cancel');
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Confirm ?'),
                                          content: Text(
                                              'Yakin ingin mengganti tanggal due date Laporan ini ?'),
                                          actions: [
                                            // ignore: deprecated_member_use
                                            FlatButton(
                                              onPressed: () {
                                                print(
                                                    'Tombol No >> tanggal due date');
                                                Navigator.pop(context);
                                              },
                                              child: Text('No'),
                                            ),
                                            // ignore: deprecated_member_use
                                            FlatButton(
                                              onPressed: () {
                                                // print(formActive);
                                                print(
                                                    'Tombol Yes >> tanggal due date');
                                                setState(() {
                                                  changeDueDate =
                                                      DateTime.parse(
                                                          valueDate.toString());

                                                  tglDue = valueDate.year
                                                          .toString() +
                                                      '-' +
                                                      valueDate.month
                                                          .toString() +
                                                      '-' +
                                                      valueDate.day.toString();

                                                  _changeDueDate(
                                                      widget.idLaporan, tglDue);
                                                  // print(changeDueDate);
                                                  // print(tglDue);
                                                });

                                                Navigator.pop(context);
                                              },
                                              child: Text('Yes'),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  }
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 18,
                                  // color: getColors(changeDueDate.toString()),
                                ),
                                Text(
                                  ' ' + tglDue,
                                  style: TextStyle(
                                      color:
                                          getColors(changeDueDate.toString()),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(5.0, 2.0, 0.0, 2.0),
                      height: hScreen * 0.2,
                      width: wScreen * 0.22,
                      // color: Colors.yellow,
                      child: SizedBox(
                        height: hScreen * 0.06,
                        child: Opacity(
                          opacity: isLaporanisClose ? 1.0 : 0.2,
                          child: ElevatedButton(
                            onPressed: () {
                              // print(formActive);
                              if (formActive == '2DOPribadi') {
                                showAlert(context, 'Informasi Clossing',
                                    'To Do List Hanya bisa di Close oleh Atasan');
                              } else {
                                if (isLaporanisClose == true) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Confirm ?'),
                                        content: Text(
                                            'Yakin ingin Close Laporan ini ?'),
                                        actions: [
                                          // ignore: deprecated_member_use
                                          FlatButton(
                                            onPressed: () {
                                              print('No');
                                              Navigator.pop(context, false);
                                            },
                                            child: Text('No'),
                                          ),
                                          // ignore: deprecated_member_use
                                          FlatButton(
                                            onPressed: () {
                                              // Proses Close Laporan
                                              closeLaporan(widget.idLaporan);
                                              // Proses Disable Tombol Close
                                              btnFunction();
                                              setState(() {
                                                currenttab =
                                                    formActive == '2DODetail'
                                                        ? 1
                                                        : 0;
                                              });
                                              Navigator.pop(context, true);
                                              Navigator.pushReplacementNamed(
                                                  context, "/menu_utama",
                                                  arguments: mytoken);
                                            },
                                            child: Text('Yes'),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showAlert(context, "Message",
                                      'Laporan ini sudah di Close');
                                }
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 12,
                                ),
                                Expanded(
                                  child:
                                      //
                                      Text(
                                    'Close Laporan',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 10.0),
                                    softWrap: true,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
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

  // ignore: non_constant_identifier_names
  DropdownButton<String> DropDownPic(double hScreen) {
    return DropdownButton(
      menuMaxHeight: hScreen * 0.6,
      value: selectedPIC,
      hint: Text('Pilih PIC'),
      onChanged: (selectedValue) {
        setState(() {
          selectedPIC = selectedValue.toString();
          // showAlert(context ,'Pic', selectedPIC + ' ' + widget.pic);

          if (selectedPIC != widget.pic) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Confirm ?'),
                  content: Text('Yakin ingin Merubah PIC Laporan ini ?'),
                  actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                      onPressed: () {
                        print('No');
                        Navigator.pop(context, false);
                      },
                      child: Text('No'),
                    ),
                    // ignore: deprecated_member_use
                    FlatButton(
                      onPressed: () {
                        // Proses Close Laporan
                        _changeNewPIC(widget.idLaporan, selectedPIC);
                        // Proses Disable Tombol Close
                        // btnFunction();
                        Navigator.pop(context, true);
                        Navigator.pushReplacementNamed(context, "/menu_utama",
                            arguments: mytoken);
                      },
                      child: Text('Yes'),
                    )
                  ],
                );
              },
            );
          } else {}
        });
      },
      items: _listpic,
    );
  }

  // // ignore: non_constant_identifier_names
  // DropdownButton<String> DropDownPic(double hScreen) {
  //   return DropdownButton(
  //     menuMaxHeight: hScreen,
  //     value: selectedPIC,
  //     hint: Text('Pilih PIC'),
  //     onChanged: (selectedValue) {
  //       setState(() {
  //         print(selectedPIC);
  //         selectedPIC = selectedValue.toString();

  //         // selectedPIC == 'All'
  //         //     ? categoryDiRubah = false
  //         //     : categoryAsset != selectedPIC
  //         //         ? categoryDiRubah = true
  //         //         : categoryDiRubah = false;

  //         categoryAsset = selectedPIC;

  //         if (widget.pic != selectedPIC) {
  //           showDialog(
  //             context: context,
  //             builder: (context) {
  //               return AlertDialog(
  //                 title: Text('Confirm ?'),
  //                 content: Text('Yakin ingin Mengganti PIC Laporan ini ?'),
  //                 actions: [
  //                   // ignore: deprecated_member_use
  //                   FlatButton(
  //                     onPressed: () {
  //                       print('No');
  //                       setState(() {
  //                         selectedPIC = widget.pic;
  //                       });

  //                       Navigator.pop(context);
  //                     },
  //                     child: Text('No'),
  //                   ),
  //                   // ignore: deprecated_member_use
  //                   FlatButton(
  //                     onPressed: () {
  //                       print('Yes');
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text('Yes'),
  //                   )
  //                 ],
  //               );
  //             },
  //           );
  //         }
  //         // count = 0;
  //         // dtArray.clear();
  //         // getdataFromAPIwDIO();
  //       });
  //     },
  //     items: listpicname.map((chooseItem) {
  //       return DropdownMenuItem(
  //         value: chooseItem,
  //         child: Text(chooseItem),
  //       );
  //     }).toList(),
  //   );
  // }
}
