// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, file_names, avoid_unnecessary_containers, unused_local_variable, unnecessary_new, avoid_print, unused_import, avoid_web_libraries_in_flutter

// import 'dart:html';

import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';

class MRIT extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<MRIT> {
  var dataSimpan = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var hScreen = MediaQuery.of(context).size.height;
    var wScreen = MediaQuery.of(context).size.width;
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: Text(
            'Maintenance Request',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.save),
                onPressed: () => {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Maintenance Request"),
                          content: Text(
                              'Permintaan/Keluhan Anda Berhasil Disimpan.'),
                          actions: [
                            // ignore: deprecated_member_use
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            )
                          ],
                        );
                      })
                },
              );
            }),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 200,
              width: wScreen,
              margin: const EdgeInsets.all(5),
              color: Colors.blue,
              child: Container(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: const [
                    Text(
                      "1. Efektif per tanggal 1 Januari 2016, helpdesk hardcopy (manual) sudah tidak perlu dibuat.",
                      textAlign: TextAlign.justify,
                    ),
                    Text(
                        "2. Jangan lupa meminta approval dari atasan Anda, karena MR baru bisa ditindaklanjuti setelah diapprove. (Kecuali jika requester adalah BOD akan otomatis approved)",
                        textAlign: TextAlign.justify),
                    Text(
                        "3. User yang sudah memiliki Login ID tidak boleh menginput dengan user Guest, karena request bersangkutan akan di reject.",
                        textAlign: TextAlign.justify),
                    Text(
                        "4. Untuk request query/report mohon untuk memberikan format query/report yang diinginkan kepada tim IT baik berupa print out/excel file.",
                        textAlign: TextAlign.justify),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              height: hScreen - 300,
              // color: Colors.amber,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                      child: Text(
                        'Request To IT',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                      child: Text(
                        'From ' + namaLengkap + ' Dept. ' + departemen,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new TextField(
                      controller: dataSimpan,
                      minLines: 10,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Masukan Permintaan/Keluhan Anda',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
