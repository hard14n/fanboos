// ignore_for_file: file_names, must_be_immutable, avoid_print, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:convert';

import 'package:fanboos/Controller/Tab/General/ToDoPribadi/Model/FollowUpModel.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

var selectedPIC;
List<FollowUp> myData = [];
int count = 0;
int hitung = 0;
var loading = false;
bool statusSimpan = false;
String tanggalDue = '';
DateTime changeDueDate = DateTime.now();
String tglDue = changeDueDate.year.toString() +
    ' ' +
    getNamaBulan(changeDueDate.month) +
    ' ' +
    changeDueDate.day.toString();
final List<DropdownMenuItem<String>> _listpic = [];
var dataSimpanFollowUp = TextEditingController();
String addFollowup = '';

class ToDoListDetail extends StatefulWidget {
  // const ToDoListDetail({Key? key}) : super(key: key);
  String idLaporan;
  String topik;
  String uraianTopik;
  String followUp;
  String pic;
  DateTime dueDate;

  ToDoListDetail({
    Key? key,
    required this.idLaporan,
    required this.topik,
    required this.uraianTopik,
    required this.followUp,
    required this.pic,
    required this.dueDate,
  }) : super(key: key);

  @override
  State<ToDoListDetail> createState() => _ToDoListDetailState();
}

class _ToDoListDetailState extends State<ToDoListDetail> {
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

  Future<void> _onRefresh() async {
    myData.clear();
    count = 0;

    getdataFromAPIwDIO();

    return Future.delayed(const Duration(seconds: 1));
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
        _listpic.add(DropdownMenuItem(value: userID, child: Text(username)));
      });
    } else {
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
  }

  bool isLaporanisClose = true;

  void btnFunction() {
    setState(() {
      isLaporanisClose = false;
      // print('Click CLose Laporan');
    });
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

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
              'Just Some information to inform user about a particular event !'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var hScreen = MediaQuery.of(context).size.height;
    var wScreen = MediaQuery.of(context).size.width;

    // print(selectedPIC);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: mytoolbarHeight,
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: const Text(
          'View/Add Follow Up To Do List',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          judulBox(hScreen * 0.35, wScreen, context),
          Container(
            height: hScreen - mytoolbarHeight - (hScreen * 0.35) - 40,
            width: wScreen,
            alignment: Alignment.topLeft,
            // padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
            // color: Colors.lightBlueAccent[200],
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    height: 20,
                    width: wScreen,
                    margin: const EdgeInsets.fromLTRB(7.0, 10.0, 0.0, 0.0),
                    // color: Colors.blue[200],
                    child: const Text(
                      'Follow Up',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: kPrimaryColor),
                    ),
                  ),
                  myData.isEmpty && count == 0
                      ? widget.followUp == '0'
                          ? tidakAdaFollowUP(hScreen, wScreen)
                          : const CircularProgressIndicator()
                      : adaFollowUP(hScreen, wScreen),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton:
          TambahFollowUp(context, dataSimpanFollowUp, addFollowup),
    );
  }

  Container adaFollowUP(double hScreen, double wScreen) {
    // ignore: avoid_unnecessary_containers, sized_box_for_whitespace
    return Container(
      height: hScreen - mytoolbarHeight - (hScreen * 0.35) - 40,
      // color: Colors.red,
      child: ListView(
        children: myData
            .map(
              (e) => Container(
                margin: const EdgeInsets.all(5),
                height: 100,
                width: wScreen,
                decoration: const BoxDecoration(
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
                      height: 25,
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(e.username),
                          ),
                          const Spacer(),
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: Text(e.tglupdate),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          height: 74,
                          // color: Colors.white,
                          child: Icon(
                            Icons.account_circle_outlined,
                            size: 50,
                          ),
                        ),
                        SizedBox(
                          height: 74,
                          width: wScreen - 60,
                          // color: Colors.white,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              e.keterangan,
                            ),
                          ),
                        )
                      ],
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
        boxShadow: const [
          BoxShadow(
            spreadRadius: 1,
            color: Colors.grey,
            blurRadius: 3.0,
            offset: Offset(0.0, 1.0),
          ),
        ],
      ),
      child: const Text('Belum Ada Follow Up'),
    );
  }

  // ignore: non_constant_identifier_names
  FloatingActionButton TambahFollowUp(BuildContext context,
      TextEditingController dataSimpanFollowUp, String addFollowup) {
    String initValue = '';
    return FloatingActionButton(
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
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: TextFormField(
                        autofocus: true,
                        // controller: dataSimpanFollowUp,
                        initialValue: initValue,
                        onChanged: (value) {
                          setState(() {
                            addFollowup = value;
                          });
                        },
                        minLines: 1,
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(fontSize: 14),

                        decoration: const InputDecoration(
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
                          margin: const EdgeInsets.only(left: 20),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.yellow)),
                            onPressed: () {
                              print('Cancel >> ' + addFollowup);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              print('Save >> ' + addFollowup);
                              // saveDataFollowUp(addFollowup, context);
                              // Lakukan proses Save Disini
                              String _url =
                                  alamaturl + "/w_todolist_pribadi/detail";
                              statusSimpan = false;
                              Dio _dio = Dio();
                              if (addFollowup.isEmpty) {
                                showAlert(context, 'Err. Save Message',
                                    'Data yang ingin disimpan masih kosong');
                                Navigator.pop(context);
                              } else {
                                //
                                try {
                                  Response response;
                                  dynamic _data = {
                                    'id_laporan': widget.idLaporan,
                                    'keterangan': addFollowup
                                  };
                                  FormData data = FormData.fromMap(_data);

                                  response = await _dio.post(
                                    _url,
                                    data: data,
                                    options: Options(
                                      headers: {
                                        "Authorization": "Bearer $mytoken"
                                      },
                                    ),
                                  );

                                  if (response.data['respon'] == 1) {
                                    showAlert(context, 'Information Messages',
                                        'Proses Simpan Berhasil.');
                                    setState(() {
                                      statusSimpan = true;
                                      addFollowup = '';
                                      Navigator.pop(context);
                                      _onRefresh();
                                    });
                                  } else {
                                    showAlert(context, 'Information Messages',
                                        'Respon Penyimpanan Bermasalah.');
                                    setState(() {
                                      statusSimpan = false;
                                      _onRefresh();
                                    });
                                  }

                                  print(response.data);
                                } on DioError catch (dioError) {
                                  print(dioError.response);
                                } catch (e) {
                                  print(e);
                                }
                              }
                              // #=======================================================
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
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
      child: const Icon(Icons.add_task_outlined),
    );
  }

  Container judulBox(double hScreen, double wScreen, context) {
    // print('judulBox');
    return Container(
      margin: const EdgeInsets.all(5),
      height: hScreen,
      width: wScreen,
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: kPrimaryColor,
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
            margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                widget.topik,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                style: const TextStyle(
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
            child: const Text(
              'Noted.',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          // SizedBox(height: 2),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            alignment: Alignment.topLeft,
            decoration: const BoxDecoration(
              // color: Colors.blue,
              border: Border(
                bottom: BorderSide(
                    color: Colors.grey, width: 1, style: BorderStyle.solid),
              ),
            ),
            height: hScreen * 0.3,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                widget.uraianTopik,
                textAlign: TextAlign.justify,
                style: const TextStyle(
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
                          const Icon(
                            Icons.people_alt_outlined,
                            size: 18,
                          ),
                          const Text(' '),
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
                                          title: const Text('Confirm ?'),
                                          content: const Text(
                                              'Yakin ingin mengganti tanggal due date Laporan ini ?'),
                                          actions: [
                                            // ignore: deprecated_member_use
                                            FlatButton(
                                              onPressed: () {
                                                print(
                                                    'Tombol No >> tanggal due date');
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No'),
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
                                              child: const Text('Yes'),
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
                                const Icon(
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
                                        title: const Text('Confirm ?'),
                                        content: const Text(
                                            'Yakin ingin Close Laporan ini ?'),
                                        actions: [
                                          // ignore: deprecated_member_use
                                          FlatButton(
                                            onPressed: () {
                                              print('No');
                                              Navigator.pop(context, false);
                                            },
                                            child: const Text('No'),
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
                                            child: const Text('Yes'),
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
                              children: const [
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
                              shape: const RoundedRectangleBorder(
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

  // ignore: non_constant_identifier_names
  DropdownButton<String> DropDownPic(double hScreen) {
    return DropdownButton(
      menuMaxHeight: hScreen * 0.6,
      value: selectedPIC,
      hint: const Text('Pilih PIC'),
      onChanged: (selectedValue) {
        setState(() {
          selectedPIC = selectedValue.toString();
          // showAlert(context ,'Pic', selectedPIC + ' ' + widget.pic);

          if (selectedPIC != widget.pic) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Confirm ?'),
                  content: const Text('Yakin ingin Merubah PIC Laporan ini ?'),
                  actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                      onPressed: () {
                        print('No');
                        Navigator.pop(context, false);
                      },
                      child: const Text('No'),
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
                      child: const Text('Yes'),
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
}
