// import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:number_display/number_display.dart';
import 'package:dio/dio.dart';

const kPrimaryColor = Color(0xFFBA68C8);
const kPrimaryButtonColor = Colors.purple;

const kTextColor = Color(0xFF3C4646);

const kBackgroundColor = Color(0xFFF9F8FD);
const double kDefaultPadding = 20.0;
const companyName = 'Fabindo Sejahtera';
const myCompany = 'FS Cikupa';

final displayNumber = createDisplay(
  separator: ',',
  length: 10,
  decimal: 2,
);

String userID = "";
String username = "";
String namaLengkap = "";
String alamat = "";
String title = "";
String departemen = "";
String statuskaryawan = "";
String email = "";
String mytoken = '';

// ignore: non_constant_identifier_names
String formActive = '';

String categoryAsset = '';

int invalidTokenStatusCode = 401;

int currenttab = 0;

// ignore: non_constant_identifier_names
bool loading_Form = false;

var categoryDiRubah = false;
bool statusfromdetail = false;

String alamaturl = "http://api.fabindo.com/";

Future<Response> getdataFromAPI(String myCompany, String myCategory) async {
  Dio _dio = Dio();

  String _url = alamaturl +
      "/w_sales_trend/?company=" +
      myCompany +
      '&category=' +
      myCategory;

  Response response = await _dio.get(_url,
      options: Options(headers: {
        'Authorization': 'Bearer $mytoken',
        'User-Agent': 'flutter-format',
      }));

  return response;
}

String getNamaBulan(int mon) {
  // print('Bulan yang masuk >> ' + mon.toString());

  String bulan = '';
  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  bulan = months[mon - 1];

  return bulan;
}

Color getColors(String dueDate) {
  Color barColor;

  DateTime parsedDate = DateTime.parse(dueDate);
  DateTime now = DateTime.now();

  int diff = parsedDate.difference(now).inDays;

  // DateTime yesterday = DateTime(now.year, now.month, now.day - 6);

  barColor = Colors.black;

  if (diff >= 0 && diff <= 2) {
    barColor = Colors.yellow;
  } else {
    if (diff > 2) {
      barColor = Colors.blue;
    } else {
      barColor = Colors.red;
    }
  }

  return barColor;
}

  showAlert(BuildContext context, String mytitle, String msg) {
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
              // ignore: prefer_const_constructors
              child: Text('OK'),
            )
          ],
        );
      });
}

// void onAlertButtonPressed(context, descTitle, descMessage) {
//   Alert(
//     context: context,
//     type: (descTitle == 'MESSAGE') ? AlertType.success : AlertType.warning,
//     title: descTitle,
//     desc: descMessage,
//     buttons: [
//       DialogButton(
//         child: const Text(
//           "OK",
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//         onPressed: () => Navigator.pop(context),
//         width: 120,
//       )
//     ],
//   ).show();
// }
